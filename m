Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1JYT6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 15:58:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51514 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab1JYT6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 15:58:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=WwJZnCrC+Zs190xzhfnotN2feXbWGVbHQKeKPsUfZBmCalr0Li2LuSARMUXuZ+6sy
	ZQdRD1I7If6bW4xxdRQGg==
MIME-Version: 1.0
In-Reply-To: <4EA6F2F4.9080005@numascale.com>
References: <1318926156-25504-1-git-send-email-daniel@numascale-asia.com>
 <1318926156-25504-3-git-send-email-daniel@numascale-asia.com>
 <CAErSpo4Rmtd4LsXmgvb4Vn92z=u1feRyPWF=KS8ggVZvitjEnA@mail.gmail.com>
 <4EA6D76C.5050505@numascale.com> <CAErSpo6T8NXrHzkyHQmw3h4u5u61AZ_biF4FBf3US7FryEwhTw@mail.gmail.com>
 <4EA6F2F4.9080005@numascale.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 25 Oct 2011 13:57:57 -0600
Message-ID: <CAErSpo6gJR3BnGqoZv2BPR4O5B4oqMK0tcf+8-fVQ9uquhcjQg@mail.gmail.com>
Subject: Re: [PATCH 3/3] Add NumaChip quirk
To: Steffen Persvold <sp@numascale.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Arne Georg Gleditsch <arne.gleditsch@numascale.com>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 11:33 AM, Steffen Persvold <sp@numascale.com> wrote:
> On 10/25/2011 19:15, Bjorn Helgaas wrote:
>>
>> [+cc linux-pci]
>>
> []
>>>
>>> The conflict we refer to in the patch is that since Linux thinks we have
>>> those windows assigned to us, we get conflicts later on with real devices
>>> :
>>>
>>> [    5.887856] pnp 00:0e: disabling [mem 0x00000000-0x0009ffff] because
>>> it
>>> overlaps 0000:00:1a.0 BAR 0 [mem 0x00000000-0x000fffff]
>>> [    5.899525] pnp 00:0e: disabling [mem 0x000c0000-0x000cffff] because
>>> it
>>> overlaps 0000:00:1a.0 BAR 0 [mem 0x00000000-0x000fffff]
>>> [    5.911002] pnp 00:0e: disabling [mem 0x000e0000-0x000fffff] because
>>> it
>>> overlaps 0000:00:1a.0 BAR 0 [mem 0x00000000-0x000fffff]
>>
>> Yeah, this is gross, and this is definitely something Linux is doing
>> wrong.  We don't have a consistent way of marking PCI BARs as
>> "disabled," so every zero-valued BAR seems to conflict with PNP
>> devices.  Typically there are motherboard devices like your 00:0e that
>> reserve regions of low memory.
>>
>> Lots of machines complain like this, not just NumaChip, and there's no
>> real ill effect.  We say we're disabling a PNP device resource, but we
>> don't actually evaluate an _SRS method to tell the BIOS to do
>> anything.  So I think we complain about the conflict but don't do
>> anything else.
>
> Ah, ok. I didn't dive into it, so I didn't see if anything bad(tm) really
> happened when that PNP device got "disabled" resources.
>
>>
>>> I guess technically, the Linux PCI bus probing code should check the
>>> Command
>>> register (offset 0x4) to see if MemorySpace is enabled (which in our case
>>> it
>>> won't be) before checking the BAR registers.
>>
>> The question is how we handle a device with MemorySpace disabled.  In
>> most cases, I think we want to assign BAR resources to it so that if a
>> driver claims the device, we can enable MemorySpace and the device
>> will work.  If the BIOS leaves MemorySpace disabled and Linux doesn't
>> assign BAR space at boot-time, we may be stuck because in general we
>> can't assign resources dynamically.  Dynamic assignment might require
>> moving other devices, enlarging bridge windows, etc., which Linux
>> currently doesn't support.
>
> Yes, I didn't want to open that can of worms :)
>
>>
>> NumaChip sounds like an exception because you know you never care
>> about using those BARs.  But I'm curious -- it looks like Linux didn't
>> even try to assign resources to them.  I thought something in the
>> pci_assign_unassigned_resources() path would have tried to do
>> something with them.  If we *did* assign resources to those BARs, I
>> assume nothing would break, since there's no driver that actually uses
>> them.  Right?
>>
>
> Correct, the BARs are there and if something sensible were written to them
> (and MemorySpace was enabled in the Command register) NumaChip *would*
> respond to mmio accesses to that address range. However, those BARs are only
> for memory mapped configuration register (CSR) access which can be accessed
> in a "reserved" address range anyway which is what we refer to as global CSR
> space. This is what the 2 other sub-patches are using for talking to the
> NumaChip, and if someone would write any driver at some point it would most
> likely be tied to that type of access anyway.
>
> The BARs can only be used for "local" CSR space which isn't that useful
> anyway so we don't bother assigning anything to it (or don't care if
> anything is). Besides, in a cluster with 1000s of NumaChip nodes all
> connected together (with different PCI segments etc. etc.) you really don't
> want to assign BARs anyway since you already have the global CSR space.
>
> With this background, would you agree that it makes sense to still have the
> quirk or would you go about and solve it in a different way ?

In this case, I think the only thing the quirk does for you is to get
rid of the warning.  I don't think it will make anything work better,
so my inclination would be to just skip the quirk.

Tangent: I looked at the other patches, specifically
https://lkml.org/lkml/2011/7/22/97, and I see some of the global CSR
space stuff.  I assume you have ACPI devices that describe the global
CSR address space?  I don't see anything in the patch that reserves
that space in iomem_resource.  There should be some mechanism for
reserving that space to prevent collisions.  For PCI devices, normally
that's the BAR.  For other devices on x86, normally that's ACPI.

Bjorn
