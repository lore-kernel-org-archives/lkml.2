Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0JUCnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:43:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab0JUCnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:43:07 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=YBb_RYhy0G4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=gK245kvmrmg24UJkMm4A:9 a=0KKaUo89TN8ES49U_Z64KxwHCycA:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101021024304.827826848@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Oct 2010 22:42:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] tracing: Prevent unloadable modules from using trace_bprintk()
References: <20101021024233.530237054@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Prevent-unloadable-modules-from-using-trace_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.7.1


