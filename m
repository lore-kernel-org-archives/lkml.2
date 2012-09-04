Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2IDJox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:44:53 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:20303 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810Ab2IDJow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:44:52 -0400
X-IronPort-AV: E=Sophos;i="4.80,366,1344204000"; 
   d="scan'208";a="171789659"
Date: Tue, 4 Sep 2012 11:44:34 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Lars-Peter Clausen <lars@metafoo.de>
cc: dedekind1@gmail.com, Julia Lawall <Julia.Lawall@lip6.fr>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/mtd/nand/mpc5121_nfc.c: some devm_
 cleanups
In-Reply-To: <5045C19A.7000705@metafoo.de>
Message-ID: <alpine.DEB.2.02.1209041142130.2759@hadrien>
References: <1346517191-8794-1-git-send-email-Julia.Lawall@lip6.fr>  <1346517191-8794-4-git-send-email-Julia.Lawall@lip6.fr> <1346748171.12610.22.camel@sauron.fi.intel.com> <5045C19A.7000705@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012, Lars-Peter Clausen wrote:

> On 09/04/2012 10:42 AM, Artem Bityutskiy wrote:
> > Aiaiai! :-) [1] [2]
> >
> > I've build-tested this using aiaiai and it reports that this change breaks the build:
> >
> > dedekind@blue:~/git/maintaining$ ./verify ../l2-mtd/ mpc5121_nfc < ~/tmp/julia2.mbox
> > Tested the patch(es) on top of the following commits:
> > ba64756 Quick fixes - applied by aiaiai
> > 651c6fa JFFS2: don't fail on bitflips in OOB
> > e22ac84 mtd: autcpu12-nvram: drop frees of devm_ alloc'd data
> > ea9d312 mtd: cmdlinepart: minor cleanups
> >
> > --------------------------------------------------------------------------------
> > Failed to build the following commit for configuration "powerpc-mpc512x_defconfig" (architecture powerpc)":
> >
> > 0fe13ab drivers/mtd/nand/mpc5121_nfc.c: some devm_ cleanups
> >
> > ...
> > drivers/mtd/nand/mpc5121_nfc.c: In function 'mpc5121_nfc_probe':
> > drivers/mtd/nand/mpc5121_nfc.c:622:28: warning: variable 'regs_size' set but not used [-Wunused-but-set-variable]
> > drivers/mtd/nand/mpc5121_nfc.c:622:16: warning: variable 'regs_paddr' set but not used [-Wunused-but-set-variable]
> > drivers/built-in.o: In function `mpc5121_nfc_probe':
> > mpc5121_nfc.c:(.devinit.text+0x2a14): undefined reference to `devm_clk_get'
> > make[1]: *** [vmlinux] Error 1
> >
> > --------------------------------------------------------------------------------
> >
> > I do not really know why, but it seems that clock framework is not supported for powerpc. CCing the PPC mailing list. Preserved the context below for the PPC people.
> >
>
> I've been bitten by the same issue recently, also cause by one of these
> cocci devm patches. devm_clk_get is only available if the generic
> clk_get/clk_put implementation is used. Not all architectures do this and
> some implement their own clk_get/clk_put, etc functions. Since devm_clk_get
> is merely a wrapper around clk_get/clk_put there is no reason why it should
> depend CLKDEV_LOOKUP. I've prepared a patch which makes them generically
> available if the clk_get/clk_put are implemented (i.e. if HAVE_CLK is set),
> but it is on a different machine right now, will try to submit it later today.

Sorry about this.  I wasn't aware that devm_clk_get wasn't supported by
all architectures, and I have no way of compiling code for these
architectures...  But I wonder why it is not, since devm-ness doesn't seem
to have anything to do with architecture-specific details?  It would be
really nice to have it for all architectures, because the clock functions
are just as (or at least almost as) common as kzalloc, ioremap, etc.

thanks,
julia
