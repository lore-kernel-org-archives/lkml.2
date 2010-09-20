Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0ITInB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:43:01 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21685 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab0ITIm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:42:59 -0400
Date: Mon, 20 Sep 2010 10:44:51 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH v3] USB device driver of Topcliff PCH
In-reply-to: <4C921E19.7010101@dsn.okisemi.com>
To: Maurus Cuelenaere <mcuelenaere@gmail.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Toshiharu Okada <okada533@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>,
        MeeGo <meego-dev@meego.com>, LKML <linux-kernel@vger.kernel.org>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Arjan <arjan@linux.intel.com>
Message-id: <op.vjbo81dq7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.62 (Linux)
References: <4C921E19.7010101@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a few things I've noticed.  Do not consider it a proper review:


On Thu, 16 Sep 2010 15:39:37 +0200, Masayuki Ohtake <masa-korg@dsn.okisemi.com> wrote:
> +struct pch_udc_stp_dma_desc {
> +	u32 status;
> +	u32 reserved;
> +	u32 data12;
> +	u32 data34;
> +};

 From what I've seen, there is no reason why not make the above:

struct pch_udc_stp_dma_desc {
	u32 status;
	u32 reserved;
	struct usb_ctrlrequest request;
} __attribute((packed));


> +struct pch_udc_ep {
> +	struct usb_ep			ep;
> +	dma_addr_t			td_stp_phys;
> +	dma_addr_t			td_data_phys;
> +	struct pch_udc_stp_dma_desc	*td_stp;
> +	struct pch_udc_data_dma_desc	*td_data;
> +	struct pch_udc_dev		*dev;
> +	unsigned long			offset_addr;
> +	const struct usb_endpoint_descriptor	*desc;
> +	struct list_head		queue;
> +	unsigned			num:5;
> +	unsigned			in:1;
> +	unsigned			halted;

Can't this be made into bitfield as well?

> +	unsigned long			epsts;
> +};


> +union pch_udc_setup_data {
> +	u32		data[2];
> +	struct usb_ctrlrequest	request;
> +};

This should not be needed.  Just use struct pch_udc_stp_dma_desc as
described above.


> +static void pch_udc_csr_busy(struct pch_udc_dev *dev)
> +{
> +	unsigned int count = MAX_LOOP;

At this point, I would start wondering whether the MAX_LOOP macro is
really needed.  I'd remove the #define and just put a plain number
here.

> +
> +	/* Wait till idle */
> +	while ((pch_udc_readl(dev, UDC_CSR_BUSY_ADDR) & UDC_CSR_BUSY)
> +		&& --count)
> +		cpu_relax();
> +	if (!count)
> +		dev_err(&dev->pdev->dev, "%s: wait error", __func__);
> +}


> +static inline void pch_udc_vbus_session(struct pch_udc_dev *dev,
> +					  int is_active)
> +{
> +	if (is_active)
> +		pch_udc_clear_disconnect(dev);
> +	else
> +		pch_udc_set_disconnect(dev);
> +}


> +/**
> + * pch_udc_ep_clear_nak() - Set the bit 8 (CNAK field)
> + *				of the endpoint control register
> + * @ep:		reference to structure of type pch_udc_ep_regs
> + */
> +static void pch_udc_ep_clear_nak(struct pch_udc_ep *ep)
> +{
> +	unsigned int loopcnt = 0;
> +	struct pch_udc_dev *dev = ep->dev;
> +
> +	if (!(pch_udc_ep_readl(ep, UDC_EPCTL_ADDR) & UDC_EPCTL_NAK))
> +		return;
> +	if (!ep->in) {
> +		loopcnt = 100000;
> +		while (!(pch_udc_read_ep_status(ep) & UDC_EPSTS_MRXFIFO_EMP) &&
> +			--loopcnt)
> +			udelay(100);

This loop can take up to 10 seconds.  Is it desired?

> +		if (!loopcnt)
> +			dev_dbg(&dev->pdev->dev, "%s: RxFIFO not Empty "
> +				"loop count = %d", __func__, loopcnt);

Shouldn't that be dev_err()?

> +	}
> +	loopcnt = 100000;
> +	while ((pch_udc_read_ep_control(ep) & UDC_EPCTL_NAK) && --loopcnt) {
> +		pch_udc_ep_bit_set(ep, UDC_EPCTL_ADDR, UDC_EPCTL_CNAK);
> +		udelay(5);
> +	}

This loop can take up to half a second.  Is it desired?

> +	if (!loopcnt)
> +		dev_dbg(&dev->pdev->dev,
> +			"%s: Clear NAK not set for ep%d%s: counter=%d",
> +			__func__, ep->num, (ep->in ? "in" : "out"), loopcnt);

Shouldn't that be dev_err()?

> +}


