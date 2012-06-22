Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab2FVKpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:45:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5172 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab2FVKpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:45:42 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FlAZEPfbBygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=ek13JImSwrPhBqvSRdYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340361939.27036.224.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        AndrewMorton <akpm@linux-foundation.org>
Date: Fri, 22 Jun 2012 06:45:39 -0400
In-Reply-To: <20120622071718.GC22167@gmail.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
	 <20120622071718.GC22167@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 09:17 +0200, Ingo Molnar wrote:

> Maybe also add the actual usage sites, to demonstrate how it's 
> going to be used?

Here's the places that I added (and tested) the pr_flush().

I even added 'set_current_task(TASK_UNINTERRUPTIBLE);
schedule_timeout(5*HZ);' to see if it does flush, and it worked fine.

-- Steve

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 49249c2..f7f2cd0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -825,6 +825,7 @@ int register_tracer(struct tracer *type)
 
 		/* the test is responsible for initializing and enabling */
 		pr_info("Testing tracer %s: ", type->name);
+		pr_flush();
 		ret = type->selftest(type, tr);
 		/* the test is responsible for resetting too */
 		current_trace = saved_tracer;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 29111da..84b674e 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1606,6 +1606,7 @@ static __init void event_trace_self_tests(void)
 #endif
 
 		pr_info("Testing event %s: ", call->name);
+		pr_flush();
 
 		/*
 		 * If an event is already enabled, someone is using
@@ -1635,6 +1636,7 @@ static __init void event_trace_self_tests(void)
 			continue;
 
 		pr_info("Testing event system %s: ", system->name);
+		pr_flush();
 
 		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 1);
 		if (WARN_ON_ONCE(ret)) {
@@ -1657,6 +1659,7 @@ static __init void event_trace_self_tests(void)
 
 	pr_info("Running tests on all trace events:\n");
 	pr_info("Testing all events: ");
+	pr_flush();
 
 	ret = __ftrace_set_clr_event(NULL, NULL, NULL, 1);
 	if (WARN_ON_ONCE(ret)) {
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 288541f..9638639 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -161,6 +161,7 @@ static void print_counts(void)
 	       trace_selftest_test_probe3_cnt,
 	       trace_selftest_test_global_cnt,
 	       trace_selftest_test_dyn_cnt);
+	pr_flush();
 }
 
 static void reset_counts(void)
@@ -184,6 +185,7 @@ static int trace_selftest_ops(int cnt)
 
 	printk(KERN_CONT "PASSED\n");
 	pr_info("Testing dynamic ftrace ops #%d: ", cnt);
+	pr_flush();
 
 	ftrace_enabled = 1;
 	reset_counts();
@@ -315,6 +317,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	/* The ftrace test PASSED */
 	printk(KERN_CONT "PASSED\n");
 	pr_info("Testing dynamic ftrace: ");
+	pr_flush();
 
 	/* enable tracing, and record the filter function */
 	ftrace_enabled = 1;


