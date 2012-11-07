Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2KGKCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:02:35 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:6439 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517Ab2KGKCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:02:33 -0500
Subject: [PATCH 1/4] ipc: simplify free_copy() call
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: ebiederm@xmission.com, devel@openvz.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org
Date: Wed, 07 Nov 2012 13:04:55 +0300
Message-ID: <20121107100455.22846.75336.stgit@localhost.localdomain>
In-Reply-To: <20121107100317.22846.94715.stgit@localhost.localdomain>
References: <20121107100317.22846.94715.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing and checking of msgflg to free_copy() is redundant.
This patch sets copy to NULL on declaration instead and checks for non-NULL in
free_copy().

Note: in case of copy allocation failure, error is returned immediately. So
no need to check for IS_ERR() in free_copy().

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 ipc/msg.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index a0b0224..f1070c3 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -797,15 +797,17 @@ static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
 	return copy;
 }
 
-static inline void free_copy(int msgflg, struct msg_msg *copy)
+static inline void free_copy(struct msg_msg *copy)
 {
-	if (msgflg & MSG_COPY)
+	if (copy)
 		free_msg(copy);
 }
 #else
-#define free_copy(msgflg, copy)				do {} while (0)
 #define prepare_copy(buf, sz, msgflg, msgtyp, copy_nr)	ERR_PTR(-ENOSYS)
 #define fill_copy(copy_nr, msg_nr, msg, copy)		NULL
+static inline void free_copy(struct msg_msg *copy)
+{
+}
 #endif
 
 long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
@@ -816,7 +818,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	struct msg_msg *msg;
 	int mode;
 	struct ipc_namespace *ns;
-	struct msg_msg *copy;
+	struct msg_msg *copy = NULL;
 	unsigned long __maybe_unused copy_number;
 
 	if (msqid < 0 || (long) bufsz < 0)
@@ -831,7 +833,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 
 	msq = msg_lock_check(ns, msqid);
 	if (IS_ERR(msq)) {
-		free_copy(msgflg, copy);
+		free_copy(copy);
 		return PTR_ERR(msq);
 	}
 
@@ -964,7 +966,7 @@ out_unlock:
 		}
 	}
 	if (IS_ERR(msg)) {
-		free_copy(msgflg, copy);
+		free_copy(copy);
 		return PTR_ERR(msg);
 	}
 

