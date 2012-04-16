Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2DPOGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:06:11 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:8495 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab2DPOGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:06:09 -0400
Subject: [PATCH v2 1/2] IPC: message queue stealing feature introduced
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, criu@openvz.org, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, mtk.manpages@gmail.com
Date: Mon, 16 Apr 2012 18:06:05 +0400
Message-ID: <20120416140605.653.23115.stgit@localhost6.localdomain6>
In-Reply-To: <20120416140235.653.36996.stgit@localhost6.localdomain6>
References: <20120416140235.653.36996.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3:
1) MSG_PEEK_ALL looks familiar because MSG_PEEK for one socket message is used
already.
2) All new checkpoint/restore code parts are now covered with
CONFIG_CHECKPOINT_RESTORE macro. So it would be easy to remove them, in case
the whole project fails.
3) return -ENOSYS, if user called sys_msgrcv() with MSG_PEEK_ALL flag set and
checkpoint/restore code wasn't compiled.

v2:
1) compat functions added.
2) message slot size in array is now aligned by struct msgbuf_a.
3) check for enough free space in buffer before message copying added.
4) if MSG_STEAL flag is set, then do_msgrcv() returns number of bytes written
to buffer.
5) flag MSG_NOERROR is ignored if MSG_STEAL flag is set.

This patch is required for checkpoint/restore in userspace.
IOW, c/r requires some way to get all pending IPC messages without deleting
them for the queue (checkpoint can fail and in this case tasks will be resumed,
so queue have to be valid).
To achive this, new operation flag MSG_STEAL for sys_msgrcv() system call
introduced.
If this flag is set, then passed struct msgbuf pointer will be used for storing
array of structures:

struct msgbuf_a {
	long mtype;         /* type of message */
	int msize;          /* size of message */
	char mtext[0];      /* message text */
};

each of which will be followed by corresponding message data.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

---
 include/linux/msg.h |    8 ++++++
 ipc/compat.c        |   42 +++++++++++++++++++++++++++++++--
 ipc/msg.c           |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/include/linux/msg.h b/include/linux/msg.h
index 9411b76..bd8fe66 100644
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -11,6 +11,7 @@
 /* msgrcv options */
 #define MSG_NOERROR     010000  /* no error if message is too big */
 #define MSG_EXCEPT      020000  /* recv any msg except of specified type.*/
