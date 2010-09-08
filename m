Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0IHB6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 21:58:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48539 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0IHB6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 21:58:45 -0400
Date: Wed, 08 Sep 2010 03:58:04 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB device driver of Topcliff PCH
In-reply-to: <4C85EE6F.6000706@dsn.okisemi.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Maurus Cuelenaere <mcuelenaere@gmail.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Fabien Chouteau <fabien.chouteau@barco.com>,
        david Brownell <dbrownell@users.sourceforge.net>,
        Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
        LKML <linux-kernel@vger.kernel.org>, MeeGo <meego-dev@meego.com>,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Arjan <arjan@linux.intel.com>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>
Message-id: <op.vioye2r17p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <4C85EE6F.6000706@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure why I'm on the "To" list, but here are a few of my comments:

On Tue, 07 Sep 2010 09:49:03 +0200, Masayuki Ohtake <masa-korg@dsn.okisemi.com> wrote:
> +/**
> + * pch_udc_write_csr - Write the command and status registers.

IIRC, the correct way to write kernel doc is:

+ * pch_udc_write_csr() - Write the command and status registers.

Note the "()".  This applies to other functions as well.

> + * @val:	value to be written to CSR register
> + * @addr:	address of CSR register
> + */
> +inline void pch_udc_write_csr(unsigned long val, unsigned long addr)

As it was pointed, unless those functions are extern, make them static and remove
the inline.

