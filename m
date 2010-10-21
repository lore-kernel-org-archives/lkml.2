Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab0JUNpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:45:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55423 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab0JUNpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:45:44 -0400
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=mlhvJPAZVHMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=Tty9oNO6AAAA:8 a=Z4Rwk6OoAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=B9Hjl3UMDJWzuylPRXoA:9 a=fxLOk315nPgiT5oiGv7nE277HMMA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH v2][GIT PULL] tracing: Prevent unloadable modules from
 using trace_bprintk()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 21 Oct 2010 09:45:42 -0400
Message-ID: <1287668742.16971.585.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is based off of my core-2 branch. I'm moved this patch after that
so if anyone has any objections, I can change this patch without holding
off the previous one.

Note, I made the TRACE_BPRINTK_ALLOWED change since it looks better.

Thanks,

-- Steve

Please pull the latest tip/perf/core-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core-3


Steven Rostedt (1):
      tracing: Prevent unloadable modules from using trace_bprintk()

----
 include/linux/kernel.h      |   20 ++++++++++++++++++--
 kernel/trace/trace_printk.c |    2 ++
 2 files changed, 20 insertions(+), 2 deletions(-)
---------------------------
commit c3b87c579e5df72a59fe97d77d4c3791dc8154ec
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Oct 20 20:50:00 2010 -0400

    tracing: Prevent unloadable modules from using trace_bprintk()
    
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
    
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2b0a35e..9c683f3 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -538,6 +538,22 @@ do {									\
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
+#if defined(MODULE) && (defined(CONFIG_MODULE_UNLOAD) || !defined(CONFIG_MODVERSIONS))
+# define TRACE_BPRINTK_ALLOWED 0
+#else
+# define TRACE_BPRINTK_ALLOWED 1
+#endif
+
 /**
  * trace_printk - printf formatting in the ftrace buffer
  * @fmt: the printf format for printing
@@ -558,14 +574,14 @@ do {									\
 #define trace_printk(fmt, args...)					\
 do {									\
 	__trace_printk_check_format(fmt, ##args);			\
-	if (__builtin_constant_p(fmt)) {				\
+	if (__builtin_constant_p(fmt) && TRACE_BPRINTK_ALLOWED) {	\
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
index 2547d88..230bbd9 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -115,7 +115,9 @@ int __trace_bprintk(unsigned long ip, const char *fmt, ...)
 	va_end(ap);
 	return ret;
 }
+#if TRACE_BPRINTK_ALLOWED
 EXPORT_SYMBOL_GPL(__trace_bprintk);
+#endif
 
 int __ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap)
  {


