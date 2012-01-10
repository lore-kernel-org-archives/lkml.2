Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2AJBcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 20:32:31 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43166 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab2AJBc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 20:32:29 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
	<201109062222.p86MMlK9023363@demeter2.kernel.org>
	<CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
	<CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<20120108221342.GA7058@ime.usp.br>
	<CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
	<20120109112207.7f993845@jbarnes-desktop>
	<CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
Date: Mon, 9 Jan 2012 17:32:28 -0800
X-Google-Sender-Auth: tEsWj03AVlKnEk6zbYjldkdclio
Message-ID: <CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>,
        bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 11:41 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 9, 2012 at 11:22 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>
>> I don't remember what problems we hit, but if Ram and Yinghai are
>> willing to take a look at them we should go ahead and try again.
>
> So the two bugzilla entries quoted in the revert are
>
>  http://bugzilla.kernel.org/show_bug.cgi?id=10080
>  http://bugzilla.kernel.org/show_bug.cgi?id=9961
>
>  with at least one real smoking gun in this one:
>
>  https://lkml.org/lkml/2008/3/26/94
>
> however at least *part* of the problem for some people was not the
> transparency itself, as much as the fact that we did bad things with
> 64-bit resources etc.

2 cases:
a. transparent bridge has resource allocated from BIOS.
b. transparent bridge does not have resource allocated from BIOS.

skipping transparent bridge size checking only affects case b.

when skip code is there, those bridge register will not be probed (
with 0xfff0fff0),
and those bridge bar will not get allocated. and child devices that
does not get allocated from
BIOS, kernel will allocate from parent bus resources... up to peer root bus.

Rogério's laptop does not like bus resize, could be because the bridge
does not like kernel to use
0xfff0fff0 to probe it...

We could add one quirks etc to skip this kind of probe.

>
> So what I think mostly happened was that not sizing up transparent
> bridges ended up showing up other bugs. We've fixed at least some of
> those other bugs in the meantime (things like using "unsigned long"
> for physical addresses in ioremap etc, which broke when 64-bit
> resources were used on 32-bit architectures).
>
> But it's entirely possible that it will still trigger similar issues.
> For example, even if a bridge is transparent, maybe it is still
> limited to 32-bit addresses? If we look at the actual IO windows, we'd
> get that 32-bit limit right automatically. If we just say "it's
> transparent", we might allocate child devices with 64-bit resources
> above the 4GB area, and be screwed. That seems to have been one
> problem above - even if we now get it right on a software level, there
> may actually be hardware issues in the same area.

in pci_bus_alloc_resource(),  we already have

        /* don't allocate too high if the pref mem doesn't support 64bit*/
        if (!(res->flags & IORESOURCE_MEM_64))
                max = PCIBIOS_MAX_MEM_32;

So it should allocate to range below 4G to unassigned children devices.

but need to make sure (peer) root bus does have valid resource range at first.

Rogério,

Do you have bootlog with "debug ignore_loglevel pci=earlydump" ?

Thanks

Yinghai