+#define MSG_PEEK_ALL    040000  /* copy (not remove) all queue messages */
 
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct msqid_ds {
@@ -38,6 +39,13 @@ struct msgbuf {
 	char mtext[1];      /* message text */
 };
 
+/* message buffer for msgrcv in case of array calls */
+struct msgbuf_a {
+	long mtype;         /* type of message */
+	int msize;          /* size of message */
+	char mtext[0];      /* message text */
+};
+
 /* buffer for msgctl calls IPC_INFO, MSG_INFO */
 struct msginfo {
 	int msgpool;
diff --git a/ipc/compat.c b/ipc/compat.c
index 38c1ee5..bf31af7 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -38,6 +38,12 @@ struct compat_msgbuf {
 	char mtext[1];
 };
 
+struct compat_msgbuf_a {
+	compat_long_t mtype;
+	int msize;
+	char mtext[0];
+};
+
 struct compat_ipc_perm {
 	key_t key;
 	__compat_uid_t uid;
@@ -328,6 +334,33 @@ long compat_sys_msgsnd(int first, int second, int third, void __user *uptr)
 	return do_msgsnd(first, type, up->mtext, second, third);
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static long compat_do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
+{
+	struct compat_msgbuf_a __user *msgp = dest;
+	size_t msgsz;
+
+	msgsz = roundup(sizeof(struct msgbuf_a) + msg->m_ts,
+			__alignof__(struct msgbuf_a));
+
+	if (bufsz < msgsz)
+		return -E2BIG;
+
+	if (put_user(msg->m_type, &msgp->mtype))
+		return -EFAULT;
+	if (put_user(msg->m_ts, &msgp->msize))
+		return -EFAULT;
+	if (store_msg(msgp->mtext, msg, msg->m_ts))
+		return -EFAULT;
+	return msgsz;
+}
+#else
+static long compat_do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
+{
+	return -EINVAL;
+}
+#endif
+
 long compat_do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct compat_msgbuf __user *msgp;
@@ -349,7 +382,10 @@ long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 		return -EINVAL;
 	if (second < 0)
 		return -EINVAL;
-
+#ifndef CONFIG_CHECKPOINT_RESTORE
+	if (third & MSG_PEEK_ALL)
+		return -ENOSYS;
+#endif
 	if (!version) {
 		struct compat_ipc_kludge ipck;
 		if (!uptr)
@@ -359,7 +395,9 @@ long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 		uptr = compat_ptr(ipck.msgp);
 		msgtyp = ipck.msgtyp;
 	}
-	return do_msgrcv(first, uptr, second, msgtyp, third, compat_do_msg_fill);
+	return do_msgrcv(first, uptr, second, msgtyp, third,
+			 (third & MSG_PEEK_ALL) ? compat_do_msg_peek_all
+						: compat_do_msg_fill);
 }
 
 static inline int get_compat_msqid64(struct msqid64_ds *m64,
diff --git a/ipc/msg.c b/ipc/msg.c
index 1d34c11..e7d07c9 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -762,6 +762,40 @@ static inline int convert_mode(long *msgtyp, int msgflg)
 	return SEARCH_EQUAL;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static long do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
+{
+	struct msgbuf_a __user *msgp = dest;
+	size_t msgsz;
+
+	/*
+	 * Message size have to be aligned.
+	 */
+	msgsz = roundup(sizeof(struct msgbuf_a) + msg->m_ts,
+			__alignof__(struct msgbuf_a));
+
+	/*
+	 * No need to support MSG_NOERROR flag because truncated message array
+	 * is useless.
+	 */
+	if (bufsz < msgsz)
+		return -E2BIG;
+
+	if (put_user(msg->m_type, &msgp->mtype))
+		return -EFAULT;
+	if (put_user(msg->m_ts, &msgp->msize))
+		return -EFAULT;
+	if (store_msg(msgp->mtext, msg, msg->m_ts))
+		return -EFAULT;
+	return msgsz;
+}
+#else
+static long do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
+{
+	return -EINVAL;
+}
+#endif
+
 static long do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct msgbuf __user *msgp = dest;
@@ -784,9 +818,16 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	struct msg_msg *msg;
 	int mode;
 	struct ipc_namespace *ns;
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	size_t arrsz = bufsz;
+#endif
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
+#ifndef CONFIG_CHECKPOINT_RESTORE
+	if (msgflg & MSG_PEEK_ALL)
+		return -ENOSYS;
+#endif
 	mode = convert_mode(&msgtyp, msgflg);
 	ns = current->nsproxy->ipc_ns;
 
@@ -817,6 +858,18 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 						walk_msg->m_type != 1) {
 					msg = walk_msg;
 					msgtyp = walk_msg->m_type - 1;
+#ifdef CONFIG_CHECKPOINT_RESTORE
+				} else if (msgflg & MSG_PEEK_ALL) {
+					long ret;
+
+					ret = msg_fill(buf, msg, arrsz);
+					if (ret < 0) {
+						msg = ERR_PTR(ret);
+						goto out_unlock;
+					}
+					buf += ret;
+					arrsz -= ret;
+#endif
 				} else {
 					msg = walk_msg;
 					break;
@@ -825,6 +878,10 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 			tmp = tmp->next;
 		}
 		if (!IS_ERR(msg)) {
+#ifdef CONFIG_CHECKPOINT_RESTORE
+			if (msgflg & MSG_PEEK_ALL)
+				goto out_unlock;
+#endif
 			/*
 			 * Found a suitable message.
 			 * Unlink it from the queue.
@@ -919,6 +976,11 @@ out_unlock:
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	if (msgflg & MSG_PEEK_ALL)
+		return bufsz - arrsz;
+#endif
+
 	bufsz = msg_fill(buf, msg, bufsz);
 	free_msg(msg);
 
@@ -928,7 +990,8 @@ out_unlock:
 SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
 		long, msgtyp, int, msgflg)
 {
-	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg, do_msg_fill);
+	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg,
+			 (msgflg & MSG_PEEK_ALL) ? do_msg_peek_all : do_msg_fill);
 }
 
 #ifdef CONFIG_PROC_FS

