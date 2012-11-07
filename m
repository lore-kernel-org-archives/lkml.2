Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2KGKCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:02:42 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:46002 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab2KGKCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:02:40 -0500
Subject: [PATCH 2/4] ipc: convert prepare_copy() from macro to function
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: ebiederm@xmission.com, devel@openvz.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jmorris@namei.org
Date: Wed, 07 Nov 2012 13:05:00 +0300
Message-ID: <20121107100500.22846.143.stgit@localhost.localdomain>
In-Reply-To: <20121107100317.22846.94715.stgit@localhost.localdomain>
References: <20121107100317.22846.94715.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code works if CONFIG_CHECKPOINT_RESTORE is disabled.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 ipc/msg.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index f1070c3..ad194f8 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -803,8 +803,15 @@ static inline void free_copy(struct msg_msg *copy)
 		free_msg(copy);
 }
 #else
-#define prepare_copy(buf, sz, msgflg, msgtyp, copy_nr)	ERR_PTR(-ENOSYS)
 #define fill_copy(copy_nr, msg_nr, msg, copy)		NULL
+
+static inline struct msg_msg *prepare_copy(void __user *buf, size_t bufsz,
+					   int msgflg, long *msgtyp,
+					   unsigned long *copy_number)
+{
+	return ERR_PTR(-ENOSYS);
+}
+
 static inline void free_copy(struct msg_msg *copy)
 {
 }
@@ -819,7 +826,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	int mode;
 	struct ipc_namespace *ns;
 	struct msg_msg *copy = NULL;
-	unsigned long __maybe_unused copy_number;
+	unsigned long __maybe_unused copy_number = 0;
 
 	if (msqid < 0 || (long) bufsz < 0)
 		return -EINVAL;

