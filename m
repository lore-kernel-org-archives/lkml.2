Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab1FXTMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 15:12:47 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:46454 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564Ab1FXTMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 15:12:46 -0400
Date: Fri, 24 Jun 2011 14:04:41 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>
Subject: High IRQ usage on CPU 0
Message-ID: <20110624190441.GA2164@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running 3.0.0-rc4+ I noticed I'm seeing the following on an idle Dell
r610 system:

Cpu0  :  0.0%us,  0.0%sy,  0.0%ni, 64.3%id,  0.0%wa, 35.7%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.3%hi,  0.3%si,  0.0%st
Cpu4  :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.3%hi,  0.3%si,  0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu8  :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
Cpu9  :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
Cpu10 :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
Cpu11 :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu12 :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st
Cpu13 :  0.0%us,  0.0%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.3%hi,  0.3%si,  0.0%st
Cpu14 :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.3%si,  0.0%st
Cpu15 :  0.0%us,  0.0%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.3%hi,  0.0%si,  0.0%st

Watching /proc/interrupts it looks like most of the interrupts on CPU0
are on IRQ 0 from "IO-APIC-edge      timer".

perf top -C 0 shows:

---------------------------------------------------------------------
PerfTop:    1024 irqs/sec  kernel:100.0%  exact:  0.0% [1000Hz cycles],  (all, CPU: 0)
---------------------------------------------------------------------

             samples  pcnt function                            DSO
             _______ _____ ___________________________________ _______

            11648.00 83.6% default_send_IPI_mask_sequence_phys vmlinux
             1548.00 11.1% _raw_spin_lock_irqsave              vmlinux
              530.00  3.8% intel_idle                          vmlinux
               36.00  0.3% hpet_legacy_next_event              vmlinux
               28.00  0.2% tick_handle_oneshot_broadcast       vmlinux
               20.00  0.1% find_next_bit                       vmlinux
               16.00  0.1% find_busiest_group                  vmlinux
               15.00  0.1% _raw_spin_unlock_irqrestore         vmlinux
               13.00  0.1% cpuidle_idle_call                   vmlinux
               10.00  0.1% _raw_spin_lock                      vmlinux
                9.00  0.1% tick_broadcast_oneshot_control      vmlinux
                8.00  0.1% notifier_call_chain                 vmlinux
                7.00  0.1% leave_mm                            vmlinux

For some reason 'perf record -C 0 -g sleep 5' doesn't record anything,
but here is the top functions from a 'perf record -a -g sleep 5':

# Events: 77K cycles
#
# Overhead          Command       Shared Object                               Symbol
# ........  ...............  ..................  ...................................
#
    80.22%          swapper  [kernel.kallsyms]   [k] _raw_spin_lock_irqsave
                    |
                    --- _raw_spin_lock_irqsave
                       |          
                       |--89.92%-- clockevents_notify
                       |          intel_idle
                       |          cpuidle_idle_call
                       |          cpu_idle
                       |          |          
                       |          |--98.67%-- start_secondary
                       |          |          
                       |           --1.33%-- rest_init
                       |                     start_kernel
                       |                     x86_64_start_reservations
                       |                     x86_64_start_kernel
                       |          
                       |--10.03%-- tick_broadcast_oneshot_control
                       |          tick_notify
                       |          notifier_call_chain
                       |          raw_notifier_call_chain
                       |          clockevents_notify
                       |          intel_idle
                       |          cpuidle_idle_call
                       |          cpu_idle
                       |          |          
                       |          |--99.97%-- start_secondary
                       |           --0.03%-- [...]
                        --0.05%-- [...]

     9.32%          swapper  [kernel.kallsyms]   [k] default_send_IPI_mask_sequence_phys
                    |
                    --- default_send_IPI_mask_sequence_phys
                        physflat_send_IPI_mask
                        lapic_timer_broadcast
                        tick_do_broadcast
                        tick_handle_oneshot_broadcast
                        timer_interrupt
                        handle_irq_event_percpu
                        handle_irq_event
                        handle_edge_irq
                        handle_irq
                        do_IRQ
                        common_interrupt
                       |          
                       |--99.91%-- cpuidle_idle_call
                       |          cpu_idle
                       |          rest_init
                       |          start_kernel
                       |          x86_64_start_reservations
                       |          x86_64_start_kernel
                        --0.09%-- [...]

     5.83%          swapper  [kernel.kallsyms]   [k] intel_idle
                    |
                    --- intel_idle
                       |          
                       |--99.67%-- cpuidle_idle_call
                       |          cpu_idle
                       |          |          
                       |          |--94.19%-- start_secondary
                       |          |          
                       |           --5.81%-- rest_init
                       |                     start_kernel
                       |                     x86_64_start_reservations
                       |                     x86_64_start_kernel
                        --0.33%-- [...]

I'm not sure what other information would be useful here.  Please let
me know if you need anything else.

Thanks,
Shawn


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

