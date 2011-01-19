Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1ASQPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:15:39 -0500
Received: from mail.openrapids.net ([64.15.138.104]:60788 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754218Ab1ASQPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:15:37 -0500
Date: Wed, 19 Jan 2011 11:15:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Miller <davem@davemloft.net>, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119161534.GB15031@Krystal>
References: <1295382144.12215.123.camel@gandalf.stny.rr.com> <20110119050844.GA8776@Krystal> <20110118.223247.241909079.davem@davemloft.net> <20110118.232045.58440904.davem@davemloft.net> <1295451961.12215.1291.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295451961.12215.1291.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:13:23 up 56 days, 21:16,  5 users,  load average: 0.08, 0.02,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> After applying David's "remove align" patch, I got it to boot on x86_64
> with the following two patches. I thought just adding the "align" to the
> structure declaration would work, but it still failed on the syscall for
> init_module. By removing the double "declaration" of event_exit_##sname,
> removed this problem.
> 
> I'll test this on x86 32bit and PPC 64. If it works there, I'll push all
> of them out for 38. Should these go to 37 stable too?

Please hold before adding these patches into git. They don't seem to address the
underlying problem correctly. See the latest exchanges between David Miller and
myself for more info.

We need to come up with something better than "it boots" as an explanation for
the fix.

Thanks,

Mathieu

> 
> -- Steve
> 
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index cacc27a..0e3bce6 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -142,8 +142,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
>  	static struct syscall_metadata					\
>  	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
> -	static struct ftrace_event_call					\
> -	__attribute__((__aligned__(4))) event_exit_##sname;		\
>  	static struct ftrace_event_call __used				\
>  	  __attribute__((__aligned__(4)))				\
>  	  __attribute__((section("_ftrace_events")))			\
> 
> 
> Index: linux-trace.git/include/linux/ftrace_event.h
> ===================================================================
> --- linux-trace.git.orig/include/linux/ftrace_event.h
> +++ linux-trace.git/include/linux/ftrace_event.h
> @@ -194,7 +194,7 @@ struct ftrace_event_call {
>  	int				perf_refcount;
>  	struct hlist_head __percpu	*perf_events;
>  #endif
> -};
> +} __attribute__((__aligned__(32)));
>  
>  #define PERF_MAX_TRACE_SIZE	2048
>  
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
