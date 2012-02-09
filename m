Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab2BISCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:02:12 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:42642 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758196Ab2BISCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:02:10 -0500
Subject: [PATCH 5/5] ipc: add new SEM_SET command for sys_semctl() call
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        eparis@parisplace.org, sds@tycho.nsa.gov
Date: Thu, 09 Feb 2012 22:01:56 +0400
Message-ID: <20120209180156.24392.28866.stgit@localhost6.localdomain6>
In-Reply-To: <20120209175043.24392.62810.stgit@localhost6.localdomain6>
References: <20120209175043.24392.62810.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New SEM_SET command will be interpreted exactly as IPC_SET, but also will
update key, cuid and cgid values. IOW, it allows to change existent key value.
The fact, that key is not used is checked before update. Otherwise -EEXIST is
returned.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 include/linux/sem.h        |    1 +
 ipc/compat.c               |    1 +
 ipc/sem.c                  |   10 ++++++++--
 security/selinux/hooks.c   |    1 +
 security/smack/smack_lsm.c |    1 +
 5 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 10d6b22..c74b9b5 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -18,6 +18,7 @@
 /* ipcs ctl cmds */
 #define SEM_STAT 18
 #define SEM_INFO 19
+#define SEM_SET  20
 
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct semid_ds {
diff --git a/ipc/compat.c b/ipc/compat.c
index 20d639e..b828244 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -289,6 +289,7 @@ long compat_sys_semctl(int first, int second, int third, void __user *uptr)
 		break;
 
 	case IPC_SET:
+	case SEM_SET:
 		if (version == IPC_64) {
 			err = get_compat_semid64_ds(&s64, compat_ptr(pad));
 		} else {
diff --git a/ipc/sem.c b/ipc/sem.c
index 845c912..d9024d5 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1084,12 +1084,13 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 	struct semid64_ds semid64;
 	struct kern_ipc_perm *ipcp;
 
-	if(cmd == IPC_SET) {
+	if (cmd == IPC_SET || cmd == SEM_SET) {
 		if (copy_semid_from_user(&semid64, arg.buf, version))
 			return -EFAULT;
 	}
 
-	ipcp = ipcctl_pre_down(ns, &sem_ids(ns), semid, cmd,
+	ipcp = ipcctl_pre_down(ns, &sem_ids(ns), semid,
+			       (cmd != SEM_SET) ? : IPC_SET,
 			       &semid64.sem_perm, 0);
 	if (IS_ERR(ipcp))
 		return PTR_ERR(ipcp);
@@ -1104,6 +1105,10 @@ static int semctl_down(struct ipc_namespace *ns, int semid,
 	case IPC_RMID:
 		freeary(ns, ipcp);
 		goto out_up;
+	case SEM_SET:
+		err = ipc_update_key(&sem_ids(ns), &semid64.sem_perm, ipcp);
+		if (err)
+			break;
 	case IPC_SET:
 		ipc_update_perm(&semid64.sem_perm, ipcp);
 		sma->sem_ctime = get_seconds();
@@ -1149,6 +1154,7 @@ SYSCALL_DEFINE(semctl)(int semid, int semnum, int cmd, union semun arg)
 		return err;
 	case IPC_RMID:
 	case IPC_SET:
+	case SEM_SET:
 		err = semctl_down(ns, semid, cmd, version, arg);
 		return err;
 	default:
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1428f8d..3bea7e3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5097,6 +5097,7 @@ static int selinux_sem_semctl(struct sem_array *sma, int cmd)
 		perms = SEM__DESTROY;
 		break;
 	case IPC_SET:
+	case SEM_SET:
 		perms = SEM__SETATTR;
 		break;
 	case IPC_STAT:
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 143c053..a4a5d0c 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2329,6 +2329,7 @@ static int smack_sem_semctl(struct sem_array *sma, int cmd)
 	case SETALL:
 	case IPC_RMID:
 	case IPC_SET:
+	case SEM_SET:
 		may = MAY_READWRITE;
 		break;
 	case IPC_INFO:

