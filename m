Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2LKQ4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:56:16 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58393 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2LKQ4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:56:15 -0500
Date: Tue, 11 Dec 2012 16:55:45 +0000
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
Message-ID: <20121211165545.GV14363@n2100.arm.linux.org.uk>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com> <201212111043.50627.arnd@arndb.de> <20121211170338.4859ddf0@skate> <201212111615.03262.arnd@arndb.de> <20121211173013.0ceea196@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211173013.0ceea196@skate>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 05:30:13PM +0100, Thomas Petazzoni wrote:
> arch/arm/mm/iomap.c is unconditionally compiled in all ARM kernels. And
> in this file, ioport_map() and ioport_unmap() are implement as soon as
> __io is defined. And basically, in arch/arm/include/asm/io.h, __io is
> defined for all platforms

Actually, I think that's a major bug in the single-zImage conversion:

#ifdef CONFIG_NEED_MACH_IO_H
#include <mach/io.h>
#elif defined(CONFIG_PCI)
#define IO_SPACE_LIMIT  ((resource_size_t)0xfffff)
#define __io(a)         __typesafe_io(PCI_IO_VIRT_BASE + ((a) & IO_SPACE_LIMIT))
#else
#define __io(a)         __typesafe_io((a) & IO_SPACE_LIMIT)
#endif

#ifndef IO_SPACE_LIMIT
#if defined(CONFIG_PCMCIA_SOC_COMMON) || defined(CONFIG_PCMCIA_SOC_COMMON_MODULE)
#define IO_SPACE_LIMIT ((resource_size_t)0xffffffff)
#elif defined(CONFIG_PCI) || defined(CONFIG_ISA) || defined(CONFIG_PCCARD)
#define IO_SPACE_LIMIT ((resource_size_t)0xffff)
#else
#define IO_SPACE_LIMIT ((resource_size_t)0)
#endif
#endif

So, in the !PCI !PCMCIA !ISA !PCCARD case, IO_SPACE_LIMIT will be zero,
which means the above common __io() functions will end up pointing the
access at the NULL pointer - whereas we shouldn't be providing IO space
support at all.  (Okay, there's a couple of corner cases we've known
about for a few _years_ but it's about time that stuff got fixed before
we try and put yet more band-aids over this.  Fix the root problems
guys, don't create more problems.)
