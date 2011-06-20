Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab1FTU1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:27:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62531 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab1FTU1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:27:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Mon, 20 Jun 2011 22:26:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>, gregkh@suse.de,
        lkml <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>,
        Alexander Holler <holler@ahsoftware.de>
References: <alpine.LFD.2.00.1106201306210.2142@xanadu.home> <Pine.LNX.4.44L0.1106201329390.2113-100000@iolanthe.rowland.org> <20110620184849.GI26089@n2100.arm.linux.org.uk>
In-Reply-To: <20110620184849.GI26089@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106202226.37381.arnd@arndb.de>
X-Provags-ID: V02:K0:b9dWa1Sn0Waw4GMJkUGysRIrjp93bPRzXhY/m298Jab
 3YzG3yqHsMo/DieZ99uo/hMFCNWDweyagyL+Lg7y69OyRosW52
 B4Y+3zi7d8mW2yHkM0iOulk4FblbnUHiMCykKo+TH+0zKpQhyl
 /uKKJjDM+5iVL1tG9XIhqmFFnSCcQ7s5LAZRdQbNGYO9RAgdAq
 gIowg86uKDfyU+1CTNLcw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 June 2011 20:48:49 Russell King - ARM Linux wrote:
> On Mon, Jun 20, 2011 at 01:35:35PM -0400, Alan Stern wrote:
> > According to Arnd, any remaining possible issues will be addressed by
> > changing the implementation of readl/writel on ARM.  It doesn't look as
> > though the ehci files need anything else done.
> 
> I'm not about to change their implementation because they've proven
> themselves over the last 10 years to be perfectly fine, and changing
> them has a habbit of causing GCC to play less optimally than it should
> do.

Well, we do know that gcc now makes different tradeoffs, and that it's
entirely within the C99 specification when it's generating byte accesses
from __raw_readl(). The case where the pointer is __packed is just the
obvious case where it would do that, and I fully agree that the __packed
in that case is a bug, but I'm much in favor of writing code so that
we instruct the compiler to create correct code rather than giving it
the choice between correct and incorrect.

> I've seen drivers where GCC reloads the base address from the driver
> private data structure each time a register access is performed, rather
> than caching the base address in a register.  I've seen it issuing
> separate add instructions and using a zero pre-index load/store.  The
> existing way is the only way I've found to get GCC to come anywhere
> close to producing "optimal" code for the IO accessors.

Two points here:

* What's the olders compiler that we really need to be able to build
  efficient kernels? Would you consider it if we can show that gcc-4.2
  and higher produce code that is as good as the existing macros?
  How about making the code gcc version dependent?

* We already need a compiler barrier in the non-_relaxed() versions of
  the I/O accessors, which will force a reload of the base address
  in a lot of cases, so the code is already suboptimal. Yes, we don't
  have the barrier today without CONFIG_ARM_DMA_MEM_BUFFERABLE, but that
  is a bug, because it lets the compiler move accesses to DMA buffers
  around readl/writel.

> If it is the case that these structures do not require packing to get
> their desired layout, then they don't require packing, and the packed
> attribute should be dropped.

Yes. But are you going to audit every other use of __packed in the kernel
to check if it is used on __iomem pointers?

	Arnd
