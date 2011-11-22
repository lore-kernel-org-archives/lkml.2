Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab1KVU1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:27:18 -0500
Received: from mail131.messagelabs.com ([216.82.242.99]:44479 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab1KVU1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:27:03 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1321993616!3380900!5
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "rmallon@gmail.com" <rmallon@gmail.com>,
        Rafal Prylowski <prylowski@metasoft.pl>
Date: Tue, 22 Nov 2011 14:26:52 -0600
Subject: RE: [PATCH 2/2] dma/ep93xx_dma: prevent ep93xx_dma_tasklet() to
 access empty list
Thread-Topic: [PATCH 2/2] dma/ep93xx_dma: prevent ep93xx_dma_tasklet() to
 access empty list
Thread-Index: AcypT1/bJilkEYclRHm3Hk9cp/eRRAABFxng
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3E96DA6B7@AUSP01VMBX24.collaborationhost.net>
References: <19bcd0ee953116fd71bc1c705636c5fec80608cb.1321990466.git.mika.westerberg@iki.fi>
 <707c0a5c61bd597ceed3871fc3528f687ac0fcff.1321990466.git.mika.westerberg@iki.fi>
In-Reply-To: <707c0a5c61bd597ceed3871fc3528f687ac0fcff.1321990466.git.mika.westerberg@iki.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 22, 2011 12:46 PM, Mika Westerberg wrote:
> From: Rafal Prylowski <prylowski@metasoft.pl>
>
> If dma_terminate_all() is called before the ep93xx_dma_tasklet() gets to run,
> it tries to access an empty ->active list causing following OOPS:

[snip]

> As we expect that the ->active list is never empty when the ep93xx_dma_tasklet()
> is called, we fix this by adding a new flag per channel EP93XX_DMA_IS_RUNNING
> which determines whether the channel is running or not.
> 
> We also add BUG_ON() to ep93xx_dma_get_active() to make sure that similar
> problems will be caught early.
> 
> Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
> [added a flag instead of just checking for empty list]
> Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
> ---
>  drivers/dma/ep93xx_dma.c |   25 ++++++++++++++++---------
>  1 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
> index 6181811..cc3a302 100644
> --- a/drivers/dma/ep93xx_dma.c
> +++ b/drivers/dma/ep93xx_dma.c
> @@ -155,6 +155,8 @@ struct ep93xx_dma_chan {
>  	unsigned long			flags;
>  /* Channel is configured for cyclic transfers */
>  #define EP93XX_DMA_IS_CYCLIC		0
> +/* Channel is enabled */
> +#define EP93XX_DMA_IS_RUNNING		1
>  
>  	int				buffer;
>  	dma_cookie_t			last_completed;
> @@ -246,6 +248,7 @@ static void ep93xx_dma_set_active(struct ep93xx_dma_chan *edmac,
>  static struct ep93xx_dma_desc *
>  ep93xx_dma_get_active(struct ep93xx_dma_chan *edmac)
>  {
> +	BUG_ON(list_empty(&edmac->active));
>  	return list_first_entry(&edmac->active, struct ep93xx_dma_desc, node);

Mika,

Thanks for looking into this.

I still don't like the BUG_ON here.  Is it even possible to get here with
an empty list now that your catching it in the tasklet?

But, ep93xx_dma_set_active() also has a BUG_ON test so...

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>
