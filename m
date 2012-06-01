Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033Ab2FAPGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:06:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49120 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab2FAPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:06:46 -0400
Date: Fri, 1 Jun 2012 16:06:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linaro-mm-sig@lists.linaro.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] CMA and ARM DMA-mapping updates for v3.5
Message-ID: <20120601150621.GA9525@n2100.arm.linux.org.uk>
References: <1337672417-10065-1-git-send-email-m.szyprowski@samsung.com> <20120529122932.GA24623@n2100.arm.linux.org.uk> <015e01cd3daa$6d910e50$48b32af0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <015e01cd3daa$6d910e50$48b32af0$%szyprowski@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 04:50:45PM +0200, Marek Szyprowski wrote:
> Hello,
> 
> On Tuesday, May 29, 2012 2:30 PM Russell King - ARM Linux wrote:
> 
> > I notice we have new warnings as a result of CMA being merged, though
> > thankfully they're just in Kconfig:
> > 
> > warning: (ARM) selects CMA which has unmet direct dependencies (HAVE_DMA_CONTIGUOUS &&
> > HAVE_MEMBLOCK && EXPERIMENTAL)
> > 
> > This seems totally weird: you're mandating that ARM must have CMA
> > selected, but it's an experimental feature?  So you're implying that
> > the entire ARM kernel becomes totally experimental for the next
> > release cycle?
> > 
> > I think this needs fixing.
> 
> No, that wasn't my intention. I will provide a patch which removes unconditional dependency
> on CMA - it will let one to disable CMA and use old allocation method if needed, but this 
> requires a few more changes in the dma-mapping implementation. I wasn't aware of the 
> consequences and no one has complained about this since v15 of CMA patches (Aug 2011).

I've just been looking at the automatic build and boot logs, and CMA looks
like it has the potential to cause regressions:

Linux version 3.4.0+ (rmk@rmk-PC.arm.linux.org.uk) (gcc version 4.3.5 (GCC) ) #1 PREEMPT Fri Jun 1 02:01:58 BST 2012
CPU: ARMv7 Processor [411fc082] revision 2 (ARMv7), cr=10c53c7d
CPU: PIPT / VIPT nonaliasing data cache, VIPT nonaliasing instruction cache
Machine: OMAP LDP board
vmalloc area is too big, limiting to 976MB
Reserving 2097152 bytes SDRAM for VRAM
cma: CMA: failed to reserve 16 MiB
...
Kernel command line: console=ttyO2,115200n8 noinitrd vmalloc=1G mem=128M root=/dev/mmcblk0p2 rw ip=none rootdelay=2 video=omap24xxfb:rotation=270
...
NET: Registered protocol family 16
initlevel:2=postcore, 16 registered initcalls
DMA: failed to allocate 256 KiB pool for atomic coherent allocation

I don't see any other failures, but that doesn't look good...

Note that that command line has worked perfectly well up until now.
