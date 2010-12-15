Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0LOQfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:35:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41383 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0LOQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:35:12 -0500
Date: Wed, 15 Dec 2010 16:34:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Zhang Lily-R58066 <r58066@freescale.com>, linux-fbdev@vger.kernel.org,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] ARM i.MX51: Add ipu clock support
Message-ID: <20101215163445.GE9937@n2100.arm.linux.org.uk>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <1291902441-24712-2-git-send-email-s.hauer@pengutronix.de> <201012151640.03789.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012151640.03789.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 04:40:03PM +0100, Arnd Bergmann wrote:
> On Thursday 09 December 2010, Sascha Hauer wrote:
> > +static int clk_ipu_enable(struct clk *clk)
> > +{
> > +       u32 reg;
> > +
> > +       _clk_ccgr_enable(clk);
> > +
> > +       /* Enable handshake with IPU when certain clock rates are changed */
> > +       reg = __raw_readl(MXC_CCM_CCDR);
> > +       reg &= ~MXC_CCM_CCDR_IPU_HS_MASK;
> > +       __raw_writel(reg, MXC_CCM_CCDR);
> > +
> > +       /* Enable handshake with IPU when LPM is entered */
> > +       reg = __raw_readl(MXC_CCM_CLPCR);
> > +       reg &= ~MXC_CCM_CLPCR_BYPASS_IPU_LPM_HS;
> > +       __raw_writel(reg, MXC_CCM_CLPCR);
> > +
> > +       return 0;
> > +}
> 
> Why __raw_readl?
> 
> The regular accessor function for I/O registers is readl, which handles
> the access correctly with regard to atomicity, I/O ordering and byteorder.

There's no possibility of those two being mis-ordered - they will be in
program order whatever.

What isn't guaranteed is the ordering between I/O accesses (accesses to
device memory) and SDRAM accesses (normal memory) which can pass each other
without additional barriers.  Memory accesses can pass I/O accesses.

So, (eg), if you're writing to a register which causes the hardware to
begin reading DMA descriptors from an area allocated from dma_alloc_coherent(),
you need a barrier to ensure that writes to the dma_alloc_coherent() are
visible to the hardware before you write the enable register.

If you don't need normal vs device access ordering, using readl_relaxed()/
writel_relaxed() is preferred, and avoids the (apparantly rather high)
performance overhead of having to issue barriers all the way down to the
L2 cache.

Lastly, I don't see where atomicity comes into it - __raw_writel vs writel
have the same atomicity.  Both are single access atomic provided they're
naturally aligned.  Misaligned device accesses are not predictable.
