Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0JULGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:06:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855Ab0JULGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:06:09 -0400
Date: Thu, 21 Oct 2010 13:05:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] tracing: Prevent unloadable modules from using
 trace_bprintk()
Message-ID: <20101021110551.GA26984@elte.hu>
References: <20101021024233.530237054@goodmis.org>
 <20101021024304.827826848@goodmis.org>
 <20101021081648.GC8775@elte.hu>
 <1287658671.16971.566.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287658671.16971.566.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > > +#endif
> > 
> > Looks quite ugly all around. Cannot suggest anything better though straight away 
> > - so please Cc: it more widely and get an ack from the module folks: Rusty, 
> > Linus, akpm.
> 
> Just added them.

Below is the full patch again.

	Ingo

----- Forwarded message from Steven Rostedt <rostedt@goodmis.org> -----

Date: Wed, 20 Oct 2010 22:42:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] tracing: Prevent unloadable modules from using trace_bprintk()

From: Steven Rostedt <srostedt@redhat.com>

While debugging a module, I found that unloading the module and
then reading the ring buffer can cause strange side effects, including
a kernel crash.

This is due to the trace_bprintk(). The trace_bprintk() is a faster
version of trace_printk(). The difference is that trace_bprintk()
only copies the arguments and a pointer to the format string into
the ring buffer.

If a module uses this function and is unloaded, the pointer back to
the format string in the module is still around. If the trace file
is read, then the pointer is referenced and this can cause a kernel
oops.

The simple solution is to not let modules use trace_bprintk() and
instead it will use the slower version of this.

When talking with Frederic Weisbecker about it, he suggested not to
punish modules that can not be unloaded since they do not have
this side effect. Modules that can not be unloaded can still use
trace_bprintk(). We added a check for MODVERSIONS to be set to make
sure that the module and kernel have the same options. If you
run without MODVERSIONS set, and you load a module that was compiled
differently, then that's just your tough luck.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h      |   21 +++++++++++++++++++--
 kernel/trace/trace_printk.c |    2 ++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2b0a35e..1003476 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -538,6 +538,23 @@ do {									\
 		____trace_printk_check_format(fmt, ##args);		\
 } while (0)
 
+/*
+ * Module code must not use trace_bprintk, because if it is unloaded
+ * then we leave a pointer back to the module code inside
+ * the ring buffer, and then reading the ring buffer may cause a bug.
+ *
+ * We do allow for modules to use it if the kernel does not allow
+ * unloading of modules, and MODVERSIONS is set (to make sure kernel
+ * and module are the same). If you load modules without MODVERSIONS
+ * set, then you deserve what you get.
+ */
+#if defined(MODULE) &&							\
+	(defined(CONFIG_MODULE_UNLOAD) || !defined(CONFIG_MODVERSIONS))
+# define FORCE_TRACEPRINTK 1
+#else
+# define FORCE_TRACEPRINTK 0
+#endif
+
 /**
  * trace_printk - printf formatting in the ftrace buffer
  * @fmt: the printf format for printing
@@ -558,14 +575,14 @@ do {									\
 #define trace_printk(fmt, args...)					\
 do {									\
 	__trace_printk_check_format(fmt, ##args);			\
-	if (__builtin_constant_p(fmt)) {				\
+	if (__builtin_constant_p(fmt) && !FORCE_TRACEPRINTK) {		\
 		static const char *trace_printk_fmt			\
 		  __attribute__((section("__trace_printk_fmt"))) =	\
 			__builtin_constant_p(fmt) ? fmt : NULL;		\
 									\
 		__trace_bprintk(_THIS_IP_, trace_printk_fmt, ##args);	\
 	} else								\
-		__trace_printk(_THIS_IP_, fmt, ##args);		\
+		__trace_printk(_THIS_IP_, fmt, ##args);			\
 } while (0)
 
 extern int
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 2547d88..c4a5db6 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -115,7 +115,9 @@ int __trace_bprintk(unsigned long ip, const char *fmt, ...)
 	va_end(ap);
 	return ret;
 }
+#if !FORCE_TRACEPRINTK
 EXPORT_SYMBOL_GPL(__trace_bprintk);
+#endif
 
 int __ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap)
  {

