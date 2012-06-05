Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2FESFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 14:05:24 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:17269 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513Ab2FESFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 14:05:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -16
X-BigFish: VS-16(zzbb2dI9371I542M1432N98dKzz1202hzz8275dhz2dh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FCE4A5A.3020603@freescale.com>
Date: Tue, 5 Jun 2012 13:05:14 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Li Yang-R58472 <r58472@freescale.com>
CC: Wood Scott-B07421 <B07421@freescale.com>,
        Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>
Subject: Re: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup event
 source
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com> <1336737235-15370-4-git-send-email-chenhui.zhao@freescale.com> <4FC93D74.3090200@freescale.com> <20120604113609.GC20676@localhost.localdomain> <4FCD3E8B.30805@freescale.com> <94F013E7935FF44C83EBE7784D62AD3F09335D27@039-SN2MPN1-022.039d.mgd.msft.net> <4FCE2FB8.9080307@freescale.com> <94F013E7935FF44C83EBE7784D62AD3F093360C1@039-SN2MPN1-022.039d.mgd.msft.net>
In-Reply-To: <94F013E7935FF44C83EBE7784D62AD3F093360C1@039-SN2MPN1-022.039d.mgd.msft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 11:49 AM, Li Yang-R58472 wrote:
> 
> 
>> -----Original Message-----
>> From: Wood Scott-B07421
>> Sent: Wednesday, June 06, 2012 12:12 AM
>> To: Li Yang-R58472
>> Cc: Wood Scott-B07421; Zhao Chenhui-B35336; linuxppc-dev@lists.ozlabs.org;
>> linux-kernel@vger.kernel.org; galak@kernel.crashing.org
>> Subject: Re: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup
>> event source
>>
>> On 06/04/2012 11:08 PM, Li Yang-R58472 wrote:
>>>
>>>
>>>> -----Original Message-----
>>>> From: Wood Scott-B07421
>>>> Sent: Tuesday, June 05, 2012 7:03 AM
>>>> To: Zhao Chenhui-B35336
>>>> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
>>>> galak@kernel.crashing.org; Li Yang-R58472
>>>> Subject: Re: [PATCH v5 4/5] fsl_pmc: Add API to enable device as
>>>> wakeup event source
>>>>
>>>> On 06/04/2012 06:36 AM, Zhao Chenhui wrote:
>>>>> On Fri, Jun 01, 2012 at 05:08:52PM -0500, Scott Wood wrote:
>>>>>> On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
>>>>>>> +int mpc85xx_pmc_set_wake(struct platform_device *pdev, bool
>>>>>>> +enable)
>>>>>>
>>>>>> Why does it have to be a platform_device?  Would a bare device_node
>>>> work
>>>>>> here?  If it's for stuff like device_may_wakeup() that could be in
>>>>>> a platform_device wrapper function.
>>>>>
>>>>> It does not have to be a platform_device. I think it can be a struct
>>>> device.
>>>>
>>>> Why does it even need that?  The low level mechanism for influencing
>>>> PMCDR should only need a device node, not a Linux device struct.
>>>
>>> It does no harm to pass the device structure and makes more sense for
>> object oriented interface design.
>>
>> It does do harm if you don't have a device structure to pass, if for some
>> reason you found the device by directly looking for it rather than going
>> through the device model.
> 
> Whether or not a device is a wakeup source not only depends on the
> SoC specification but also the configuration and current state for
> the device.  I only expect the device driver to have this knowledge
> and call this function rather than some standalone platform code.
> Therefore I don't think your concern matters.

First, I think it's bad API to force the passing of a higher level
object when a lower level object would suffice (and there are no
legitimate future-proofing or abstraction reasons for hiding the lower
level object).

But regardless, the entity you call a "device driver" may or may not use
the standard driver model (e.g. look at PCI root complexes), and your
assumption about what platform code knows may or may not be correct.  I
could just as well say that only platform code knows about the SoC
clock/power routing during a given low power state.

>>>>>> Who is setting can_wakeup for these devices?
>>>>>
>>>>> The device driver is responsible to set can_wakeup.
>>>>
>>>> How would the device driver know how to set it?  Wouldn't this depend
>>>> on the particular SoC and low power mode?
>>>
>>> It is based on the "fsl,magic-packet" and "fsl,wake-on-filer" device
>> tree properties.
>>
>> fsl,magic-packet was a mistake.  It is equivalent to checking the
>> compatible for etsec.  It does not convey any information about whether
> 
> It can be described either by explicit feature property or by the
> compatible.  I don't think it is a problem that we choose one against
> another.

I do think it's a problem, because it's unnecessarily complicated, and
more error prone (we probably didn't have fsl,magic-packet on all the
SoCs that support it before the .dtsi refactoring).  But my point was
that it says nothing about whether the eTSEC will still be functioning
during a low power state.

>> the eTSEC is still active in a given low power mode.
> 
> Whether or not the eTSEC is still active in both sleep and deep sleep
> is only depending on if we set it to be a wakeup source.

Only because we happen to support eTSEC as a wakeup source on all SoCs.

> If it behaves differently for low power modes in the future, we could
> address that by adding additional property.
> 
>>
>> How is fsl,wake-os-filer relevant to this decision?  When will it be set
>> but not fsl,magic-packet?
> 
> I mean either fsl,magic-packet or fsl,wake-on-filer shows it can be a
> wakeup source.  Currently we don't have an SoC to have wake-on-filer
> while not wake-on-magic.  But I think it's better to consider both as
> they are independent features.

You're not willing to consider an SoC where waking on eTSEC is
unsupported, but you're willing to consider an eTSEC that has
wake-on-filer but magic packet support has for some reason been dropped?

>> What about devices other than ethernet?  What about differences between
>> ordinary sleep and deep sleep?
> 
> There is no difference for sleep and deep sleep for all wakeup sources currently.

I recall being able to wake an mpc85xx chip (maybe mpc8544?) from
ordinary sleep using the DUART (even though the manual suggests that
only external interrupts can be used -- not even eTSEC).  You can't do
that in deep sleep.

You ignored "what about devices other than ethernet".

-Scott

