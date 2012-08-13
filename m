Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab2HMMdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:33:02 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2569 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab2HMMc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:32:59 -0400
Subject: [PATCH v4 4/9] ipc: add new SHM_SET command for sys_shmctl() call
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: manfred@colorfullife.com, a.p.zijlstra@chello.nl, arnd@arndb.de,
        hughd@google.com, linux-kernel@vger.kernel.org, cmetcalf@tilera.com,
        yeohc@au1.ibm.com, linux-security-module@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, casey@schaufler-ca.com,
        eparis@parisplace.org, devel@openvz.org
Date: Mon, 13 Aug 2012 16:31:54 +0400
Message-ID: <20120813123153.5581.80101.stgit@localhost6.localdomain6>
In-Reply-To: <20120813122835.5581.70057.stgit@localhost6.localdomain6>
References: <20120813122835.5581.70057.stgit@localhost6.localdomain6>
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
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
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
index aa88515..e7d4af7 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -688,6 +688,7 @@ long compat_sys_shmctl(int first, int second, void __user *uptr)
 
 
 	case IPC_SET:
+	case SHM_SET:
 		if (version == IPC_64) {
 			err = get_compat_shmid64_ds(&s64, uptr);
 		} else {
diff --git a/ipc/shm.c b/ipc/shm.c
index d4c0a9e..677b9f6 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -635,6 +635,9 @@ copy_shmid_from_user(struct shmid64_ds *out, void __user *buf, int version)
 		out->shm_perm.uid	= tbuf_old.shm_perm.uid;
 		out->shm_perm.gid	= tbuf_old.shm_perm.gid;
 		out->shm_perm.mode	= tbuf_old.shm_perm.mode;
+		out->shm_perm.cuid	= tbuf_old.shm_perm.cuid;
+		out->shm_perm.cgid	= tbuf_old.shm_perm.cgid;
+		out->shm_perm.key	= tbuf_old.shm_perm.key;
 
 		return 0;
 	    }
@@ -739,12 +742,13 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
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
@@ -758,6 +762,10 @@ static int shmctl_down(struct ipc_namespace *ns, int shmid, int cmd,
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
@@ -935,6 +943,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 	}
 	case IPC_RMID:
 	case IPC_SET:
+	case SHM_SET:
 		err = shmctl_down(ns, shmid, cmd, buf, version);
 		return err;
 	default:
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6c56ebf..9e07e22 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5054,6 +5054,7 @@ static int selinux_shm_shmctl(struct shmid_kernel *shp, int cmd)
 		perms = SHM__GETATTR | SHM__ASSOCIATE;
 		break;
 	case IPC_SET:
+	case SHM_SET:
 		perms = SHM__SETATTR;
 		break;
 	case SHM_LOCK:
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ee0bb57..a25dfd1 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2145,6 +2145,7 @@ static int smack_shm_shmctl(struct shmid_kernel *shp, int cmd)
 		may = MAY_READ;
 		break;
 	case IPC_SET:
+	case SHM_SET:
 	case SHM_LOCK:
 	case SHM_UNLOCK:
 	case IPC_RMID:

