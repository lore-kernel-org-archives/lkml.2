Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab3AJBzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:55:25 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:57431 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab3AJBzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:55:23 -0500
Date: Wed, 9 Jan 2013 20:59:56 -0500
From: Matt Porter <mporter@ti.com>
To: Vinod Koul <vkoul@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        vinod.koul@intel.com, Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [RFC PATCH 1/3] dmaengine: add dma_get_channel_caps()
Message-ID: <20130110015956.GA12220@beef>
References: <1350615088-14562-1-git-send-email-mporter@ti.com>
 <1350615088-14562-2-git-send-email-mporter@ti.com>
 <CACxGe6sUrXPc2wtLfOy8_LvRMM+e=9=sSDNLkeszfe=JX_ipbw@mail.gmail.com>
 <1351048407.5263.10.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351048407.5263.10.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 08:43:27AM +0530, Vinod Koul wrote:
> On Tue, 2012-10-23 at 23:49 +0100, Grant Likely wrote:
> > > +enum dmaengine_apis {
> > > +       DMAENGINE_MEMCPY        = 0x0001,
> > > +       DMAENGINE_XOR           = 0x0002,
> > > +       DMAENGINE_XOR_VAL       = 0x0004,
> > > +       DMAENGINE_PQ            = 0x0008,
> > > +       DMAENGINE_PQ_VAL        = 0x0010,
> > > +       DMAENGINE_MEMSET        = 0x0020,
> > > +       DMAENGINE_SLAVE         = 0x0040,
> > > +       DMAENGINE_CYCLIC        = 0x0080,
> > > +       DMAENGINE_INTERLEAVED   = 0x0100,
> > > +       DMAENGINE_SG            = 0x0200,
> > > +};
> > 
> > Actually, one more comment. Why the new enum? Why can't the
> > dma_transaction_type enum be used directly along with dma_cap_mask_t? 
> Some of the capabilities above are not there in dma_caps_t like DMA_SG.
> Also DMA_INTERRUPT and DMA_PRIVATE would not make much sense here.
> 
> BUT would help to keep things simpler if have one definition which
> includes all.

All good points. I think we can best eliminate this redundant set of 
enums by using dma_cap_mask_t and noting in a comment as follows:

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 0181887..9add5ca 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -391,14 +391,15 @@ enum dmaengine_apis {
  * a) APIs/ops supported
  * b) channel physical capabilities
  *
- * @ops: or'ed api capability
+ * @cap_mask: api/ops capability (DMA_INTERRUPT and DMA_PRIVATE
+ *	       are invalid api/ops and will never be set)
  * @seg_nr: maximum number of SG segments supported on a SG/SLAVE
  *	    channel (0 for no maximum or not a SG/SLAVE channel)
  * @seg_len: maximum length of SG segments supported on a SG/SLAVE
  *	     channel (0 for no maximum or not a SG/SLAVE channel)
  */
 struct dmaengine_chan_caps {
-	enum dmaengine_apis ops;
+	dma_cap_mask_t cap_mask;
 	int seg_nr;
 	int seg_len;
 };

If that sounds good I'll send an updated series with this change.

-Matt
