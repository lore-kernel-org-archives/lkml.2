Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1A0STe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:19:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab1A0STd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:19:33 -0500
Date: Thu, 27 Jan 2011 19:19:07 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 3/3] tracepoints: Use __u64_aligned/U64_ALIGN()
Message-ID: <20110127181907.GA5226@jolsa.brq.redhat.com>
References: <20110126040459.289776311@goodmis.org>
 <20110126041014.987944521@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126041014.987944521@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 11:05:02PM -0500, Steven Rostedt wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 
> commit 7e066fb870fcd1025ec3ba7bbde5d541094f4ce1 added the aligned(32) type and
> variable attribute to the tracepoint structures to deal with gcc happily
> aligning statically defined structures on 32-byte multiples.
> 
> Working on issues within Ftrace, we came up with __64_aligned, which deals with
> this issue more elegantly by forcing an 8-byte alignment to both the type
> declaration and variable definition.
> 
> This therefore saves space, bringing down the size of struct tracepoint from 64
> bytes to 38 on 64-bit architectures.
> 
> Updating:
> - The type attribute (for iteration over the struct tracepoint array)
> - Added the variable attribute to the extern definition (needed to force gcc to
>   consider this alignment for the following definition)
> - The definition variable attribute (to force gcc to this specific alignment for
>   the static definitions)
> - The linker script (8-byte alignment can now replace the previous 32-byte
>   alignment for the custom tracepoint section)
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> LKML-Reference: <20110121203643.046218322@efficios.com>
> Acked-by: David Miller <davem@davemloft.net>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/asm-generic/vmlinux.lds.h |    2 +-
>  include/linux/tracepoint.h        |   12 ++++--------
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index e4af65c..95abb5f 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -176,7 +176,7 @@
>  	CPU_KEEP(exit.data)						\
>  	MEM_KEEP(init.data)						\
>  	MEM_KEEP(exit.data)						\
> -	. = ALIGN(32);							\
> +	U64_ALIGN();							\
>  	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
>  	*(__tracepoints)						\
>  	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index c681461..4bc50ea 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -33,12 +33,7 @@ struct tracepoint {
>  	void (*regfunc)(void);
>  	void (*unregfunc)(void);
>  	struct tracepoint_func __rcu *funcs;
> -} __attribute__((aligned(32)));		/*
> -					 * Aligned on 32 bytes because it is
> -					 * globally visible and gcc happily
> -					 * align these on the structure size.
> -					 * Keep in sync with vmlinux.lds.h.
> -					 */
> +} __u64_aligned;
>  
>  /*
>   * Connect a probe to a tracepoint.
> @@ -146,7 +141,7 @@ static inline void tracepoint_update_probe_range(struct tracepoint *begin,
>   * structure. Force alignment to the same alignment as the section start.
>   */
>  #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args)	\
> -	extern struct tracepoint __tracepoint_##name;			\
> +	extern struct tracepoint __u64_aligned __tracepoint_##name;	\
>  	static inline void trace_##name(proto)				\
>  	{								\
>  		JUMP_LABEL(&__tracepoint_##name.state, do_trace);	\
> @@ -178,7 +173,8 @@ do_trace:								\
>  	static const char __tpstrtab_##name[]				\
>  	__attribute__((section("__tracepoints_strings"))) = #name;	\
>  	struct tracepoint __tracepoint_##name				\
> -	__attribute__((section("__tracepoints"), aligned(32))) =	\
> +	__u64_aligned							\
> +	__attribute__((section("__tracepoints"))) =			\
>  		{ __tpstrtab_##name, 0, reg, unreg, NULL }
>  
>  #define DEFINE_TRACE(name)						\
> -- 
> 1.7.2.3

hi,

this patch breaks tracepoint section iterating for me
when trying to enable any event I get:

[   69.119483] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   69.119868] IP: [<ffffffff8121c2c2>] strlen+0x2/0x30
[   69.120104] PGD 77b84067 PUD 75dd6067 PMD 0 
[   69.120104] Oops: 0000 [#1] SMP 
[   69.120104] last sysfs file: /sys/devices/virtual/vc/vcs5/uevent
[   69.120104] CPU 1 
[   69.120104] Modules linked in:
[   69.120104] 
[   69.120104] Pid: 1119, comm: bash Not tainted 2.6.38-rc2-tip+ #325 To be filled by O.E.M./Montevina platform
[   69.120104] RIP: 0010:[<ffffffff8121c2c2>]  [<ffffffff8121c2c2>] strlen+0x2/0x30
[   69.120104] RSP: 0018:ffff8800754fbd60  EFLAGS: 00010246
[   69.120104] RAX: 0000000000000000 RBX: ffffffff8180e530 RCX: 0000000073ed290b
[   69.120104] RDX: 0000000002687d93 RSI: ffffffff8173387c RDI: 0000000000000000
[   69.120104] RBP: ffff8800754fbd88 R08: 0000000000000000 R09: 0000000000000000
[   69.120104] R10: ffff8800779dbad0 R11: 0000000000000000 R12: 0000000000000000
[   69.120104] R13: 0000000000000000 R14: ffffffff8180fa48 R15: 0000000000000000
[   69.120104] FS:  00007fd6c90ae720(0000) GS:ffff88007b480000(0000) knlGS:0000000000000000
[   69.120104] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   69.120104] CR2: 0000000000000000 CR3: 0000000075bec000 CR4: 00000000000406e0
[   69.120104] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   69.120104] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   69.120104] Process bash (pid: 1119, threadinfo ffff8800754fa000, task ffff88007bdc2640)
[   69.120104] Stack:
[   69.120104]  ffffffff8109b9fa ffff8800779dbb00 ffffffff8180e530 0000000000000000
[   69.120104]  0000000000000001 ffff8800754fbdc8 ffffffff8109c4b6 ffffffff81a1d3e8
[   69.120104]  0000000000000000 0000000000000000 0000000000000000 ffff880076ed3c00
[   69.120104] Call Trace:
[   69.120104]  [<ffffffff8109b9fa>] ? get_tracepoint+0x1a/0x1a0
[   69.120104]  [<ffffffff8109c4b6>] tracepoint_update_probe_range+0xe6/0x1d0
[   69.120104]  [<ffffffff8109c5fc>] tracepoint_update_probes+0x1c/0x30
[   69.120104]  [<ffffffff8109c855>] tracepoint_probe_register+0x85/0xb0
[   69.120104]  [<ffffffff810ad4dd>] tracing_start_sched_switch+0x4d/0xf0
[   69.120104]  [<ffffffff810ad5f9>] tracing_start_cmdline_record+0x9/0x10
[   69.120104]  [<ffffffff810b5955>] ftrace_event_enable_disable+0xc5/0xf0
[   69.120104]  [<ffffffff810b6648>] event_enable_write+0xf8/0x130
[   69.120104]  [<ffffffff8110e564>] ? rw_verify_area+0xf4/0x1b0
[   69.120104]  [<ffffffff8110f0d9>] vfs_write+0x119/0x1c0
[   69.120104]  [<ffffffff8110f281>] sys_write+0x51/0x90
[   69.120104]  [<ffffffff8100316b>] system_call_fastpath+0x16/0x1b
[   69.120104] Code: 11 eb 1b 66 0f 1f 44 00 00 48 83 ea 01 48 39 c2 72 0c 0f b6 0a f6 81 a0 c4 55 81 20 75 eb c6 42 01 00 c9 c3 0f 1f 44 00 00 31 c0 <80> 3f 00 55 48 89 fa 48 89 e5 74 11 66 90 48 83 c2 01 80 3a 00 
[   69.120104] RIP  [<ffffffff8121c2c2>] strlen+0x2/0x30
[   69.120104]  RSP <ffff8800754fbd60>
[   69.120104] CR2: 0000000000000000



