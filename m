Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3AJPUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:20:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3AJPUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:20:14 -0500
Message-ID: <1357831182.5841.21.camel@marge.simpson.net>
Subject: Re: [PATCH 0/5] x86,smp: make ticket spinlock proportional backoff
 w/ auto tuning
From: Mike Galbraith <bitbucket@online.de>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Date: Thu, 10 Jan 2013 16:19:42 +0100
In-Reply-To: <20130108172632.1126898a@annuminas.surriel.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:g7R2XGK47H+mksFoK0jBT1U0bjdokOk2KiSozVIN3W4
 l20mNhpR3GojAIJY3fzZ40dg71Qqz93X/7g0PIAp4wNLnMCuS2
 bpdT2ndteAbZKNg8oOWDq0RLMezIDyfBEDCWv9T+N0/gdB7DCH
 aQTtq1eFG4E7gba8s68JgUKvrU0nKrItMiRA5HqtXlevAFKaTB
 F5FWAXMMNZ5cienm2Abdtm7I98WiYzWqG7k0k7esSq2hBzQGdB
 KNqgRMoikuZOQDV/1tgjQfHntL9m2MsAA+x6jGAB1/QC8vOOPM
 7Tj/2orNtPV8ru4kn1l9YwutPtkLh5poQmNbQF5smtSXbw3Dlx
 d1wbxgllAwcESlnAw6WSJrLf3wb026U06fWxf2uo9EwufafTtT
 Vel2JIXCqSe6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 17:26 -0500, Rik van Riel wrote:

> Please let me know if you manage to break this code in any way,
> so I can fix it...

I didn't break it, but did let it play with rq->lock contention.  Using
cyclictest -Smp99 -i 100 -d 0, with 3 rt tasks for pull_rt_task() to
pull around appears to have been a ~dead heat.

              3.6.11                                    3.6.11-spinlock

   PerfTop:   78852 irqs/sec  kernel:96.4%  exact:  0.0% [1000Hz cycles],  (all, 80 CPUs)
-------------------------------------------------------------------------------------------------

             samples  pcnt function                     samples  pcnt function
             _______ _____ ___________________________  _______ _____ ___________________________

           468341.00 52.0% cpupri_set                  471786.00 52.0% cpupri_set
           110259.00 12.2% _raw_spin_lock               88963.00  9.8% ticket_spin_lock_wait
            78863.00  8.8% native_write_msr_safe        77109.00  8.5% native_write_msr_safe
            42882.00  4.8% __schedule                   48858.00  5.4% native_write_cr0
            40930.00  4.5% native_write_cr0             47038.00  5.2% __schedule
            13718.00  1.5% finish_task_switch           24775.00  2.7% _raw_spin_lock
            13188.00  1.5% plist_del                    13117.00  1.4% plist_del
            13078.00  1.5% _raw_spin_lock_irqsave       12372.00  1.4% ttwu_do_wakeup
            12083.00  1.3% ttwu_do_wakeup               11553.00  1.3% _raw_spin_lock_irqsave
             8359.00  0.9% pull_rt_task                  8186.00  0.9% pull_rt_task
             6979.00  0.8% apic_timer_interrupt          7989.00  0.9% finish_task_switch
             4623.00  0.5% __enqueue_rt_entity           6430.00  0.7% apic_timer_interrupt
             3961.00  0.4% resched_task                  4721.00  0.5% resched_task
             3942.00  0.4% __switch_to                   4109.00  0.5% __switch_to
             3128.00  0.3% _raw_spin_trylock             2917.00  0.3% rcu_idle_exit_common
             3081.00  0.3% __tick_nohz_idle_enter        2897.00  0.3% __local_bh_enable
             2561.00  0.3% update_curr_rt                2873.00  0.3% _raw_spin_trylock
             2385.00  0.3% _raw_spin_lock_irq            2674.00  0.3% __enqueue_rt_entity
             2190.00  0.2% __local_bh_enable             2434.00  0.3% update_curr_rt
             1904.00  0.2% rcu_idle_exit_common          2161.00  0.2% hrtimer_interrupt
             1870.00  0.2% clockevents_program_event     2106.00  0.2% ktime_get_update_offsets
             1828.00  0.2% hrtimer_interrupt             1766.00  0.2% tick_nohz_idle_exit
             1741.00  0.2% do_nanosleep                  1608.00  0.2% __tick_nohz_idle_enter
             1681.00  0.2% sys_clock_nanosleep           1437.00  0.2% do_nanosleep
             1639.00  0.2% pick_next_task_rt             1428.00  0.2% hrtimer_init
             1630.00  0.2% pick_next_task_stop           1320.00  0.1% sched_clock_idle_sleep_event
             1535.00  0.2% _raw_spin_unlock_irqrestore   1290.00  0.1% sys_clock_nanosleep

