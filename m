Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2AHW1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 17:27:47 -0500
Received: from a2-smtpout6.uol.com.br ([200.147.33.244]:51405 "EHLO
	smtps.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754603Ab2AHW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 17:27:46 -0500
X-Greylist: delayed 815 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jan 2012 17:27:46 EST
X-UOL-SMTP: SMTPS25
Date: Sun, 8 Jan 2012 20:27:22 -0200
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Edward Donovan <edward.donovan@numble.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        bugzilla-daemon@bugzilla.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?utf-8?Q?M=C3=A1rcia?= Coutinho de Brito <mcbrito@gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
Message-ID: <20120108222722.GB7058@ime.usp.br>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
 <201109062222.p86MMlK9023363@demeter2.kernel.org>
 <CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
 <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
 <CADdbW+HvKQRFJgcofZCjJrTtaPDpDhcw4UStuhyTUe1aKnD2JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADdbW+HvKQRFJgcofZCjJrTtaPDpDhcw4UStuhyTUe1aKnD2JQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SIG5: 91ba36adc227b46fcdfcf11fe86ffd23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi, Edward.

On Jan 06 2012, Edward Donovan wrote:
> I'll be interested to know if any IRQ handled by 2.6.38 isn't handled now,
> but I expect it will be.  I'm sorry if that isn't enough for this laptop,
> though -

I bisected the PCI stuff and ended up with a bad commit 12c22d6ef299ccf0955,
which was made by Linus:

,----[ git show 12c22d6ef299ccf0955e5756eb57d90d7577ac68 ]
| commit 12c22d6ef299ccf0955e5756eb57d90d7577ac68
| Author: Linus Torvalds <torvalds@linux-foundation.org>
| Date:   Wed Mar 26 11:22:40 2008 -0700
| 
|     Revert "PCI: remove transparent bridge sizing"
| (...)    
`----

The patch that I am using to make this laptop boot at least is essentially a
revert of that commit.

Just for the sake of documentation, I am attaching here the patch that makes
things work (at least partially).

Any directions to debug this properly are welcome.


Thanks,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br

--GvXjxJ+pjyke8COw
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="do_not_size_subtractive_decoding_transparent_pci_to_pci_bridges.patch"

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 86b69f85..84543f5 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -849,6 +849,10 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 		break;
 
 	case PCI_CLASS_BRIDGE_PCI:
+		/* don't size subtractive decoding (transparent)
+		 * PCI-to-PCI bridges */
+		if (bus->self->transparent)
+			break;
 		pci_bridge_check_ranges(bus);
 		if (bus->self->is_hotplug_bridge) {
 			additional_io_size  = pci_hotplug_io_size;

--GvXjxJ+pjyke8COw--
