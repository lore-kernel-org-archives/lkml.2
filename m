Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1ISJpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:45:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:33753 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab1ISJpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:45:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="50026822"
Subject: RE: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <Barry.Song@csr.com>
Cc: "21cnbao@gmail.com" <21cnbao@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <Workgroup.Linux@csr.com>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <5EB3BFCD089AD643B9BB63439F5FD5E9840F3A8D@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
	 <1316422774.26662.30.camel@vkoul-udesk3>
	 <5EB3BFCD089AD643B9BB63439F5FD5E9840F3A8D@SHAASIEXM01.ASIA.ROOT.PRI>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 15:11:17 +0530
Message-ID: <1316425277.26662.41.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 09:23 +0000, Barry Song wrote:
> Hi Vinod,
> Thanks!
> 
> > -----Original Message-----
> > From: Vinod Koul [mailto:vinod.koul@intel.com]
> > Sent: 2011年9月19日 17:00
> > To: Barry Song
> > Cc: Arnd Bergmann; Jassi Brar; Linus Walleij; linux-kernel@vger.kernel.org;
> > DL-SHA-WorkGroupLinux; Rongjun Ying; linux-arm-kernel@lists.infradead.org
> > Subject: Re: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
> > 
> > On Fri, 2011-09-16 at 02:56 -0700, Barry Song wrote:
> > > From: Rongjun Ying <rongjun.ying@csr.com>
> > >
> > > Cc: Jassi Brar <jaswinder.singh@linaro.org>
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Linus Walleij <linus.walleij@linaro.org>
> > > Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> > > Signed-off-by: Barry Song <Baohua.Song@csr.com>
> > > ---
> > >  -v2:
> > >  use generic xfer API from jassi;
> > >  delete sirf self-defined slave config;
> > >  fix feedback from vinod;
> > >  fix filter function: we have two dmac, clients drivers think the chan id as
> > 0~31;
> > >  rename regs to base;
> > >  delete redundant chan_id initialization in probe since dmaengine core will
> > >  re-write it, refer to my patch too:
> > >  [PATCH] dmaengine: delete redundant chan_id and chancnt initialization in
> > dma drivers
> > >  http://www.spinics.net/lists/kernel/msg1237455.html
> > >
> > >  this patch doesn't provide a common way for filter and doesn't use the
> > jassi's v2 patch.
> > > +
> > > +static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
> > > +	struct dma_slave_config *config)
> > > +{
> > > +	u32 addr, direction;
> > > +	unsigned long flags;
> > > +
> > > +	switch (config->direction) {
> > > +	case DMA_FROM_DEVICE:
> > > +		direction = 0;
> > > +		addr = config->dst_addr;
> > > +		break;
> > > +
> > > +	case DMA_TO_DEVICE:
> > > +		direction = 1;
> > > +		addr = config->src_addr;
> > > +		break;
> > > +
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	if ((config->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
> > > +		(config->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES))
> > > +		return -EINVAL;
> > > +
> > > +	spin_lock_irqsave(&schan->lock, flags);
> > > +	schan->addr = addr;
> > > +	schan->direction = direction;
> > > +	schan->mode = (config->src_maxburst == 4 ? 1 : 0);
> > > +	spin_unlock_irqrestore(&schan->lock, flags);
> > Not sure why you support this, there seem to be no DMA_SLAVE support in
> > this version ate least
> 
> Not. I support dma_slave. But I have no prep_slave_sg function since I can use the gen xfer to replace it.
Yes thats okay...

Then I have questions on genxfer function...
where are you copying either src or dstn_start address, you seem to
completely ignore them?

Do you support only slave transfers or M2M as well for this driver?
If only slave you might want to check if dma_config_slave is set for
this channel or not.

-- 
~Vinod