> +static void pch_udc_ep_fifo_flush(struct pch_udc_ep *ep, int dir)
> +{
> +	unsigned int loopcnt = 0;
> +	struct pch_udc_dev *dev = ep->dev;
> +
> +	dev_dbg(&dev->pdev->dev, "%s: ep%d%s", __func__, ep->num,
> +		(ep->in ? "in" : "out"));
> +	if (dir) {	/* IN ep */
> +		pch_udc_ep_bit_set(ep, UDC_EPCTL_ADDR, UDC_EPCTL_F);
> +		return;
> +	}
> +
> +	if (pch_udc_read_ep_status(ep) & UDC_EPSTS_MRXFIFO_EMP)
> +		return;
> +	pch_udc_ep_bit_set(ep, UDC_EPCTL_ADDR, UDC_EPCTL_MRXFLUSH);
> +	/* Wait for RxFIFO Empty */
> +	loopcnt = 1000000;
> +	while (!(pch_udc_read_ep_status(ep) & UDC_EPSTS_MRXFIFO_EMP) &&
> +		--loopcnt)
> +		udelay(100);
> +	if (!loopcnt)
> +		dev_dbg(&dev->pdev->dev, "RxFIFO not Empty");

Same as in function above.  The loop can take up to 10 seconds plus if
loopcnt reaches zero error should be printed (IMO).

> +	pch_udc_ep_bit_clr(ep, UDC_EPCTL_ADDR, UDC_EPCTL_MRXFLUSH);
> +}


> +static int pch_udc_free_dma_chain(struct pch_udc_dev *dev,
> +						 struct pch_udc_request *req)
> +{
> +	struct pch_udc_data_dma_desc	*td;
> +	struct pch_udc_data_dma_desc	*td_last;
> +	u32 i;

Why u32?  Why not plain unsigned?

> +
> +	/* do not free first desc., will be done by free for request */
> +	td_last = req->td_data;
> +	td = phys_to_virt(td_last->next);
> +
> +	for (i = 1; i < req->chain_len; i++) {
> +		pci_pool_free(dev->data_requests, td,
> +			      (dma_addr_t) td_last->next);
> +		td_last = td;
> +		td = phys_to_virt(td_last->next);
> +	}
> +	return 0;
> +}

If I'm not mistaken, this can be refactored as:

static void pch_udc_free_dma_chain(struct pch_udc_dev *dev,
				   struct pch_udc_request *req)
{
	struct pch_udc_data_dma_desc *td = req->td_data;
	unsigned i = req->chain_len;

	for (; i > 1; --i) {
		dma_addr_t addr = (dma_addr_t)td->next;
		/* do not free first desc., will be done by free for request */
		td = phys_to_virt(addr);
		pci_pool_free(dev->data_requests, td, addr);
	}
}

