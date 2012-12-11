Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2LKQZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:25:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58310 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab2LKQZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:25:01 -0500
Date: Tue, 11 Dec 2012 16:23:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Yehuda Yitschak <yehuday@marvell.com>,
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
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions
	in CONFIG_HAS_IOPORT
Message-ID: <20121211162325.GR14363@n2100.arm.linux.org.uk>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com> <201212111043.50627.arnd@arndb.de> <20121211170338.4859ddf0@skate> <201212111615.03262.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212111615.03262.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 04:15:02PM +0000, Arnd Bergmann wrote:
> On Tuesday 11 December 2012, Thomas Petazzoni wrote:
> > On Tue, 11 Dec 2012 10:43:49 +0000, Arnd Bergmann wrote:
> > > On Friday 07 December 2012, Thomas Petazzoni wrote:
> > > > The pcim_*() functions are used by the libata-sff subsystem, and this
> > > > subsystem is used for many SATA drivers on ARM platforms that do not
> > > > necessarily have I/O ports.
> > > 
> > > I think this one is wrong as the CONFIG_HAS_IOPORT does not refer to the
> > > presence of PIO ports but to whether or not they provide an ioport_map
> > > function. If there is no ioport_map(), devm_pci_iomap will fail to link
> > > as far as I can tell.
> > 
> > The problem is that on ARCH_MULTI_V7, ARCH_VEXPRESS is forcefully
> > enabled. And ARCH_VEXPRESS selects NO_IOPORT.. so you don't have the
> > pcim_*() functions, and therefore libata-sff.c (needed for many SATA
> > drivers) will not build. How do you solve this?
> 
> What you describe here are probable two bugs, and we should fix both:
> 
> * ARCH_VEXPRESS should not select NO_IOPORT. It's generally wrong
>   to select this in combination with ARCH_MULTIPLATFORM, when some
>   of the other platforms you may enable actually have IOPORT mapping
>   support.

No.  ARCH_VEXPRESS selects NO_IOPORT because it _does_ _not_ support
PCI/ISA IO space.  That in itself is reasonable, but what isn't
reasonable is the _negative_ logic being used.  Negative logic in
the config system always tends to provoke this kind of sillyness
because you're selecting something to be excluded which another
platform may require.

Positive logic is the only way to deal with this.

We should instead have HAVE_IOPORT and platforms which need ISA/PCI IO
space support should select this symbol instead - so it becomes an
_inclusive_ feature rather than an _exclusive_ feature.
