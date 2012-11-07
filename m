Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2KGKCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:02:46 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:7888 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab2KGKCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:02:44 -0500
Subject: [PATCH 3/4] ipc: simplify message copying
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: ebiederm@xmission.com, devel@openvz.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org
Date: Wed, 07 Nov 2012 13:05:05 +0300
Message-ID: <20121107100505.22846.27342.stgit@localhost.localdomain>
In-Reply-To: <20121107100317.22846.94715.stgit@localhost.localdomain>
References: <20121107100317.22846.94715.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removed redundant and confusing fill_copy(). It also adds
copy_msg() check for error. In this case exit from the function have to be
done instead of break, because further code interprets any error as EAGAIN.

It also defines copy_msg() for the case when CONFIG_CHECKPOINT_RESTORE is
disabled.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 ipc/msg.c     |   24 +++++++++---------------
 ipc/msgutil.c |    5 +++++
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index ad194f8..5e317fe 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -770,16 +770,6 @@ static long do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
-static inline struct msg_msg *fill_copy(unsigned long copy_nr,
-					unsigned long msg_nr,
-					struct msg_msg *msg,
-					struct msg_msg *copy)
-{
-	if (copy_nr == msg_nr)
-		return copy_msg(msg, copy);
-	return NULL;
-}
-
 static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
 					   int msgflg, long *msgtyp,
 					   unsigned long *copy_number)
@@ -803,8 +793,6 @@ static inline void free_copy(struct msg_msg *copy)
 		free_msg(copy);
 }
 #else
-#define fill_copy(copy_nr, msg_nr, msg, copy)		NULL
-
 static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
 					   int msgflg, long *msgtyp,
 					   unsigned long *copy_number)
@@ -868,10 +856,16 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 						walk_msg->m_type != 1) {
 					msgtyp = walk_msg->m_type - 1;
 				} else if (msgflg & MSG_COPY) {
-					msg = fill_copy(copy_number, msg_counter,
-							walk_msg, copy);
-					if (msg)
+					if (copy_number == msg_counter) {
+						/*
+						 * Found requested message.
+						 * Copy it.
+						 */
+						msg = copy_msg(msg, copy);
+						if (IS_ERR(msg))
+							goto out_unlock;
 						break;
+					}
 				} else
 					break;
 				msg_counter++;
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index b281f5c..4168bb8 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -138,6 +138,11 @@ struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst)
 
 	return dst;
 }
+#else
+struct msg_msg *copy_msg(struct msg_msg *src, struct msg_msg *dst)
+{
+	return ERR_PTR(-ENOSYS);
+}
 #endif
 int store_msg(void __user *dest, struct msg_msg *msg, int len)
 {