> +static int pch_udc_create_dma_chain(struct pch_udc_ep *ep,
> +				     struct pch_udc_request *req,
> +				     unsigned long buf_len,
> +				     gfp_t gfp_flags)
> +{
> +	unsigned long bytes = req->req.length;
> +	unsigned int i;

If bytes and buf_len is unsigned long why i is unsigned int?

> +	dma_addr_t dma_addr;
> +	struct pch_udc_data_dma_desc	*td = NULL;
> +	struct pch_udc_data_dma_desc	*last = NULL;
> +	unsigned long txbytes;
> +	unsigned len;
> +
> +	pr_debug("%s: enter  bytes = %ld buf_len = %ld", __func__, bytes,
> +		 buf_len);
> +	/* unset L bit in first desc for OUT */
> +	if (!ep->in)
> +		req->td_data->status = PCH_UDC_BS_HST_BSY;
> +
> +	/* alloc only new desc's if not already available */
> +	len = req->req.length / buf_len;
> +	if (req->req.length % buf_len)
> +		len++;

	len = (bytes + buf_len - 1) / buf_len;

> +
> +	/* shorter chain already allocated before */
> +	if (req->chain_len > 1)
> +		pch_udc_free_dma_chain(ep->dev, req);
> +
> +	req->chain_len = len;
> +
> +	td = req->td_data;
> +	/* gen. required number of descriptors and buffers */
> +	for (i = buf_len; i < bytes; i += buf_len) {
> +		dma_addr = DMA_ADDR_INVALID;

No use to set.

> +		/* create or determine next desc. */
> +		td = pci_pool_alloc(ep->dev->data_requests, gfp_flags,
> +				    &dma_addr);
> +		if (!td)
> +			return -ENOMEM;
> +
> +		td->status = 0;

No use to set.

> +		td->dataptr = req->req.dma + i; /* assign buffer */
> +
> +		if ((bytes - i) >= buf_len)
> +			txbytes = buf_len;
> +		else /* short packet */
> +			txbytes = bytes - i;
> +		/* link td and assign tx bytes */
> +		if (i == buf_len) {
> +			req->td_data->next = dma_addr;
> +			/* set the count bytes */
> +			if (ep->in) {
> +				req->td_data->status = PCH_UDC_BS_HST_BSY |
> +						       buf_len;
> +				/* second desc */
> +				td->status = PCH_UDC_BS_HST_BSY | txbytes;
> +			} else {
> +				td->status = PCH_UDC_BS_HST_BSY;
> +			}
> +		} else {
> +			last->next = dma_addr;
> +			if (ep->in)
> +				td->status = PCH_UDC_BS_HST_BSY | txbytes;
> +			else
> +				td->status = PCH_UDC_BS_HST_BSY;
> +
> +		}
> +		last = td;
> +	}
> +	/* set last bit */
> +	if (td) {

This is always true.

> +		td->status |= PCH_UDC_DMA_LAST;
> +		/* last desc. points to itself */
> +		req->td_data_last = td;
> +		td->next = req->td_data_phys;
> +	}
> +	return 0;
> +}

The above function can (at least I think it can) be changed to a shorter version
with no memory error recovery:

static int pch_udc_create_dma_chain(struct pch_udc_ep *ep,
				    struct pch_udc_request *req,
				    unsigned long buf_len,
				    gfp_t gfp_flags)
{
	struct pch_udc_data_dma_desc *td = req->td_data, *last;
	unsigned long bytes = req->req.length, i = 0;
	dma_addr_t dma_addr;
	unsigned len = 1;

	pr_debug("%s: enter  bytes = %ld buf_len = %ld", __func__, bytes,
		 buf_len);

	if (req->chain_len > 1)
		pch_udc_free_dma_chain(ep->dev, req);

	for (; ; bytes -= buf_len, i += buf_len, ++len) {
		if (ep->in)
			td->status = PCH_UDC_BS_HST_BSY | min(buf_len, bytes);
		else
			td->status = PCH_UDC_BS_HST_BSY;

		if (bytes <= buf_len)
			break;

		last = td;
		td = pci_pool_alloc(ep->dev->data_requests, gfp_flags,
				    &dma_addr);
		if (!td)
			goto nomem;

		i += buf_len;
		td->dataptr = req->req.dma + i;
		last->next = dma_addr;
	}

	req->td_data_last = td;
	td->status |= PCH_UDC_DMA_LAST;
	td->next = req->td_data_phys;
	req->chain_len = len;

	return 0;

nomem:
	if (len > 1) {
		req->chain_len = len;
		pch_udc_free_dma_chain(ep->dev, req);
	}
	req->chain_len = 1;

	return -ENOMEM;
}


> +static int prepare_dma(struct pch_udc_ep *ep, struct pch_udc_request *req,
> +			  gfp_t gfp)
> +{
> +	int	retval = 0;

Actually, what's the use of initialising?

> +
> +	pr_debug("%s: enter  req->req.dma=0x%08x", __func__, req->req.dma);
> +	/* set buffer pointer */
> +	req->td_data->dataptr = req->req.dma;
> +	/* set last bit */
> +	req->td_data->status |= PCH_UDC_DMA_LAST;
> +
> +	/* Allocate and create a DMA chain */
> +	retval = pch_udc_create_dma_chain(ep, req, ep->ep.maxpacket, gfp);
> +	if (retval) {
> +		if (retval == -ENOMEM)
> +			pr_err("%s: Out of DMA memory", __func__);

I'd change this to a simple pr_err() without if (retval == -ENOMEM).  Eg.:

		pr_err("%s: could not create DMA chain: %d\n", __func__, retval);

Also, you've forgotten about \n at the end.

> +		return retval;
> +	}
> +	if (!ep->in)
> +		return retval;

Just "return 0;".

> +
> +	if (req->req.length <= ep->ep.maxpacket)
> +		/* write tx bytes */
> +		req->td_data->status = PCH_UDC_DMA_LAST | PCH_UDC_BS_HST_BSY |
> +				       req->req.length;
> +	/* if bytes < max packet then tx bytes must
> +	 * be written in packet per buffer mode
> +	 */
> +	if ((req->req.length < ep->ep.maxpacket) || !ep->num)
> +		/* write the count */
> +		req->td_data->status = (req->td_data->status &
> +					~PCH_UDC_RXTX_BYTES) | req->req.length;
> +	/* set HOST BUSY */
> +	req->td_data->status = (req->td_data->status &
> +				~PCH_UDC_BUFF_STS) | PCH_UDC_BS_HST_BSY;
> +	return retval;

Just "return 0;".

> +}