tracepoint_update_probe_range will oops due to the tracepoint name
being null

I found the elements in "__tracepoints" sections might have different
size after above patch is applied:

with:

nm vmlinux | grep __tracepoint_ | sort

I got:

...
ffffffff8180e4b8 D __tracepoint_clock_disable
ffffffff8180e4e0 D __tracepoint_clock_set_rate
ffffffff8180e508 D __tracepoint_power_domain_target
ffffffff8180e540 D __tracepoint_mm_vmscan_kswapd_sleep
ffffffff8180e568 D __tracepoint_mm_vmscan_kswapd_wake
...

addr(__tracepoint_mm_vmscan_kswapd_sleep) - addr(__tracepoint_power_domain_target) = 0x38

while size of "struct tracepoints" seems to be 0x28

and the listing has several places like that


At least the code "tracepoint_update_probe_range" relies on that,
while iterating the section.

please let me know if you need more info,
not sure what's going on.. :)

thanks,
jirka


[root@dhcp-26-214 ~]# uname -a
Linux dhcp-26-214.brq.redhat.com 2.6.38-rc2-tip+ #325 SMP Thu Jan 27 19:11:56 CET 2011 x86_64 x86_64 x86_64 GNU/Linux

[jolsa@krava1 linux-2.6-tip]$ gcc --version
gcc (GCC) 4.4.4 20100726 (Red Hat 4.4.4-13)
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.

