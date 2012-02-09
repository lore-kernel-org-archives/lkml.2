Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab2BISB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:01:58 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:35504 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160Ab2BISB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:01:56 -0500
Subject: [PATCH 3/5] ipc: add new SHM_SET command for sys_shmctl() call
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        eparis@parisplace.org, sds@tycho.nsa.gov
Date: Thu, 09 Feb 2012 22:01:41 +0400
Message-ID: <20120209180141.24392.72036.stgit@localhost6.localdomain6>
In-Reply-To: <20120209175043.24392.62810.stgit@localhost6.localdomain6>
References: <20120209175043.24392.62810.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New SHM_SET command will be interpreted exactly as IPC_SET, but also will
update key, cuid and cgid values. IOW, it allows to change existent key value.
The fact, that key is not used is checked before update. Otherwise -EEXIST is
returned.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 include/linux/shm.h        |    1 +
 ipc/compat.c               |    1 +
 ipc/shm.c                  |   13 +++++++++++--
 security/selinux/hooks.c   |    1 +
 security/smack/smack_lsm.c |    1 +
 5 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/shm.h b/include/linux/shm.h
index 92808b8..6fc5447 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -63,6 +63,7 @@ struct shmid_ds {
 /* ipcs ctl commands */
 #define SHM_STAT 	13
 #define SHM_INFO 	14
+#define SHM_SET		15
 
 /* Obsolete, used only for backwards compatibility */
 struct	shminfo {
diff --git a/ipc/compat.c b/ipc/compat.c
index 43f3596..fc378d9 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -630,6 +630,7 @@ long compat_sys_shmctl(int first, int second, void __user *uptr)
 
 
 	case IPC_SET:
+	case SHM_SET:
 		if (version == IPC_64) {
 			err = get_compat_shmid64_ds(&s64, uptr);
 		} else {
diff --git a/ipc/shm.c b/ipc/shm.c
index 67ed2e2..20fe8f5 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -623,6 +623,9 @@ copy_shmid_from_user(struct shmid64_ds *out, void __user *buf, int version)
 		out->shm_perm.uid	= tbuf_old.shm_perm.uid;
 		out->shm_perm.gid	= tbuf_old.shm_perm.gid;
 		out->shm_perm.mode	= tbuf_old.shm_perm.mode;
+		out->shm_perm.cuid	= tbuf_old.shm_perm.cuid;
+		out->shm_perm.cgid	= tbuf_old.shm_perm.cgid;
+		out->shm_perm.key	= tbuf_old.shm_perm.key;
 
 		return 0;
 	    }
@@ -727,12 +730,13 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 	struct shmid_kernel *shp;
 	int err;
 
-	if (cmd == IPC_SET) {
+	if (cmd == IPC_SET || cmd == SHM_SET) {
 		if (copy_shmid_from_user(&shmid64, buf, version))
 			return -EFAULT;
 	}
 
-	ipcp = ipcctl_pre_down(ns, &shm_ids(ns), shmid, cmd,
+	ipcp = ipcctl_pre_down(ns, &shm_ids(ns), shmid,
+			       (cmd != SHM_SET) ? : IPC_SET,
 			       &shmid64.shm_perm, 0);
 	if (IS_ERR(ipcp))
 		return PTR_ERR(ipcp);
@@ -746,6 +750,10 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
 	case IPC_RMID:
 		do_shm_rmid(ns, ipcp);
 		goto out_up;
+	case SHM_SET:
+		err = ipc_update_key(&shm_ids(ns), &shmid64.shm_perm, ipcp);
+		if (err)
+			break;
 	case IPC_SET:
 		ipc_update_perm(&shmid64.shm_perm, ipcp);
 		shp->shm_ctim = get_seconds();
@@ -923,6 +931,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 	}
 	case IPC_RMID:
 	case IPC_SET:
+	case SHM_SET:
 		err = shmctl_down(ns, shmid, cmd, buf, version);
 		return err;
 	default:
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6a3683e..1728a5e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4991,6 +4991,7 @@ static int selinux_shm_shmctl(struct shmid_kernel *shp, int cmd)
 		perms = SHM__GETATTR | SHM__ASSOCIATE;
 		break;
 	case IPC_SET:
+	case SHM_SET:
 		perms = SHM__SETATTR;
 		break;
 	case SHM_LOCK:
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index e8af5b0b..4765659 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2197,6 +2197,7 @@ static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
 		may = MAY_READ;
 		break;
 	case IPC_SET:
+	case SHM_SET:
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	case IPC_RMID:

