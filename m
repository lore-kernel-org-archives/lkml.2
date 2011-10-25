Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1JYRPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 13:15:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18776 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab1JYRPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 13:15:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=MCSCKx71ekFJqg2/8jQGiVFr3XyICl69BJ4ryO7ikVw7kM+n8FT8m9EKIFiwF5e5q
	5y7i93v0wODMzfi25n+Fw==
MIME-Version: 1.0
In-Reply-To: <4EA6D76C.5050505@numascale.com>
References: <1318926156-25504-1-git-send-email-daniel@numascale-asia.com>
 <1318926156-25504-3-git-send-email-daniel@numascale-asia.com>
 <CAErSpo4Rmtd4LsXmgvb4Vn92z=u1feRyPWF=KS8ggVZvitjEnA@mail.gmail.com> <4EA6D76C.5050505@numascale.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 25 Oct 2011 11:15:29 -0600
Message-ID: <CAErSpo6T8NXrHzkyHQmw3h4u5u61AZ_biF4FBf3US7FryEwhTw@mail.gmail.com>
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

[+cc linux-pci]

On Tue, Oct 25, 2011 at 9:36 AM, Steffen Persvold <sp@numascale.com> wrote:
> On 10/25/2011 16:38, Bjorn Helgaas wrote:
>>
>> On Tue, Oct 18, 2011 at 2:22 AM, Daniel J Blueman
>> <daniel@numascale-asia.com>  wrote:
>>>
>>> Add quirk for Numascale's NumaChip to prevent resource conflicts.
>
> []
>>
>> This feels like a band-aid ... what's the background here?  I can see
>> that you're disabling PCI resources, and I can read that this avoids
>> conflicts, but what's the underlying cause of the conflict?
>>
>> I wonder if there's a more generic problem that should be fixed
>> differently.  Presumably the NumaChip designers put those BARs there
>> for a reason, and often when we report "conflicts," it's really a clue
>> that we're doing something wrong in host bridge discovery or in
>> generic PCI.
>>
>> Can you post a complete dmesg log showing the conflict?
>>
>
> Hi Bjorn,
>
> The issue is a bit complicated, but here's the story; NumaChip is a coherent
> NorthBridge device on AMD systems (i.e part of the coherent fabric) but the
> BIOS does *not* assign any resources to it, in fact the BIOS skips our
> device entirely leaving our BAR registers at HW init values (0x00000000).
> This is in fact by design (AMD AGESA code). This isn't really a big issue
> for us anyway because we have other means of reaching our CSR logic (not
> going into detail, but the other patches in this patchset would reveal how
> we do that).
>
> Linux however, when scanning the PCI buses finds our device (because it is
> responding to config space requests) it thinks that we got a BAR0 that
> starts at 0x00000000 which obviously isn't correct. In addition, in the
> bootloader that we've written for NumaChip systems (to bring them all
> together as a huge coherent system) we had to use the expansion rom config
> space register (F0x030) as kind of a "scratch register".

We do treat zero as a special value when found in BARs, but that's
sort of a muddy area.  On x86, a zero-valued BAR is not very useful
because typically there's RAM at address zero and PCI host bridges
don't usually perform address translation.  But on architectures like
ia64/alpha/parisc/powerpc/etc., where host bridges often *do*
translate addresses, zero might be a perfectly valid BAR value.

> The end result is :
>
> [    4.636297] pci 0000:00:1a.0: reg 10: [mem 0x00000000-0x000fffff]
> [    4.640317] pci 0000:00:1a.0: reg 30: [mem 0x3fff0000-0x3fffffff pref]
> [    4.644369] pci 0000:00:1a.1: [1b47:0602] type 0 class 0x000600
>
> Neither of these resources are real, our device will not respond to requests
> to any of those windows.
>
> The conflict we refer to in the patch is that since Linux thinks we have
> those windows assigned to us, we get conflicts later on with real devices :
>
> [    5.887856] pnp 00:0e: disabling [mem 0x00000000-0x0009ffff] because it
> overlaps 0000:00:1a.0 BAR 0 [mem 0x00000000-0x000fffff]
> [    5.899525] pnp 00:0e: disabling [mem 0x000c0000-0x000cffff] because it
> overlaps 0000:00:1a.0 BAR 0 [mem 0x00000000-0x000fffff]
> [    5.911002] pnp 00:0e: disabling [mem 0x000e0000-0x000fffff] because it
> overlaps 0000:00:1a.0 BAR 0 [mem 0x00000000-0x000fffff]

Yeah, this is gross, and this is definitely something Linux is doing
wrong.  We don't have a consistent way of marking PCI BARs as
"disabled," so every zero-valued BAR seems to conflict with PNP
devices.  Typically there are motherboard devices like your 00:0e that
reserve regions of low memory.

Lots of machines complain like this, not just NumaChip, and there's no
real ill effect.  We say we're disabling a PNP device resource, but we
don't actually evaluate an _SRS method to tell the BIOS to do
anything.  So I think we complain about the conflict but don't do
anything else.

> I guess technically, the Linux PCI bus probing code should check the Command
> register (offset 0x4) to see if MemorySpace is enabled (which in our case it
> won't be) before checking the BAR registers.

The question is how we handle a device with MemorySpace disabled.  In
most cases, I think we want to assign BAR resources to it so that if a
driver claims the device, we can enable MemorySpace and the device
will work.  If the BIOS leaves MemorySpace disabled and Linux doesn't
assign BAR space at boot-time, we may be stuck because in general we
can't assign resources dynamically.  Dynamic assignment might require
moving other devices, enlarging bridge windows, etc., which Linux
currently doesn't support.

NumaChip sounds like an exception because you know you never care
about using those BARs.  But I'm curious -- it looks like Linux didn't
even try to assign resources to them.  I thought something in the
pci_assign_unassigned_resources() path would have tried to do
something with them.  If we *did* assign resources to those BARs, I
assume nothing would break, since there's no driver that actually uses
them.  Right?

Bjorn
