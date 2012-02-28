Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965391Ab2B1O54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:57:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965140Ab2B1O5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:57:53 -0500
Date: Tue, 28 Feb 2012 15:57:45 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Fix build breakage without CONFIG_PERF_EVENTS
Message-ID: <20120228145744.GG1694@m.brq.redhat.com>
References: <1330426967-17067-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1330427423-25499-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330427423-25499-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 11:10:23AM +0000, Mark Brown wrote:
> Today's -next fails to build for me:
> 
>   CC      kernel/trace/trace_export.o
> In file included from kernel/trace/trace_export.c:197: kernel/trace/trace_entries.h:58: error: 'perf_ftrace_event_register' undeclared here (not in a function)
> make[2]: *** [kernel/trace/trace_export.o] Error 1
> make[1]: *** [kernel/trace] Error 2
> make: *** [kernel] Error 2
> 
> because as of ced390 (ftrace, perf: Add support to use function
> tracepoint in perf) perf_trace_event_register() is declared in trace.h
> only if CONFIG_PERF_EVENTS is enabled but I don't have that set.
> 
> Ensure that we always have a definition of perf_trace_event_register()
> by providing a definition if CONFIG_PERF_EVENTS is disabled.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> This one had the build test run all the way...
> 
>  kernel/trace/trace.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 54faec7..2aef24e 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -842,6 +842,8 @@ int perf_ftrace_event_register(struct ftrace_event_call *call,
>  #else
>  #define perf_ftrace_event_register NULL
>  #endif /* CONFIG_FUNCTION_TRACER */
> +#else
> +#define perf_ftrace_event_register NULL
>  #endif /* CONFIG_PERF_EVENTS */
>  
>  #endif /* _LINUX_KERNEL_TRACE_H */
> -- 
> 1.7.9.1
> 

ook, this one fixies that for me as well ;) I got your replies mixed in
mailbox and thought this one was not actually working..

I also added this bit to get rid of the switch warnings,
feel free to use it.

thanks,
jirka
---
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index dd478fc..5f3f3be 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -144,12 +144,14 @@ struct event_filter;
 enum trace_reg {
 	TRACE_REG_REGISTER,
 	TRACE_REG_UNREGISTER,
+#ifdef CONFIG_PERF_EVENTS
 	TRACE_REG_PERF_REGISTER,
 	TRACE_REG_PERF_UNREGISTER,
 	TRACE_REG_PERF_OPEN,
 	TRACE_REG_PERF_CLOSE,
 	TRACE_REG_PERF_ADD,
 	TRACE_REG_PERF_DEL,
+#endif
 };
 
 struct ftrace_event_call;
