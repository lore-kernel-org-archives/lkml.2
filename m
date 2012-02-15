Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab2BOJJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:09:10 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:24641 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973Ab2BOJJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:09:03 -0500
Subject: [PATCH] IPC: message queue stealing feature introduced
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: criu@openvz.org, lucas.demarchi@profusion.mobi, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, serge.hallyn@canonical.com
Date: Wed, 15 Feb 2012 13:08:38 +0400
Message-ID: <20120215090711.11586.5396.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is required for checkpoint/restore in userspace project.
C/r requires some way to get all pending IPC messages without deleting them for
the queue (checkpoint can fail and in this case tasks will be resumed, so queue
have to be valid).
To achive this, new operation flag MSG_STEAL for sys_msgrcv() system call
introduced.
If this flag is set, then passed struct msgbuf pointer will be used for storing
array of structures:

struct msgbuf_a {
	long mtype;         /* type of message */
	size_t msize;       /* size of message */
	char mtext[0];      /* message text */
};

each of which will be followed by corresponding message data.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

---
 include/linux/msg.h |    8 ++++++++
 ipc/msg.c           |   43 ++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/include/linux/msg.h b/include/linux/msg.h
index 6689e73..2bace1a 100644
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
+	size_t msize;       /* size of message */
+	char mtext[0];      /* message text */
+};
+
 /* buffer for msgctl calls IPC_INFO, MSG_INFO */
 struct msginfo {
 	int msgpool;
diff --git a/ipc/msg.c b/ipc/msg.c
index 303362b..d024cdc 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -762,6 +762,23 @@ static inline int convert_mode(long *msgtyp, int msgflg)
 	return SEARCH_EQUAL;
 }
 
+static int do_store_msg(void __user *mtext, size_t msgsz, struct msg_msg *msg)
+{
+	msgsz = (msgsz > msg->m_ts) ? msg->m_ts : msgsz;
+	if (store_msg(mtext, msg, msgsz))
+		return -EFAULT;
+	return msgsz;
+}
+
+static int do_steal_msg(struct msgbuf_a __user *msgp, size_t msgsz, struct msg_msg *msg)
+{
+	if (put_user(msg->m_type, &msgp->mtype))
+		return -EFAULT;
+	if (put_user(msg->m_ts, &msgp->msize))
+		return -EFAULT;
+	return do_store_msg(msgp->mtext, msgsz, msg);
+}
+
 long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
 		size_t msgsz, long msgtyp, int msgflg)
 {
@@ -769,6 +786,7 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
 	struct msg_msg *msg;
 	int mode;
 	struct ipc_namespace *ns;
+	size_t arrsz = msgsz;
 
 	if (msqid < 0 || (long) msgsz < 0)
 		return -EINVAL;
@@ -802,6 +820,16 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
 						walk_msg->m_type != 1) {
 					msg = walk_msg;
 					msgtyp = walk_msg->m_type - 1;
+				} else if (msgflg & MSG_STEAL) {
+					int ret;
+
+					ret = do_steal_msg(mtext, arrsz, msg);
+					if (ret < 0) {
+						msg = ERR_PTR(ret);
+						goto out_unlock;
+					}
+					mtext += ret + sizeof(struct msgbuf_a);
+					arrsz -= ret + sizeof(struct msgbuf_a);
 				} else {
 					msg = walk_msg;
 					break;
@@ -810,6 +838,8 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
 			tmp = tmp->next;
 		}
 		if (!IS_ERR(msg)) {
+			if (msgflg & MSG_STEAL)
+				goto out_unlock;
 			/*
 			 * Found a suitable message.
 			 * Unlink it from the queue.
@@ -904,10 +934,11 @@ out_unlock:
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
-	msgsz = (msgsz > msg->m_ts) ? msg->m_ts : msgsz;
+	if (msgflg & MSG_STEAL)
+		return msgsz;
+
 	*pmtype = msg->m_type;
-	if (store_msg(mtext, msg, msgsz))
-		msgsz = -EFAULT;
+	msgsz = do_store_msg(mtext, msgsz, msg);
 
 	free_msg(msg);
 
@@ -919,8 +950,10 @@ SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
 {
 	long err, mtype;
 
-	err =  do_msgrcv(msqid, &mtype, msgp->mtext, msgsz, msgtyp, msgflg);
-	if (err < 0)
+	err =  do_msgrcv(msqid, &mtype,
+			 (msgflg & MSG_STEAL) ? (void *)msgp : msgp->mtext,
+			 msgsz, msgtyp, msgflg);
+	if (err < 0 || msgflg & MSG_STEAL)
 		goto out;
 
 	if (put_user(mtype, &msgp->mtype))

