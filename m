Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1JYUDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:03:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54502 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1JYUDa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:03:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=P5A/RKpxS1V2vlEFjo21OXjoyViWD5j/u8deiYshmyDLOS6eqwkY11xNnhdbg4gvW
	95DdXMia72CFjHgafxVGg==
MIME-Version: 1.0
In-Reply-To: <4EA6FB6A.2020800@numascale.com>
References: <1318926156-25504-1-git-send-email-daniel@numascale-asia.com>
 <1318926156-25504-3-git-send-email-daniel@numascale-asia.com>
 <CAErSpo4Rmtd4LsXmgvb4Vn92z=u1feRyPWF=KS8ggVZvitjEnA@mail.gmail.com>
 <4EA6D76C.5050505@numascale.com> <CAErSpo6T8NXrHzkyHQmw3h4u5u61AZ_biF4FBf3US7FryEwhTw@mail.gmail.com>
 <4EA6F2F4.9080005@numascale.com> <4EA6FB6A.2020800@numascale.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 25 Oct 2011 14:03:08 -0600
Message-ID: <CAErSpo7tPwZQ_SokhUL_-M5MG1FueuP7hwR=sxoL2H2t_b-7QA@mail.gmail.com>
Subject: Re: [PATCH 3/3] Add NumaChip quirk
To: Arne Georg Gleditsch <arne.gleditsch@numascale.com>
Cc: Steffen Persvold <sp@numascale.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:09 PM, Arne Georg Gleditsch
<arne.gleditsch@numascale.com> wrote:
> On 25. okt. 2011 19:33, Steffen Persvold wrote:
>> On 10/25/2011 19:15, Bjorn Helgaas wrote:
>>> NumaChip sounds like an exception because you know you never care
>>> about using those BARs.  But I'm curious -- it looks like Linux didn't
>>> even try to assign resources to them.  I thought something in the
>>> pci_assign_unassigned_resources() path would have tried to do
>>> something with them.  If we *did* assign resources to those BARs, I
>>> assume nothing would break, since there's no driver that actually uses
>>> them.  Right?
>>>
>>
>> Correct, the BARs are there and if something sensible were written to
>> them (and MemorySpace was enabled in the Command register) NumaChip
>> *would* respond to mmio accesses to that address range.
>
> A minor point: adjusting the BARs would not strictly speaking be
> sufficient for the NumaChip to respond, as it would never see these
> accesses unless the [MMIO address range]->[HyperTransport node/link]
> registers of the CPU NorthBridges were also updated with the relevant
> ranges.  This is a bit messy, but in a way much the same issue as when
> secondary southbridges are connected to secondary CPUs in any other
> HyperTransport-based system.

The [MMIO address range]->[HyperTransport node/link] registers you're
talking about are the implementation side of the PCI host bridge
abstraction.  You should have an ACPI host bridge device (PNP0A03 or
PNP0A08) that describes the apertures, and if Linux assigns resources
to the BARs, it will only use areas inside the apertures.  If there's
no available space in the apertures, we just leave the device alone
(maybe this explains why we didn't assign anything).

> Perhaps an alternative to this NumaChip-specific quirk would be to
> special-case BARs belonging to "PCI" devices 00:18 - 00:1f in AMD
> Opteron systems.  These always indicate coherent HT devices and fiddling
> with the CPU NB maps are going to be required if anything is changed
> regarding the BAR assignments here.

I don't think there's a need to special-case these AMD BARs.  If the
BIOS programs them correctly (inside a PCI host bridge aperture
reported via ACPI), Linux won't touch them.

Bjorn
