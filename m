Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab2BCRC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:02:57 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41494 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757084Ab2BCRC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:02:56 -0500
Date: Fri, 3 Feb 2012 17:01:53 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Per FORLIN <per.forlin@stericsson.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Viresh KUMAR <viresh.kumar@st.com>
Subject: Re: [PATCH 05/11] mmc/host: add context parameter for DMA_SLAVE
	and DMA_CYCLIC
Message-ID: <20120203170153.GA15891@flint.arm.linux.org.uk>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-6-git-send-email-alexandre.bounine@idt.com> <4F2BA6C0.10100@stericsson.com> <0CE8B6BE3C4AD74AB97D9D29BD24E5520287270D@CORPEXCH1.na.ads.idt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E5520287270D@CORPEXCH1.na.ads.idt.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 08:52:07AM -0800, Bounine, Alexandre wrote:
> If these API changes will be approved I will resubmit these changes as
> one patch.

I'd like to suggest an alternative approach, if you still want to add a
void * parameter to this.

1. A patch which adds this, and convert users over to it:

static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
	struct dma_chan *chan, struct scatterlist *sg, unsigned sg_len,
	enum dma_transfer_direction direction, unsigned long flags)
{
	return chan->device->device_prep_slave_sg(chan, sg, sglen, dir, flags);
}

2. Change device->device_prep_slave_sg() to have a new prototype, and
   update the above inline function to cope with the change.  This API
   change is then restricted to just the DMA engine code.

3. Introduce a new inline function to deal with rapidio slave sg
   submission.

This means all drivers which aren't capable of using the special rapidio
features get to ignore the new details about rapidio entirely.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
