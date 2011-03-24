Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049Ab1CXUAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:00:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48290 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933847Ab1CXUAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:00:41 -0400
Date: Thu, 24 Mar 2011 21:00:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
Message-ID: <20110324200010.GB7957@elte.hu>
References: <201103241026.01624.knikanth@suse.de>
 <20110324085647.GI30812@elte.hu>
 <20110324145221.GC31194@aftab>
 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
 <20110324173020.GA26761@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324173020.GA26761@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> > 
> > This cacheline bouncing was actually observed and measured
> > on SGI UV systems, but I'm not certain we're permitted to publish
> > that data. I'm copying the two SGI guys who had reported that
> > issue (and the special case fix, which Nikanth simply generalized)
> > to us, for them to decide.
> 
> We frequently run into the cacheline bouncing issues. I don't have
> the data handy that you refer to, but feel free to publish it.

One good way to see cache bounces is to run a misses/accesses ratio profile:

   perf top -e cache-misses -e cache-references --count-filter 10

Note the two events: this runs a 'weighted' profile, you'll see (LLC) 
cache-misses of a function relative to cache-references it does, a 
misses/references ratio in essence.

The --count-filter filters out rare entries. (so that rare functions 
accidentally producing a large ratio do not clutter the output)

For example during a scheduler-intense workload you'll get something like:

   PerfTop:   32652 irqs/sec  kernel:71.2%  exact:  0.0% [cache-misses/cache-references],  (all, 16 CPUs)
-------------------------------------------------------------------------------------------------------

   weight    samples  pcnt function                     DSO
   ______    _______ _____ ____________________________ ____________________

      1.9        606  3.2% irqtime_account_process_tick [kernel.kallsyms]   
      1.6        854  4.4% update_vsyscall              [kernel.kallsyms]   
      1.5        446  2.3% atomic_cmpxchg               [kernel.kallsyms]   
      1.5        758  3.9% tick_do_update_jiffies64     [kernel.kallsyms]   
      1.4        149  0.8% arch_local_irq_save          [kernel.kallsyms]   
      1.3       1524  7.9% do_timer                     [kernel.kallsyms]   
      1.2        215  1.1% clear_page_c                 [kernel.kallsyms]   
      1.2        128  0.7% dso__find_symbol             /home/mingo/bin/perf
      1.0        281  1.5% calc_global_load             [kernel.kallsyms]   
      0.9        560  2.9% profile_tick                 [kernel.kallsyms]   
      0.7        246  1.3% _raw_spin_lock               [kernel.kallsyms]   
      0.6       2523 13.1% current_kernel_time          [kernel.kallsyms]   

This output is very different from a plain cycles (or even cache-misses) 
measured profile and is very good at identifying 'bouncy' cache-miss sources. 

Another good 'view' is store-references against store-misses:

   PerfTop:   29530 irqs/sec  kernel:99.5%  exact:  0.0% [L1-dcache-store-misses/L1-dcache-stores],  (all, 16 CPUs)
-------------------------------------------------------------------------------------------------------

   weight    samples  pcnt function                 DSO
   ______    _______ _____ ________________________ __________________________________

   1271.3       3814  3.2% apic_timer_interrupt     [kernel.kallsyms]                 
    844.0        844  0.7% read_tsc                 [kernel.kallsyms]                 
    615.0        615  0.5% timekeeping_get_ns       [kernel.kallsyms]                 
    520.0        520  0.4% intel_pmu_disable_all    [kernel.kallsyms]                 
    390.0        390  0.3% tick_dev_program_event   [kernel.kallsyms]                 
    308.3       1850  1.5% update_vsyscall          [kernel.kallsyms]                 
    251.7        755  0.6% hrtimer_interrupt        [kernel.kallsyms]                 
    246.0        246  0.2% find_busiest_group       [kernel.kallsyms]                 
    222.7        668  0.6% native_apic_mem_write    [kernel.kallsyms]                 
    149.0        298  0.2% apic_write               [kernel.kallsyms]                 
    137.0        274  0.2% irq_enter                [kernel.kallsyms]                 
    105.0        105  0.1% arch_local_irq_save      [kernel.kallsyms]                 
    101.0        101  0.1% tick_program_event       [kernel.kallsyms]                 
     95.5        191  0.2% ack_APIC_irq             [kernel.kallsyms]           

You might want to experiment around with the events to see which one expresses 
things best for you on the system in question.

Thanks,

	Ingo
