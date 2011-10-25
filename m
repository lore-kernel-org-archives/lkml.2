Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab1JYQD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:03:27 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:43226 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab1JYQDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:03:25 -0400
X-Greylist: delayed 1621 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Oct 2011 12:03:25 EDT
Message-ID: <4EA6D76C.5050505@numascale.com>
Date: Tue, 25 Oct 2011 17:36:12 +0200
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "'Arne Georg Gleditsch'" <arne.gleditsch@numascale.com>
Subject: Re: [PATCH 3/3] Add NumaChip quirk
References: <1318926156-25504-1-git-send-email-daniel@numascale-asia.com> <1318926156-25504-3-git-send-email-daniel@numascale-asia.com> <CAErSpo4Rmtd4LsXmgvb4Vn92z=u1feRyPWF=KS8ggVZvitjEnA@mail.gmail.com>
In-Reply-To: <CAErSpo4Rmtd4LsXmgvb4Vn92z=u1feRyPWF=KS8ggVZvitjEnA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 16:38, Bjorn Helgaas wrote:
> On Tue, Oct 18, 2011 at 2:22 AM, Daniel J Blueman
> <daniel@numascale-asia.com>  wrote:
>> Add quirk for Numascale's NumaChip to prevent resource conflicts.
[]
> This feels like a band-aid ... what's the background here?  I can see
> that you're disabling PCI resources, and I can read that this avoids
> conflicts, but what's the underlying cause of the conflict?
>
> I wonder if there's a more generic problem that should be fixed
> differently.  Presumably the NumaChip designers put those BARs there
> for a reason, and often when we report "conflicts," it's really a clue
> that we're doing something wrong in host bridge discovery or in
> generic PCI.
>
> Can you post a complete dmesg log showing the conflict?
>

Hi Bjorn,

The issue is a bit complicated, but here's the story; NumaChip is a 
coherent NorthBridge device on AMD systems (i.e part of the coherent 
fabric) but the BIOS does *not* assign any resources to it, in fact the 
BIOS skips our device entirely leaving our BAR registers at HW init 
values (0x00000000). This is in fact by design (AMD AGESA code). This 
isn't really a big issue for us anyway because we have other means of 
reaching our CSR logic (not going into detail, but the other patches in 
this patchset would reveal how we do that).

Linux however, when scanning the PCI buses finds our device (because it 
is responding to config space requests) it thinks that we got a BAR0 
that starts at 0x00000000 which obviously isn't correct. In addition, in 
the bootloader that we've written for NumaChip systems (to bring them 
all together as a huge coherent system) we had to use the expansion rom 
config space register (F0x030) as kind of a "scratch register".

The end result is :

[    4.636297] pci 0000:00:1a.0: reg 10: [mem 0x00000000-0x000fffff]
[    4.640317] pci 0000:00:1a.0: reg 30: [mem 0x3fff0000-0x3fffffff pref]
[    4.644369] pci 0000:00:1a.1: [1b47:0602] type 0 class 0x000600

Neither of these resources are real, our device will not respond to 
requests to any of those windows.

The conflict we refer to in the patch is that since Linux thinks we have 
those windows assigned to us, we get conflicts later on with real devices :

[    5.887856] pnp 00:0e: disabling [mem 0x00000000-0x0009ffff] because 
it overlaps 0000:00:1a.0 BAR 0 [mem 0x00000000-0x000fffff]
[    5.899525] pnp 00:0e: disabling [mem 0x000c0000-0x000cffff] because 
it overlaps 0000:00:1a.0 BAR 0 [mem 0x00000000-0x000fffff]
[    5.911002] pnp 00:0e: disabling [mem 0x000e0000-0x000fffff] because 
it overlaps 0000:00:1a.0 BAR 0 [mem 0x00000000-0x000fffff]


I guess technically, the Linux PCI bus probing code should check the 
Command register (offset 0x4) to see if MemorySpace is enabled (which in 
our case it won't be) before checking the BAR registers.

 From my perspective however, it seemed easier and less intrusive to 
just hook in a quirk for our device since we do not use those BAR 
settings anyway in any form once Linux is booted.

I hope this clear things up a bit. If you have any other questions don't 
hesitate to ask.

Kind regards,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
