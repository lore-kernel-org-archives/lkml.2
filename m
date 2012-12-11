Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2LKQvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:51:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58379 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab2LKQvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:51:10 -0500
Date: Tue, 11 Dec 2012 16:50:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Lior Amsalem <alior@marvell.com>,
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
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions
	in CONFIG_HAS_IOPORT
Message-ID: <20121211165050.GU14363@n2100.arm.linux.org.uk>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com> <201212111043.50627.arnd@arndb.de> <20121211170338.4859ddf0@skate> <201212111615.03262.arnd@arndb.de> <20121211162325.GR14363@n2100.arm.linux.org.uk> <20121211173819.6f2cf32b@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211173819.6f2cf32b@skate>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 05:38:19PM +0100, Thomas Petazzoni wrote:
> Russell,
> 
> On Tue, 11 Dec 2012 16:23:25 +0000, Russell King - ARM Linux wrote:
> 
> > > * ARCH_VEXPRESS should not select NO_IOPORT. It's generally wrong
> > >   to select this in combination with ARCH_MULTIPLATFORM, when some
> > >   of the other platforms you may enable actually have IOPORT mapping
> > >   support.
> > 
> > No.  ARCH_VEXPRESS selects NO_IOPORT because it _does_ _not_ support
> > PCI/ISA IO space.  That in itself is reasonable, but what isn't
> > reasonable is the _negative_ logic being used.  Negative logic in
> > the config system always tends to provoke this kind of sillyness
> > because you're selecting something to be excluded which another
> > platform may require.
> 
> Could you enlighten my very naive understanding of things about PCI/ISA
> IO space? On x86, I seem to understand this is the separate address
> space accessed by the special in/out CPU instructions. Are there ARM
> platforms with the same sort of things?
> 
> As far as I understand, on my ARM Marvell system, everything is
> memory-mapped, so there isn't such a separate PCI/ISA IO space.
> 
> Therefore, why would I need to "select HAVE_IOPORT" simply to be able
> to build libata-sff.c, that is used for PCI drivers that work fine with
> purely memory-mapped registers?

- PCI buses make the distinction between memory accesses and IO accesses.
- ARM doesn't have IO access instructions; everything is memory mapped.
- In order to make the two work together, whatever PCI interface provides
  a way to issue IO accesses via a contiguous memory mapped region.
- The PCI layer and drivers are written to keep these two spaces separate
  so that they remain portable across multiple different platforms.

Therefore, if you have PCI/ISA drivers that make use of IO space, you need
to provide the IO space accessors and mapping functions so that these
drivers can access the IO space on their devices in a platform independent
manner.
