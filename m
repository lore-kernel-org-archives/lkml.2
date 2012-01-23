Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab2AWKOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 05:14:42 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:40491 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992Ab2AWKOj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 05:14:39 -0500
MIME-Version: 1.0
In-Reply-To: <1326127761-2723-1-git-send-email-eranian@google.com>
References: <1326127761-2723-1-git-send-email-eranian@google.com>
Date: Mon, 23 Jan 2012 11:14:37 +0100
Message-ID: <CABPqkBTYrEeSefnXr4-ezmXHjNv1XkfVZGULzY5-=FE3tr3pfg@mail.gmail.com>
Subject: Re: [PATCH 00/13] perf_events: add support for sampling taken
 branches (v3)
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments on this patch set?


On Mon, Jan 9, 2012 at 5:49 PM, Stephane Eranian <eranian@google.com> wrote:
>
> This patchset adds an important and useful new feature to
> perf_events: branch stack sampling. In other words, the
> ability to capture taken branches into each sample.
>
> Statistical sampling of taken branch should not be confused
> for branch tracing. Not all branches are necessarily captured
>
> Sampling taken branches is important for basic block profiling,
> statistical call graph, function call counts. Many of those
> measurements can help drive a compiler optimizer.
>
> The branch stack is a software abstraction which sits on top
> of the PMU hardware. As such, it is not available on all
> processors. For now, the patch provides the generic interface
> and the Intel X86 implementation where it leverages the Last
> Branch Record (LBR) feature (from Core2 to SandyBridge).
>
> Branch stack sampling is supported for both per-thread and
> system-wide modes.
>
> It is possible to filter the type and privilege level of branches
> to sample. The target of the branch is used to determine
> the privilege level.
>
> For each branch, the source and destination are captured. On
> some hardware platforms, it may be possible to also extract
> the target prediction and, in that case, it is also exposed
> to end users.
>
> The branch stack can record a variable number of taken
> branches per sample. Those branches are always consecutive
> in time. The number of branches captured depends on the
> filtering and the underlying hardware. On Intel Nehalem
> and later, up to 16 consecutive branches can be captured
> per sample.
>
> Branch sampling is always coupled with an event. It can
> be any PMU event but it can't be a SW or tracepoint event.
>
> Branch sampling is requested by setting a new sample_type
> flag called: PERF_SAMPLE_BRANCH_STACK.
>
> To support branch filtering, we introduce a new field
> to the perf_event_attr struct: branch_sample_type. We chose
> NOT to overload the config1, config2 field because those
> are related to the event encoding. Branch stack is a
> separate feature which is combined with the event.
>
> The branch_sample_type is a bitmask of possible filters.
> The following filters are defined (more can be added):
> - PERF_SAMPLE_BRANCH_ANY     : any control flow change
> - PERF_SAMPLE_BRANCH_USER    : capture branches when target is at user level
> - PERF_SAMPLE_BRANCH_KERNEL  : capture branches when target is at user level
> - PERF_SAMPLE_BRANCH_ANY_CALL: capture call branches (incl. syscalls)
> - PERF_SAMPLE_BRANCH_ANY_RET : capture return branches (incl. syscall returns)
> - PERF_SAMPLE_BRANCH_IND_CALL: capture indirect calls
>
> It is possible to combine filters, e.g., IND_CALL|USER|KERNEL.
>
> When the privilege level is not specified, the branch stack
> inherits that of the associated event.
>
> Some processors may not offer hardware branch filtering, e.g., Intel
> Atom. Some may have HW filtering bugs (e.g., Nehalem). The Intel
> X86 implementation in this patchset also provides a SW branch filter
> which works on a best effort basis. It can compensate for the lack
> of LBR filtering. But first and foremost, it helps work around LBR
> filtering errata. The goal is to only capture the type of branches
> requested by the user.
>
> It is possible to combine branch stack sampling with PEBS on Intel
> X86 processors. Depending on the precise_sampling mode, there are
> certain filterting restrictions. When precise_sampling=1, then
> there are no filtering restrictions. When precise_sampling > 1,
> then only ANY|USER|KERNEL filter can be used. This comes from
> the fact that the kernel uses LBR to compensate for the PEBS
> off-by-1 skid on the instruction pointer.
>
> To demonstrate how the perf_event branch stack sampling interface
> works, the patchset also modifies perf record to capture taken
> branches. Similarly perf report is enhanced to display a histogram
> of taken branches.
>
> I would like to thank Roberto Vitillo @ LBL for his work on the perf
> tool for this.
>
> Enough talking, let's take a simple example. Our trivial test program
> goes like this:
>
> void f2(void)
> {}
> void f3(void)
> {}
> void f1(unsigned long n)
> {
>  if (n & 1UL)
>    f2();
>  else
>    f3();
> }
> int main(void)
> {
>  unsigned long i;
>
>  for (i=0; i < N; i++)
>   f1(i);
>  return 0;
> }
>
> $ perf record -b any branchy
> $ perf report -b
> # Events: 23K cycles
> #
> # Overhead  Source Symbol     Target Symbol
> # ........  ................  ................
>
>    18.13%  [.] f1            [.] main
>    18.10%  [.] main          [.] main
>    18.01%  [.] main          [.] f1
>    15.69%  [.] f1            [.] f1
>     9.11%  [.] f3            [.] f1
>     6.78%  [.] f1            [.] f3
>     6.74%  [.] f1            [.] f2
>     6.71%  [.] f2            [.] f1
>
> Of the total number of branches captured, 18.13% were from f1() -> main().
>
> Let's make this clearer by filtering the user call branches only:
>
> $ perf record -b any_call -e cycles:u branchy
> $ perf report -b
> # Events: 19K cycles
> #
> # Overhead  Source Symbol              Target Symbol
> # ........  .........................  .........................
> #
>    52.50%  [.] main                   [.] f1
>    23.99%  [.] f1                     [.] f3
>    23.48%  [.] f1                     [.] f2
>     0.03%  [.] _IO_default_xsputn     [.] _IO_new_file_overflow
>     0.01%  [k] _start                 [k] __libc_start_main
>
> Now it is more obvious. %52 of all the captured branches where calls from main() -> f1().
> The rest is split 50/50 between f1() -> f2() and f1() -> f3() which is expected given
> that f1() dispatches based on odd vs. even values of n which is constantly increasing.
>
>
> Here is a kernel example, where we want to sample indirect calls:
> $ perf record -a -C 1 -b ind_call -e r1c4:k sleep 10
> $ perf report -b
> #
> # Overhead  Source Symbol               Target Symbol
> # ........  ..........................  ..........................
> #
>    36.36%  [k] __delay                 [k] delay_tsc
>     9.09%  [k] ktime_get               [k] read_tsc
>     9.09%  [k] getnstimeofday          [k] read_tsc
>     9.09%  [k] notifier_call_chain     [k] tick_notify
>     4.55%  [k] cpuidle_idle_call       [k] intel_idle
>     4.55%  [k] cpuidle_idle_call       [k] menu_reflect
>     2.27%  [k] handle_irq              [k] handle_edge_irq
>     2.27%  [k] ack_apic_edge           [k] native_apic_mem_write
>     2.27%  [k] hpet_interrupt_handler  [k] hrtimer_interrupt
>     2.27%  [k] __run_hrtimer           [k] watchdog_timer_fn
>     2.27%  [k] enqueue_task            [k] enqueue_task_rt
>     2.27%  [k] try_to_wake_up          [k] select_task_rq_rt
>     2.27%  [k] do_timer                [k] read_tsc
>
> Due to HW limitations, branch filtering may be approximate on
> Core, Atom processors. It is more accurate on Nehalem, Westmere
> and best on Sandy Bridge.
>
> In version 2, we've updated the patch to tip/master (commit 5734857) and
> we've incoporated the feedback from v1 concerning anynous bitfield
> struct for branch_stack_entry and the hanlding of i386 ABI binaries
> on 64-bit host in the instr decoder for the LBR SW filter.
>
> In version 3, we've updated to 3.2.0-tip. The Atom revision
> check has been put into its own patch. We fixed a browser
> issue with report report. We fixed all the style issues as well.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>
> Roberto Agostino Vitillo (3):
>  perf: add code to support PERF_SAMPLE_BRANCH_STACK
>  perf: add support for sampling taken branch to perf record
>  perf: add support for taken branch sampling to perf report
>
> Stephane Eranian (10):
>  perf_events: add generic taken branch sampling support (v3)
>  perf_events: add Intel LBR MSR definitions
>  perf_events: add Intel X86 LBR sharing logic
>  perf_events: sync branch stack sampling with X86 precise_sampling
>  perf_events: add LBR mappings for PERF_SAMPLE_BRANCH filters
>  perf_events: disable LBR support for older Intel Atom processors
>  perf_events: implement PERF_SAMPLE_BRANCH for Intel X86
>  perf_events: add LBR software filter support for Intel X86
>  perf_events: disable PERF_SAMPLE_BRANCH_* when not supported
>  perf_events: add hook to flush branch_stack on context switch
>
>  arch/alpha/kernel/perf_event.c             |    4 +
>  arch/arm/kernel/perf_event.c               |    4 +
>  arch/mips/kernel/perf_event_mipsxx.c       |    4 +
>  arch/powerpc/kernel/perf_event.c           |    4 +
>  arch/sh/kernel/perf_event.c                |    4 +
>  arch/sparc/kernel/perf_event.c             |    4 +
>  arch/x86/include/asm/msr-index.h           |    7 +
>  arch/x86/kernel/cpu/perf_event.c           |   47 +++-
>  arch/x86/kernel/cpu/perf_event.h           |   19 +
>  arch/x86/kernel/cpu/perf_event_amd.c       |    3 +
>  arch/x86/kernel/cpu/perf_event_intel.c     |  120 +++++--
>  arch/x86/kernel/cpu/perf_event_intel_ds.c  |   22 +-
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |  525 ++++++++++++++++++++++++++--
>  include/linux/perf_event.h                 |   78 ++++-
>  kernel/events/core.c                       |  167 +++++++++
>  kernel/events/hw_breakpoint.c              |    6 +
>  tools/perf/Documentation/perf-record.txt   |   18 +
>  tools/perf/Documentation/perf-report.txt   |    7 +
>  tools/perf/builtin-record.c                |   69 ++++
>  tools/perf/builtin-report.c                |   95 +++++-
>  tools/perf/perf.h                          |   18 +
>  tools/perf/util/annotate.c                 |    2 +-
>  tools/perf/util/event.h                    |    1 +
>  tools/perf/util/evsel.c                    |   14 +
>  tools/perf/util/hist.c                     |   93 ++++-
>  tools/perf/util/hist.h                     |    7 +
>  tools/perf/util/session.c                  |   72 ++++
>  tools/perf/util/session.h                  |    4 +
>  tools/perf/util/sort.c                     |  361 ++++++++++++++-----
>  tools/perf/util/sort.h                     |    5 +
>  tools/perf/util/symbol.h                   |   13 +
>  31 files changed, 1601 insertions(+), 196 deletions(-)