> +static int pch_udc_pcd_ep_enable(struct usb_ep *usbep,
> +				    const struct usb_endpoint_descriptor *desc)
> +{
> +	struct pch_udc_ep	*ep;
> +	struct pch_udc_dev	*dev;
> +	unsigned long		iflags;
> +
> +	if (!usbep || (usbep->name == ep0_string) || !desc ||
> +	    (desc->bDescriptorType != USB_DT_ENDPOINT) || !desc->wMaxPacketSize)
> +		return -EINVAL;
> +
> +	ep = container_of(usbep, struct pch_udc_ep, ep);
> +	dev = ep->dev;
> +
> +	dev_dbg(&dev->pdev->dev, "%s: ep %d", __func__, ep->num);
> +	if (!dev->driver || (dev->gadget.speed == USB_SPEED_UNKNOWN))
> +		return -ESHUTDOWN;
> +
> +	spin_lock_irqsave(&dev->lock, iflags);
> +	ep->desc = desc;
> +	ep->halted = 0;
> +	pch_udc_ep_enable(ep, &ep->dev->cfg_data, desc);
> +	ep->ep.maxpacket = le16_to_cpu(desc->wMaxPacketSize);
> +	pch_udc_enable_ep_interrupts(ep->dev, PCH_UDC_EPINT(ep->in, ep->num));
> +	dev_dbg(&dev->pdev->dev, "%s: %s enabled", __func__, usbep->name);
> +
> +	spin_unlock_irqrestore(&dev->lock, iflags);

Move the empty line from before unlock to after unlock, please.

> +	return 0;
> +}


> +/**
> + * pch_udc_free_request() - This function frees request structure.
> + *				It is called by gadget driver
> + * @usbep:	Reference to the USB endpoint structure
> + * @usbreq:	Reference to the USB request
> + */
> +static void pch_udc_free_request(struct usb_ep *usbep,
> +				  struct usb_request *usbreq)
> +{
> +	struct pch_udc_ep	*ep;
> +	struct pch_udc_request	*req;
> +	struct pch_udc_dev	*dev;
> +
> +	if (!usbep || !usbreq)
> +		return;
> +
> +	ep = container_of(usbep, struct pch_udc_ep, ep);
> +	req = container_of(usbreq, struct pch_udc_request, req);
> +	dev = ep->dev;
> +	dev_dbg(&dev->pdev->dev, "%s: %s  req = 0x%p", __func__, usbep->name,
> +		req);
> +
> +	if (!list_empty(&req->queue))
> +		dev_err(&dev->pdev->dev, "%s: %s  req = 0x%p  queue not empty",
> +			__func__, usbep->name, req);
> +
> +	if (req->td_data != NULL) {
> +		if (req->chain_len > 1)
> +			pch_udc_free_dma_chain(ep->dev, req);
> +		else
> +			pci_pool_free(ep->dev->data_requests, req->td_data,
> +				      req->td_data_phys);

The first td_data is never freed?  Or am I missing something?   I think the "else"
should be dropped and the second part should be done unconditionally.

> +	}
> +	kfree(req);
> +}



> +			/*
> +			* For IN trfr the descriptors will be programmed and
> +			* P bit will be set when
> +			* we get an IN token
> +			*/
> +
> +			while (pch_udc_read_ep_control(ep) & UDC_EPCTL_S)
> +				udelay(100);

Some kind of limit should be used here IMO.  What if hardware malfunctions
and the condition is never met?

> +			pch_udc_ep_clear_nak(ep);
> +			pch_udc_enable_ep_interrupts(ep->dev,
> +							 (1 << ep->num));
> +			/* enable DMA */
> +			pch_udc_set_dma(dev, DMA_DIR_TX);

