Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab2BKDPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 22:15:33 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47879 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab2BKDPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 22:15:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6616"; a="162340433"
Message-ID: <4F35DD3E.4020406@codeaurora.org>
Date: Fri, 10 Feb 2012 19:15:10 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Todd Poynor <toddpoynor@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nicolas Pitre <nico@fluxnic.net>, Oleg Nesterov <oleg@redhat.com>,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linaro-kernel@lists.linaro.org, Mike Chan <mike@android.com>,
        Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        Arjan Van De Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
References: <20120208013959.GA24535@panacea> <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com> <1328736834.2903.33.camel@pasglop> <20120209075106.GB18387@elte.hu>
In-Reply-To: <20120209075106.GB18387@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 11:51 PM, Ingo Molnar wrote:
>
> * Benjamin Herrenschmidt<benh@kernel.crashing.org>  wrote:
>
>> On Wed, 2012-02-08 at 15:23 -0500, Dave Jones wrote:
>>> I think the biggest mistake we ever made with cpufreq was making it
>>> so configurable. If we redesign it, just say no to plugin governors,
>>> and
>>> yes to a lot fewer sysfs knobs.
>>>
>>> So, provide mechanism to kill off all the governors, and there's a
>>> migration path from what we have now to something that just works
>>> in a lot more cases, while remaining configurable enough for the
>>> corner-cases.
>>
>> On the other hand, the need for schedulable contxts may not
>> necessarily go away.
>
> We will support it, but the *sane* hw solution is where
> frequency transitions can be done atomically.

I'm not sure atomicity has much to do with this. From what I can tell, 
it's about the physical characteristics of the voltage source and the 
load on said source.

After a quick digging around for some info for one of our platforms 
(ARM/MSM), it looks like it will take 200us to ramp up the power rail 
from the voltage for the lowest CPU freq to voltage for the highest CPU 
freq. And that's ignoring any communication delay. The 200us is purely 
how long it takes for the PMIC output to settle given the power load 
from the CPU. I would think other PMICs from different manufacturers 
would be in the same ballpark.

200us is a lot of time to add to a context switch or to busy wait on 
when the processors today can run at GHz speeds.

So, with what I know this doesn't look like a matter of broken HW unless 
the PMIC I'm looking up data for is a really crappy one. I'm sure other 
in the community know more about PMICs than I do and they can correct me 
if the general PMIC voltage settling characteristic is much better than 
the one I'm look at.

> Most workloads
> change their characteristics very quickly, and so does their
> power management profile change.
>
> The user-space driven policy model failed for that reason: it
> was *way* too slow in reacting) - and slow hardware transitions
> suck for a similar reason as well.

I think we all agree on this.

> We accomodate all hardware as well as we can, but we *design*
> for proper hardware. So Peter is right, this should be done
> properly.

When you say accommodate all hardware, does it mean we will keep around 
CPUfreq and allow attempts at improving it? Or we will completely move 
to scheduler based CPU freq scaling, but won't try to force atomicity? 
Say, may be queue up a notification to a CPU driver to scale up the 
frequency as soon as it can?

IMHO, I think the problem with CPUfreq and its dynamic governors today 
is that they do a timer based sampling of the CPU load instead of 
getting some hints from the scheduler when the scheduler knows that the 
load average is quite high.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
