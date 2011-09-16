Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1IPMSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:18:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43813 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab1IPMS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:18:29 -0400
X-Authority-Analysis: v=1.1 cv=BYTzOfBuqH0MnPkg9hJMEJejO8uiqGqgn0U8Q/tCzYo= c=1 sm=0 a=Ou53dPJkDmsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=meVymXHHAAAA:8 a=ZTsbKecoXV8ulAn1bFYA:9 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] ftrace:  use a global counter for the global clock
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1316163765.10174.8.camel@twins>
References: <1316163765.10174.8.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 16 Sep 2011 08:18:26 -0400
Message-ID: <1316175506.26295.36.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 11:02 +0200, Peter Zijlstra wrote:
> no reason to muck about, just use a counter already.
> 

But some of us actually use the global clock as a clock ;)

How about this patch instead?

----

tracing: Add a counter clock for those that do not trust clocks

When debugging tight race conditions, it can be helpful to have a
synchronized tracing method. Although in most cases the global clock
provides this functionality, if timings is not the issue, it is more
comforting to know that the order of events really happened in a precise
order.

Instead of using a clock, add a "counter" that is simply an incrementing
atomic 64bit counter that orders the events as they are perceived to
happen.

The trace_clock_counter() is added from the attempt by Peter Zijlstra
trying to convert the trace_clock_global() to it. I took Peter's counter
code and made trace_clock_counter() instead, and added it to the choice
of clocks. Just echo counter > /debug/tracing/trace_clock to activate
it.

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Requested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/trace_clock.h b/include/linux/trace_clock.h
index 7a81303..4eb4902 100644
--- a/include/linux/trace_clock.h
+++ b/include/linux/trace_clock.h
@@ -15,5 +15,6 @@
 extern u64 notrace trace_clock_local(void);
 extern u64 notrace trace_clock(void);
 extern u64 notrace trace_clock_global(void);
+extern u64 notrace trace_clock_counter(void);
 
 #endif /* _LINUX_TRACE_CLOCK_H */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b419070..4b8df0d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -435,6 +435,7 @@ static struct {
 } trace_clocks[] = {
 	{ trace_clock_local,	"local" },
 	{ trace_clock_global,	"global" },
+	{ trace_clock_counter,	"counter" },
 };
 
 int trace_clock_id;
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 6302747..3947835 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -113,3 +113,15 @@ u64 notrace trace_clock_global(void)
 
 	return now;
 }
+
+static atomic64_t trace_counter;
+
+/*
+ * trace_clock_counter(): simply an atomic counter.
+ * Use the trace_counter "counter" for cases where you do not care
+ * about timings, but are interested in strict ordering.
+ */
+u64 notrace trace_clock_counter(void)
+{
+	return atomic64_add_return(1, &trace_counter);
+}


