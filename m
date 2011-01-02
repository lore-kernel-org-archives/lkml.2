Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1ABHZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:43 -0500
Received: from mail.windriver.com ([147.11.1.11]:37106 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1ABHZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:36 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Lindgren <tony@atomide.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 223/260] sched: Fix string comparison in /proc/sched_features
Date: Sun,  2 Jan 2011 02:18:39 -0500
Message-Id: <1293952756-15010-224-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:13.0495 (UTC) FILETIME=[0E571470:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 7740191cd909b75d75685fb08a5d1f54b8a9d28b upstream.

Fix incorrect handling of the following case:

 INTERACTIVE
 INTERACTIVE_SOMETHING_ELSE

The comparison only checks up to each element's length.

Changelog since v1:
 - Embellish using some Rostedtisms.
  [ mingo:                 ^^ == smaller and cleaner ]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Lindgren <tony@atomide.com>
LKML-Reference: <20100913214700.GB16118@Krystal>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dd7c170..12ee156 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -713,7 +713,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
 	char buf[64];
-	char *cmp = buf;
+	char *cmp;
 	int neg = 0;
 	int i;
 
@@ -724,6 +724,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 		return -EFAULT;
 
 	buf[cnt] = 0;
+	cmp = strstrip(buf);
 
 	if (strncmp(buf, "NO_", 3) == 0) {
 		neg = 1;
@@ -731,9 +732,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	}
 
 	for (i = 0; sched_feat_names[i]; i++) {
-		int len = strlen(sched_feat_names[i]);
-
-		if (strncmp(cmp, sched_feat_names[i], len) == 0) {
+		if (strcmp(cmp, sched_feat_names[i]) == 0) {
 			if (neg)
 				sysctl_sched_features &= ~(1UL << i);
 			else
-- 
1.7.3.3

