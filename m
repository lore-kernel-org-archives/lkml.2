Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1IQPDK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 11:03:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59824 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1IQPDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 11:03:08 -0400
Date: Sat, 17 Sep 2011 16:02:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Barry Song <Baohua.Song@csr.com>
Cc: vinod.koul@intel.com, Arnd Bergmann <arnd@arndb.de>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] dmaengine: add CSR SiRFprimaII DMAC driver
Message-ID: <20110917150246.GH16381@n2100.arm.linux.org.uk>
References: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316166960-20964-1-git-send-email-Baohua.Song@csr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 02:56:00AM -0700, Barry Song wrote:
> +static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
> +	struct dma_slave_config *config)
> +{
> +	u32 addr, direction;
> +	unsigned long flags;
> +
> +	switch (config->direction) {

config->direction is deprecated, please don't use it.

> +	case DMA_FROM_DEVICE:
> +		direction = 0;
> +		addr = config->dst_addr;
> +		break;
> +
> +	case DMA_TO_DEVICE:
> +		direction = 1;
> +		addr = config->src_addr;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if ((config->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
> +		(config->dst_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES))
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&schan->lock, flags);
> +	schan->addr = addr;
> +	schan->direction = direction;
> +	schan->mode = (config->src_maxburst == 4 ? 1 : 0);

Please store the source address, destination address, and mode separately
for each direction.  You should then select from that at prepare time.