> +/**
> + * pch_udc_pcd_dequeue() - This function de-queues a request packet.
> + *				It is called by gadget driver
> + * @usbep:	Reference to the USB endpoint structure
> + * @usbreq:	Reference to the USB request
> + * Returns
> + *	0:			Success
> + *	linux error number:	Failure
> + */
> +static int pch_udc_pcd_dequeue(struct usb_ep *usbep,
> +				struct usb_request *usbreq)
> +{
> +	struct pch_udc_ep	*ep;
> +	struct pch_udc_request	*req;
> +	struct pch_udc_dev	*dev;
> +	unsigned long		flags;

I would add "int ret = -EINVAL;" here,

> +
> +	ep = container_of(usbep, struct pch_udc_ep, ep);
> +	dev = ep->dev;
> +	if (!usbep || !usbreq || (!ep->desc && ep->num))
> +		return -EINVAL;
> +	dev_dbg(&dev->pdev->dev, "%s: enter  ep%d%s", __func__, ep->num,
> +		(ep->in ? "in" : "out"));
> +	req = container_of(usbreq, struct pch_udc_request, req);
> +	spin_lock_irqsave(&ep->dev->lock, flags);
> +	/* make sure it's still queued on this endpoint */
> +	list_for_each_entry(req, &ep->queue, queue) {
> +		if (&req->req == usbreq)
> +			break;

replace the above "if" with:

		if (&req->req == usbreq) {
			pch_udc_ep_set_nak(ep);
			if (!list_empty(&req->queue))
				complete_req(ep, req, -ECONNRESET);
			ret = 0;
			break;
		}

> +	}
> +
> +	if (&req->req != usbreq) {
> +		spin_unlock_irqrestore(&ep->dev->lock, flags);
> +		return -EINVAL;
> +	}
> +	pch_udc_ep_set_nak(ep);
> +	if (!list_empty(&req->queue))
> +		complete_req(ep, req, -ECONNRESET);
> +
> +	spin_unlock_irqrestore(&ep->dev->lock, flags);
> +	return 0;

And then, replace the whole section after the loop with:

	spin_unlock_irqrestore(&ep->dev->lock, flags);
	return ret;

> +}


> +static int pch_udc_pcd_set_halt(struct usb_ep *usbep, int halt)
> +{
> +	struct pch_udc_ep	*ep;
> +	struct pch_udc_dev	*dev;
> +	unsigned long iflags;
> +
> +	if (!usbep)
> +		return -EINVAL;
> +
> +	pr_debug("%s: %s: halt=%d", __func__, usbep->name, halt);
> +	ep = container_of(usbep, struct pch_udc_ep, ep);
> +	dev = ep->dev;
> +	if (!ep->desc && !ep->num) {
> +		dev_dbg(&dev->pdev->dev, "%s: ep->desc = 0x%x: ep->num = 0x%x",
> +			 __func__, (u32)(ep->desc), ep->num);
> +		return -EINVAL;
> +	}
> +	if (!ep->dev->driver || (ep->dev->gadget.speed == USB_SPEED_UNKNOWN)) {
> +		dev_dbg(&dev->pdev->dev, "%s: ep->dev->driver = 0x%x:"
> +			 " ep->dev->gadget.speed = 0x%x",
> +			 __func__, (u32)(ep->dev->driver),
> +				 ep->dev->gadget.speed);
> +		return -ESHUTDOWN;
> +	}
> +
> +	spin_lock_irqsave(&udc_stall_spinlock, iflags);
> +
> +	if (!list_empty(&ep->queue)) {
> +		dev_dbg(&dev->pdev->dev, "%s: list not empty", __func__);
> +		spin_unlock_irqrestore(&udc_stall_spinlock, iflags);
> +		return -EAGAIN;

Similarly as above, I don't like when a lock has two different unlocks.
It's better to use a "int ret;" above and a goto.  Even better, here you can
just use a chain if-else-if-...-else.

> +	}
> +	/* halt or clear halt */
> +	if (!halt) {
> +		pch_udc_ep_clear_stall(ep);
> +	} else {
> +		if (ep->num == PCH_UDC_EP0)
> +			ep->dev->stall = 1;
> +
> +		pch_udc_ep_set_stall(ep);
> +		pch_udc_enable_ep_interrupts(ep->dev,
> +					     PCH_UDC_EPINT(ep->in, ep->num));
> +	}
> +	spin_unlock_irqrestore(&udc_stall_spinlock, iflags);
> +	return 0;

Like so:

	spin_lock_irqsave(&udc_stall_spinlock, iflags);
	if (!list_empty(&ep->queue)) {
		dev_dbg(&dev->pdev->dev, "%s: list not empty", __func__);
		ret = -EAGAIN;
	} else if (!halt) {	/* halt or clear halt */
		pch_udc_ep_clear_stall(ep);
		ret = 0;
	} else {
		if (ep->num == PCH_UDC_EP0)
			ep->dev->stall = 1;
		pch_udc_ep_set_stall(ep);
		pch_udc_enable_ep_interrupts(ep->dev,
					     PCH_UDC_EPINT(ep->in, ep->num));
		ret = 0;
	}
	spin_unlock_irqrestore(&udc_stall_spinlock, iflags);
	return ret;

> +}


