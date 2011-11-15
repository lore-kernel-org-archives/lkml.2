Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab1KOSAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:00:09 -0500
Received: from mail160.messagelabs.com ([216.82.253.99]:29356 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab1KOSAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:00:07 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1321379987!38876912!13
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Rafal Prylowski <prylowski@metasoft.pl>,
        Mika Westerberg <mika.westerberg@iki.fi>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rmallon@gmail.com" <rmallon@gmail.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "lrg@ti.com" <lrg@ti.com>
Date: Tue, 15 Nov 2011 11:59:50 -0600
Subject: RE: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
Thread-Topic: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
Thread-Index: Acyjp6PTiuJM+kAtS7mAQgbs+WpL/QAFuKYg
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3E93FDC22@AUSP01VMBX24.collaborationhost.net>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
 <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi>
 <4EC27EED.4030108@metasoft.pl>
In-Reply-To: <4EC27EED.4030108@metasoft.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAFI0PLS025033

On Tuesday, November 15, 2011 8:02 AM, Rafal Prylowski wrote:
>
> Hello.
>
> During adaptation of my experimental ep93xx ide driver to the new dmaengine api,
> I discovered two issues with ep93xx dma implementation:

Nice to see someone is trying to get IDE support for the ep93xx into mainline!
Unfortunately none of my ep93xx hardware supports IDE... :-(

> 1) Control register is incorrectly programmed for IDE (m2m_hw_setup),
> probably copy-paste bug ;)
> 2) Kernel oops when trying to stop running transfers by calling
> dmaengine_terminate_all(...) - caused by dereferencing empty list
> in ep93xx_dma_get_active
>
> Following is a patch, which solves these problems for me.
>
> Regards,
> Rafal Prylowski
>
> Index: linux-2.6/drivers/dma/ep93xx_dma.c
> ===================================================================
> --- linux-2.6.orig/drivers/dma/ep93xx_dma.c
> +++ linux-2.6/drivers/dma/ep93xx_dma.c
> @@ -246,6 +246,7 @@ static void ep93xx_dma_set_active(struct
>  static struct ep93xx_dma_desc *
>  ep93xx_dma_get_active(struct ep93xx_dma_chan *edmac)
>  {
> +	BUG_ON(list_empty(&edmac->active));

BUG_ON is evil...

I'm not sure this is the right way to handle this.

If your doing dma the list should never be empty.  If it is I think it should
have been caught way before this.  Mika, do you have any comments?

> 	return list_first_entry(&edmac->active, struct ep93xx_dma_desc, node);
> }
> 
> @@ -459,9 +460,6 @@ static int m2m_hw_setup(struct ep93xx_dm
>  		 * This IDE part is totally untested. Values below are taken
>  		 * from the EP93xx Users's Guide and might not be correct.
>  		 */
> -		control |= M2M_CONTROL_NO_HDSK;
> -		control |= M2M_CONTROL_RSS_IDE;
> -		control |= M2M_CONTROL_PW_16;
>  
>  		if (data->direction == DMA_TO_DEVICE) {
>  			/* Worst case from the UG */
> @@ -473,6 +471,9 @@ static int m2m_hw_setup(struct ep93xx_dm
>  			control |= M2M_CONTROL_SAH;
>  			control |= M2M_CONTROL_TM_RX;
>  		}
> +		control |= M2M_CONTROL_NO_HDSK;
> +		control |= M2M_CONTROL_RSS_IDE;
> +		control |= M2M_CONTROL_PW_16;
>  		break;

This looks right.  The common OR'ed in bits should be added after setting the
direction bits.

>  	default:
> @@ -668,24 +669,28 @@ static void ep93xx_dma_unmap_buffers(str
>  static void ep93xx_dma_tasklet(unsigned long data)
>  {
>  	struct ep93xx_dma_chan *edmac = (struct ep93xx_dma_chan *)data;
> -	struct ep93xx_dma_desc *desc, *d;
> -	dma_async_tx_callback callback;
> -	void *callback_param;
> +	struct ep93xx_dma_desc *desc = NULL, *d;
> +	dma_async_tx_callback callback = NULL;
> +	void *callback_param = NULL;
>  	LIST_HEAD(list);
>  
>  	spin_lock_irq(&edmac->lock);
> -	desc = ep93xx_dma_get_active(edmac);
> -	if (desc->complete) {
> -		edmac->last_completed = desc->txd.cookie;
> -		list_splice_init(&edmac->active, &list);
> +	if (!list_empty(&edmac->active)) {
> +		desc = ep93xx_dma_get_active(edmac);
> +		if (desc->complete) {
> +			edmac->last_completed = desc->txd.cookie;
> +			list_splice_init(&edmac->active, &list);
> +		}

It looks like this might actually catch your BUG_ON issue above.

>  	}
>  	spin_unlock_irq(&edmac->lock);
>  
>  	/* Pick up the next descriptor from the queue */
>  	ep93xx_dma_advance_work(edmac);
>  
> -	callback = desc->txd.callback;
> -	callback_param = desc->txd.callback_param;
> +	if (desc) {
> +		callback = desc->txd.callback;
> +		callback_param = desc->txd.callback_param;
> +	}

These could be moved up to where 'desc' is getting set.  You have already
verified that the list is not empty and have a valid 'desc' pointer.  Set
the callback pointers there to remove this extra if (desc) test.

> 
>  	/* Now we can release all the chained descriptors */
>  	list_for_each_entry_safe(desc, d, &list, node) {

Thanks,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
