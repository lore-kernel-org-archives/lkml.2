Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab1FGRIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:08:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48597 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab1FGRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:08:28 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=jbiHSLWd0S0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=qrFUQHepZ-ABwXDrkuMA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110607170827.629849682@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 07 Jun 2011 13:07:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH 3/3] ftrace: Revert 8ab2b7efd ftrace: Remove unnecessary disabling of
References: <20110607170740.235441001@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Revert-8ab2b7efd-ftrace-Remove-unnecessary-di.patch
 irqs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Revert the commit that removed the disabling of interrupts around
the initial modifying of mcount callers to nops, and update the comment.

The original comment was outdated and stated that the interrupts were
being disabled to prevent kstop machine, which was required with the
old ftrace daemon, but was no longer the case.

What the comment failed to mention was that interrupts needed to be
disabled to keep interrupts from preempting the modifying of the code
and then executing the code that was partially modified.

Revert the commint and update the comment.

Reported-by: Richard W.M. Jones <rjones@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 204b3eb..908038f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3330,6 +3330,7 @@ static int ftrace_process_locs(struct module *mod,
 {
 	unsigned long *p;
 	unsigned long addr;
+	unsigned long flags;
 
 	mutex_lock(&ftrace_lock);
 	p = start;
@@ -3346,7 +3347,13 @@ static int ftrace_process_locs(struct module *mod,
 		ftrace_record_ip(addr);
 	}
 
+	/*
+	 * Disable interrupts to prevent interrupts from executing
+	 * code that is being modified.
+	 */
+	local_irq_save(flags);
 	ftrace_update_code(mod);
+	local_irq_restore(flags);
 	mutex_unlock(&ftrace_lock);
 
 	return 0;
-- 
1.7.4.4