> +static int pch_udc_pcd_set_wedge(struct usb_ep *usbep)
> +{
> +	struct pch_udc_ep	*ep;
> +	struct pch_udc_dev	*dev;
> +	unsigned long iflags;
> +
> +	if (!usbep)
> +		return -EINVAL;
> +
> +	pr_debug("%s: %s:", __func__, usbep->name);
> +	ep = container_of(usbep, struct pch_udc_ep, ep);
> +	dev = ep->dev;
> +	if (!ep->desc && !ep->num) {
> +		dev_dbg(&dev->pdev->dev, "%s: ep->desc = 0x%x: ep->num = 0x%x",
> +			 __func__, (u32)(ep->desc), ep->num);
> +		return -EINVAL;
> +	}
> +	if (!ep->dev->driver || (ep->dev->gadget.speed == USB_SPEED_UNKNOWN)) {
> +		dev_dbg(&dev->pdev->dev, "%s: ep->dev->driver = 0x%x: "
> +			"ep->dev->gadget.speed = 0x%x", __func__,
> +			(u32)(ep->dev->driver), ep->dev->gadget.speed);
> +		return -ESHUTDOWN;
> +	}
> +
> +	spin_lock_irqsave(&udc_stall_spinlock, iflags);
> +
> +	if (!list_empty(&ep->queue)) {
> +		dev_dbg(&dev->pdev->dev, "%s: list not empty", __func__);
> +		spin_unlock_irqrestore(&udc_stall_spinlock, iflags);
> +		return -EAGAIN;

Like above, please add an "else" section and use an "int ret" to hold exit
status.  This will again allow to have only one "unlock".

> +	}
> +	/* halt */
> +	if (ep->num == PCH_UDC_EP0)
> +		ep->dev->stall = 1;
> +
> +	pch_udc_ep_set_stall(ep);
> +	pch_udc_enable_ep_interrupts(ep->dev, PCH_UDC_EPINT(ep->in, ep->num));
> +
> +	ep->dev->prot_stall = 1;
> +	spin_unlock_irqrestore(&udc_stall_spinlock, iflags);
> +	return 0;
> +}



> +static void pch_udc_pcd_fifo_flush(struct usb_ep *usbep)
> +{
> +	struct pch_udc_ep  *ep ;
> +
> +	if (!usbep)
> +		return;
> +
> +	pr_debug("%s: %s", __func__, usbep->name);
> +	ep = container_of(usbep, struct pch_udc_ep, ep);
> +	if (!ep->desc && ep->num)
> +		return;
> +	pch_udc_ep_fifo_flush(ep, ep->in);

A matter of taste I think, but why not:

	if (ep->desc || !ep->num)
		pch_udc_ep_fifo_flush(ep, ep->in);

> +}


