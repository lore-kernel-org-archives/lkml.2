Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab1JGGVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 02:21:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:20903 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758619Ab1JGGVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 02:21:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,500,1312182000"; 
   d="scan'208";a="59719527"
Subject: Re: [PATCH] pch_dma: Fix suspend issue
From: Vinod Koul <vinod.koul@intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
In-Reply-To: <4E8E940E.7040701@dsn.lapis-semi.com>
References: <1317713279-2774-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
	 <1317963658.1573.2229.camel@vkoul-udesk3>
	 <4E8E940E.7040701@dsn.lapis-semi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 11:44:40 +0530
Message-ID: <1317968080.1573.2266.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 14:54 +0900, Tomoya MORINAGA wrote:
> (2011/10/07 14:00), Vinod Koul wrote:
> > How would changing the max number of descriptors fix the memory
> > violation?
> >
> 
> In probe of pch_dma,  you can see the following code.
> 
> 	for (i = 0; i < nr_channels; i++) {
> 
> snip...
> 
> 		pd_chan->membase = &regs->desc[i];
> 
> snip...
> 
> 	}
> 
> Max value of nr_channels is 12 defined at pci_table.
> So, this caused memory access violation.
This is all is due to not saving nr_channels in probe and using that
instead.

Looking deeper, struct pch_dma defines array of length MAX_CHAN_NR for
channels. Then why do you allocate memory in probe as 
         pd = kzalloc(sizeof(struct pch_dma)+
                 sizeof(struct pch_dma_chan) * nr_channels, GFP_KERNEL);
what is the point in allocating additional memory for each channel?

Given this, why should there be predefined channel array in pcm_dma?

It would be great if we could fix this by dynamically allocating memory
for channels based on nr_channels and not wasting due to a static array.

-- 
~Vinod

