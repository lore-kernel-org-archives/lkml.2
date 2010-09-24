Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab0IXMjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:39:19 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60284 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab0IXMjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:39:17 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Fri, 24 Sep 2010 14:41:13 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH v4] USB device driver of Topcliff PCH
In-reply-to: <4C9C95A5.7020800@dsn.okisemi.com>
To: Maurus Cuelenaere <mcuelenaere@gmail.com>,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Toshiharu Okada <okada533@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>,
        MeeGo <meego-dev@meego.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, "Wang, Qi" <qi.wang@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>
Message-id: <op.vjjeuztd7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <4C9C95A5.7020800@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 14:12:21 +0200, Masayuki Ohtake <masa-korg@dsn.okisemi.com> wrote:
> Hi Maurus and Michal.
>
> Thank you for your comments.
>
> This patch was modified.
>   Add MODULE_AUTHOR()
>   Modify struct pch_udc_stp_dma_desc.
>   Delete union pch_udc_setup_data.
>   Modify as only one "unlock"
>   Modify while loop.
>   Modify loop count.
>   Refactored function
>    -pch_udc_free_dma_chain()
>    -pch_udc_create_dma_chain()
>  and so on

As Maurus commented before, this is not a proper commit message.  Describe
what the patch does.  All other comments should go after the "---" marker.


> diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
> +static inline void pch_udc_writel(struct pch_udc_dev *dev,
> +				    unsigned long val, unsigned long reg)
> +{
> +	iowrite32(val, dev->base_addr + reg);
> +}

Empty line please.

> +static inline void pch_udc_bit_set(struct pch_udc_dev *dev,
> +				     unsigned long reg,
> +				     unsigned long bitmask)
> +{
> +	pch_udc_writel((dev), pch_udc_readl((dev), (reg)) | (bitmask), (reg));
> +}
> +static inline void pch_udc_bit_clr(struct pch_udc_dev *dev,
> +				     unsigned long reg,
> +				     unsigned long bitmask)
> +{
> +	pch_udc_writel((dev), pch_udc_readl((dev), (reg)) & ~(bitmask), (reg));
> +}

Definitely too many parenthesis here.  It's no longer a macro so parens around
arguments are not needed and only clutter the code.

> +
> +static inline u32 pch_udc_ep_readl(struct pch_udc_ep *ep, unsigned long reg)
> +{
> +	return ioread32(ep->dev->base_addr + ep->offset_addr + reg);
> +}
> +
> +static inline void pch_udc_ep_writel(struct pch_udc_ep *ep,
> +				    unsigned long val, unsigned long reg)
> +{
> +	iowrite32(val, ep->dev->base_addr + ep->offset_addr + reg);
> +}

Again, empty line please.

> +static inline void pch_udc_ep_bit_set(struct pch_udc_ep *ep,
> +				     unsigned long reg,
> +				     unsigned long bitmask)
> +{
> +	pch_udc_ep_writel((ep), pch_udc_ep_readl((ep), (reg)) | (bitmask),
> +			  (reg));
> +}
> +static inline void pch_udc_ep_bit_clr(struct pch_udc_ep *ep,
> +				     unsigned long reg,
> +				     unsigned long bitmask)
> +{
> +	pch_udc_ep_writel((ep), pch_udc_ep_readl((ep), (reg)) & ~(bitmask),
> +			  (reg));
> +}

And again, too many parenthesis.

> +static void process_zlp(struct pch_udc_ep *ep, struct pch_udc_request *req)
> +{
> +	struct pch_udc_dev	*dev = ep->dev;
> +
> +	dev_dbg(&dev->pdev->dev, "%s: enter  ep%d%s", __func__, ep->num,
> +		(ep->in ? "in" : "out"));
> +	/* IN zlp's are handled by hardware */
> +	complete_req(ep, req, 0);
> +
> +	/* if set_config or set_intf is waiting for ack by zlp
> +	 * then set CSR_DONE
> +	 */
> +	if (dev->set_cfg_not_acked) {
> +		dev_dbg(&dev->pdev->dev, "%s: process_zlp: csr done", __func__);
> +		pch_udc_set_csr_done(dev);
> +		dev->set_cfg_not_acked = 0;
> +	}
> +	/* setup command is ACK'ed now by zlp */
> +	if ((!dev->stall) && (dev->waiting_zlp_ack)) {

Useless parenthesis.

> +		/* clear NAK by writing CNAK in EP0_IN */
> +		pch_udc_ep_clear_nak(&(dev->ep[UDC_EP0IN_IDX]));
> +		dev->waiting_zlp_ack = 0;
> +	}
> +}


> +/**
> + * pch_udc_alloc_request() - This function allocates request structure.
> + *				It iscalled by gadget driver

"is called" -- typo.

> + * @usbep:	Reference to the USB endpoint structure
> + * @gfp:	Flag to be used while allocating memory
> + * Returns
> + *	NULL:			Failure
> + *	Allocated address:	Success
> + */


Other then those trivial mistakes, I haven't noticed any obvious
problems so I guess "Acked-by" me.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