> +static void pch_udc_start_next_txrequest(struct pch_udc_ep *ep)
> +{
> +	struct pch_udc_request *req;
> +	struct pch_udc_data_dma_desc *td_data;
> +	struct pch_udc_dev *dev = ep->dev;
> +
> +	if (pch_udc_read_ep_control(ep) & UDC_EPCTL_P)
> +		return;
> +
> +	if (list_empty(&ep->queue))
> +		return;
> +
> +	/* next request */
> +	req = list_entry(ep->queue.next, struct pch_udc_request, queue);
> +	if (req->dma_going)
> +		return;
> +
> +	dev_dbg(&dev->pdev->dev, "%s: Set request: req=%p req->td_data=%p",
> +		__func__, req, req->td_data);
> +	if (!req->td_data)
> +		return;
> +
> +	while (pch_udc_read_ep_control(ep) & UDC_EPCTL_S)
> +		udelay(100);

Again.  What if condition never gets true?

> +	req->dma_going = 1;
> +	/* Clear the descriptor pointer */
> +	pch_udc_ep_set_ddptr(ep, 0);
> +
> +	td_data = req->td_data;
> +	while (1) {
> +		td_data->status = (td_data->status & ~PCH_UDC_BUFF_STS) |
> +				   PCH_UDC_BS_HST_RDY;
> +		if ((td_data->status & PCH_UDC_DMA_LAST) == PCH_UDC_DMA_LAST)
> +			break;
> +		td_data = phys_to_virt(td_data->next);
> +	}
> +	/* Write the descriptor pointer */
> +	pch_udc_ep_set_ddptr(ep, req->td_data_phys);
> +	pch_udc_set_dma(ep->dev, DMA_DIR_TX);
> +	/* Set the poll demand bit */
> +	pch_udc_ep_set_pd(ep);
> +	pch_udc_enable_ep_interrupts(ep->dev, PCH_UDC_EPINT(ep->in, ep->num));
> +	pch_udc_ep_clear_nak(ep);
> +}


> +/**
> + * pch_udc_pcd_reinit() - This API initializes the endpoint structures
> + * @dev:	Reference to the driver structure
> + */
> +static void pch_udc_pcd_reinit(struct pch_udc_dev *dev)
> +{
> +	const char *const ep_string[] = {
> +		ep0_string, "ep0out", "ep1in", "ep1out", "ep2in", "ep2out",
> +		"ep3in", "ep3out", "ep4in", "ep4out", "ep5in", "ep5out",
> +		"ep6in", "ep6out", "ep7in", "ep7out", "ep8in", "ep8out",
> +		"ep9in", "ep9out", "ep10in", "ep10out", "ep11in", "ep11out",
> +		"ep12in", "ep12out", "ep13in", "ep13out", "ep14in", "ep14out",
> +		"ep15in", "ep15out",
> +	};
> +	int i;
> +
> +	dev->gadget.speed = USB_SPEED_UNKNOWN;
> +	INIT_LIST_HEAD(&dev->gadget.ep_list);
> +
> +	/* Initialize the endpoints structures */
> +	for (i = 0; i < PCH_UDC_EP_NUM; i++) {
> +		struct pch_udc_ep *ep = &dev->ep[i];
> +		memset(ep, 0, sizeof(*ep));

Why not just "memset(dev->ep, 0, sizeof dev->ep);" before the loop?

> +
> +		ep->desc = NULL;

Useless.  This has already been set by memset().

> +		ep->dev = dev;
> +		ep->halted = 1;
> +		ep->num = i / 2;
> +		ep->in = ((i & 1) == 0) ? 1 : 0;

Or "ep->in = ~i & 1;".

> +
> +		ep->ep.name = ep_string[i];
> +		ep->ep.ops = &pch_udc_ep_ops;
> +		if (ep->in)
> +			ep->offset_addr = ep->num * UDC_EP_REG_OFS;
> +		else
> +			ep->offset_addr = (UDC_EPINT_OUT_OFS + ep->num) *
> +					  UDC_EP_REG_OFS;
> +		/* need to set ep->ep.maxpacket and set Default Configuration?*/
> +		ep->ep.maxpacket = UDC_BULK_MAX_PKT_SIZE;
> +		list_add_tail(&ep->ep.ep_list, &dev->gadget.ep_list);
> +		INIT_LIST_HEAD(&ep->queue);
> +	}
> +	dev->ep[UDC_EP0IN_IDX].ep.maxpacket = UDC_EP0IN_MAX_PKT_SIZE;
> +	dev->ep[UDC_EP0OUT_IDX].ep.maxpacket = UDC_EP0OUT_MAX_PKT_SIZE;
> +
> +	dev->dma_addr = pci_map_single(dev->pdev, dev->ep0out_buf, 256,
> +				  PCI_DMA_FROMDEVICE);
> +
> +	/* remove ep0 in and out from the list.  They have own pointer */
> +	list_del_init(&dev->ep[UDC_EP0IN_IDX].ep.ep_list);
> +	list_del_init(&dev->ep[UDC_EP0OUT_IDX].ep.ep_list);
> +
> +	dev->gadget.ep0 = &dev->ep[UDC_EP0IN_IDX].ep;
> +	INIT_LIST_HEAD(&dev->gadget.ep0->ep_list);
> +}


