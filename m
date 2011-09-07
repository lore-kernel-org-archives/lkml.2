Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1IGQgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:36:55 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:13749
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801Ab1IGQgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:36:52 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dK1432N98dKzz1202hzzz2fh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E679CE5.3050001@am.sony.com>
Date: Wed, 7 Sep 2011 09:33:41 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@tglx.de>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
References: <1313232790.25267.7.camel@twins> <4E559039.8060209@am.sony.com> <20110826235507.GJ2342@linux.vnet.ibm.com> <4E66DCAB.8090801@am.sony.com> <alpine.LFD.2.02.1109071115410.2723@ionos> <20110907104633.GR6619@n2100.arm.linux.org.uk> <20110907104747 <20110907140130.GT6619@n2100.arm.linux.org.uk>
In-Reply-To: <20110907140130.GT6619@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/11 07:01, Russell King - ARM Linux wrote:
> On Wed, Sep 07, 2011 at 12:57:44PM +0200, Thomas Gleixner wrote:
>> The problem is that if you enable interrupts on the CPU _BEFORE_ it is
>> set online AND active, then you can end up waking up kernel threads
>> which are bound to that CPU and the scheduler will happily schedule
>> them on an online CPU. That makes them lose the cpu affinity to the
>> CPU as well and hell breaks lose.
> 
> How can that happen?
> 
> 1. The only interrupts we're likely to receive are the local timer
>    interrupts - we have not routed any other interrupts to this CPU.

Yes, it is the local timer interrupt.

> 
> 2. We will not schedule on this CPU except at explicit scheduling
>    points (such as contended mutexes or explicit calls to schedule)
>    as we have a call to preempt_disable().

It is not a schedule.  It is wake_up_process():

   wake_up_process()
      try_to_wake_up()
         select_task_rq()
            if (... || !cpu_online(cpu))
               select_fallback_rq(task_cpu(p), p)
                  ...
                  /* No more Mr. Nice Guy. */
                  dest_cpu = cpuset_cpus_allowed_fallback(p)
                     do_set_cpus_allowed(p, cpu_possible_mask)
                        #  Thus ksoftirqd can now run on any cpu...


> 
>> Frank has observed this with softirq threads, but the same thing is
>> true for any other CPU bound thread like the worker stuff.
> 
> So who is scheduling a workqueue from the local timer?

   do_local_timer()
      ipi_timer()
         irq_exit()
            invoke_softirq()
               wakeup_softirqd()
                  wake_up_process()

> 
>> So moving the online, active thing BEFORE enabling interrupt is the
>> only sensible solution.
> 
> Yes, that'll be why even x86 enables interrupts before setting the CPU
> online for the delay calibration.

-Frank

