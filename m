Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab0ETOjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:39:41 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46140 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab0ETOjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:39:40 -0400
Message-ID: <4BF5499F.8050203@us.ibm.com>
Date: Thu, 20 May 2010 07:39:27 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jan-Bernd Themann <THEMANN@de.ibm.com>, michael@ellerman.id.au,
       Brian King <brking@linux.vnet.ibm.com>,
       Doug Maxey <doug.maxey@us.ibm.com>, dvhltc@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       niv@linux.vnet.ibm.com, Will Schmidt <will_schmidt@vnet.ibm.com>
Subject: Re: [PATCH RT] ehea: make receive irq handler non-threaded (IRQF_NODELAY)
References: <4BF30793.5070300@us.ibm.com> <4BF30C32.1020403@linux.vnet.ibm.com>  <4BF31322.5090206@us.ibm.com> <1274232324.29980.9.camel@concordia> <4BF3F2DB.7030701@us.ibm.com> <alpine.LFD.2.00.1005191620350.3368@localhost.localdomain> <alpine.LFD.2.00.1005192244430.3368@localhost.localdomain> <1274319248.22892.40.camel@concordia> <OF17F8F35C.B09E4797-ONC1257729.0028292D-C1257729.0029E9AC@de.ibm.com> <alpine.LFD.2.00.1005200950410.3368@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005200950410.3368@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 01:14 AM, Thomas Gleixner wrote:
> On Thu, 20 May 2010, Jan-Bernd Themann wrote:
>>>> Thought more about that. The case at hand (ehea) is nasty:
>>>>
>>>> The driver does _NOT_ disable the rx interrupt in the card in the rx
>>>> interrupt handler - for whatever reason.
>>>
>>> Yeah I saw that, but I don't know why it's written that way. Perhaps
>>> Jan-Bernd or Doug will chime in and enlighten us? :)
>>
>>  From our perspective there is no need to disable interrupts for the
>> RX side as the chip does not fire further interrupts until we tell
>> the chip to do so for a particular queue. We have multiple receive
>
> The traces tell a different story though:
>
>      ehea_recv_irq_handler()
>        napi_reschedule()
>      eoi()
>      ehea_poll()
>        ...
>        ehea_recv_irq_handler()<---------------- ???
>          napi_reschedule()
>        ...
>        napi_complete()
>
> Can't tell whether you can see the same behaviour in mainline, but I
> don't see a reason why not.

I was going to suggest that because these are threaded handlers, perhaps 
they are rescheduled on a different CPU and then receive the interrupt 
for the other CPU/queue that Jan was mentioning.

But, the handlers are affined if I remember correctly, and we aren't 
running with multiple receive queues. So, we're back to the same 
question, why are we seeing another irq. It comes in before 
napi_complete() and therefor before the ehea_reset*() block of calls 
which do the equivalent of re-enabling interrupts.

--
Darren

>
>> queues with an own interrupt each so that the interrupts can arrive
>> on multiple CPUs in parallel.  Interrupts are enabled again when we
>> leave the NAPI Poll function for the corresponding receive queue.
>
> I can't see a piece of code which does that, but that's probably just
> lack of detailed hardware knowledge on my side.
>
> Thanks,
>
> 	tglx


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
