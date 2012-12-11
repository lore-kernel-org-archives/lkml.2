Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab2LKWUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:20:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57638 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2LKWUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:20:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions in CONFIG_HAS_IOPORT
Date: Tue, 11 Dec 2012 22:20:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eran Ben-Avi" <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com> <20121211173819.6f2cf32b@skate> <20121211172916.2668a5be@pyramind.ukuu.org.uk>
In-Reply-To: <20121211172916.2668a5be@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212112220.04597.arnd@arndb.de>
X-Provags-ID: V02:K0:6FpX0/TsEUrs5LCXiTZ2+EGFcBZl/6bPj6CRkLK1W8/
 9lj0WBEpTjSiJavN+QQPLC3BRlobyGBypiHolo1suDoeXmR+Mt
 sBTAIs9c+T04ZQBHqvxieMMGwhS+cvEbOPGwSJ+hNIduZc5GHi
 ZXIwtxmsMtQZ031fJTucKrb4uFTuL4js+YI/VamGg8GLvXx21l
 0mVbJKh4WdLXmxyMIGhUUvYim1f91aPjmSpgjeJAsmChns1RV1
 RimivsU8rBuIswID48rIblv1n1ETVtfWQeklFJNtjJXPZ8pmMj
 EQcpf1slVHMuub+yoR3EIXAhz+t7EVdyv5bDDTAhwZM6K6pXt6
 gD0rVGEhAvLo8JJuCJGc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2012, Alan Cox wrote:
> The "no I/O space" case really applies to things like the S/390 mainframe
> which simply have no such concept on the system or the devices. In the
> ARM case the bus has an I/O space and the bridge glues the processors
> simpler model to the bridge model.

While we are getting slightly offtopic, s390 is actually gaining PCI support
now: https://patchwork.kernel.org/patch/1740231/ For all I can tell, they
would theoretically support an I/O space, but none of the supported
add-on cards use it, so the kernel implementation doesn't need to bother.

One architecture that never has an I/O space is the arch/um, but that is
special in a lot of ways, e.g. since it also never has MMIO.

On ARM, we have platforms that fall into four categories:

1. Full PCI or PCMCIA or ISA support with directly mapped I/O space

2. No PCI or PCMCIA or ISA support, and consequently no I/O space

3. PCI support but no I/O space because of limitations or bugs in
   the PCI hardware implementation.

4. ISA-style I/O space that is not offsettable (CONFIG_NO_IOPORT)
   but still has inb/outb accessors.

For cases 2 and 3, we can undefine the __io() macro, which leads to
intentional build errors someone tries to build code that uses the
inb/outb accessors. One missing piece that I have been working on
in the past and been meaning to pick up again is a patch set to
globally rename CONFIG_NO_IOPORT to the more appropriate
CONFIG_NO_IOPORT_MAP, and introduce a new CONFIG_NO_IOPORT that
signifies whether inb/outb are supported or not, rather than whether
you can access the I/O ports through ioport_map() and ioread/iowrite.

	Arnd
