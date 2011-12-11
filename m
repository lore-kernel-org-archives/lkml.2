Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab1LKKrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 05:47:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45890 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab1LKKrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 05:47:53 -0500
Date: Sun, 11 Dec 2011 11:46:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
Message-ID: <20111211104607.GA10351@elte.hu>
References: <20111210132220.083204833@linutronix.de>
 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
 <alpine.LFD.2.02.1112102144370.3020@ionos>
 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
 <20111211103047.GA19299@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111211103047.GA19299@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., i just noticed another performance weirdness, running the 
latest version on -tip with such a 64-bit x86 kernel:

  make defconfig
  make kvmconfig   # sidenote: sigh - this still needs a 'make oldconfig'


and do a 'kvm run' into a shell, then I get a permanently busy 
kvm executable sucking up CPU time:

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 28206 mingo     20   0 3586m  80m 1080 S 56.1  0.7   0:13.83 kvm
 29462 mingo     20   0 15380 1392  900 R  0.3  0.0   0:00.02 top

perf kvm top suggests simple idling around of 16 CPUs:

--------------------------------------------------------------------------------------------------
   PerfTop:    1635 irqs/sec  kernel:91.1% us: 0.3% guest kernel: 8.5% guest us: 0.0% exact:  0.0% [1000Hz cycles],  (all, 16 CPUs)
--------------------------------------------------------------------------------------------------

             samples  pcnt function                  DSO
             _______ _____ _________________________ _______________________________

              155.00 17.9% apic_timer_interrupt      /home/mingo/linux/linux/vmlinux
               89.00 10.3% find_busiest_group        /home/mingo/linux/linux/vmlinux
               66.00  7.6% native_apic_mem_write     /home/mingo/linux/linux/vmlinux
               51.00  5.9% idle_cpu                  /home/mingo/linux/linux/vmlinux
               29.00  3.3% __rcu_pending             /home/mingo/linux/linux/vmlinux
               25.00  2.9% run_posix_cpu_timers      /home/mingo/linux/linux/vmlinux
               24.00  2.8% _raw_spin_lock            /home/mingo/linux/linux/vmlinux
               19.00  2.2% cpumask_next_and          /home/mingo/linux/linux/vmlinux
               19.00  2.2% ktime_get                 /home/mingo/linux/linux/vmlinux
               18.00  2.1% run_timer_softirq         /home/mingo/linux/linux/vmlinux
               16.00  1.8% run_rebalance_domains     /home/mingo/linux/linux/vmlinux
               16.00  1.8% native_sched_clock        /home/mingo/linux/linux/vmlinux
               15.00  1.7% rcu_exit_nohz             /home/mingo/linux/linux/vmlinux
               14.00  1.6% tick_nohz_stop_sched_tick /home/mingo/linux/linux/vmlinux
               14.00  1.6% hrtimer_run_queues        /home/mingo/linux/linux/vmlinux

NO_HZ is set in the .config.

Btw., 'perf kvm' is in need of some love: for example it is 
unable to pick up a vmlinux from the current directory and 
./vmlinux does not work either, it needs 
/home/mingo/linux/linux/vmlinux specified explicitly - that 
sucks.

Ideally perf could be taught to talk to the guest kvm process 
and get its vmlinux home position (even better: its guest 
kallsyms) from there - so if i typed 'perf kvm top' it would do 
the right thing all automagically. [ What a fantastc level of 
automation! ;-) ]

Thanks,

	Ingo
