Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2LKQre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:47:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58360 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab2LKQrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:47:32 -0500
Date: Tue, 11 Dec 2012 16:46:08 +0000
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
Message-ID: <20121211164608.GT14363@n2100.arm.linux.org.uk>
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

That's an unfortunate side-effect of the single-zImage effort.

>, except maybe on some platforms having their
> own mach/io.h file, but those are quite limited in number (ebsa110, rpc,
> at91, s3c24xx, pxa, omap1, footbridge and ixp4xx). So if __io is
> defined, says on VEXPRESS, why does it "select NO_IOPORT" ? Essentially
> all ARM platforms should select HAVE_IOPORT, except the few ones that
> don't define __io. Correct?

No they damned well should not; it actively _breaks_ at least some of the
platforms you list above.

This whole area is a massive can of worms caused by people over the
years just not understanding what an x86 IO port is and how to deal
with it.  It's very simple.  The IO port space is for ISA/PCMCIA and
PCI IO port regions.  It is nothing more than that.

It's there because when you have a PCI peripheral in your system, you
need to set it up, and the address space used for IO ports is entirely
separate from that used for the rest of the memory mapped IO.  You
can't mix the IO ports amongst the MMIO ports - because most host PCI
bridges will only let you map into MMIO space one region of PCI IO
space.

The ISA case is a little harder to see, but believe me when I say that
in the early days of Linux, we used talk to all ISA chips on platforms
without ISA buses using the inb/outb/etc macros and it turned into one
hell of a disgusting mess.  Now these platforms all use the regular
readb/writeb acros and ioremap() for their accesses which has resulted
in much cleaner solutions - the result of that is these platforms no
longer need the "ISA IO space" region, so providing ISA IO space support
is additional unnecessary work for them.

Plus, if you _have_ IO space support, you must have some MMIO region for
them to target - doing what many platforms have done to date and targetted
ISA IO address 0 at virtual address 0 is just not on because as soon as
you build a device driver which probes ISA addresses into your kernel,
you will oops.  Moreover, userspace can open /dev/ioport and ask the
kernel to access IO port addresses that way too.  Having IO space support
enabled when the platform does not support it is a liability and an
additional unnecessary security problem.
