Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab2A3EQy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 23:16:54 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33224 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2A3EQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 23:16:52 -0500
Message-ID: <4F2619A3.6000608@linux.vnet.ibm.com>
Date: Mon, 30 Jan 2012 09:46:35 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, dsahern@gmail.com
Subject: Re: [PATCH v4 00/18] perf: add support for sampling taken branches
References: <1327697778-18515-1-git-send-email-eranian@google.com>
In-Reply-To: <1327697778-18515-1-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12013004-5564-0000-0000-00000126FDEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 January 2012 02:26 AM, Stephane Eranian wrote:
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
> - PERF_SAMPLE_BRANCH_ANY     : any control flow change
> - PERF_SAMPLE_BRANCH_USER    : branches when target is at user level
> - PERF_SAMPLE_BRANCH_KERNEL  : branches when target is at kernel level
> - PERF_SAMPLE_BRANCH_HV      : branches when target is at hypervisor level
> - PERF_SAMPLE_BRANCH_ANY_CALL: call branches (incl. syscalls)
> - PERF_SAMPLE_BRANCH_ANY_RET : return branches (incl. syscall returns)
> - PERF_SAMPLE_BRANCH_IND_CALL: indirect calls
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
>   if (n & 1UL)
>     f2();
>   else
>     f3();
> }
> int main(void)
> {
>   unsigned long i;
> 
>   for (i=0; i < N; i++)
>    f1(i);
>   return 0;
> }
> 
> $ perf record -b any branchy
> $ perf report -b
> # Events: 23K cycles
> #
> # Overhead  Source Symbol     Target Symbol
> # ........  ................  ................
> 
>     18.13%  [.] f1            [.] main                          
>     18.10%  [.] main          [.] main                          
>     18.01%  [.] main          [.] f1                            
>     15.69%  [.] f1            [.] f1                            
>      9.11%  [.] f3            [.] f1                            
>      6.78%  [.] f1            [.] f3                            
>      6.74%  [.] f1            [.] f2                            
>      6.71%  [.] f2            [.] f1                            
> 
> Of the total number of branches captured, 18.13% were from f1() -> main().
> 
> Let's make this clearer by filtering the user call branches only:
> 
> $ perf record -b any_call -e cycles:u branchy
> $ perf report -b
> # Events: 19K cycles
> #
> # Overhead  Source Symbol              Target Symbol
> # ........  .........................  .........................
> #
>     52.50%  [.] main                   [.] f1                   
>     23.99%  [.] f1                     [.] f3                   
>     23.48%  [.] f1                     [.] f2                   
>      0.03%  [.] _IO_default_xsputn     [.] _IO_new_file_overflow
>      0.01%  [k] _start                 [k] __libc_start_main    
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
> # Overhead  Source Symbol               Target Symbol
> # ........  ..........................  ..........................
> #
>     36.36%  [k] __delay                 [k] delay_tsc             
>      9.09%  [k] ktime_get               [k] read_tsc              
>      9.09%  [k] getnstimeofday          [k] read_tsc              
>      9.09%  [k] notifier_call_chain     [k] tick_notify           
>      4.55%  [k] cpuidle_idle_call       [k] intel_idle            
>      4.55%  [k] cpuidle_idle_call       [k] menu_reflect          
>      2.27%  [k] handle_irq              [k] handle_edge_irq       
>      2.27%  [k] ack_apic_edge           [k] native_apic_mem_write 
>      2.27%  [k] hpet_interrupt_handler  [k] hrtimer_interrupt     
>      2.27%  [k] __run_hrtimer           [k] watchdog_timer_fn     
>      2.27%  [k] enqueue_task            [k] enqueue_task_rt       
>      2.27%  [k] try_to_wake_up          [k] select_task_rq_rt     
>      2.27%  [k] do_timer                [k] read_tsc              
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
> In version 4, we've modified the branch stack API to add a missing
> priv level : hypervisor. There is a new PERF_SAMPLE_BRANCH_HV. It
> is not used on Intel X86. Thanks to  khandual@linux.vnet.ibm.com
> for pointing this out. We also fix compilation error on ARM.
> 
> In version 4, we also extend the patch to include the changes necessary
> to the perf tool to support reading perf.data files which were produced
> from older perf_event ABI revisions. This patch set extends the ABI
> with a new field in struct perf_event_attr. That struct is saved as
> is in the perf.data file. Therefore, older perf.data files contain
> smaller perf_event_attr struct, yet perf must process them transparently.
> That's not the case today. It dies with 'incompatible file format'.
> 
> The patch solves this problem and, at the same time, decouples endianness
> detection from the size of perf_event_attr. Endianness is now detected via
> the signature (the first 8 bytes of the file). We introduce a new signature
> (PERFILE2). It is not laid out the same way in the file based on the endianness
So as perf subsystem evolves and we modify perf_event_attr structure, a new 'PERFFILE<N>' 
marker is generated (for perf subsystem version N) and placed in perf.data. Perf tools 
would be modified to distinguish between various versions of perf.data file and process
them accordingly. Sounds good ! PERFFILE,PERFFILE2,PERFFILE3........ We should have named
PERFFILE as PERFILE1 expecting this to happen one day :)
> of the host where the file is written. Therefore, we can dynamically detect
> the endianness by simply reading the first 8 bytes. The size of the
> perf_event_attr struct can then be processed according to the endianness.
> The ambiguity between the size being at the same time, the endianness marker
> and the actual size is gone. We can now distinguish an older ABI by the size
> and not confuse it with an endianness mismatch.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> 
> Roberto Agostino Vitillo (3):
>   perf: add code to support PERF_SAMPLE_BRANCH_STACK
>   perf: add support for sampling taken branch to perf record
>   perf: add support for taken branch sampling to perf report
> 
> Stephane Eranian (15):
>   perf: add generic taken branch sampling support
>   perf: add Intel LBR MSR definitions
>   perf: add Intel X86 LBR sharing logic
>   perf: sync branch stack sampling with X86 precise_sampling
>   perf: add LBR mappings for PERF_SAMPLE_BRANCH filters
>   perf: disable LBR support for older Intel Atom processors
>   perf: implement PERF_SAMPLE_BRANCH for Intel X86
>   perf: add LBR software filter support for Intel X86
>   perf: disable PERF_SAMPLE_BRANCH_* when not supported
>   perf: add hook to flush branch_stack on context switch
>   perf: fix endianness detection in perf.data
>   perf: add ABI reference sizes
>   perf: enable reading of perf.data files from different ABI rev
>   perf: fix bug print_event_desc()
>   perf: make perf able to read file from older ABIs
> 
>  arch/alpha/kernel/perf_event.c             |    4 +
>  arch/arm/kernel/perf_event.c               |    4 +
>  arch/mips/kernel/perf_event_mipsxx.c       |    4 +
>  arch/powerpc/kernel/perf_event.c           |    4 +
>  arch/sh/kernel/perf_event.c                |    4 +
>  arch/sparc/kernel/perf_event.c             |    4 +
>  arch/x86/include/asm/msr-index.h           |    7 +
>  arch/x86/kernel/cpu/perf_event.c           |   47 ++-
>  arch/x86/kernel/cpu/perf_event.h           |   19 +
>  arch/x86/kernel/cpu/perf_event_amd.c       |    3 +
>  arch/x86/kernel/cpu/perf_event_intel.c     |  120 +++++--
>  arch/x86/kernel/cpu/perf_event_intel_ds.c  |   22 +-
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |  532 ++++++++++++++++++++++++++--
>  include/linux/perf_event.h                 |   82 ++++-
>  kernel/events/core.c                       |  177 +++++++++
>  kernel/events/hw_breakpoint.c              |    6 +
>  tools/perf/Documentation/perf-record.txt   |   25 ++
>  tools/perf/Documentation/perf-report.txt   |    7 +
>  tools/perf/builtin-record.c                |   74 ++++
>  tools/perf/builtin-report.c                |   98 +++++-
>  tools/perf/perf.h                          |   18 +
>  tools/perf/util/annotate.c                 |    2 +-
>  tools/perf/util/event.h                    |    1 +
>  tools/perf/util/evsel.c                    |   14 +
>  tools/perf/util/header.c                   |  231 +++++++++++--
>  tools/perf/util/hist.c                     |   93 ++++-
>  tools/perf/util/hist.h                     |    7 +
>  tools/perf/util/session.c                  |   72 ++++
>  tools/perf/util/session.h                  |    4 +
>  tools/perf/util/sort.c                     |  362 ++++++++++++++-----
>  tools/perf/util/sort.h                     |    5 +
>  tools/perf/util/symbol.h                   |   13 +
>  32 files changed, 1835 insertions(+), 230 deletions(-)
> 


-- 
Anshuman Khandual
Linux Technology Centre
IBM Systems and Technology Group