> +static int init_dma_pools(struct pch_udc_dev *dev)
> +{
> +	struct pch_udc_stp_dma_desc	*td_stp;
> +	struct pch_udc_data_dma_desc	*td_data;
> +
> +	/* DMA setup */
> +	dev->data_requests = pci_pool_create("data_requests", dev->pdev,
> +		sizeof(struct pch_udc_data_dma_desc), 0, 0);
> +	if (!dev->data_requests) {
> +		dev_err(&dev->pdev->dev, "%s: can't get request data pool",
> +			__func__);
> +		return -ENOMEM;
> +	}
> +
> +	/* dma desc for setup data */
> +	dev->stp_requests = pci_pool_create("setup requests", dev->pdev,
> +		sizeof(struct pch_udc_stp_dma_desc), 0, 0);
> +	if (!dev->stp_requests) {

Why dev->data_requests? Something that has been created needs to be
destroyed during error recovery.

> +		dev_err(&dev->pdev->dev, "%s: can't get setup request pool",
> +			__func__);
> +		return -ENOMEM;
> +	}
> +	/* setup */
> +	td_stp = pci_pool_alloc(dev->stp_requests, GFP_KERNEL,
> +				&dev->ep[UDC_EP0OUT_IDX].td_stp_phys);
> +	if (!td_stp) {
> +		dev_err(&dev->pdev->dev,
> +			"%s: can't allocate setup dma descriptor", __func__);

Same here.

> +		return -ENOMEM;
> +	}
> +	dev->ep[UDC_EP0OUT_IDX].td_stp = td_stp;
> +
> +	/* data: 0 packets !? */
> +	td_data = pci_pool_alloc(dev->data_requests, GFP_KERNEL,
> +				&dev->ep[UDC_EP0OUT_IDX].td_data_phys);
> +	if (!td_data) {

And here.

> +		dev_err(&dev->pdev->dev,
> +			"%s: can't allocate data dma descriptor", __func__);
> +		return -ENOMEM;
> +	}
> +	dev->ep[UDC_EP0OUT_IDX].td_data = td_data;
> +	dev->ep[UDC_EP0IN_IDX].td_stp = NULL;
> +	dev->ep[UDC_EP0IN_IDX].td_stp_phys = 0;
> +	dev->ep[UDC_EP0IN_IDX].td_data = NULL;
> +	dev->ep[UDC_EP0IN_IDX].td_data_phys = 0;
> +	return 0;
> +}
> +


> +static void pch_udc_remove(struct pci_dev *pdev)
> +{
> +	struct pch_udc_dev	*dev = pci_get_drvdata(pdev);
> +
> +	dev_dbg(&pdev->dev, "%s: enter", __func__);
> +	/* gadget driver must not be registered */
> +	if (dev->driver)
> +		dev_err(&pdev->dev,
> +			"%s: gadget driver still bound!!!", __func__);
> +	/* dma pool cleanup */
> +	if (dev->data_requests)
> +		pci_pool_destroy(dev->data_requests);
> +
> +	if (dev->stp_requests) {
> +		/* cleanup DMA desc's for ep0in */
> +		if (dev->ep[UDC_EP0OUT_IDX].td_stp) {
> +			pci_pool_free(dev->stp_requests,
> +				dev->ep[UDC_EP0OUT_IDX].td_stp,
> +				dev->ep[UDC_EP0OUT_IDX].td_stp_phys);
> +		}
> +		if (dev->ep[UDC_EP0OUT_IDX].td_data) {
> +			pci_pool_free(dev->stp_requests,
> +				dev->ep[UDC_EP0OUT_IDX].td_data,
> +				dev->ep[UDC_EP0OUT_IDX].td_data_phys);
> +		}
> +		pci_pool_destroy(dev->stp_requests);
> +	}
> +
> +	pch_udc_exit(dev);
> +
> +	if (dev->irq_registered)
> +		free_irq(pdev->irq, dev);
> +	if (dev->base_addr)
> +		iounmap(dev->base_addr);
> +	if (dev->mem_region)
> +		release_mem_region(dev->phys_addr,
> +				   pci_resource_len(pdev, PCH_UDC_PCI_BAR));
> +	if (dev->active)
> +		pci_disable_device(pdev);
> +	if (dev->registered)
> +		device_unregister(&dev->gadget.dev);
> +	else
> +		kfree(dev);

Really? kfree(dev) in "else" clause?

> +
> +	pci_set_drvdata(pdev, NULL);
> +}

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
