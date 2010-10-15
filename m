Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab0JONkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:40:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46238 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab0JONkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:40:40 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=nFyw1t5h3Z8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=LWcCxnepD4hHFV3HXfIA:9 a=qmnna7JkFSPkm0msOVEA:7 a=_LSepemYSbi3Dm2bKROu3zzI4KMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][GIT PULL] ftrace: Rename config option
 HAVE_C_MCOUNT_RECORD to HAVE_C_RECORDMCOUNT
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101015073836.GA6870@elte.hu>
References: <1287114319.23682.34.camel@gandalf.stny.rr.com>
	 <20101015041307.GA31764@elte.hu>  <20101015073836.GA6870@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 09:40:38 -0400
Message-ID: <1287150038.23682.56.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 09:38 +0200, Ingo Molnar wrote:
> FYI, a recent tracing change causes this new warning on latest -tip:
> 
> Freeing SMP alternatives: 20k freed
> ftrace: allocating 14134 entries in 28 pages
> ------------[ cut here ]------------
> WARNING: at kernel/trace/ftrace.c:1006 ftrace_bug+0x94/0x1f9()
> Hardware name: System Product Name
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.36-rc8-tip+ #49604
> Call Trace:
>  [<c102c224>] warn_slowpath_common+0x6a/0x7f
>  [<c10629f3>] ? ftrace_bug+0x94/0x1f9
>  [<c10633d8>] ? ftrace_process_locs+0x152/0x225
>  [<c102c24d>] warn_slowpath_null+0x14/0x18
>  [<c10629f3>] ftrace_bug+0x94/0x1f9
>  [<c1063404>] ftrace_process_locs+0x17e/0x225
>  [<c10633d8>] ? ftrace_process_locs+0x152/0x225
>  [<c13fd7b4>] ftrace_init+0x112/0x12a
>  [<c13ed7ca>] start_kernel+0x287/0x291
>  [<c13ed079>] i386_start_kernel+0x79/0x7b
> ---[ end trace 4eaa2a86a8e2da22 ]---
> ftrace failed to modify [<c10633d8>] ftrace_process_locs+0x152/0x225

I know exactly what happened here, and it has to be because of the C
recordmcount code, because the perl version will not process a file
called ftrace.o

What happened is that ftrace_process_locs() references the mcount call,
and since we are adding relocations of mcount to the __mcount_loc
section, we just added a place that references the call but does not
actually call mcount. So we fail the check when we try to modify a
caller to mcount.

I'll see if I can add a fix to that in the code.

-- Steve

>  actual: b9:44:2b:00:c1
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> enabled ExtINT on CPU#0
> 
> (it booted up fine after this)
> 
> Candidates would be:
> 
> 0fdf136: Merge branch 'tip/perf/recordmcount-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace into perf/core
> cf4db25: ftrace: Rename config option HAVE_C_MCOUNT_RECORD to HAVE_C_RECORDMCOUNT
> d9d572a: Merge branch 'perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing into perf/core
> c28d507: ftrace: Remove duplicate code for 64 and 32 bit in recordmcount.c
> 72441cb: ftrace/x86: Add support for C version of recordmcount
> 81d3858: ftrace: Add C version of recordmcount compile time code
> ebc8827: x86: Barf when vmalloc and kmemcheck faults happen in NMI
> 3cba11d: kconfig/x86: Add HAVE_TEXT_POKE_SMP config for stop_machine dependency
> 3caa375: x86: Use __stop_machine() in text_poke_smp()
> 087a4eb: stopmachine: Define __stop_machine when CONFIG_STOP_MACHINE=n
> fd02e6f: kprobes: Fix selftest to clear flags field for reusing probes
> 0f55a2f: kprobes: Update document about irq disabled state in kprobe handler
> 
> Config attached.
> 
> Gut feeling suggests that it's the new in-C recordmcount code causing 
> this bug.
> 
> Thanks,
> 
> 	Ingo


