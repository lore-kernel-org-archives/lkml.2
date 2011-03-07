Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1CGKpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:45:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab1CGKo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:44:57 -0500
Date: Mon, 7 Mar 2011 11:44:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        masami.hiramatsu.pt@hitachi.com, hpa@zytor.com, ananth@in.ibm.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        eric.dumazet@gmail.com, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 1/2] x86: separating entry text section
Message-ID: <20110307104423.GA3661@jolsa.redhat.com>
References: <20110220125948.GC25700@elte.hu>
 <1298298313-5980-1-git-send-email-jolsa@redhat.com>
 <1298298313-5980-2-git-send-email-jolsa@redhat.com>
 <20110222080934.GB7001@elte.hu>
 <20110222125201.GB1884@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222125201.GB1884@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
any feedback?

thanks,
jirka

On Tue, Feb 22, 2011 at 01:52:01PM +0100, Jiri Olsa wrote:
> On Tue, Feb 22, 2011 at 09:09:34AM +0100, Ingo Molnar wrote:
> > 
> > * Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > > Putting x86 entry code to the separate section: .entry.text.
> > 
> > Trying to apply your patch i noticed one detail:
> > 
> > > before patch:
> > >      26282174  L1-icache-load-misses      ( +-   0.099% )  (scaled from 81.00%)
> > >   0.206651959  seconds time elapsed   ( +-   0.152% )
> > > 
> > > after patch:
> > >      24237651  L1-icache-load-misses      ( +-   0.117% )  (scaled from 80.96%)
> > >   0.210509948  seconds time elapsed   ( +-   0.140% )
> > 
> > So time elapsed actually went up.
> > 
> > hackbench is notoriously unstable when it comes to runtime - and increasing the 
> > --repeat value only has limited effects on that.
> > 
> > Dropping all system caches:
> > 
> >    echo 1 > /proc/sys/vm/drop_caches
> > 
> > Seems to do a better job of 'resetting' system state, but if we put that into the 
> > measured workload then the results are all over the place (as we now depend on IO 
> > being done):
> > 
> >  # cat hb10
> > 
> >  echo 1 > /proc/sys/vm/drop_caches
> >  ./hackbench 10
> > 
> >  # perf stat --repeat 3 ./hb10
> > 
> >  Time: 0.097
> >  Time: 0.095
> >  Time: 0.101
> > 
> >  Performance counter stats for './hb10' (3 runs):
> > 
> >          21.351257 task-clock-msecs         #      0.044 CPUs    ( +-  27.165% )
> >                  6 context-switches         #      0.000 M/sec   ( +-  34.694% )
> >                  1 CPU-migrations           #      0.000 M/sec   ( +-  25.000% )
> >                410 page-faults              #      0.019 M/sec   ( +-   0.081% )
> >         25,407,650 cycles                   #   1189.984 M/sec   ( +-  49.154% )
> >         25,407,650 instructions             #      1.000 IPC     ( +-  49.154% )
> >          5,126,580 branches                 #    240.107 M/sec   ( +-  46.012% )
> >            192,272 branch-misses            #      3.750 %       ( +-  44.911% )
> >            901,701 cache-references         #     42.232 M/sec   ( +-  12.857% )
> >            802,767 cache-misses             #     37.598 M/sec   ( +-   9.282% )
> > 
> >         0.483297792  seconds time elapsed   ( +-  31.152% )
> > 
> > So here's a perf stat feature suggestion to solve such measurement problems: a new 
> > 'pre-run' 'dry' command could be specified that is executed before the real 'hot' 
> > run is executed. Something like this:
> > 
> >   perf stat --pre-run-script ./hb10 --repeat 10 ./hackbench 10
> > 
> > Would do the cache-clearing before each run, it would run hackbench once (dry run) 
> > and then would run hackbench 10 for real - and would repeat the whole thing 10 
> > times. Only the 'hot' portion of the run would be measured and displayed in the perf 
> > stat output event counts.
> > 
> > Another observation:
> > 
> > >      24237651  L1-icache-load-misses      ( +-   0.117% )  (scaled from 80.96%)
> > 
> > Could you please do runs that do not display 'scaled from' messages? Since we are 
> > measuring a relatively small effect here, and scaling adds noise, it would be nice 
> > to ensure that the effect persists with non-scaled events as well:
> > 
> > You can do that by reducing the number of events that are measured. The PMU can not 
> > measure all those L1 cache events you listed - so only use the most important one 
> > and add cycles and instructions to make sure the measurements are comparable:
> > 
> >   -e L1-icache-load-misses -e instructions -e cycles
> > 
> > Btw., there's another 'perf stat' feature suggestion: it would be nice if it was 
> > possible to 'record' a perf stat run, and do a 'perf diff' over it. That would 
> > compare the two runs all automatically, without you having to do the comparison 
> > manually.
> 
> hi,
> 
> I made another test with "reseting" the system state as suggested and
> only for cache-misses together with instructions and cycles events.
> 
> I can see even bigger drop of icache load misses than before
> from 19359739 to 16448709 (about 15%).
> 
> The instruction/cycles count is slightly bigger in the patched
> kernel run though..
> 
> perf stat --repeat 100  -e L1-icache-load-misses -e instructions -e cycles ./hackbench/hackbench 10
> 
> -------------------------------------------------------------------------------
> before patch:
> 
>  Performance counter stats for './hackbench/hackbench 10' (100 runs):
> 
>            19359739  L1-icache-load-misses      ( +-   0.313% )
>          2667528936  instructions             #      0.498 IPC     ( +- 0.165% )
>          5352849800  cycles                     ( +-   0.303% )
> 
>         0.205402048  seconds time elapsed   ( +-   0.299% )
> 
>  Performance counter stats for './hackbench/hackbench 10' (500 runs):
> 
>            19417627  L1-icache-load-misses      ( +-   0.147% )
>          2676914223  instructions             #      0.497 IPC     ( +- 0.079% )
>          5389516026  cycles                     ( +-   0.144% )
> 
>         0.206267711  seconds time elapsed   ( +-   0.138% )
> 
> 
> -------------------------------------------------------------------------------
> after patch:
> 
>  Performance counter stats for './hackbench/hackbench 10' (100 runs):
> 
>            16448709  L1-icache-load-misses      ( +-   0.426% )
>          2698406306  instructions             #      0.500 IPC     ( +- 0.177% )
>          5393976267  cycles                     ( +-   0.321% )
> 
>         0.206072845  seconds time elapsed   ( +-   0.276% )
> 
>  Performance counter stats for './hackbench/hackbench 10' (500 runs):
> 
>            16490788  L1-icache-load-misses      ( +-   0.180% )
>          2717734941  instructions             #      0.502 IPC     ( +- 0.079% )
>          5414756975  cycles                     ( +-   0.148% )
> 
>         0.206747566  seconds time elapsed   ( +-   0.137% )
> 
> 
> Attaching patch with above numbers in comment.
> 
> thanks,
> jirka
> 
> 
> ---
> Putting x86 entry code to the separate section: .entry.text.
> 
> Separating the entry text section seems to have performance
> benefits with regards to the instruction cache usage.
> 
> Running hackbench showed that the change compresses the icache
> footprint. The icache load miss rate went down by about 15%:
> 
> before patch:
>          19417627  L1-icache-load-misses      ( +-   0.147% )
> 
> after patch:
>          16490788  L1-icache-load-misses      ( +-   0.180% )
> 
> 
> Whole perf output follows.
> 
> - results for current tip tree:
>   Performance counter stats for './hackbench/hackbench 10' (500 runs):
> 
>          19417627  L1-icache-load-misses      ( +-   0.147% )
>        2676914223  instructions             #      0.497 IPC     ( +- 0.079% )
>        5389516026  cycles                     ( +-   0.144% )
> 
>       0.206267711  seconds time elapsed   ( +-   0.138% )
> 
> - results for current tip tree with the patch applied are:
>   Performance counter stats for './hackbench/hackbench 10' (500 runs):
> 
>          16490788  L1-icache-load-misses      ( +-   0.180% )
>        2717734941  instructions             #      0.502 IPC     ( +- 0.079% )
>        5414756975  cycles                     ( +-   0.148% )
> 
>       0.206747566  seconds time elapsed   ( +-   0.137% )
> 
> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  arch/x86/ia32/ia32entry.S         |    2 ++
>  arch/x86/kernel/entry_32.S        |    6 ++++--
>  arch/x86/kernel/entry_64.S        |    6 ++++--
>  arch/x86/kernel/vmlinux.lds.S     |    1 +
>  include/asm-generic/sections.h    |    1 +
>  include/asm-generic/vmlinux.lds.h |    6 ++++++
>  6 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
> index 0ed7896..50f1630 100644
> --- a/arch/x86/ia32/ia32entry.S
> +++ b/arch/x86/ia32/ia32entry.S
> @@ -25,6 +25,8 @@
>  #define sysretl_audit ia32_ret_from_sys_call
>  #endif
>  
> +	.section .entry.text, "ax"
> +
>  #define IA32_NR_syscalls ((ia32_syscall_end - ia32_sys_call_table)/8)
>  
>  	.macro IA32_ARG_FIXUP noebp=0
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index c8b4efa..f5accf8 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -65,6 +65,8 @@
>  #define sysexit_audit	syscall_exit_work
>  #endif
>  
> +	.section .entry.text, "ax"
> +
>  /*
>   * We use macros for low-level operations which need to be overridden
>   * for paravirtualization.  The following will never clobber any registers:
> @@ -788,7 +790,7 @@ ENDPROC(ptregs_clone)
>   */
>  .section .init.rodata,"a"
>  ENTRY(interrupt)
> -.text
> +.section .entry.text, "ax"
>  	.p2align 5
>  	.p2align CONFIG_X86_L1_CACHE_SHIFT
>  ENTRY(irq_entries_start)
> @@ -807,7 +809,7 @@ vector=FIRST_EXTERNAL_VECTOR
>        .endif
>        .previous
>  	.long 1b
> -      .text
> +      .section .entry.text, "ax"
>  vector=vector+1
>      .endif
>    .endr
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 891268c..39f8d21 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -61,6 +61,8 @@
>  #define __AUDIT_ARCH_LE	   0x40000000
>  
>  	.code64
> +	.section .entry.text, "ax"
> +
>  #ifdef CONFIG_FUNCTION_TRACER
>  #ifdef CONFIG_DYNAMIC_FTRACE
>  ENTRY(mcount)
> @@ -744,7 +746,7 @@ END(stub_rt_sigreturn)
>   */
>  	.section .init.rodata,"a"
>  ENTRY(interrupt)
> -	.text
> +	.section .entry.text
>  	.p2align 5
>  	.p2align CONFIG_X86_L1_CACHE_SHIFT
>  ENTRY(irq_entries_start)
> @@ -763,7 +765,7 @@ vector=FIRST_EXTERNAL_VECTOR
>        .endif
>        .previous
>  	.quad 1b
> -      .text
> +      .section .entry.text
>  vector=vector+1
>      .endif
>    .endr
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index e70cc3d..459dce2 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -105,6 +105,7 @@ SECTIONS
>  		SCHED_TEXT
>  		LOCK_TEXT
>  		KPROBES_TEXT
> +		ENTRY_TEXT
>  		IRQENTRY_TEXT
>  		*(.fixup)
>  		*(.gnu.warning)
> diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
> index b3bfabc..c1a1216 100644
> --- a/include/asm-generic/sections.h
> +++ b/include/asm-generic/sections.h
> @@ -11,6 +11,7 @@ extern char _sinittext[], _einittext[];
>  extern char _end[];
>  extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
>  extern char __kprobes_text_start[], __kprobes_text_end[];
> +extern char __entry_text_start[], __entry_text_end[];
>  extern char __initdata_begin[], __initdata_end[];
>  extern char __start_rodata[], __end_rodata[];
>  
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index fe77e33..906c3ce 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -424,6 +424,12 @@
>  		*(.kprobes.text)					\
>  		VMLINUX_SYMBOL(__kprobes_text_end) = .;
>  
> +#define ENTRY_TEXT							\
> +		ALIGN_FUNCTION();					\
> +		VMLINUX_SYMBOL(__entry_text_start) = .;			\
> +		*(.entry.text)						\
> +		VMLINUX_SYMBOL(__entry_text_end) = .;
> +
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>  #define IRQENTRY_TEXT							\
>  		ALIGN_FUNCTION();					\
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
