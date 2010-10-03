Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab0JCL3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 07:29:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50356 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0JCL3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 07:29:13 -0400
Date: Sun, 3 Oct 2010 12:28:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: x0095840@ti.com, linux-arm-kernel@lists.infradead.org,
        Hiroshi.DOYU@nokia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist: define SG chain for arm architecture
Message-ID: <20101003112839.GA32736@n2100.arm.linux.org.uk>
References: <1285950521-8093-1-git-send-email-x0095840@ti.com> <20101001163958.GA22533@n2100.arm.linux.org.uk> <20101003195758B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101003195758B.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 03, 2010 at 08:02:52PM +0900, FUJITA Tomonori wrote:
> On Fri, 1 Oct 2010 17:39:58 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > On Fri, Oct 01, 2010 at 11:28:41AM -0500, Fernando Guzman Lugo wrote:
> > > Define SG chain for ARM architecture in order to work
> > > with big buffers. This patch is needed in order to
> > > iovmm users can pass a big buffer to map it and ARM
> > > architecture has not issues using SG chain.
> > > 
> > > This change was suggested by FUJITA Tomonori.
> > 
> > Have you audited all places where SG lists are used in the ARM
> > architecture to ensure that SG chain support is safe?  (That
> > goes for ARM generic code and ARM specific drivers.)
> 
> As far as I know, only SCSI actually uses SG chain feature (that is,
> sending chained scatter lists). All SCSI drivers were converted when
> we added SG chain feature. So what you need to care about is the dma
> code.
> 
> There are only several files that actually use scatter list under
> arch/arm.
> 
> >From a quick look, arch/arm/mm/dma-mapping.c,
> arch/arm/common/dmabounce.c, arch/arm/kernel/dma.c, and
> arch/arm/include/asm/dma-mapping.h looks fine.
> 
> arm/mach-imx/dma-v1.c also looks like to use chained sg API properly
> (but this isn't used with SCSI, right?).
> 
> Seems that arch/arm/plat-omap/iovmm.c can handle the chained SG
> too. It doesn't allocate the chained SG now though.

There's also RiscPC and its SCSI drivers could well be an issue for SG
chaining.  They have to manually save the SCSI 'data pointer' (down to
the byte position in the SG chain and be able to restore a previously
saved point.)  This code was written before SG chaining ever appeared,
and although it has been partly fixed up, it's probably buggy if SG
chaining were to be enabled.

If it's just OMAP users who wish to enable SG chaining, then the sane
thing to do would be to make the definition of the macro conditional
on OMAP.
