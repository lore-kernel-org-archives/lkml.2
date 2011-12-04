Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1LDULe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 15:11:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41590 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab1LDULd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 15:11:33 -0500
MIME-Version: 1.0
In-Reply-To: <1318595833-29984-1-git-send-email-eranian@google.com>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
Date: Sun, 4 Dec 2011 12:11:31 -0800
Message-ID: <CABPqkBRToF=ikf=bZaWVv-JeFDHfzhm7xXvixMoZteMmHC9Vsw@mail.gmail.com>
Subject: Re: [PATCH 00/12] perf_events: add support for sampling taken
 branches (v2)
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ming.m.lin@intel.com,
        andi@firstfloor.org, robert.richter@amd.com, ravitillo@lbl.gov,
        will.deacon@arm.com, paulus@samba.org, benh@kernel.crashing.org,
        rth@twiddle.net, ralf@linux-mips.org, davem@davemloft.net,
        lethal@linux-sh.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any update on this patchset?

On Fri, Oct 14, 2011 at 5:37 AM, Stephane Eranian <eranian@google.com> wrote:
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
> $ perf report
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
> In version 2, we update the patch to tip/master (commit 5734857) and
> we've incoporated the feedback from v1 concerning anynous bitfield
> struct for branch_stack_entry and the hanlding of i386 ABI binaries
> on 64-bit host in the instr decoder for the LBR SW filter.
>
> Signed-off-by: Stephane Eranian <eranian@google.com>
>
>
> Roberto Agostino Vitillo (2):
>  perf: add support for sampling taken branch to perf record
>  perf: add support for taken branch sampling to perf report
>
> Stephane Eranian (10):
>  perf_events: add generic taken branch sampling support
>  perf_events: add Intel LBR MSR definitions
>  perf_events: add Intel X86 LBR sharing logic
>  perf_events: sync branch stack sampling with X86 precise_sampling
>  perf_events: add LBR mappings for PERF_SAMPLE_BRANCH filters
>  perf_events: implement PERF_SAMPLE_BRANCH for Intel X86
>  perf_events: add LBR software filter support for Intel X86
>  perf_events: disable PERF_SAMPLE_BRANCH_* when not supported
>  perf_events: add hook to flush branch_stack on context switch
>  perf: add code to support PERF_SAMPLE_BRANCH_STACK
>
>  arch/alpha/kernel/perf_event.c             |    4 +
>  arch/arm/kernel/perf_event.c               |    4 +
>  arch/mips/kernel/perf_event.c              |    4 +
>  arch/powerpc/kernel/perf_event.c           |    4 +
>  arch/sh/kernel/perf_event.c                |    4 +
>  arch/sparc/kernel/perf_event.c             |    4 +
>  arch/x86/include/asm/msr-index.h           |    7 +
>  arch/x86/kernel/cpu/perf_event.c           |   62 +++-
>  arch/x86/kernel/cpu/perf_event_amd.c       |    3 +
>  arch/x86/kernel/cpu/perf_event_intel.c     |  126 +++++--
>  arch/x86/kernel/cpu/perf_event_intel_ds.c  |   21 +-
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |  529 ++++++++++++++++++++++++++--
>  include/linux/perf_event.h                 |   74 ++++-
>  kernel/events/core.c                       |  167 +++++++++
>  kernel/events/hw_breakpoint.c              |    6 +
>  tools/perf/Documentation/perf-record.txt   |   18 +
>  tools/perf/Documentation/perf-report.txt   |    7 +
>  tools/perf/builtin-record.c                |   75 ++++
>  tools/perf/builtin-report.c                |   93 +++++-
>  tools/perf/perf.h                          |   17 +
>  tools/perf/util/annotate.c                 |    2 +-
>  tools/perf/util/event.h                    |    1 +
>  tools/perf/util/evsel.c                    |   10 +
>  tools/perf/util/hist.c                     |   97 ++++--
>  tools/perf/util/hist.h                     |    6 +
>  tools/perf/util/session.c                  |   72 ++++
>  tools/perf/util/session.h                  |    5 +
>  tools/perf/util/sort.c                     |  348 ++++++++++++++-----
>  tools/perf/util/sort.h                     |    5 +
>  tools/perf/util/symbol.h                   |   13 +
>  30 files changed, 1584 insertions(+), 204 deletions(-)
>
> --
> 1.7.4.1
>
