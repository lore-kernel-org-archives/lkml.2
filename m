Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab0I0ORY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:17:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938Ab0I0ORX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:17:23 -0400
Message-ID: <4CA0A76B.6000803@redhat.com>
Date: Mon, 27 Sep 2010 16:17:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86, nmi: workaround sti; hlt race vs nmi; intr
References: <1284913699-14986-1-git-send-email-avi@redhat.com> <20100927103128.GO15338@8bytes.org>
In-Reply-To: <20100927103128.GO15338@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/27/2010 12:31 PM, Joerg Roedel wrote:
> On Sun, Sep 19, 2010 at 06:28:19PM +0200, Avi Kivity wrote:
> >  On machines without monitor/mwait we use an sti; hlt sequence to atomically
> >  enable interrupts and put the cpu to sleep.  The sequence uses the "interrupt
> >  shadow" property of the sti instruction: interrupts are enabled only after
> >  the instruction following sti has been executed.  This means an interrupt
> >  cannot happen in the middle of the sequence, which would leave us with
> >  the interrupt processed but the cpu halted.
> >
> >  The interrupt shadow, however, can be broken by an nmi; the following
> >  sequence
> >
> >     sti
> >       nmi ... iret
> >       # interrupt shadow disabled
> >       intr ... iret
> >     hlt
> >
> >  puts the cpu to sleep, even though the interrupt may need additional
> >  processing after the hlt (like scheduling a task).
>
> Doesn't the interrupt return path check for a re-schedule condition
> before iret? So to my believe the handler would not jump back to the
> idle task if something else becomes running in the interrupt handler,
> no?
>

Perhaps on preemptible kernels?  But at least on non-preemptible 
kernels, you can't just switch tasks while running kernel code.

void cpu_idle(void)
{
     current_thread_info()->status |= TS_POLLING;

     /*
      * If we're the non-boot CPU, nothing set the stack canary up
      * for us.  CPU0 already has it initialized but no harm in
      * doing it again.  This is a good place for updating it, as
      * we wont ever return from this function (so the invalid
      * canaries already on the stack wont ever trigger).
      */
     boot_init_stack_canary();

     /* endless idle loop with no priority at all */
     while (1) {
         tick_nohz_stop_sched_tick(1);
         while (!need_resched()) {

             rmb();

             if (cpu_is_offline(smp_processor_id()))
                 play_dead();
             /*
              * Idle routines should keep interrupts disabled
              * from here on, until they go to idle.
              * Otherwise, idle callbacks can misfire.
              */
             local_irq_disable();
             enter_idle();
             /* Don't trace irqs off for idle */
             stop_critical_timings();
             pm_idle();
             start_critical_timings();

             trace_power_end(smp_processor_id());

             /* In many cases the interrupt that ended idle
                has already called exit_idle. But some idle
                loops can be woken up without interrupt. */
             __exit_idle();
         }

         tick_nohz_restart_sched_tick();
         preempt_enable_no_resched();
         schedule();
         preempt_disable();
     }
}

Looks like we rely on an explicit schedule() - pm_idle() is called with 
preemption disabled.

(pm_idle eventually calls safe_halt() if no other idle method is used)

-- 
error compiling committee.c: too many arguments to function

