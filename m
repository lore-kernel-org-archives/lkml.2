Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0HZSO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:14:27 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40482 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab0HZSOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:14:22 -0400
Message-Id: <20100826181339.637321874@efficios.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 Aug 2010 14:09:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tony Lindgren <tony@atomide.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 01/11] sched: fix string comparison in features
References: <20100826180908.648103531@efficios.com>
Content-Disposition: inline; filename=sched-features-fix-string-compare.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 26 Aug 2010 18:13:39 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incorrect handling of the following case:

INTERACTIVE
INTERACTIVE_SOMETHING_ELSE

The comparison only checks up to each element's length.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng.git/kernel/sched.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched.c
+++ linux-2.6-lttng.git/kernel/sched.c
@@ -722,7 +722,7 @@ sched_feat_write(struct file *filp, cons
 {
 	char buf[64];
 	char *cmp = buf;
-	int neg = 0;
+	int neg = 0, cmplen;
 	int i;
 
 	if (cnt > 63)
@@ -732,15 +732,24 @@ sched_feat_write(struct file *filp, cons
 		return -EFAULT;
 
 	buf[cnt] = 0;
+	for (i = 0; i < cnt; i++) {
+		if (buf[i] == '\n' || buf[i] == ' ') {
+			buf[i] = 0;
+			break;
+		}
+	}
 
 	if (strncmp(buf, "NO_", 3) == 0) {
 		neg = 1;
 		cmp += 3;
 	}
 
+	cmplen = strlen(cmp);
 	for (i = 0; sched_feat_names[i]; i++) {
 		int len = strlen(sched_feat_names[i]);
 
+		if (cmplen != len)
+			continue;
 		if (strncmp(cmp, sched_feat_names[i], len) == 0) {
 			if (neg)
 				sysctl_sched_features &= ~(1UL << i);

