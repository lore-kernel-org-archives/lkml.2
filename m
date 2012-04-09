Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab2DIRyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:54:22 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:9386 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405Ab2DIRyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:54:18 -0400
Subject: [PATCH 1/4] ipc: rename obfuscating MSG_STEAL flag into MSG_PEEK_ALL
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, dhowells@redhat.com, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        criu@openvz.org, mtk.manpages@gmail.com
Date: Mon, 09 Apr 2012 21:53:57 +0400
Message-ID: <20120409175357.8358.21000.stgit@localhost6.localdomain6>
In-Reply-To: <20120409175309.8358.21631.stgit@localhost6.localdomain6>
References: <20120409175309.8358.21631.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSG_PEEK_ALL looks familiar because MSG_PEEK for one socket message is used
already.

---
 include/linux/msg.h |    2 +-
 ipc/compat.c        |    6 +++---
 ipc/msg.c           |   10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/msg.h b/include/linux/msg.h
index 5eb43a2..bd8fe66 100644
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -11,7 +11,7 @@
 /* msgrcv options */
 #define MSG_NOERROR     010000  /* no error if message is too big */
 #define MSG_EXCEPT      020000  /* recv any msg except of specified type.*/
-#define MSG_STEAL       040000  /* copy (not remove) all queue messages */
+#define MSG_PEEK_ALL    040000  /* copy (not remove) all queue messages */
 
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct msqid_ds {
diff --git a/ipc/compat.c b/ipc/compat.c
index d2b34f8..96cb9db 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -335,7 +335,7 @@ long compat_sys_msgsnd(int first, int second, int third, void __user *uptr)
 }
 
 
-static long compat_do_msg_steal(void __user *dest, struct msg_msg *msg, size_t bufsz)
+static long compat_do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct compat_msgbuf_a __user *msgp = dest;
 	size_t msgsz;
@@ -387,8 +387,8 @@ long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
 		msgtyp = ipck.msgtyp;
 	}
 	return do_msgrcv(first, uptr, second, msgtyp, third,
-			 (third & MSG_STEAL) ? compat_do_msg_steal
-					      : compat_do_msg_fill);
+			 (third & MSG_PEEK_ALL) ? compat_do_msg_peek_all
+						: compat_do_msg_fill);
 }
 
 static inline int get_compat_msqid64(struct msqid64_ds *m64,
diff --git a/ipc/msg.c b/ipc/msg.c
index 64f83b6..017bf0b 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -762,7 +762,7 @@ static inline int convert_mode(long *msgtyp, int msgflg)
 	return SEARCH_EQUAL;
 }
 
-static long do_msg_steal(void __user *dest, struct msg_msg *msg, size_t bufsz)
+static long do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
 {
 	struct msgbuf_a __user *msgp = dest;
 	size_t msgsz;
@@ -845,7 +845,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 						walk_msg->m_type != 1) {
 					msg = walk_msg;
 					msgtyp = walk_msg->m_type - 1;
-				} else if (msgflg & MSG_STEAL) {
+				} else if (msgflg & MSG_PEEK_ALL) {
 					long ret;
 
 					ret = msg_fill(buf, msg, arrsz);
@@ -863,7 +863,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 			tmp = tmp->next;
 		}
 		if (!IS_ERR(msg)) {
-			if (msgflg & MSG_STEAL)
+			if (msgflg & MSG_PEEK_ALL)
 				goto out_unlock;
 			/*
 			 * Found a suitable message.
@@ -959,7 +959,7 @@ out_unlock:
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
-	if (msgflg & MSG_STEAL)
+	if (msgflg & MSG_PEEK_ALL)
 		return bufsz - arrsz;
 
 	bufsz = msg_fill(buf, msg, bufsz);
@@ -972,7 +972,7 @@ SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
 		long, msgtyp, int, msgflg)
 {
 	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg,
-			 (msgflg & MSG_STEAL) ? do_msg_steal : do_msg_fill);
+			 (msgflg & MSG_PEEK_ALL) ? do_msg_peek_all : do_msg_fill);
 }
 
 #ifdef CONFIG_PROC_FS

