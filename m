Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab0EDQRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:17:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40621 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab0EDQRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:17:11 -0400
X-Authority-Analysis: v=1.1 cv=Sj+DEJq9TvmrEz0yYf786F+83+V8ZKDvY/KsKt+Cs/8= c=1 sm=0 a=NoCRb4wRjeUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=jjGmlxDQAU8W45E5S4wA:9 a=z-BDHHD_AdlMDJgKvKkA:7 a=sfjp2hpb480P_sy3tVhN590-gTwA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] tracing: Convert nop macros to static inlines
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 04 May 2010 12:17:08 -0400
Message-ID: <1272989828.9739.223.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Steven Rostedt (1):
      tracing: Convert nop macros to static inlines

----
 include/linux/ftrace.h |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)
---------------------------
commit 4dbf6bc239c169b032777616806ecc648058f6b2
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue May 4 11:24:01 2010 -0400

    tracing: Convert nop macros to static inlines
    
    The ftrace.h file contains several functions as macros when the
    functions are disabled due to config options. This patch converts
    most of them to static inlines.
    
    There are two exceptions:
    
      register_ftrace_function() and unregister_ftrace_function()
    
    This is because their parameter "ops" must not be evaluated since
    code using the function is allowed to #ifdef out the creation of
    the parameter.
    
    This also fixes an error caused by recent changes:
    
     kernel/trace/trace_irqsoff.c: In function 'start_irqsoff_tracer':
     kernel/trace/trace_irqsoff.c:571: error: expected expression before 'do'
    
    Reported-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 8415a52..e0ae83b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -82,9 +82,13 @@ void clear_ftrace_function(void);
 extern void ftrace_stub(unsigned long a0, unsigned long a1);
 
 #else /* !CONFIG_FUNCTION_TRACER */
-# define register_ftrace_function(ops) do { } while (0)
-# define unregister_ftrace_function(ops) do { } while (0)
-# define clear_ftrace_function(ops) do { } while (0)
+/*
+ * (un)register_ftrace_function must be a macro since the ops parameter
+ * must not be evaluated.
+ */
+#define register_ftrace_function(ops) ({ 0; })
+#define unregister_ftrace_function(ops) ({ 0; })
+static inline void clear_ftrace_function(void) { }
 static inline void ftrace_kill(void) { }
 static inline void ftrace_stop(void) { }
 static inline void ftrace_start(void) { }
@@ -237,11 +241,13 @@ extern int skip_trace(unsigned long ip);
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
 #else
-# define skip_trace(ip)				({ 0; })
-# define ftrace_force_update()			({ 0; })
-# define ftrace_set_filter(buf, len, reset)	do { } while (0)
-# define ftrace_disable_daemon()		do { } while (0)
-# define ftrace_enable_daemon()			do { } while (0)
+static inline int skip_trace(unsigned long ip) { return 0; }
+static inline int ftrace_force_update(void) { return 0; }
+static inline void ftrace_set_filter(unsigned char *buf, int len, int reset)
+{
+}
+static inline void ftrace_disable_daemon(void) { }
+static inline void ftrace_enable_daemon(void) { }
 static inline void ftrace_release_mod(struct module *mod) {}
 static inline int register_ftrace_command(struct ftrace_func_command *cmd)
 {
@@ -314,16 +320,16 @@ static inline void __ftrace_enabled_restore(int enabled)
   extern void time_hardirqs_on(unsigned long a0, unsigned long a1);
   extern void time_hardirqs_off(unsigned long a0, unsigned long a1);
 #else
-# define time_hardirqs_on(a0, a1)		do { } while (0)
-# define time_hardirqs_off(a0, a1)		do { } while (0)
+  static inline void time_hardirqs_on(unsigned long a0, unsigned long a1) { }
+  static inline void time_hardirqs_off(unsigned long a0, unsigned long a1) { }
 #endif
 
 #ifdef CONFIG_PREEMPT_TRACER
   extern void trace_preempt_on(unsigned long a0, unsigned long a1);
   extern void trace_preempt_off(unsigned long a0, unsigned long a1);
 #else
-# define trace_preempt_on(a0, a1)		do { } while (0)
-# define trace_preempt_off(a0, a1)		do { } while (0)
+  static inline void trace_preempt_on(unsigned long a0, unsigned long a1) { }
+  static inline void trace_preempt_off(unsigned long a0, unsigned long a1) { }
 #endif
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD


