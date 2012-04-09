Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab2DIRy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:54:29 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:24810 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517Ab2DIRy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:54:26 -0400
Subject: [PATCH 2/4] ipc: move all checkpoint-restore code under appropriate
 define
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, dhowells@redhat.com, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        criu@openvz.org, mtk.manpages@gmail.com
Date: Mon, 09 Apr 2012 21:54:04 +0400
Message-ID: <20120409175404.8358.32321.stgit@localhost6.localdomain6>
In-Reply-To: <20120409175309.8358.21631.stgit@localhost6.localdomain6>
References: <20120409175309.8358.21631.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All new checkpoint/restore code parts are now covered with
CONFIG_CHECKPOINT_RESTORE marco. So it would be easy to remove them, in case
the whole project fails.

---
 ipc/compat.c |    9 ++++++---
 ipc/msg.c    |   15 ++++++++++++++-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/ipc/compat.c b/ipc/compat.c
index 96cb9db..bb9350d 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -334,7 +334,7 @@ long compat_sys_msgsnd(int first, int second, int third, void __user *uptr)
 	return do_msgsnd(first, type, up->mtext, second, third);
 }
 
-
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static long compat_do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct compat_msgbuf_a __user *msgp = dest;
@@ -354,6 +354,7 @@ static long compat_do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_
 		return -EFAULT;
 	return msgsz;
 }
+#endif
 
 long compat_do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
@@ -387,8 +388,10 @@ long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 		msgtyp = ipck.msgtyp;
 	}
 	return do_msgrcv(first, uptr, second, msgtyp, third,
-			 (third & MSG_PEEK_ALL) ? compat_do_msg_peek_all
-						: compat_do_msg_fill);
+#ifdef CONFIG_CHECKPOINT_RESTORE
+			 (third & MSG_PEEK_ALL) ? compat_do_msg_peek_all :
+#endif
+						compat_do_msg_fill);
 }
 
 static inline int get_compat_msqid64(struct msqid64_ds *m64,
diff --git a/ipc/msg.c b/ipc/msg.c
index 017bf0b..8d63cc7 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -762,6 +762,7 @@ static inline int convert_mode(long *msgtyp, int msgflg)
 	return SEARCH_EQUAL;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static long do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct msgbuf_a __user *msgp = dest;
@@ -788,6 +789,7 @@ static long do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz
 		return -EFAULT;
 	return msgsz;
 }
+#endif
 
 static long do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
@@ -811,7 +813,9 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	struct msg_msg *msg;
 	int mode;
 	struct ipc_namespace *ns;
+#ifdef CONFIG_CHECKPOINT_RESTORE
 	size_t arrsz = bufsz;
+#endif
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
@@ -845,6 +849,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 						walk_msg->m_type != 1) {
 					msg = walk_msg;
 					msgtyp = walk_msg->m_type - 1;
+#ifdef CONFIG_CHECKPOINT_RESTORE
 				} else if (msgflg & MSG_PEEK_ALL) {
 					long ret;
 
@@ -855,6 +860,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 					}
 					buf += ret;
 					arrsz -= ret;
+#endif
 				} else {
 					msg = walk_msg;
 					break;
@@ -863,8 +869,10 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 			tmp = tmp->next;
 		}
 		if (!IS_ERR(msg)) {
+#ifdef CONFIG_CHECKPOINT_RESTORE
 			if (msgflg & MSG_PEEK_ALL)
 				goto out_unlock;
+#endif
 			/*
 			 * Found a suitable message.
 			 * Unlink it from the queue.
@@ -959,8 +967,10 @@ out_unlock:
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
 	if (msgflg & MSG_PEEK_ALL)
 		return bufsz - arrsz;
+#endif
 
 	bufsz = msg_fill(buf, msg, bufsz);
 	free_msg(msg);
@@ -972,7 +982,10 @@ SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
 		long, msgtyp, int, msgflg)
 {
 	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg,
-			 (msgflg & MSG_PEEK_ALL) ? do_msg_peek_all : do_msg_fill);
+#ifdef CONFIG_CHECKPOINT_RESTORE
+			 (msgflg & MSG_PEEK_ALL) ? do_msg_peek_all :
+#endif
+			 do_msg_fill);
 }
 
 #ifdef CONFIG_PROC_FS

