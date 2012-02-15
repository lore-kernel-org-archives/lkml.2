Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2BOQzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:55:14 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:28310 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab2BOQzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:55:11 -0500
Subject: [PATCH 2/2] IPC: message queue stealing feature introduced
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, criu@openvz.org, lucas.demarchi@profusion.mobi,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com
Date: Wed, 15 Feb 2012 20:54:39 +0400
Message-ID: <20120215165439.27978.43513.stgit@localhost6.localdomain6>
In-Reply-To: <20120215163203.27978.52494.stgit@localhost6.localdomain6>
References: <20120215163203.27978.52494.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---
 include/linux/msg.h |    8 ++++++++
 ipc/compat.c        |   31 ++++++++++++++++++++++++++++++-
 ipc/msg.c           |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/include/linux/msg.h b/include/linux/msg.h
index 9411b76..5eb43a2 100644
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -11,6 +11,7 @@
 /* msgrcv options */
 #define MSG_NOERROR     010000  /* no error if message is too big */
 #define MSG_EXCEPT      020000  /* recv any msg except of specified type.*/
+#define MSG_STEAL       040000  /* copy (not remove) all queue messages */
 
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
index 38c1ee5..d2b34f8 100644
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
@@ -328,6 +334,27 @@ long compat_sys_msgsnd(int first, int second, int third, void __user *uptr)
 	return do_msgsnd(first, type, up->mtext, second, third);
 }
 
+
+static long compat_do_msg_steal(void __user *dest, struct msg_msg *msg, size_t bufsz)
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
+
 long compat_do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct compat_msgbuf __user *msgp;
@@ -359,7 +386,9 @@ long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 		uptr = compat_ptr(ipck.msgp);
 		msgtyp = ipck.msgtyp;
 	}
-	return do_msgrcv(first, uptr, second, msgtyp, third, compat_do_msg_fill);
+	return do_msgrcv(first, uptr, second, msgtyp, third,
+			 (third & MSG_STEAL) ? compat_do_msg_steal
+					      : compat_do_msg_fill);
 }
 
 static inline int get_compat_msqid64(struct msqid64_ds *m64,
diff --git a/ipc/msg.c b/ipc/msg.c
index 1d34c11..64f83b6 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -762,6 +762,33 @@ static inline int convert_mode(long *msgtyp, int msgflg)
 	return SEARCH_EQUAL;
 }
 
+static long do_msg_steal(void __user *dest, struct msg_msg *msg, size_t bufsz)
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
+
 static long do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct msgbuf __user *msgp = dest;
@@ -784,6 +811,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	struct msg_msg *msg;
 	int mode;
 	struct ipc_namespace *ns;
+	size_t arrsz = bufsz;
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;
@@ -817,6 +845,16 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 						walk_msg->m_type != 1) {
 					msg = walk_msg;
 					msgtyp = walk_msg->m_type - 1;
+				} else if (msgflg & MSG_STEAL) {
+					long ret;
+
+					ret = msg_fill(buf, msg, arrsz);
+					if (ret < 0) {
+						msg = ERR_PTR(ret);
+						goto out_unlock;
+					}
+					buf += ret;
+					arrsz -= ret;
 				} else {
 					msg = walk_msg;
 					break;
@@ -825,6 +863,8 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 			tmp = tmp->next;
 		}
 		if (!IS_ERR(msg)) {
+			if (msgflg & MSG_STEAL)
+				goto out_unlock;
 			/*
 			 * Found a suitable message.
 			 * Unlink it from the queue.
@@ -919,6 +959,9 @@ out_unlock:
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
+	if (msgflg & MSG_STEAL)
+		return bufsz - arrsz;
+
 	bufsz = msg_fill(buf, msg, bufsz);
 	free_msg(msg);
 
@@ -928,7 +971,8 @@ out_unlock:
 SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
 		long, msgtyp, int, msgflg)
 {
-	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg, do_msg_fill);
+	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg,
+			 (msgflg & MSG_STEAL) ? do_msg_steal : do_msg_fill);
 }
 
 #ifdef CONFIG_PROC_FS

