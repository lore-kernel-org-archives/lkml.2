Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2AHWZO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 17:25:14 -0500
Received: from a2-sete6-1.uol.com.br ([200.147.34.180]:58027 "EHLO
	a2-sete6.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754651Ab2AHWZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 17:25:12 -0500
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jan 2012 17:25:12 EST
X-UOL-SMTP: SMTPS25
Date: Sun, 8 Jan 2012 20:13:42 -0200
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bugzilla-daemon@bugzilla.kernel.org,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?utf-8?Q?M=C3=A1rcia?= Coutinho de Brito <mcbrito@gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
Message-ID: <20120108221342.GA7058@ime.usp.br>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
 <201109062222.p86MMlK9023363@demeter2.kernel.org>
 <CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
 <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SIG5: 8039fa81e5522bceb8c8447029826e55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there, Linus.

On Jan 06 2012, Linus Torvalds wrote:
> 2012/1/6 Rogério Brito <rbrito@ime.usp.br>:
> >
> > For the record, *some* description of the problem is at:
> >
> > * https://bugzilla.kernel.org/show_bug.cgi?id=41132
> 
> This one looks very much like the thing that Edward Donovan fixed
> fairly recently in commit 52553ddffad7 ("genirq: fix regression in
> irqfixup, irqpoll")

It does look similar, but not quite the same. And, yes, my main desktop (the
one that I'm using right now) was affected by Edward's commit, which, BTW,
has my Reported-and-tested-by.

This one is different. Here is a brief summary of the situation:

# Computer description

* Rebranded Clevo M5X0JE
* nForce2 chipset
* AMD Sempron CPU
* NIC with driver forcedeth
* wifi rtl8187

# Booting options

The current working options passed to the kernel are: `acpi=off pnpbios=off noapic`

It doesn't boot with a vanilla kernel. It only boots when I pass the options
above *and* compile the kernel with the following patch applied:

,----[ do_not_size_subtractive_decoding_transparent_pci_to_pci_bridges.patch ]
| diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
| index 86b69f85..84543f5 100644
| --- a/drivers/pci/setup-bus.c
| +++ b/drivers/pci/setup-bus.c
| @@ -849,6 +849,10 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
|  		break;
|  
|  	case PCI_CLASS_BRIDGE_PCI:
| +		/* don't size subtractive decoding (transparent)
| +		 * PCI-to-PCI bridges */
| +		if (bus->self->transparent)
| +			break;
|  		pci_bridge_check_ranges(bus);
|  		if (bus->self->is_hotplug_bridge) {
|  			additional_io_size  = pci_hotplug_io_size;
`----

Otherwise, it hangs right when trying to configure PCI, which, according to
the dmesg log when it boots occurs approximately 0.12 seconds after the
kernel shows its first message.

> So that should be fixed in 3.2 (and it's marked for stable, so I think
> it's in the latest stable kernels too)
> 
> > * https://bugzilla.kernel.org/show_bug.cgi?id=41722
> 
> That, however, looks totally insane. I don't even have a clue where to
> begin. I take it that it works with "acpi=off", and don't have a clue
> about what might go wrong with ACPI enabled.

Yes, with acpi=off it "works" (well, it seems that without ACPI many things
don't get enabled).  At least mom was able to visit a site like Gmail to
check her email.

She would like say that she is positively impressed with the committment of
the community with a case of a layman person and she told me to send you all
big thank you.


Thanks from me also,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
