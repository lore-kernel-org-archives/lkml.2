Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1FDMD2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 08:03:28 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:15836
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755395Ab1FDMDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 08:03:24 -0400
X-SpamScore: -19
X-BigFish: VS-19(zz1447R1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sat, 4 Jun 2011 20:08:23 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Shawn Guo <shawn.guo@linaro.org>, <linux-mmc@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cbouatmailru@gmail.com>, <w.sang@pengutronix.de>, <cjb@laptop.org>,
        <arnd@arndb.de>, <sfr@canb.auug.org.au>, <patches@linaro.org>
Subject: Re: [PATCH] mmc: sdhci: change sdhci-pltfm into a module
Message-ID: <20110604120821.GA19972@S2100-06.ap.freescale.net>
References: <20110601130431.59f4f0d4.sfr@canb.auug.org.au>
 <1306983470-18588-1-git-send-email-shawn.guo@linaro.org>
 <20110603200316.GB17972@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110603200316.GB17972@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Fri, Jun 03, 2011 at 02:03:16PM -0600, Grant Likely wrote:
> On Thu, Jun 02, 2011 at 10:57:50AM +0800, Shawn Guo wrote:
> > From: Shawn Guo <shawn.guo@freescale.com>
> > 
> > There are a couple of problems left from the sdhci pltfm and OF
> > consolidation changes.
> > 
> > * When building more than one sdhci-pltfm based drivers in the same
> >   image, linker will give multiple definition error on the sdhci-pltfm
> >   helper functions.  For example right now, building sdhci-of-esdhc
> >   and sdhci-of-hlwd together is a valid combination from Kconfig view.
> > 
> > * With the current build method, there is error with building the
> >   drivers as module, but module installation fails with modprobe.
> > 
> > The patch fixes above problems by changing sdhci-pltfm into a module.
> > To avoid EXPORT_SYMBOL on so many big endian IO accessors, it moves
> > these accessors into sdhci-pltfm.h as the 'static inline' functions.
> > As a result, sdhci.h needs to be included in sdhci-pltfm.h, and in
> > turn can be removed from individual drivers which already include
> > sdhci-pltfm.h.
> 
> Mostly looks good.  One comment below about a static inline, but
> otherwise you can add my:
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> 
> > +static inline void sdhci_be32bs_writew(struct sdhci_host *host,
> > +				       u16 val, int reg)
> > +{
> > +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> > +	int base = reg & ~0x3;
> > +	int shift = (reg & 0x2) * 8;
> > +
> > +	switch (reg) {
> > +	case SDHCI_TRANSFER_MODE:
> > +		/*
> > +		 * Postpone this write, we must do it together with a
> > +		 * command write that is down below.
> > +		 */
> > +		pltfm_host->xfer_mode_shadow = val;
> > +		return;
> > +	case SDHCI_COMMAND:
> > +		sdhci_be32bs_writel(host,
> > +				    val << 16 | pltfm_host->xfer_mode_shadow,
> > +				    SDHCI_TRANSFER_MODE);
> > +		return;
> > +	}
> > +	clrsetbits_be32(host->ioaddr + base, 0xffff << shift, val << shift);
> > +}
> 
> This is really too big to be a static inline.  Go ahead and make it an
> exported symbol.  Personally, I wouldn't worry about it and just exporting all
> of these accessors.  Making them inline doesn't buy much anyway since
> they are used to initialize an ops table, and making them inline
> forces each driver to instantiate its own copy.
> 
Thanks for the comment.  Since Chris had picked the patch up, I would
not send another update for this, unless Chris asks me to do.  I
actually like to see all these accessors implemented in the same way
and in the same place.

-- 
Regards,
Shawn

