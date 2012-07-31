Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2GaWDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 18:03:12 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52635 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab2GaWDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 18:03:09 -0400
Date: Tue, 31 Jul 2012 23:01:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, linus.walleij@stericsson.com,
        broonie@opensource.wolfsonmicro.com, olalilja@yahoo.se,
        STEricsson_nomadik_linux@list.st.com, lrg@ti.com
Subject: Re: [PATCH 5/6] ARM: ux500: Enable HIGHMEM on all mop500 platforms
Message-ID: <20120731220145.GD10335@n2100.arm.linux.org.uk>
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <5017EBDC.6010005@linaro.org> <20120731143732.GS6802@n2100.arm.linux.org.uk> <201207312050.03113.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207312050.03113.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 08:50:02PM +0000, Arnd Bergmann wrote:
> On Tuesday 31 July 2012, Russell King - ARM Linux wrote:
> > I still fail to see how not having highmem enabled would ever cause memory
> > corruption errors (unless something dealing with memory in a very very
> > wrong way - iow, not using one of the reservation or memory allocation
> > methods provided by the kernel.)
> 
> The problem is that all users of ux500 systems pass a command line like
> 
> vmalloc=256M mem=128M@0 mali.mali_mem=32M@128M hwmem=168M@160M mem=48M@328M mem_issw=1M@383M mem=640M@384M
> 
> This is of course totally bogus and should not be done. If I understand
> Lee correctly, one of the issues resulting from passing a command
> line like this without enabling highmem is memory corruption.

But the question is _why_ does that corruption happen.

>From the above, we will end up with the kernel getting:

0x00000000 - 0x07ffffff (128M @ 0)
0x14800000 - 0x177fffff (48M  @ 328M)
0x18000000 - 0x3fffffff (640M @ 384M)

with:

0x08000000 - 0x081fffff used for mali
0x0a000000 - 0x147fffff used for hwmem
0x17f00000 - 0x17ffffff used for mem_issw

Now, with highmem disabled, the kernel should still map exactly the
regions: 0x00000000 - 0x07ffffff, 0x14800000 - 0x177fffff, into the
direct mapped region, and truncate the 0x18000000 - 0x3fffffff
region appropriately, reducing the amount of memory available such
that it won't overlap the vmalloc area (which you've specified to be
a minimum of 256M.)

This should _NOT_ cause any memory corruption.

So, come on guys.  Debugging is *mandatory* for this kind of problem.
Papering over it is obscene.
