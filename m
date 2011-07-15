Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825Ab1GODlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 23:41:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab1GODlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 23:41:03 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=k8zRvvoms2cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=LTrEE7AAE4Y_Qw5AjyAA:9 a=I21kZ0yO7GYbUqUOQuUA:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110715034101.665952185@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jul 2011 23:38:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] ftrace: Fix regression where ftrace breaks when modules are loaded
References: <20110715033855.206223173@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-Fix-regression-where-ftrace-breaks-when-modul.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Enabling function tracer to trace all functions, then load a module and
then disable function tracing will cause ftrace to fail.

This can also happen by enabling function tracing on the command line:

  ftrace=function

and during boot up, modules are loaded, then you disable function tracing
with 'echo nop > current_tracer' you will trigger a bug in ftrace that
will shut itself down.

The reason is, the new ftrace code keeps ref counts of all ftrace_ops that
are registered for tracing. When one or more ftrace_ops are registered,
all the records that represent the functions that the ftrace_ops will
trace have a ref count incremented. If this ref count is not zero,
when the code modification runs, that function will be enabled for tracing.
If the ref count is zero, that function will be disabled from tracing.

To make sure the accounting was working, FTRACE_WARN_ON()s were added
to updating of the ref counts.

If the ref count hits its max (> 2^30 ftrace_ops added), or if
the ref count goes below zero, a FTRACE_WARN_ON() is triggered which
disables all modification of code.

Since it is common for ftrace_ops to trace all functions in the kernel,
instead of creating > 20,000 hash items for the ftrace_ops, the hash
count is just set to zero, and it represents that the ftrace_ops is
to trace all functions. This is where the issues arrise.

If you enable function tracing to trace all functions, and then add
a module, the modules function records do not get the ref count updated.
When the function tracer is disabled, all function records ref counts
are subtracted. Since the modules never had their ref counts incremented,
they go below zero and the FTRACE_WARN_ON() is triggered.

The solution to this is rather simple. When modules are loaded, and
their functions are added to the the ftrace pool, look to see if any
ftrace_ops are registered that trace all functions. And for those,
update the ref count for the module function records.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1c4c0b0..ef9271b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1744,10 +1744,36 @@ static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
+static int ops_traces_mod(struct ftrace_ops *ops)
+{
+	struct ftrace_hash *hash;
+
+	hash = ops->filter_hash;
+	return !!(!hash || !hash->count);
+}
+
 static int ftrace_update_code(struct module *mod)
 {
 	struct dyn_ftrace *p;
 	cycle_t start, stop;
+	unsigned long ref = 0;
+
+	/*
+	 * When adding a module, we need to check if tracers are
+	 * currently enabled and if they are set to trace all functions.
+	 * If they are, we need to enable the module functions as well
+	 * as update the reference counts for those function records.
+	 */
+	if (mod) {
+		struct ftrace_ops *ops;
+
+		for (ops = ftrace_ops_list;
+		     ops != &ftrace_list_end; ops = ops->next) {
+			if (ops->flags & FTRACE_OPS_FL_ENABLED &&
+			    ops_traces_mod(ops))
+				ref++;
+		}
+	}
 
 	start = ftrace_now(raw_smp_processor_id());
 	ftrace_update_cnt = 0;
@@ -1760,7 +1786,7 @@ static int ftrace_update_code(struct module *mod)
 
 		p = ftrace_new_addrs;
 		ftrace_new_addrs = p->newlist;
-		p->flags = 0L;
+		p->flags = ref;
 
 		/*
 		 * Do the initial record conversion from mcount jump
@@ -1783,7 +1809,7 @@ static int ftrace_update_code(struct module *mod)
 		 * conversion puts the module to the correct state, thus
 		 * passing the ftrace_make_call check.
 		 */
-		if (ftrace_start_up) {
+		if (ftrace_start_up && ref) {
 			int failed = __ftrace_replace_code(p, 1);
 			if (failed) {
 				ftrace_bug(failed, p->ip);
-- 
1.7.5.4


