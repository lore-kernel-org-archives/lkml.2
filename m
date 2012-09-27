Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2I0SnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:43:25 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50328 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2I0SnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:43:24 -0400
Message-ID: <50649E1C.40602@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2012 00:12:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Chuansheng Liu <chuansheng.liu@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the
 irq affinity mask
References: <1348681092.19514.10.camel@cliu38-desktop-build> <1348703122.19514.17.camel@cliu38-desktop-build> <50632767.5050607@linux.vnet.ibm.com> <1348679199.26695.455.camel@sbsiddha-desk.sc.intel.com> <50633BA0.5030700@linux.vnet.ibm.com> <1348699588.6644.21.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1348699588.6644.21.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092718-6102-0000-0000-0000024D167C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 04:16 AM, Suresh Siddha wrote:
> On Wed, 2012-09-26 at 23:00 +0530, Srivatsa S. Bhat wrote:
>> On 09/26/2012 10:36 PM, Suresh Siddha wrote:
>>> On Wed, 2012-09-26 at 21:33 +0530, Srivatsa S. Bhat wrote:
>>>> I have some fundamental questions here:
>>>> 1. Why was the CPU never removed from the affinity masks in the original
>>>> code? I find it hard to believe that it was just an oversight, because the
>>>> whole point of fixup_irqs() is to affine the interrupts to other CPUs, IIUC.
>>>> So, is that really a bug or is the existing code correct for some reason
>>>> which I don't know of?
>>>
>>> I am not aware of the history but my guess is that the affinity mask
>>> which is coming from the user-space wants to be preserved. And
>>> fixup_irqs() is fixing the underlying interrupt routing when the cpu
>>> goes down
>>
>> and the code that corresponds to that is:
>> irq_force_complete_move(irq); is it?
> 
> No. irq_set_affinity()
> 

Um? That takes the updated/changed affinity and sets data->affinity to
that value no? You mentioned that probably the intention of the original
code was to preserve the user-set affinity mask, but still change the
underlying interrupt routing. Sorry, but I still didn't quite understand
what is that part of the code that achieves that.

It appears that ->irq_set_affinity() is doing both - change the (user-set)
affinity as well as the underlying irq routing. And it does it only when
all CPUs in the original affinity mask go offline, not on every offline;
which looks like a real bug to me.

>>> with a hope that things will be corrected when the cpu comes
>>> back online. But  as Liu noted, we are not correcting the underlying
>>> routing when the cpu comes back online. I think we should fix that
>>> rather than modifying the user-specified affinity.
>>>

I am not able to distinguish the 2 things in the existing code, as I
mentioned above :(

>>
>> Hmm, I didn't entirely get your suggestion. Are you saying that we should change
>> data->affinity (by calling ->irq_set_affinity()) during offline but maintain a
>> copy of the original affinity mask somewhere, so that we can try to match it
>> when possible (ie., when CPU comes back online)?
> 
> Don't change the data->affinity in the fixup_irqs()

You mean, IOW, don't call ->irq_set_affinity() during CPU offline at all?
(Would that even be correct?)

> and shortly after a
> cpu is online, call irq_chip's irq_set_affinity() for those irq's who
> affinity included this cpu (now that the cpu is back online,
> irq_set_affinity() will setup the HW routing tables correctly).
> 
> This presumes that across the suspend/resume, cpu offline/online
> operations, we don't want to break the irq affinity setup by the
> user-level entity like irqbalance etc...
> 

The only way I can think of to preserve the user-set affinity but still
alter the underlying routing appropriately when needed, is by having an
additional mask (per-irq) that holds the user-set affinity.


>>> That happens only if the irq chip doesn't have the irq_set_affinity() setup.
>>
>> That is my other point of concern : setting irq affinity can fail even if
>> we have ->irq_set_affinity(). (If __ioapic_set_affinity() fails, for example).
>> Why don't we complain in that case? I think we should... and if its serious
>> enough, abort the hotplug operation or atleast indicate that offline failed..
> 
> yes if there is a failure then we are in trouble, as the cpu is already
> disappeared from the online-masks etc. For platforms with
> interrupt-remapping, interrupts can be migrated from the process context
> and as such this all can be done much before.
> 
> And for legacy platforms we have done quite a few changes in the recent
> past like using eoi_ioapic_irq() for level triggered interrupts etc,
> that makes it as safe as it can be. Perhaps we can move most of the
> fixup_irqs() code much ahead and the lost section of the current
> fixup_irqs() (which check IRR bits and use the retrigger function to
> trigger the interrupt on another cpu) can still be done late just like
> now.
> 

Hmm.. ok.. Thanks for the explanation!

Regards,
Srivatsa S. Bhat

