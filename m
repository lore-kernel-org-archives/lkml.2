Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050Ab2C1FTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 01:19:13 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:44734 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2C1FTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 01:19:12 -0400
Message-ID: <4F729F46.9000308@linux.vnet.ibm.com>
Date: Wed, 28 Mar 2012 13:19:02 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Benjamin Segall <bsegall@google.com>,
        Ranjit Manomohan <ranjitm@google.com>, Nikhil Rao <ncrao@google.com>,
        jmc@cs.unc.edu, Dhaval Giani <dhaval.giani@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] LinSched for v3.3-rc7
References: <CAPM31RL6Sk6cNR9MzW_7XDvfkMA1q6xK_mcJJaCMY8Ex___9+A@mail.gmail.com> <4F6BF61E.7000009@linux.vnet.ibm.com>
In-Reply-To: <4F6BF61E.7000009@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12032805-8878-0000-0000-000001DBDDF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 12:03 PM, Michael Wang wrote:

> On 03/15/2012 11:58 AM, Paul Turner wrote:
> 
>> Hi All,
>>
>> [ Take 2, gmail tried to a non text/plain component into the last email .. ]
>>
>> Quick start version:
>>
>> Available under linsched-alpha at:
>>   git://git.kernel.org/pub/scm/linux/kernel/git/pjt/linsched.git  .linsched
> 
> Hi, All
> 
> I got confused with the LinSched main loop...
> My understanding is:
> 
> 	while (not time up) {
> 		
> 		get all cpus whose next event is the left most
> 		
> 		for those cpus {
> 
> 			simulate hres clock interrupt		
> 			
> 			process_all_softirqs() ?			
> 
> 			if cpu is idle
> 				enter idle
> 			else
> 				check process running time
> 		}
> 	}
> 
> Wonder why we need to call process_all_softirqs which will process other
> cpu's pending soft irq here?
> 


After done some test on this question, I think use
"process_all_softirqs" here is to simulate an interrupt for idle cpu,
actually, just simulate the part which process soft irq and check
reschedule, but in my opinion, this is wrong and will make the results
inaccurately.

The key point for this "process_all_softirqs" is the HRTIMER_SOFTIRQ.

Generally, in LinSched, all the softirq should be handled in "irq_exit"
after the simulated clock interrupt, beside one case:

		simulate clock irq for cpu x
		last running task going to sleep on cpu x
		clock irq leave
		cpu x enter idle(tick_nohz_idle_enter)

Here in "tick_nohz_idle_enter", if cpu x is the timer cpu,
HRTIMER_SOFTIRQ will be raised.

Now, if on a real machine, HRTIMER_SOFTIRQ will be handled while next
interrupt on cpu x, in order to restart the tick timer.

I think in LinSched, this interrupt should arrive at the time when the
sleep task wakeup on cpu x or some one else kick cpu x with an ipi
reschedule interrupt(no hz balance kick I suppose).

But if we use process_all_softirqs here, the next scene will be:
		
		simulate next clock irq for cpu y
		process clock event on cpu y
		clock irq leave
		process_all_softirqs

Here in "process_all_softirqs", HRTIMER_SOFTIRQ on cpu x will be
handled, and the tick timer of cpu x will be enabled and fire at next
tick(actually this is another mistake because we haven't call
"tick_nohz_irq_exit" in "irq_exit" even the cpu is still idle), this may
caused cpu x do an extra load balance if next tick is the time to do it.

And this will also happen if time has been passed when simulate next
clock irq for cpu y(the case that cpu x is the last cpu to be handled in
last clock event), cpu x may trigger load balance if it is the time to
do it, in "process_all_softirqs".

All these means we simulated an extra interrupt after cpu x idled, which
may help cpu x to do extra load balance work, that's doesn't make sense
and will cause some cpu more 'active' then others, isn't it?

I'd like to do more tests after disabled "process_all_softirqs", but I
don't know how we got those expectation numbers? Any one know what kind
of formula we should use to calculate the expected results?

Regards,
Michael Wang
		

> Regards,
> Michael Wang
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 






