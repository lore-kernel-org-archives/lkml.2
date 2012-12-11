Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2LKQad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:30:33 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:60055 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab2LKQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:30:29 -0500
Date: Tue, 11 Dec 2012 17:30:13 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eran Ben-Avi" <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions in
 CONFIG_HAS_IOPORT
Message-ID: <20121211173013.0ceea196@skate>
In-Reply-To: <201212111615.03262.arnd@arndb.de>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com>
	<201212111043.50627.arnd@arndb.de>
	<20121211170338.4859ddf0@skate>
	<201212111615.03262.arnd@arndb.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd Bergmann,

On Tue, 11 Dec 2012 16:15:02 +0000, Arnd Bergmann wrote:

> What you describe here are probable two bugs, and we should fix both:
> 
> * ARCH_VEXPRESS should not select NO_IOPORT. It's generally wrong
>   to select this in combination with ARCH_MULTIPLATFORM, when some
>   of the other platforms you may enable actually have IOPORT mapping
>   support.

Indeed, but I guess the "select NO_IOPORT" on vexpress is here for a
reason, no?

That said, unless I don't understand what IOPORTs are, I don't think my
platform has any of them, so why should I "select HAVE_IOPORT" ?

> * We should not unconditionally select ARCH_VEXPRESS from ARCH_MULTIPLATFORM.
>   There is no reason why we would enable that platform for building
>   a kernel that runs on only one other platform.

This one is already being worked on by Fabio Estevam, see [PATCH v2]
ARM: Kconfig: Do not force selection of ARCH_VEXPRESS by ARCH_MULTI_V7.

> > I'm not sure which devm_pci_iomap() you're referring to since my patch
> > makes only the pcim_iomap_table(), pcim_iomap(), pcim_iounmap(),
> > pcim_iomap_regions(), pcim_iomap_regions_request_all() and
> > pcim_iounmap_regions() available under CONFIG_PCI instead of CONFIG_PCI
> > && CONFIG_HAS_IOPORT.
> 
> Sorry, I meant pcim_iomap.
> 
> > So maybe you were referring to pcim_iomap(). I haven't checked in
> > details, but I guess it builds because ioport_map() is implemented in
> > arch/arm/mm/iomap.c.
> 
> Right. If an ioport_map function is provided for a given platform,
> we should also set HAVE_IOPORT and vice versa. This is probably
> fallout of the io.h conversion for multiplatform.

arch/arm/mm/iomap.c is unconditionally compiled in all ARM kernels. And
in this file, ioport_map() and ioport_unmap() are implement as soon as
__io is defined. And basically, in arch/arm/include/asm/io.h, __io is
defined for all platforms, except maybe on some platforms having their
own mach/io.h file, but those are quite limited in number (ebsa110, rpc,
at91, s3c24xx, pxa, omap1, footbridge and ixp4xx). So if __io is
defined, says on VEXPRESS, why does it "select NO_IOPORT" ? Essentially
all ARM platforms should select HAVE_IOPORT, except the few ones that
don't define __io. Correct?

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
