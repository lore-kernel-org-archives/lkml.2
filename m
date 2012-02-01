Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2BAImN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:42:13 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:33552 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab2BAImL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:42:11 -0500
Message-ID: <4F28FAD6.2010300@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 14:11:58 +0530
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
x-cbid: 12020108-9574-0000-0000-00000130A308
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

Just wondering whether appending function call chain details to branch stack
would add value from system performance event analysis perspective.

perf record -g -b any_call,u -e branch-misses:k ls

15.38% ls libc-2.11.1.so  libc-2.11.1.so  [k] getenv              [k] strncmp
15.38% ls libc-2.11.1.so  libc-2.11.1.so  [k] __execvpe           [k] strlen
15.38% ls libc-2.11.1.so  libc-2.11.1.so  [k] __execvpe           [k] memcpy
15.38% ls ld-2.11.1.so    ld-2.11.1.so    [k] _dl_map_object_from_fd  [k] mmap64
 7.69% ls libc-2.11.1.so  libc-2.11.1.so  [k] __execvpe           [k] __strchrnul
 7.69% ls libc-2.11.1.so  libc-2.11.1.so  [k] __execvpe           [k] __execve
 7.69% ls ld-2.11.1.so    ld-2.11.1.so    [k] _dl_map_object_from_fd  [k] _dl_setup_hash
 7.69% ls ld-2.11.1.so    ld-2.11.1.so    [k] _dl_map_object_from_fd  [k] close
 7.69% ls ld-2.11.1.so    ld-2.11.1.so    [k] _dl_map_object_from_fd  [k] memset

>From the example above, we can see 

(1) 15.38%  ls  libc-2.11.1.so libc-2.11.1.so [k] getenv [k] strncmp

    '[k] getenv ----> [k]' strncmp happened 15% time for the branch-misses
     event overflow.

(2) But this lacks the information from the  source code program point of view
    like what is the code path which eventually ended up in the branch (getenv
    ----> strncmp) 15.38% of time for the event. There can be N number of  
    function call chains which might lead to the branch (getenv ----> strncmp).
    Having a percentage distribution of the function callchians for every entry
    in the output (as above) would be a good idea. This would give complete 
    information (though statistical sampling) on the source code control flow
    which would have lead to the PMU event.

(3) <percentage of call_chain> <percentage of branch_chain> [EVENT]
    There may be situations where these chains are overlapping with each other
    to some extent.

If we change to newt output format, we can display the relative percentages of call
chains when we click on specific entry of branch chain similar to when we try to  
annotate a symbol in normal perf report newt output.

Any thoughts ?

