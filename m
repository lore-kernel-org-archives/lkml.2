Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0INMW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:22:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:36107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab0INMWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:22:24 -0400
Date: Tue, 14 Sep 2010 12:21:54 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, peterz@infradead.org, tony@atomide.com,
        rostedt@goodmis.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, peterz@infradead.org, tony@atomide.com,
        rostedt@goodmis.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20100913214700.GB16118@Krystal>
References: <20100913214700.GB16118@Krystal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix string comparison in /proc/sched_features
Message-ID: <tip-7740191cd909b75d75685fb08a5d1f54b8a9d28b@git.kernel.org>
Git-Commit-ID: 7740191cd909b75d75685fb08a5d1f54b8a9d28b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Sep 2010 12:21:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7740191cd909b75d75685fb08a5d1f54b8a9d28b
Gitweb:     http://git.kernel.org/tip/7740191cd909b75d75685fb08a5d1f54b8a9d28b
Author:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate: Mon, 13 Sep 2010 17:47:00 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Sep 2010 13:23:45 +0200

sched: Fix string comparison in /proc/sched_features

Fix incorrect handling of the following case:

 INTERACTIVE
 INTERACTIVE_SOMETHING_ELSE

The comparison only checks up to each element's length.

Changelog since v1:
 - Embellish using some Rostedtisms.
  [ mingo:                 ^^ == smaller and cleaner ]

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: <stable@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Lindgren <tony@atomide.com>
LKML-Reference: <20100913214700.GB16118@Krystal>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 26f83e2..b40b82e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -721,7 +721,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 		size_t cnt, loff_t *ppos)
 {
 	char buf[64];
-	char *cmp = buf;
+	char *cmp;
 	int neg = 0;
 	int i;
 
@@ -732,6 +732,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 		return -EFAULT;
 
 	buf[cnt] = 0;
+	cmp = strstrip(buf);
 
 	if (strncmp(buf, "NO_", 3) == 0) {
 		neg = 1;
@@ -739,9 +740,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	}
 
 	for (i = 0; sched_feat_names[i]; i++) {
-		int len = strlen(sched_feat_names[i]);
-
-		if (strncmp(cmp, sched_feat_names[i], len) == 0) {
+		if (strcmp(cmp, sched_feat_names[i]) == 0) {
 			if (neg)
 				sysctl_sched_features &= ~(1UL << i);
 			else
