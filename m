Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893Ab1CaO7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:59:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933166Ab1CaO7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:59:51 -0400
Date: Thu, 31 Mar 2011 10:58:50 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
Message-ID: <20110331145850.GA10163@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>
References: <20110329040939.GA32764@redhat.com>
 <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com>
 <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
 <20110331035511.GA1255@redhat.com>
 <AANLkTikP5edK=YSRx7zuNqyfwez8qEHpFumYun6GOPxu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikP5edK=YSRx7zuNqyfwez8qEHpFumYun6GOPxu@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 10:32:11PM -0700, Linus Torvalds wrote:
 > On Wed, Mar 30, 2011 at 8:55 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > I tried that, and wasn't particularly enlightened.
 > >
 > > +      6.53%  kworker/1:2  [kernel.kallsyms]  [k] read_hpet
 > > +      4.83%  kworker/0:0  [kernel.kallsyms]  [k] read_hpet
 > 
 > Go into those, deeper into the callchain. That's how to see what the
 > upper-level problem is - by seeing who actually calls it. The leafs
 > themselves (where the time is obviously spent) don't tend to be very
 > informative, no.
 
ok, a bit more interesting ?

-     17.67%  kworker/0:1  [kernel.kallsyms]  [k] read_hpet
   - read_hpet                          
      - 76.07% timekeeping_get_ns        
         - ktime_get                      
            - 64.02% tick_dev_program_event
                 tick_program_event        
                 hrtimer_interrupt          
                 smp_apic_timer_interrupt    
               + apic_timer_interrupt         
            - 35.30% sched_clock_tick          
                 scheduler_tick                 
                 update_process_times            
                 tick_sched_timer                 
                 __run_hrtimer                     
                 hrtimer_interrupt                  
                 smp_apic_timer_interrupt            
               - apic_timer_interrupt                 
                  + 65.70% _raw_spin_unlock_irqrestore 
                  + 27.33% _raw_spin_unlock_irq  
                  + 1.16% lock_acquire            
                  + 1.16% put_ldisc                
                  + 1.16% process_one_work          
                  + 1.16% lock_release               
                  + 0.78% worker_thread               
                  + 0.58% _raw_spin_lock_irqsave       
            + 0.55% tick_sched_timer      
      - 23.82% do_timer                    
           tick_do_update_jiffies64         
           tick_sched_timer                  
           __run_hrtimer                      
           hrtimer_interrupt                   
           smp_apic_timer_interrupt             
         - apic_timer_interrupt                  
            + 63.46% _raw_spin_unlock_irqrestore  
            + 22.98% _raw_spin_unlock_irq      
            + 3.50% put_ldisc                   
            + 3.28% lock_acquire                 



btw, I left this on overnight capturing the output of /proc/loadavg
it didn't drop off at all, and this morning the laptop is almost too
hot to hold.

	Dave

