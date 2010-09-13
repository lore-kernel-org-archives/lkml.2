Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab0IMVrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:47:04 -0400
Received: from mail.openrapids.net ([64.15.138.104]:34911 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751943Ab0IMVrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:47:02 -0400
Date: Mon, 13 Sep 2010 17:47:00 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH] sched: fix string comparison in features (v2)
Message-ID: <20100913214700.GB16118@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:45:53 up 234 days, 22 min,  3 users,  load average: 0.08,
	0.09, 0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect handling of the following case:

INTERACTIVE
INTERACTIVE_SOMETHING_ELSE

The comparison only checks up to each element's length.

Changelog since v1:
- Embellish using some Rostedisms.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng.git/kernel/sched.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched.c
+++ linux-2.6-lttng.git/kernel/sched.c
@@ -721,7 +721,7 @@ sched_feat_write(struct file *filp, cons
 		size_t cnt, loff_t *ppos)
 {
 	char buf[64];
-	char *cmp = buf;
+	char *cmp;
 	int neg = 0;
 	int i;
 
@@ -732,6 +732,7 @@ sched_feat_write(struct file *filp, cons
 		return -EFAULT;
 
 	buf[cnt] = 0;
+	cmp = strstrip(buf);
 
 	if (strncmp(buf, "NO_", 3) == 0) {
 		neg = 1;
@@ -739,9 +740,7 @@ sched_feat_write(struct file *filp, cons
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
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
