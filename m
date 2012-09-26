Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab2IZRaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:30:55 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58875 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab2IZRay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:30:54 -0400
Message-ID: <50633BA0.5030700@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 23:00:08 +0530
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
References: <1348681092.19514.10.camel@cliu38-desktop-build> <1348703122.19514.17.camel@cliu38-desktop-build> <50632767.5050607@linux.vnet.ibm.com> <1348679199.26695.455.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1348679199.26695.455.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092617-9574-0000-0000-0000049966BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 10:36 PM, Suresh Siddha wrote:
> On Wed, 2012-09-26 at 21:33 +0530, Srivatsa S. Bhat wrote:
>> I have some fundamental questions here:
>> 1. Why was the CPU never removed from the affinity masks in the original
>> code? I find it hard to believe that it was just an oversight, because the
>> whole point of fixup_irqs() is to affine the interrupts to other CPUs, IIUC.
>> So, is that really a bug or is the existing code correct for some reason
>> which I don't know of?
> 
> I am not aware of the history but my guess is that the affinity mask
> which is coming from the user-space wants to be preserved. And
> fixup_irqs() is fixing the underlying interrupt routing when the cpu
> goes down

and the code that corresponds to that is:
irq_force_complete_move(irq); is it?

> with a hope that things will be corrected when the cpu comes
> back online. But  as Liu noted, we are not correcting the underlying
> routing when the cpu comes back online. I think we should fix that
> rather than modifying the user-specified affinity.
> 

Hmm, I didn't entirely get your suggestion. Are you saying that we should change
data->affinity (by calling ->irq_set_affinity()) during offline but maintain a
copy of the original affinity mask somewhere, so that we can try to match it
when possible (ie., when CPU comes back online)?

>> 2. In case this is indeed a bug, why are the warnings ratelimited when the
>> interrupts can't be affined to other CPUs? Are they not serious enough to
>> report? Put more strongly, why do we even silently return with a warning
>> instead of reporting that the CPU offline operation failed?? Is that because
>> we have come way too far in the hotplug sequence and we can't easily roll
>> back? Or are we still actually OK in that situation?
> 
> Are you referring to the "cannot set affinity for irq" messages?

Yes

> That happens only if the irq chip doesn't have the irq_set_affinity() setup.

That is my other point of concern : setting irq affinity can fail even if
we have ->irq_set_affinity(). (If __ioapic_set_affinity() fails, for example).
Why don't we complain in that case? I think we should... and if its serious
enough, abort the hotplug operation or atleast indicate that offline failed..

> But that is not common.
> 
>>
>> Suresh, I'd be grateful if you could kindly throw some light on these
>> issues... I'm actually debugging an issue where an offline CPU gets apic timer
>> interrupts (and in one case, I even saw a device interrupt), which I have
>> reported in another thread at: https://lkml.org/lkml/2012/9/26/119
>> But this issue in fixup_irqs() that Liu brought to light looks even more
>> surprising to me..
> 
> These issues look different to me, will look into that.
> 

Ok, thanks a lot!

Regards,
Srivatsa S. Bhat

