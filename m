Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2A0MJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 07:09:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56251 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2A0MJ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 07:09:28 -0500
Message-ID: <1327666141.2446.168.camel@twins>
Subject: Re: [PATCH 00/13] perf_events: add support for sampling taken
 branches (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu
Date: Fri, 27 Jan 2012 13:09:01 +0100
In-Reply-To: <1326127761-2723-1-git-send-email-eranian@google.com>
References: <1326127761-2723-1-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

On Mon, 2012-01-09 at 17:49 +0100, Stephane Eranian wrote:
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

Can I have you ACK on this userspace stuff (patches 11-13)?
