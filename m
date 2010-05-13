Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab0EMU13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:27:29 -0400
Received: from relay2.sgi.com ([192.48.179.30]:35505 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751326Ab0EMU11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:27:27 -0400
Message-ID: <4BEC60AD.2080805@sgi.com>
Date: Thu, 13 May 2010 15:27:25 -0500
From: Mike Habeck <habeck@sgi.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       linux-pci@vger.kernel.org, Myron Stowe <myron.stowe@hp.com>,
       habeck@sgi.com
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com> <201005131256.17997.bjorn.helgaas@hp.com> <4BEC4F15.7060206@sgi.com> <201005131354.59721.bjorn.helgaas@hp.com>
In-Reply-To: <201005131354.59721.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Thursday, May 13, 2010 01:12:21 pm Mike Travis wrote:
>> Bjorn Helgaas wrote:
>>> On Wednesday, May 12, 2010 12:14:32 pm Mike Travis wrote:
>>>> Subject: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already assigned
>>>> From: Mike Habeck <habeck@sgi.com>
>>>>
>>>> The Linux kernel assigns BARs that a BIOS did not assign, most likely
>>>> to handle broken BIOSes that didn't enumerate the devices correctly.
>>>> On UV the BIOS purposely doesn't assign I/O BARs for certain devices/
>>>> drivers we know don't use them (examples, LSI SAS, Qlogic FC, ...).
>>>> We purposely don't assign these I/O BARs because I/O Space is a very
>>>> limited resource.  There is only 64k of I/O Space, and in a PCIe
>>>> topology that space gets divided up into 4k chucks (this is due to
>>>> the fact that a pci-to-pci bridge's I/O decoder is aligned at 4k)...
>>>> Thus a system can have at most 16 cards with I/O BARs: (64k / 4k = 16)
>>>>
>>>> SGI needs to scale to >16 devices with I/O BARs.  So by not assigning
>>>> I/O BARs on devices we know don't use them, we can do that (iff the
>>>> kernel doesn't go and assign these BARs that the BIOS purposely didn't
>>>> assign).
>>> I don't quite understand this part.  If you boot with "pci=nobar",
>>> the BIOS doesn't assign BARs, Linux doesn't either, the drivers
>>> don't need them -- everything works, and that makes sense so far.
>>>
>>> Now, if you boot normally (without "pci=nobar"), what changes?
>>> The BIOS situation is the same, but Linux tries to assign the
>>> unassigned BARs.  It may assign a few before running out of space,
>>> but the drivers still don't need those BARs.  What breaks?
>> The problem arises because we run out of address spaces to assign.
>>
>> Say you have 24 cards, and the 1st 16 do not use I/O BARs.  If
>> you assign the available 16 address spaces to cards that may not
>> need them, then the final 8 cards will not be available.
> 
> It sounds like your BIOS treats some devices specially, so I assumed
> it would leave the first sixteen devices unassigned, but would assign
> the last eight, including the bridge windows leading to them.  In that
> case, I would expect Linux to preserve the resources of the last
> eight devices, since they're already assigned, and assign anything
> left over to the first sixteen.

Correct, the BIOS special cases devices that have an I/O BAR but
aren't used because the same functionality that the I/O BAR provides
is available via the MEM BAR.  So if the device driver only uses the
MEM BAR then the BIOS will only assign resources to it, not to the
unused I/O BAR

And yes, linux would preserve the resources of the last eight devices
in your example above

> 
> Are you saying that Linux clobbers the resources of the last eight
> devices in the process of assigning the first sixteen?  If so, I'd
> say that's a Linux bug.

No, Linux does not clobbers the resources

> 
> Or are the last eight hot-added cards that the BIOS never had a
> chance to assign?  That's definitely a problem.

Yes, that is one of the problems we envision seeing.

> 
>>> Can't we figure out whether we need this ourselves?  Using a command-
>>> line option just guarantees that we'll forever be writing customer
>>> advisories about this issue.
>> I think since this is so specific (like the potential of having
>> more than 16 cards would be something the customer would know),
>> I think it's better to error on the safe side.  If a BIOS does
>> not recognize an add in card (for whatever reason), and does
>> not assign the I/O BAR, then it would be up to the kernel to
>> do that.  Wouldn't you get more customer complaints about non-working
>> I/O, than someone with > 16 PCI cards not being able to use them
>> all?
> 
> It feels specific now, but in five years, I bet it won't be so
> unusual.  I really don't want to force customers to figure out
> when they need this.
> 
>>> This issue is not specific to x86, so I don't really like having
>>> the implementation be x86-specific.
>> We were going for as light a touch as possible, as there is not
>> time to verify other arches.  I'd be glad to submit a follow on
>> patch dealing with the generic case and depend on others for
>> testing, if that's of interest.
> 
> It's of interest to me.  I spend a lot of time pulling generic
> out of architecture-specific places.  If there's stuff that we
> know is generic from the beginning, we shouldn't make work for
> ourselves by making it x86-specific.
> 
>>> I'm a little bit nervous about Linux's current strategy of assigning
>>> resources to things before we even know whether we're going to use
>>> them.  We don't support dynamic PCI resource reassignment, so maybe
>>> we don't have any choice in this case, but generally I prefer the
>>> lazy approach.
>> That's a great idea if it can work.  Unfortunately, we are all tied
>> to the way BIOS sets up the system, and for UV systems I don't think
>> dynamic provisioning would work.  There's too much infrastructure
>> that all has to cooperate by the time the system is fully functional.
> 
> Like I said, we maybe don't have a choice in this case, but I'd like
> to have a clearer understanding of the problem and how other OSes
> deal with it before we start applying band-aids that will hurt when
> we pull them off later.
> 
> Bjorn

