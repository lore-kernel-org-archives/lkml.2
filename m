Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2LKRYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:24:24 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60899 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2LKRYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:24:23 -0500
Date: Tue, 11 Dec 2012 17:29:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Lior Amsalem <alior@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>, Yehuda Yitschak <yehuday@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions in
 CONFIG_HAS_IOPORT
Message-ID: <20121211172916.2668a5be@pyramind.ukuu.org.uk>
In-Reply-To: <20121211173819.6f2cf32b@skate>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<201212111043.50627.arnd@arndb.de>
	<20121211170338.4859ddf0@skate>
	<201212111615.03262.arnd@arndb.de>
	<20121211162325.GR14363@n2100.arm.linux.org.uk>
	<20121211173819.6f2cf32b@skate>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you enlighten my very naive understanding of things about PCI/ISA
> IO space? On x86, I seem to understand this is the separate address
> space accessed by the special in/out CPU instructions. Are there ARM
> platforms with the same sort of things?

An x86 processor has two address spaces

A memory space
An I/O space

They are both visible to the PCI bus and both transaction types are
present on the bus and distinct.

> As far as I understand, on my ARM Marvell system, everything is
> memory-mapped, so there isn't such a separate PCI/ISA IO space.

There is if you ask the PCI bridge or beyond.

> Therefore, why would I need to "select HAVE_IOPORT" simply to be able
> to build libata-sff.c, that is used for PCI drivers that work fine with
> purely memory-mapped registers?

Because the drivers talk to the hardware beyond the bridge which knows
the difference.


So on x86 we have

	inb(0xf00);

	generates an I/O transaction on the PCI bus for I/O 0xf00

	*0xf00

	generates a memory transacion on the PCI bus for memory 0xf00
	and the two are *not* the same thing or address

On many other platforms we have 

	inb(0xf00)

	actually produces the equivalent of (*io_window+0xf00)

	which the PCI bridge turns into an I/O transaction for 0xf00

	(and for the out case may have an explicit barrier needed to get
	the I/O ordering rules)

	while

	*0xf00

	gets turned by the bridge into a memory transaction for 0xf00



The "no I/O space" case really applies to things like the S/390 mainframe
which simply have no such concept on the system or the devices. In the
ARM case the bus has an I/O space and the bridge glues the processors
simpler model to the bridge model.

For compatibility reasons (so you an boot old software) the PCI bus also
has some automatic magic mappings in I/O space, and a lot of LPC bus
devices also have magic I/O mappings. For example a SATA controller in
compatibility mode appears at a specified I/O address on the bus and is
always on a specific IRQ (matching the old ISA PC mappings which map the
old ISA MFM controller mappings whose offsets map compatiblity to the
register mappings for the WD MFM controller used on the PC/AT)

In PC space this stuff is important and it's why up until Windows 7 era
PC hardware you can boot DOS, as well as being why you can have one
generic kernel for almost any PC hardware instead of the one per board
problem some other platforms have.

Alan

