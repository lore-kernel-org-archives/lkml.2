Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab0HBC2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 22:28:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45734 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0HBC2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 22:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tKqwpq3NLYxwhro7UJBywQeTcq4/O+CruZeJv1jyf0bEmc23qvn/QuJzUWDU1LTrfT
         esjpGqi5tiKFVfaTOOgBv+dEWAVh4V/fYGKt7S6lAdUKgqyA1YnELWY53Wx3jh50TjXL
         Qt1UUzE5rbNUdm+jFHyXWploQmiUxxbZpGOz0=
Date: Mon, 2 Aug 2010 04:28:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv10 2.6.35-rc6-tip 9/14]  trace: uprobes trace_event
	interface
Message-ID: <20100802022840.GC5581@nowhere>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6> <20100727111045.24690.31897.sendpatchset@localhost6.localdomain6> <4C510BEE.3000108@hitachi.com> <20100729141524.GH21723@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729141524.GH21723@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 07:45:24PM +0530, Srikar Dronamraju wrote:
> > 
> > Possible enhancement: Moving this config right after KPROBE_EVENT, because
> >  those two provide similar dynamic events.
> > 
> 
> Masami, 
>  Below patch should address the comments raised by you.
> 
> --
> Thanks and Regards
> Srikar
> 
> ---
> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> 
> Implements trace_event support for uprobes. In its
> current form it can be used to put probes at a specified text address
> in a process and dump the required registers when the code flow reaches
> the probed address.
> 
> TODO: Documentation/trace/uprobetrace.txt
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
> 
> Changelog from v5: Addressed comments from Masami Hiramatsu and Steven
>       Rostedt. Some changes because of changes in common probe events.
> 
> Changelog from v4: (Merged to 2.6.35-rc3-tip)
> 
> Changelog from v2/v3: (Addressing comments from Steven Rostedt
> 					and Frederic Weisbecker)
> 	* removed pit field from uprobe_trace_entry.
> 	* share common parts with kprobe trace events.
> 	* use trace_create_file instead of debugfs_create_file.
> 
> 
> The following example shows how to dump the instruction pointer and %ax a
> register at the probed text address.
> 
> Start a process to trace. Get the address to trace.
>   [Here pid is asssumed as 6016]
>   [Address to trace is 0x0000000000446420]
>   [Registers to be dumped are %ip and %ax]
> 
> # cd /sys/kernel/debug/tracing/
> # echo 'p 6016:0x0000000000446420 %ip %ax' > uprobe_events
> # cat uprobe_events
> p:uprobes/p_6016_0x0000000000446420 6016:0x0000000000446420 %ip=%ip %ax=%ax
> # cat events/uprobes/p_6016_0x0000000000446420/enable
> 0
> [enable the event]
> # echo 1 > events/uprobes/p_6016_0x0000000000446420/enable
> # cat events/uprobes/p_6016_0x0000000000446420/enable
> 1
> # #### do some activity on the program so that it hits the breakpoint
> # cat uprobe_profile
>   6016 p_6016_0x0000000000446420                                234
> # tracer: nop
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>              zsh-6016  [004] 227931.093579: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
>              zsh-6016  [005] 227931.097541: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
>              zsh-6016  [000] 227931.124909: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
>              zsh-6016  [001] 227933.128565: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
>              zsh-6016  [004] 227933.132756: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
>              zsh-6016  [000] 227933.158802: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
>              zsh-6016  [001] 227935.161602: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
>              zsh-6016  [004] 227935.165229: p_6016_0x0000000000446420: (0x446420) %ip=446421 %ax=79
> 
>  arch/Kconfig                |   11 -
>  kernel/trace/Kconfig        |   16 +
>  kernel/trace/Makefile       |    1 
>  kernel/trace/trace.h        |    5 
>  kernel/trace/trace_probe.h  |    2 
>  kernel/trace/trace_uprobe.c |  739 +++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 764 insertions(+), 10 deletions(-)
>  create mode 100644 kernel/trace/trace_uprobe.c
> 
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index c8c8e3f..af167f8 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -48,16 +48,7 @@ config OPTPROBES
>  	select KALLSYMS_ALL
>  
>  config UPROBES
> -	bool "User-space probes (EXPERIMENTAL)"
> -	default n
> -	depends on ARCH_SUPPORTS_UPROBES
> -	depends on MMU
> -	help
> -	  Uprobes enables kernel subsystems to establish probepoints
> -	  in user applications and execute handler functions when
> -	  the probepoints are hit. For more information, refer to
> -	  Documentation/uprobes.txt.
> -	  If in doubt, say "N".
> +	def_bool n
>  
>  config HAVE_EFFICIENT_UNALIGNED_ACCESS
>  	bool
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index c681fa7..c77ba2d 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -377,6 +377,22 @@ config KPROBE_EVENT
>  	  This option is also required by perf-probe subcommand of perf tools.
>  	  If you want to use perf tools, this option is strongly recommended.
>  
> +config UPROBE_EVENT
> +	bool "Enable uprobes-based dynamic events"
> +	depends on ARCH_SUPPORTS_UPROBES
> +	depends on MMU
> +	select UPROBES
> +	select PROBE_EVENTS
> +	select TRACING
> +	default n
> +	help
> +	  This allows the user to add tracing events on top of userspace dynamic
> +	  events (similar to tracepoints) on the fly via the traceevents interface.
> +	  Those events can be inserted wherever uprobes can probe, and record
> +	  various registers.
> +	  This option is required if you plan to use perf-probe subcommand of perf
> +	  tools on user space applications.
> +



Why did you split CONFIG_UPROBES and CONFIG_UPROBE_EVENT?
Is there another kind of use of uprobes than through "trace events"?

Hmm, speaking about it, I think kprobes has the same problem. In fact
now I remember I noticed it by the past but we found another user of
kprobes, mostly unused I guess.

Anyway, uprobes config itself doesn't need to be split from uprobes events.

Also, what about the "Dynamic Probes" menu I proposed? (it's possibly a
crappy idea, I don't know).

