Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab1CaPEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:04:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab1CaPEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:04:21 -0400
Date: Thu, 31 Mar 2011 11:03:45 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
Message-ID: <20110331150344.GB10163@redhat.com>
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
 <20110331145850.GA10163@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331145850.GA10163@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 10:58:50AM -0400, Dave Jones wrote:
 
bah I missed a level. which seems to be the smoking gun.
something in the tty layer seems to have gone nuts.
 
 > -     17.67%  kworker/0:1  [kernel.kallsyms]  [k] read_hpet
 >    - read_hpet                          
 >       - 76.07% timekeeping_get_ns        
 >          - ktime_get                      
 >             - 64.02% tick_dev_program_event
 >                  tick_program_event        
 >                  hrtimer_interrupt          
 >                  smp_apic_timer_interrupt    
 >                + apic_timer_interrupt         

                  - 52.24% _raw_spin_unlock_irqrestore 
                     - 39.26% flush_to_ldisc             
                          process_one_work              
                          worker_thread                
                          kthread                     
                          kernel_thread_helper       
                     - 32.52% __wake_up             
                          put_ldisc                
                          tty_ldisc_deref         
                          flush_to_ldisc         
                          process_one_work      
                          worker_thread        
                          kthread             
                          kernel_thread_helper        
                     - 28.22% tty_ldisc_try          
                          tty_ldisc_ref             
                          flush_to_ldisc           
                          process_one_work        
                          worker_thread          
                          kthread               
                          kernel_thread_helper 
                  - 18.80% _raw_spin_unlock_irq   
                       process_one_work          
                       worker_thread            
                       kthread                 
                       kernel_thread_helper    
                  - 18.80% _raw_spin_unlock_irq
                       process_one_work       
                       worker_thread         
                       kthread              
                       kernel_thread_helper
                  - 5.98% process_one_work         
                       worker_thread              
                       kthread                   
                       kernel_thread_helper     
                  - 4.81% lock_acquire         
                       process_one_work       
                       worker_thread         
                       kthread              
                       kernel_thread_helper
                  - 4.70% put_ldisc       
                       tty_ldisc_deref  
                       flush_to_ldisc      
                       process_one_work  
                       worker_thread   
                       kthread        
                       kernel_thread_helper          
                  - 4.17% worker_thread             
                       kthread                     
                       kernel_thread_helper       
                  - 4.17% lock_release           
                       process_one_work         
                       worker_thread           
                       kthread                
                       kernel_thread_helper  
                  - 1.28% flush_to_ldisc    
                       process_one_work    
                       worker_thread      
                       kthread           
                       kernel_thread_helper     
                  - 1.28% arch_local_irq_save   
                     - 58.33% lock_release      
                          process_one_work      
                          worker_thread         
                          kthread               
                          kernel_thread_helper  
                     - 41.67% lock_acquire      
                          process_one_work      
                          worker_thread         
                          kthread               
                          kernel_thread_helper  
                  - 0.85% tty_ldisc_deref       
                       flush_to_ldisc           
                       process_one_work         
                       worker_thread            
                       kthread                  
                       kernel_thread_helper     
                  - 0.85% _raw_spin_lock_irqsave
                     - 62.51% flush_to_ldisc    
                          process_one_work      
                          worker_thread         
                          kthread               
                          kernel_thread_helper  
                     - 37.49% tty_ldisc_try     
                          tty_ldisc_ref       
                          flush_to_ldisc        
                          process_one_work      
                          worker_thread         
                          kthread               
                          kernel_thread_helper      
                  - 0.53% tty_ldisc_ref    
                       flush_to_ldisc       
                       process_one_work      
                       worker_thread          
                       kthread      

 >             - 35.30% sched_clock_tick          
 >                  scheduler_tick                 
 >                  update_process_times            
 >                  tick_sched_timer                 
 >                  __run_hrtimer                     
 >                  hrtimer_interrupt                  
 >                  smp_apic_timer_interrupt            
 >                - apic_timer_interrupt                 
 >                   + 65.70% _raw_spin_unlock_irqrestore 
 >                   + 27.33% _raw_spin_unlock_irq  
 >                   + 1.16% lock_acquire            
 >                   + 1.16% put_ldisc                
 >                   + 1.16% process_one_work          
 >                   + 1.16% lock_release               
 >                   + 0.78% worker_thread               
 >                   + 0.58% _raw_spin_lock_irqsave       
 >             + 0.55% tick_sched_timer      
 >       - 23.82% do_timer                    
 >            tick_do_update_jiffies64         
 >            tick_sched_timer                  
 >            __run_hrtimer                      
 >            hrtimer_interrupt                   
 >            smp_apic_timer_interrupt             
 >          - apic_timer_interrupt                  
 >             + 63.46% _raw_spin_unlock_irqrestore  
 >             + 22.98% _raw_spin_unlock_irq      
 >             + 3.50% put_ldisc                   
 >             + 3.28% lock_acquire                 