> +{
> +	int count = MAX_LOOP;
> +
> +	/* Wait till idle */
> +	while ((count > 0) &&\
> +		(ioread32((u32 *)(PCH_UDC_CSR_BUSY_ADDR + pch_udc_base)) &
> +		PCH_UDC_CSR_BUSY))
> +		count--;

I'd say: "while (ioread(...) && --count);"  Also, I'd make count to be unsigned.

> +
> +	if (count < 0)
> +		pr_debug("%s: wait error; count = %x", __func__, count);

Dead code.  If MAX_LOOP is >= 0 count will never get negative.  Did you mean
if (!count)?

> +
> +	iowrite32(val, (u32 *)addr);
> +	/* Wait till idle */
> +	count = MAX_LOOP;
> +	while ((count > 0) &&
> +		(ioread32((u32 *)(PCH_UDC_CSR_BUSY_ADDR + pch_udc_base)) &
> +		PCH_UDC_CSR_BUSY))
> +		count--;
> +
> +	if (count < 0)
> +		pr_debug("%s: wait error; count = %x", __func__, count);

Dead code.

> +/**
> + * pch_udc_read_csr - Read the command and status registers.
> + * @addr:	address of CSR register
> + * Returns
> + *	content of CSR register
> + */
> +inline u32 pch_udc_read_csr(unsigned long addr)

All comments to the pch_udc_write_csr() function apply here as well.

> +/**
> + * pch_udc_get_speed - Return the speed status
> + * @dev:	Reference to pch_udc_regs structure
> + * Retern	The speed(LOW=1, FULL=2, HIGH=3)
> + */
> +inline int pch_udc_get_speed(struct pch_udc_regs __iomem *dev)
> +{
> +	u32 val;
> +
> +	val = ioread32(&dev->devsts);

It's just me, but why not join the two lines together:

+	u32 val = ioread32(&dev->devsts);

> +	return (val & UDC_DEVSTS_ENUM_SPEED_MASK) >> UDC_DEVSTS_ENUM_SPEED_OFS;
> +}

> +/**
> + * pch_udc_ep_clear_nak - Set the bit 8 (CNAK field)
> + *				of the endpoint control register
> + * @ep:		reference to structure of type pch_udc_ep_regs
> + */
> +void pch_udc_ep_clear_nak(struct pch_udc_ep_regs __iomem *ep)
> +{
> +	unsigned int loopcnt = 0;
> +
> +	if (ioread32(&ep->epctl) & (1 << UDC_EPCTL_NAK)) {

	if (!(ioread32(&ep->epctl) & (1 << UDC_EPCTL_NAK)))
		return;

and then drop one indention level for the rest of the function.
This will help to keep indention level nearer the recommended
limit of 3.

> +		if (!(EP_IS_IN(ep))) {
> +			while ((pch_udc_read_ep_status(ep) &
> +					 (1 << UDC_EPSTS_MRXFIFO_EMP)) == 0) {
> +				if (loopcnt++ > 100000) {
> +					pr_debug("%s: RxFIFO not Empty "
> +						  "loop count = %d",
> +						  __func__, loopcnt);
> +					break;
> +				}
> +				udelay(100);
> +			}
> +		}
> +		while (ioread32(&ep->epctl) & (1 << UDC_EPCTL_NAK)) {
> +			PCH_UDC_BIT_SET(&ep->epctl, 1 << UDC_EPCTL_CNAK);
> +			udelay(5);
> +			if (loopcnt++ >= 25) {
> +				pr_debug("%s: Clear NAK not set for"
> +					  "ep%d%s: counter=%d",
> +					  __func__, EP_NUM(ep),
> +					  (EP_IS_IN(ep) ? "in" : "out"),
> +					  loopcnt);
> +				break;
> +			}
> +		}
> +	}
> +}
> +
> +/**
> + * pch_udc_ep_fifo_flush - Flush the endpoint fifo
> + * @ep:	reference to structure of type pch_udc_ep_regs
> + * @dir:	direction of endpoint
> + *		- dir = 0 endpoint is OUT
> + *		- dir != 0 endpoint is IN
> + */
> +void pch_udc_ep_fifo_flush(struct pch_udc_ep_regs __iomem *ep, int dir)
> +{
> +	unsigned int loopcnt = 0;
> +
> +	pr_debug("%s: ep%d%s", __func__, EP_NUM(ep),
> +						 (EP_IS_IN(ep) ? "in" : "out"));
> +	if (dir) {	/* IN ep */
> +		PCH_UDC_BIT_SET(&ep->epctl, 1 << UDC_EPCTL_F);

I'd add "return;" here and move the else part out of the else dropping
one indention level.

> +	} else {
> +		if ((pch_udc_read_ep_status(ep) &
> +		    (1 << UDC_EPSTS_MRXFIFO_EMP)) == 0) {

	if (pch_udc_read_ep_status(ep) & (1 << UDC_EPSTS_MRXFIFO_EMP)
		return;

and drop indention.

> +			PCH_UDC_BIT_SET(&ep->epctl, 1 << UDC_EPCTL_MRXFLUSH);
> +			/* Wait for RxFIFO Empty */
> +			while ((pch_udc_read_ep_status(ep) &
> +				(1 << UDC_EPSTS_MRXFIFO_EMP)) == 0) {
> +				if (loopcnt++ > 1000000) {
> +					pr_debug("RxFIFO not Empty loop"
> +						  " count = %d", loopcnt);
> +					break;
> +				}
> +				udelay(100);
> +			}
> +			PCH_UDC_BIT_CLR(&ep->epctl, 1 << UDC_EPCTL_MRXFLUSH);
> +		}
> +	}
> +}

> +/**
> + * pch_udc_pcd_pullup - This API is invoked to make the device
> + *				visible/invisible to the host
> + * @gadget:	Reference to the gadget driver
> + * @is_on:	Specifies whether the pull up is made active or inactive
> + * Returns
> + *	0:		Success
> + *	-EINVAL:	If the gadget passed is NULL
> + */
> +static int pch_udc_pcd_pullup(struct usb_gadget *gadget, int is_on)
> +{
> +	struct pch_udc_dev		*dev;
> +
> +	pr_debug("%s: enter", __func__);

It just struck me.  Wouldn't it be feasible to use "dev_*" instead of "pr_*"?

> +	if (gadget == NULL) {
> +		pr_debug("%s: exit -EINVAL", __func__);
> +		return -EINVAL;
> +	}
> +	dev = container_of(gadget, struct pch_udc_dev, gadget);
> +	if (is_on == 0)
> +		pch_udc_set_disconnect(dev->regs);
> +	else
> +		pch_udc_clear_disconnect(dev->regs);

There was function that did exactly that I think.  Wasn't there?

> +	return 0;
> +}

> +/**
> + * pch_udc_start_next_txrequest - This function starts
> + *					the next transmission requirement
> + * @ep:	Reference to the endpoint structure
> + */
> +static void pch_udc_start_next_txrequest(struct pch_udc_ep *ep)
> +{
> +	struct pch_udc_request *req;
> +
> +	pr_debug("%s: enter", __func__);
> +	if (pch_udc_read_ep_control(ep->regs) & (1 << UDC_EPCTL_P))
> +		return;
> +
> +	if (!list_empty(&ep->queue)) {

if (list_empty(...))
	return;

and drop indention.

> +		/* next request */
> +		req = list_entry(ep->queue.next, struct pch_udc_request, queue);
> +		if (req && !req->dma_going) {

Same here.

> +			pr_debug("%s: Set request: req=%p req->td_data=%p",
> +					__func__, req, req->td_data);
> +			if (req->td_data) {

Same eher.

> +				struct pch_udc_data_dma_desc *td_data;
> +
> +				while (pch_udc_read_ep_control(ep->regs) &
> +							 (1 << UDC_EPCTL_S))
> +					udelay(100);
> +
> +				req->dma_going = 1;
> +				/* Clear the descriptor pointer */
> +				pch_udc_ep_set_ddptr(ep->regs, 0);
> +
> +				td_data = req->td_data;
> +				while (1) {
> +					td_data->status = (td_data->status &
> +						 ~PCH_UDC_BUFF_STS) |
> +						 PCH_UDC_BS_HST_RDY;
> +					if ((td_data->status &
> +						 PCH_UDC_DMA_LAST) ==
> +						 PCH_UDC_DMA_LAST)
> +						break;

The line above has 6 levels of indention.  If you drop indentions the way
described above you get back to 3.

> +
> +					td_data =
> +					(struct pch_udc_data_dma_desc *)\
> +					phys_to_virt(td_data->next);
> +				}
> +				/* Write the descriptor pointer */
> +				pch_udc_ep_set_ddptr(ep->regs,
> +							 req->td_data_phys);
> +				pch_udc_set_dma(ep->dev->regs, DMA_DIR_TX);
> +				/* Set the poll demand bit */
> +				pch_udc_ep_set_pd(ep->regs);
> +				pch_udc_enable_ep_interrupts(ep->dev->regs,
> +						1 << (ep->in ? ep->num :\
> +						 ep->num + UDC_EPINT_OUT_EP0));
> +				pch_udc_ep_clear_nak(ep->regs);
> +			}
> +		}
> +	}
> +}
> +
> +/**
> + * pch_udc_complete_transfer - This function completes a transfer
> + * @ep:		Reference to the endpoint structure
> + */
> +static void pch_udc_complete_transfer(struct pch_udc_ep	*ep)

Same as with the function above.

> +/**
> + * pch_udc_complete_receiver - This function completes a receiver
> + * @ep:		Reference to the endpoint structure
> + */
> +static void pch_udc_complete_receiver(struct pch_udc_ep	*ep)

This function would use some indention fixing as well.

> +	if (list_empty(&ep->queue)) {
> +		/* enable DMA */
> +		pch_udc_set_dma(dev->regs, DMA_DIR_RX);
> +	}

Drop the "{" and "}". script/checkpatch.pl will find issues like this one.

> +}

> +static void pch_udc_read_all_epstatus(struct pch_udc_dev *dev, u32 ep_intr)
> +{
> +	int i;
> +	struct pch_udc_ep	*ep;
> +
> +	for (i = 0; i < PCH_UDC_USED_EP_NUM; i++) {
> +		/* IN */
> +		if (ep_intr & (0x1 << i)) {
> +			ep = &dev->ep[2*i];
> +			ep->epsts = pch_udc_read_ep_status(ep->regs);
> +			pch_udc_clear_ep_status(ep->regs, ep->epsts);
> +		}
> +		/* OUT */
> +		if (ep_intr & (0x10000 << i)) {
> +			ep = &dev->ep[2*i+1];
> +			ep->epsts = pch_udc_read_ep_status(ep->regs);
> +			pch_udc_clear_ep_status(ep->regs, ep->epsts);
> +		}
> +	}
> +	return;

Useless return.

> +}

> +/**
> + * pch_udc_svc_enum_interrupt - This function handles a USB speed enumeration
> + *				done interrupt
> + * @dev:	Reference to driver structure
> + */
> +void
> +pch_udc_svc_enum_interrupt(struct pch_udc_dev *dev)

Useless line break.  This applies not only to this function.

> +void
> +pch_udc_svc_intf_interrupt(struct pch_udc_dev *dev)
> +{
> +	u32 reg, dev_stat = 0;
> +	int i, ret;
> +
> +	pr_debug("%s: enter", __func__);
> +	dev_stat = pch_udc_read_device_status(dev->regs);
> +	dev->cfg_data.cur_intf = (dev_stat & UDC_DEVSTS_INTF_MASK) >>
> +							 UDC_DEVSTS_INTF_OFS;
> +	dev->cfg_data.cur_alt = (dev_stat & UDC_DEVSTS_ALT_MASK) >>
> +							 UDC_DEVSTS_ALT_OFS;
> +	pr_debug("DVSTATUS=%08x, cfg=%d, intf=%d, alt=%d", dev_stat,
> +			(dev_stat & UDC_CSR_NE_CFG_MASK) >> UDC_CSR_NE_CFG_OFS,
> +			dev->cfg_data.cur_intf, dev->cfg_data.cur_alt);
> +
> +	dev->set_cfg_not_acked = 1;
> +
> +	/* Construct the usb request for gadget driver and inform it */
> +	memset(&setup_data, 0 , sizeof setup_data);
> +	setup_data.request.bRequest = USB_REQ_SET_INTERFACE;
> +	setup_data.request.bRequestType = USB_RECIP_INTERFACE;
> +	setup_data.request.wValue = cpu_to_le16(dev->cfg_data.cur_alt);
> +	setup_data.request.wIndex = cpu_to_le16(dev->cfg_data.cur_intf);
> +
> +	/* programm the Endpoint Cfg registers */
> +	for (i = 0; i < PCH_UDC_USED_EP_NUM * 2; i++) {
> +		if (i == 1) { /* Only one end point cfg register */
> +			reg = pch_udc_read_csr((u32) (&dev->csr->ne[i]));
> +			reg = (reg & ~UDC_CSR_NE_INTF_MASK) |
> +			 (dev->cfg_data.cur_intf << UDC_CSR_NE_INTF_OFS);
> +			reg = (reg & ~UDC_CSR_NE_ALT_MASK) |
> +			 (dev->cfg_data.cur_alt << UDC_CSR_NE_ALT_OFS);
> +			pch_udc_write_csr(reg, (u32) (&dev->csr->ne[i]));
> +		}

Could this if be put outside of the loop? This applies not only to this function.

> +		/* clear stall bits */
> +		pch_udc_ep_clear_stall(dev->ep[i].regs);
> +		dev->ep[i].halted = 0;
> +	}
> +	dev->stall = 0;
> +	spin_unlock(&dev->lock);
> +	ret = dev->driver->setup(&dev->gadget, &setup_data.request);
> +	spin_lock(&dev->lock);
> +}

> +irqreturn_t pch_udc_isr(int irq, void *pdev)
> +{
> +	struct pch_udc_dev *dev;
> +	u32 dev_intr, ep_intr;
> +	int i;
> +
> +	pr_debug("%s: enter", __func__);
> +	dev = (struct pch_udc_dev *) pdev;
> +	dev_intr = pch_udc_read_device_interrupts(dev->regs);
> +	ep_intr = pch_udc_read_ep_interrupts(dev->regs);
> +
> +	if (dev_intr != 0) {
> +		/* Clear device interrupts */
> +		pch_udc_write_device_interrupts(dev->regs, dev_intr);
> +	}
> +	if (ep_intr != 0) {
> +		/* Clear ep interrupts */
> +		pch_udc_write_ep_interrupts(dev->regs, ep_intr);
> +	}

Useless "{" and "}" in the two above ifs.

> +	if ((dev_intr == 0) && (ep_intr == 0)) {
> +		pr_debug("%s: exit IRQ_NONE", __func__);
> +		return IRQ_NONE;
> +	}
> +	spin_lock(&dev->lock);
> +
> +	if (dev_intr != 0) {
> +		pr_debug("%s: device intr 0x%x", __func__, dev_intr);
> +		pch_udc_dev_isr(dev, dev_intr);
> +	}
> +
> +	if (ep_intr != 0) {
> +		pr_debug("%s: ep intr 0x%x", __func__, ep_intr);
> +		pch_udc_read_all_epstatus(dev, ep_intr);
> +
> +		/* Process Control In interrupts, if present */
> +		if (ep_intr & (1 << UDC_EPINT_IN_EP0)) {
> +			pch_udc_svc_control_in(dev);
> +			pch_udc_postsvc_epinters(dev, 0);
> +		}
> +		/* Process Control Out interrupts, if present */
> +		if (ep_intr & (1 << UDC_EPINT_OUT_EP0))
> +			pch_udc_svc_control_out(dev);
> +
> +		/* Process data in end point interrupts */
> +		for (i = 1; i < PCH_UDC_USED_EP_NUM; i++) {
> +			if (ep_intr & (1 <<  i)) {
> +				pch_udc_svc_data_in(dev, i);
> +				pch_udc_postsvc_epinters(dev, i);
> +			}
> +		}
> +		/* Process data out end point interrupts */
> +		for (i = UDC_EPINT_OUT_EP1; i < (UDC_EPINT_OUT_EP0 +
> +						 PCH_UDC_USED_EP_NUM); i++) {
> +			if (ep_intr & (1 <<  i))
> +				pch_udc_svc_data_out(dev, i -
> +							 UDC_EPINT_OUT_EP0);
> +		}

Useless "{" and "}" in for.

> +	}
> +	spin_unlock(&dev->lock);
> +	return IRQ_HANDLED;
> +}

> +int pch_udc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	unsigned long		resource;
> +	unsigned long		len;
> +	int					retval = 0;
> +	struct pch_udc_dev	*dev;
> +
> +	dev_dbg(&pdev->dev, "%s: enter", __func__);
> +	/* one udc only */
> +	if (pch_udc != NULL) {
> +		dev_err(&pdev->dev, "%s: already probed", __func__);
> +		return -EBUSY;
> +	}
> +
> +	/* init */
> +	dev = kzalloc(sizeof(struct pch_udc_dev), GFP_KERNEL);

I just noticed it here but it may apply to other places as well.  I recommend:

+	dev = kzalloc(sizeof *dev, GFP_KERNEL);

> +	if (dev == NULL) {
> +		dev_err(&pdev->dev, "%s: no memory for device structure",
> +								__func__);
> +		return -ENOMEM;
> +	}
> +	memset(dev, 0, sizeof(struct pch_udc_dev));

kzalloc() does that.

> +/**
> + * pch_udc_cfg_data - Structure to hold current configuration
> + *			and interface information

This applies to other places as well.  The above should read:

+ * struct pch_udc_cfg_data - ...

> + * @cur_cfg	current configuration in use
> + * @cur_intf	current interface in use
> + * @cur_alt	current alt interface in use

And there should be ":" after member name.

> + */
> +struct pch_udc_cfg_data {
> +	u16 cur_cfg;
> +	u16 cur_intf;
> +	u16 cur_alt;
> +};

> +/**
> + * pch_udc_dev - Structure holding complete information of the PCH USB device
> + *
> + * @gadget		gadget driver data
> + * @driver;		reference to gadget driver bound
> + * @pdev;		reference to the PCI device
> + * @ep[PCH_UDC_EP_NUM];	array of endpoints
> + * @lock;		protects all state
> + * @active:1,		enabled the PCI device
> + * @stall:1,		stall requested
> + * @prot_stall:1,	protcol stall requested
> + * @irq_registered:1,	irq registered with system
> + * @mem_region:1,	device memory mapped
> + * @registered:1,	driver regsitered with system
> + * @suspended:1,	driver in suspended state
> + * @connected:1,	gadget driver associated
> + * @set_cfg_not_acked:1,	pending acknowledgement 4 setup
> + * @waiting_zlp_ack:1;	pending acknowledgement 4 ZLP
> + * @csr;		address of config & status
> + * @regs;		address of device registers
> + * @*ep_regs;		address of endpoint registers
> + * @data_requests;	DMA pool for data requests
> + * @stp_requests;	DMA pool for setup requests
> + * @phys_addr;		of device memory
> + * @virt_addr;		for mapped device memory
> + * @irq;		IRQ line for the device
> + * @cfg_data;		current cfg, intf, and alt in use
> + */

Useless ":1", there should be ":" after member name and not nothing, ";" or ",".

> +

Needless empty line.

> +struct pch_udc_dev {

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

