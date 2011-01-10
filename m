Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1AJNtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:49:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:35285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1AJNtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:49:08 -0500
Subject: Re: [tip:perf/urgent] tracing: Include module.h in define_trace.h
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-3a9f987b3141f086de27832514aad9f50a53f754@git.kernel.org>
References: <tip-3a9f987b3141f086de27832514aad9f50a53f754@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 Jan 2011 14:49:37 +0100
Message-ID: <1294667377.11896.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-09 at 21:09 +0000, tip-bot for Steven Rostedt wrote:
> Commit-ID:  3a9f987b3141f086de27832514aad9f50a53f754
> Gitweb:     http://git.kernel.org/tip/3a9f987b3141f086de27832514aad9f50a53f754
> Author:     Steven Rostedt <srostedt@redhat.com>
> AuthorDate: Fri, 7 Jan 2011 15:40:10 -0500
> Committer:  Steven Rostedt <rostedt@goodmis.org>
> CommitDate: Fri, 7 Jan 2011 15:44:56 -0500
> 
> tracing: Include module.h in define_trace.h
> 
> While doing some developing, Peter Zijlstra and I have found
> that if a CREATE_TRACE_POINTS include is done before module.h
> is included, it can break the build.
> 
> We have been lucky so far that this has not broke the build
> since module.h is included in almost everything.
> 
> Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/trace/define_trace.h |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
> index b0b4eb2..da39b22 100644
> --- a/include/trace/define_trace.h
> +++ b/include/trace/define_trace.h
> @@ -21,6 +21,16 @@
>  #undef CREATE_TRACE_POINTS
>  
>  #include <linux/stringify.h>
> +/*
> + * module.h includes tracepoints, and because ftrace.h
> + * pulls in module.h:
> + *  trace/ftrace.h -> linux/ftrace_event.h -> linux/perf_event.h ->
> + *  linux/ftrace.h -> linux/module.h
> + * we must include module.h here before we play with any of
> + * the TRACE_EVENT() macros, otherwise the tracepoints included
> + * by module.h may break the build.
> + */
> +#include <linux/module.h>
>  
>  #undef TRACE_EVENT
>  #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\

After I got everything building on that tree I was working on, the above
was found to compile but not to link, since it makes every:

 #define CREATE_TRACE_POINTS
 #include <trace/event/foo.h>

site also create the trace/event/module.h tracepoints, thus confusing
the linker with tons of duplicate symbols.

The below patch makes things compile and link:

---
 include/trace/define_trace.h |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index da39b22..9ebd0d3 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -21,16 +21,6 @@
 #undef CREATE_TRACE_POINTS
 
 #include <linux/stringify.h>
-/*
- * module.h includes tracepoints, and because ftrace.h
- * pulls in module.h:
- *  trace/ftrace.h -> linux/ftrace_event.h -> linux/perf_event.h ->
- *  linux/ftrace.h -> linux/module.h
- * we must include module.h here before we play with any of
- * the TRACE_EVENT() macros, otherwise the tracepoints included
- * by module.h may break the build.
- */
-#include <linux/module.h>
 
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, args, tstruct, assign, print)	\
@@ -120,4 +110,17 @@
 /* We may be processing more files */
 #define CREATE_TRACE_POINTS
 
+#else /* CREATE_TRACE_POINTS */
+
+/*
+ * module.h includes tracepoints, and because ftrace.h
+ * pulls in module.h:
+ *  trace/ftrace.h -> linux/ftrace_event.h -> linux/perf_event.h ->
+ *  linux/ftrace.h -> linux/module.h
+ * we must include module.h here before we play with any of
+ * the TRACE_EVENT() macros, otherwise the tracepoints included
+ * by module.h may break the build.
+ */
+#include <linux/module.h>
+
 #endif /* CREATE_TRACE_POINTS */

