Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2CUTda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:33:30 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38532 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499Ab2CUTd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:33:29 -0400
Date: Wed, 21 Mar 2012 21:32:31 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Rafal Prylowski <prylowski@metasoft.pl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>
Subject: Re: [PATCH] ep93xx: Implement double buffering for M2M DMA channels
Message-ID: <20120321193231.GA3740@mwesterb-mobl.ger.corp.intel.com>
References: <4F683B36.8090101@metasoft.pl>
 <ADE657CA350FB648AAC2C43247A983F0020696D488E3@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020696D488E3@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 12:12:11PM -0500, H Hartley Sweeten wrote:
> On Tuesday, March 20, 2012 1:09 AM, Rafal Prylowski wrote:
> >
> > Implement double buffering for M2M DMA channels.
> >
> > Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
> 
> Hmm... This isn't working on my ep9307 board...
> 
> When the system boots I get stormed with messages:
> 
> dma dma1chan0: unknown interrupt!
> dma dma1chan0: unknown interrupt!
> dma dma1chan0: unknown interrupt!
> dma dma1chan1: unknown interrupt!
> dma dma1chan1: unknown interrupt!
> dma dma1chan1: unknown interrupt!
> dma dma1chan0: unknown interrupt!
> dma dma1chan0: unknown interrupt!
> dma dma1chan1: unknown interrupt!
> 
> Note, I have use_dma set for the ep93xx_spi driver and am using mmc_spi.
> 
> Also note, without your patch I also get a couple messages:
> 
> dma dma1chan1: got interrupt while active list is empty
> 
> But, the mmc card is working fine. I haven't tracked down why I get these
> yet. Mika, any ideas?

I've noticed the same. But they also happen without this patch applied. I've
tracked it down to MULTI_IRQ_HANDLER support patches for ARM vic but not sure
what might be wrong there (or is the ep93xx_dma driver behaving badly). I
noticed that when we get that 'got interrupt while active list is empty' we
don't have any interrupts set in the M2M_INTERRUPT register but we still got
an interrupt.. weird.

Below is a workaround I've been using lately but it certainly is a hack and we
should figure out what is the root cause for this.

diff --git a/arch/arm/common/vic.c b/arch/arm/common/vic.c
index dcb004a..cb6b49a 100644
--- a/arch/arm/common/vic.c
+++ b/arch/arm/common/vic.c
@@ -441,11 +441,9 @@ static int handle_one_vic(struct vic_device *vic, struct pt_regs *regs)
 	u32 stat, irq;
 	int handled = 0;
 
-	stat = readl_relaxed(vic->base + VIC_IRQ_STATUS);
-	while (stat) {
+	while ((stat = readl_relaxed(vic->base + VIC_IRQ_STATUS))) {
 		irq = ffs(stat) - 1;
 		handle_IRQ(irq_domain_to_irq(&vic->domain, irq), regs);
-		stat &= ~(1 << irq);
 		handled = 1;
 	}
 
