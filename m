Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab0INOdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:33:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16493 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0INOdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:33:09 -0400
Date: Tue, 14 Sep 2010 16:34:59 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH v2] USB device driver of Topcliff PCH
In-reply-to: <4C8F35BE.8000707@dsn.okisemi.com>
To: linux-usb <linux-usb@vger.kernel.org>,
        Maurus Cuelenaere <mcuelenaere@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Arjan <arjan@linux.intel.com>
Message-id: <op.vi01gltn7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <4C8F35BE.8000707@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 10:43:42 +0200, Masayuki Ohtake <masa-korg@dsn.okisemi.com> wrote:
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> +config PCH_USBDEV
> +	tristate
> +	depends on USB_GADGET_PCH
> +	default USB_GADGET
> +	select USB_GADGET_SELECTED

What's the use of this symbol?  Why is it missing help and prompt?

> +/**
> + * struct pch_udc_data_dma_desc - Structure to hold DMA descriptor information
> + *				  for data
> + * @status:		Status quadlet
> + * @reserved:		Reserved
> + * @dataptr:		Buffer descriptor
> + * @next:		Next descriptor
> +*/
    ^ space missing.

> +/**
> + * union pch_udc_ep - Structure holding setup request data
> + *

Needless line.

> + * @data[2]:		8 bytes of setup data

Needless "[2]".

> + * @request:		setup request for gadget driver
> + */
> +union pch_udc_setup_data {
> +	u32		data[2];
> +	struct usb_ctrlrequest	request;
> +};

Besides, do you really need this union?

> +/**
> + * struct pch_udc_dev - Structure holding complete information
> + *			of the PCH USB device
> + *

Needless empty line.

> + * @gadget:		gadget driver data
> + * @driver:		reference to gadget driver bound
> + * @pdev:		reference to the PCI device
> + * @ep[PCH_UDC_EP_NUM]:	array of endpoints

Needless "[...]".

> + * @lock:		protects all state
> + * @active:		enabled the PCI device
> + * @stall:		stall requested
> + * @prot_stall:		protcol stall requested
> + * @irq_registered:	irq registered with system
> + * @mem_region:		device memory mapped
> + * @registered:		driver regsitered with system
> + * @suspended:		driver in suspended state
> + * @connected:		gadget driver associated
> + * @set_cfg_not_acked:	pending acknowledgement 4 setup
> + * @waiting_zlp_ack:	pending acknowledgement 4 ZLP
> + * @data_requests:	DMA pool for data requests
> + * @stp_requests:	DMA pool for setup requests
> + * @dma_addr:		DMA pool for received
> + * @ep0out_buf[64]:	Buffer for DMA
> + * @setup_data:		Received setup data
> + * @phys_addr:		of device memory
> + * @base_addr:		for mapped device memory
> + * @irq:		IRQ line for the device
> + * @cfg_data:		current cfg, intf, and alt in use
> + */

> +/* macro to set a specified bit(mask) at the specified address */
> +#define PCH_UDC_BIT_SET(dev, reg, bitmask) \
> +     pch_udc_writel((dev), ((pch_udc_readl((dev), (reg)) | (bitmask))), (reg))
> +
> +/* macro to clear a specified bit(mask) at the specified address */
> +#define PCH_UDC_BIT_CLR(dev, reg, bitMask) \
> +     pch_udc_writel((dev), (pch_udc_readl((dev), (reg)) & (~(bitMask))), (reg))

You might want to make it into a static inline -- it should make some
people more happy. ;) You can put it after the pch_udc_writel() function.

> +/**
> + * struct pch_udc_request - Structure holding a PCH USB device request
> + * @req:		embedded ep request
> + * @td_data_phys:	phys. address
> + * @td_data:		first dma desc. of chain
> + * @td_data_last:	last dma desc. of chain
> + * @queue:		associated queue
> + * @dma_going:		DMA in progress for request
> + * @dma_mapped:		DMA memory mapped for request
> + * @dma_done:		DMA completed for request
> + * @chain_len:		chain length
> + */
> +struct pch_udc_request /* request packet */
> +{

"{" should go at the same line as "struct".

> +	struct usb_request		req;
> +	dma_addr_t			td_data_phys;
> +	struct pch_udc_data_dma_desc	*td_data;
> +	struct pch_udc_data_dma_desc	*td_data_last;
> +	struct list_head		queue;
> +	unsigned			dma_going:1,
> +					dma_mapped:1,
> +					dma_done:1;
> +	unsigned			chain_len;
> +};

> +/**
> + * pch_udc_write_csr() - Write the command and status registers.
> + * @val:	value to be written to CSR register
> + * @addr:	address of CSR register
> + */
> +static void pch_udc_write_csr(struct pch_udc_dev *dev, unsigned long val,
> +			       unsigned long reg)
> +{
> +	unsigned int count = MAX_LOOP;
> +
> +	/* Wait till idle */
> +	while ((pch_udc_readl(dev, UDC_CSR_BUSY_ADDR) & UDC_CSR_BUSY)
> +		&& (count > 0))
> +		count--;

Come to think of it, you sort of ignore the result of the last read if
all possible loop iterations were done.  I mean, when count hits zero
you still read the register but it does not really matter what the
read value is.  Because of that, I'd change the while to:

+	while ((pch_udc_readl(...) & UDC_CSR_BUSY) && --count)
+		/* nop */;

This also applies to other loops in other functions as well.

> +	if (!count)
> +		dev_err(&dev->pdev->dev, "%s: wait error; count = %x",
> +			__func__, count);

Writing count here is rather useless.  It's always zero.
This also applies to other loops in other functions as well.

Besides, the loop repeats in four different places (if I notices all of them).
Why not make a function out of it?

> +	pch_udc_writel(dev, val, reg);
> +	/* Wait till idle */
> +	count = MAX_LOOP;
> +	while ((pch_udc_readl(dev, UDC_CSR_BUSY_ADDR) & UDC_CSR_BUSY)
> +		&& (count > 0))
> +		count--;
> +	if (!count)
> +		dev_err(&dev->pdev->dev, "%s: wait error; count = %x",
> +			__func__, count);
> +}

> +static u32 pch_udc_read_csr(struct pch_udc_dev *dev, unsigned long reg)
> +{
[...]
> +	/* Dummy read */
> +	pch_udc_readl(dev, reg);

O_o...  I'll just assume this makes sense for the hardware. ;)
A comment about why this is done in such a way would be nice
though.

[...]
> +}

> +static inline void pch_udc_vbus_session(struct pch_udc_dev *dev,
> +					  int is_active)
> +{
> +	if (is_active == 0)
> +		pch_udc_set_disconnect(dev);
> +	else
> +		pch_udc_clear_disconnect(dev);
> +}

> +static void pch_udc_ep_clear_nak(struct pch_udc_ep *ep)
> +{
> +	unsigned int loopcnt = 0;
> +	struct pch_udc_dev *dev = ep->dev;
> +
> +	if (!(pch_udc_readl(ep->dev, ep->offset_addr + UDC_EPCTL_ADDR) &
> +	      UDC_EPCTL_NAK))

Just a thought, but maybe it would be feasible to create pch_ep_readl()
and pch_ep_writel() functions so that you wouldn't have to add the
ep->offset_addr each time.

> +		return;
> +	if (!ep->in) {

Useless "{ ... }".

> +		while ((pch_udc_read_ep_status(ep) &
> +			UDC_EPSTS_MRXFIFO_EMP) == 0) {
> +			if (loopcnt++ > 100000) {

Why not preincrementation?  Why not loop form 100000 to zero rather
than from zero to 100000.

> +				dev_dbg(&dev->pdev->dev, "%s: RxFIFO not Empty "
> +					"loop count = %d", __func__, loopcnt);
> +				break;
> +			}
> +			udelay(100);
> +		}
> +	}

You need to zero loopcnt here.  Also, I'd use a loop from 25 to zero rather
than from zero to 25 here the same as above.

> +	while (pch_udc_readl(ep->dev, ep->offset_addr + UDC_EPCTL_ADDR) &
> +		UDC_EPCTL_NAK) {
> +		PCH_UDC_BIT_SET(ep->dev, ep->offset_addr + UDC_EPCTL_ADDR,
> +				UDC_EPCTL_CNAK);
> +		udelay(5);
> +		if (loopcnt++ >= 25) {
> +			dev_dbg(&dev->pdev->dev, "%s: Clear NAK not set "
> +				"for ep%d%s: counter=%d", __func__, ep->num,
> +				 (ep->in ? "in" : "out"), loopcnt);
> +			break;
> +		}
> +	}
> +}

> +static void pch_udc_ep_fifo_flush(struct pch_udc_ep *ep, int dir)
> +{
> +	unsigned int loopcnt = 0;
> +	struct pch_udc_dev *dev = ep->dev;
> +
> +	dev_dbg(&dev->pdev->dev, "%s: ep%d%s", __func__, ep->num,
> +		(ep->in ? "in" : "out"));
> +	if (dir) {	/* IN ep */
> +		PCH_UDC_BIT_SET(ep->dev, ep->offset_addr + UDC_EPCTL_ADDR,
> +				UDC_EPCTL_F);
> +		return;
> +	} else {

Drop "else", "{" ... "}" and indention.

> +		if (pch_udc_read_ep_status(ep) & UDC_EPSTS_MRXFIFO_EMP)
> +			return;
> +		PCH_UDC_BIT_SET(ep->dev, ep->offset_addr + UDC_EPCTL_ADDR,
> +				UDC_EPCTL_MRXFLUSH);
> +		/* Wait for RxFIFO Empty */
> +		while ((pch_udc_read_ep_status(ep) &
> +			UDC_EPSTS_MRXFIFO_EMP) == 0) {
> +			if (loopcnt++ > 1000000) {
> +				dev_dbg(&dev->pdev->dev, "RxFIFO not Empty "
> +					"loop count = %d", loopcnt);
> +				break;
> +			}
> +			udelay(100);
> +		}
> +		PCH_UDC_BIT_CLR(ep->dev, ep->offset_addr + UDC_EPCTL_ADDR,
> +				UDC_EPCTL_MRXFLUSH);
> +	}
> +}

> +static void pch_udc_init(struct pch_udc_dev *dev)
> +{
[...]
> +	/* enable dynamic CSR programmingi, self powered and device speed */
> +	if (speed_fs) {
> +		PCH_UDC_BIT_SET(dev, UDC_DEVCFG_ADDR, UDC_DEVCFG_CSR_PRG |
> +				UDC_DEVCFG_SP | UDC_DEVCFG_SPD_FS);
> +	} else { /* defaul high speed */
> +		PCH_UDC_BIT_SET(dev, UDC_DEVCFG_ADDR, UDC_DEVCFG_CSR_PRG |
> +				UDC_DEVCFG_SP | UDC_DEVCFG_SPD_HS);
> +	}

Useless "{ ... }".

[...]
> +}

> +static int pch_udc_pcd_pullup(struct usb_gadget *gadget, int is_on)
> +{
> +	struct pch_udc_dev	*dev;
> +
> +	if (gadget == NULL) {
> +		pr_debug("%s: exit -EINVAL", __func__);
> +		return -EINVAL;
> +	}
> +	dev = container_of(gadget, struct pch_udc_dev, gadget);
> +	if (is_on == 0)
> +		pch_udc_set_disconnect(dev);
> +	else
> +		pch_udc_clear_disconnect(dev);
> +	return 0;

You can use pch_udc_vbus_session() here.

> +}

> +static int pch_udc_pcd_vbus_draw(struct usb_gadget *gadget, unsigned int mA)
> +{
> +	if ((gadget == NULL) || (mA > 250)) { /* Max is 250 in 2mA unit */
> +		pr_debug("%s: exit -EINVAL", __func__);
> +		return -EINVAL;
> +	}
> +	/* Could not find any regs where we can set the limit	*/
> +	return -EOPNOTSUPP;
> +}

Wouldn't it be easier to just always return -EOPNOTSUPP?

> +const struct usb_gadget_ops pch_udc_ops = {

Why not static?

> +	.get_frame = pch_udc_pcd_get_frame,
> +	.wakeup = pch_udc_pcd_wakeup,
> +	.set_selfpowered = pch_udc_pcd_selfpowered,
> +	.pullup = pch_udc_pcd_pullup,
> +	.vbus_session = pch_udc_pcd_vbus_session,
> +	.vbus_draw = pch_udc_pcd_vbus_draw,
> +};

> +static void complete_req(struct pch_udc_ep *ep, struct pch_udc_request *req,
> +								 int status)
> +{

> +	if (req->dma_mapped) {
> +		if (ep->in) {
> +			pci_unmap_single(dev->pdev, req->req.dma,
> +					 req->req.length, PCI_DMA_TODEVICE);
> +		} else {
> +			pci_unmap_single(dev->pdev, req->req.dma,
> +					 req->req.length, PCI_DMA_FROMDEVICE);
> +		}

Useless "{ ... }".

> +		req->dma_mapped = 0;
> +		req->req.dma = DMA_ADDR_INVALID;
> +	}

> +}
> +
> +/**
> + * empty_req_queue() - This API empties the request queue of an endpoint
> + * @ep:		Reference to the endpoint structure
> + */
> +static void empty_req_queue(struct pch_udc_ep *ep)
> +{
> +	struct pch_udc_request	*req;
> +
> +	ep->halted = 1;
> +	while (!list_empty(&ep->queue)) {
> +		req = list_entry(ep->queue.next, struct pch_udc_request, queue);
> +		pr_debug("%s: complete_req  ep%d%s", __func__, ep->num,
> +			  (ep->in ? "in" : "out"));
> +		complete_req(ep, req, -ESHUTDOWN);

complete_req() removes from list, right? I think it's worth adding a comment.

> +	}
> +}


> +static int pch_udc_create_dma_chain(struct pch_udc_ep *ep,
> +				     struct pch_udc_request *req,
> +				     unsigned long buf_len,
> +				     gfp_t gfp_flags)
> +{

> +	for (i = buf_len; i < bytes; i += buf_len) {
> +		dma_addr = DMA_ADDR_INVALID;
> +		/* create or determine next desc. */
> +		td = pci_pool_alloc(ep->dev->data_requests, gfp_flags,
> +				    &dma_addr);
> +		if (td == NULL)
> +			return -ENOMEM;
> +
> +		td->status = 0;
> +		td->dataptr = req->req.dma + i; /* assign buffer */
> +
> +		if ((bytes - i) >= buf_len) {
> +			txbytes = buf_len;
> +		} else { /* short packet */
> +			txbytes = bytes - i;
> +		}

Useless "{ ... }".

> +static int prepare_dma(struct pch_udc_ep *ep, struct pch_udc_request *req,
> +			  gfp_t gfp)
> +{

> +	/* Allocate and create a DMA chain */
> +	retval = pch_udc_create_dma_chain(ep, req, ep->ep.maxpacket, gfp);
> +	if (retval) {
> +		if (retval == -ENOMEM)
> +			pr_err("%s: Out of DMA memory", __func__);
> +		return retval;
> +	}
> +	if (ep->in) {
> +		if (req->req.length <= ep->ep.maxpacket) {
> +			/* write tx bytes */
> +			req->td_data->status = PCH_UDC_DMA_LAST |
> +					       PCH_UDC_BS_HST_BSY |
> +					       req->req.length;
> +		}

Useless "{ ... "}".

> +/**
> + * process_zlp() - This function process zero length packets
> + *			from the gadget driver
> + * @ep:		Reference to the endpoint structure
> + * @req:	Reference to the request
> + */
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
> +	 *then set CSR_DONE
             ^ missing space.


> +	 */

> +	/* setup command is ACK'ed now by zlp */
> +	if (!dev->stall) {
> +		if (dev->waiting_zlp_ack) {

Join both ifs into a single if with &&.

> +			/* clear NAK by writing CNAK in EP0_IN */
> +			pch_udc_ep_clear_nak(&(dev->ep[UDC_EP0IN_IDX]));
> +			dev->waiting_zlp_ack = 0;
> +		}
> +	}
> +}
> +
> +/**
> + * pch_udc_start_rxrequest() - This function starts the receive requirement.
> + * @ep:		Reference to the endpoint structure
> + * @req:	Reference to the request structure
> + */
> +static void pch_udc_start_rxrequest(struct pch_udc_ep *ep,
> +					 struct pch_udc_request *req)
> +{
> +	struct pch_udc_data_dma_desc *td_data;
> +
> +	pch_udc_clear_dma(ep->dev, DMA_DIR_RX);
> +	td_data = req->td_data;
> +	ep->td_data = req->td_data;
> +	/* Set the status bits for all descriptors */
> +	while (1) {
> +		td_data->status = (td_data->status & ~PCH_UDC_BUFF_STS) |
> +				    PCH_UDC_BS_HST_RDY;
> +		if ((td_data->status & PCH_UDC_DMA_LAST) ==  PCH_UDC_DMA_LAST)
> +			break;
> +
> +		td_data = (struct pch_udc_data_dma_desc *) \
> +			   phys_to_virt(td_data->next);

Useless cast.  phys_to_virt() returns void*.

> +	}

> +		if (ep->in) {
> +			usbreq->dma = pci_map_single(dev->pdev, usbreq->buf,
> +					usbreq->length, PCI_DMA_TODEVICE);
> +		} else {
> +			usbreq->dma = pci_map_single(dev->pdev, usbreq->buf,
> +					usbreq->length, PCI_DMA_FROMDEVICE);
> +		}

Useless "{ ... }".

> +static void pch_udc_complete_transfer(struct pch_udc_ep *ep)
> +{
> +	struct pch_udc_request *req;
> +	struct pch_udc_dev *dev = ep->dev;
> +
> +	if (list_empty(&ep->queue))
> +		return;
> +
> +	dev_dbg(&dev->pdev->dev, "%s: list_entry", __func__);
> +	req = list_entry(ep->queue.next, struct pch_udc_request, queue);
> +	if (!req)
> +		return;

This can never happen.  list_head's next is never set to NULL.  Moreover,
you already check if the queue is not empty a few lines above.

> +	if ((req->td_data_last->status & PCH_UDC_BUFF_STS) !=
> +						PCH_UDC_BS_DMA_DONE)
> +		return;
> +
> +#ifdef DMA_PPB_WITH_DESC_UPDATE
> +	for (i = 0; i < req->chain_len; i++) {

> +		req->td_data = (struct pch_udc_data_dma_desc *)
> +				 phys_to_virt(req->td_data->next);

Useless cast.

> +	}
> +#else

> +#endif

> +static void pch_udc_complete_receiver(struct pch_udc_ep *ep)
> +{
> +	struct pch_udc_request *req;
> +	struct pch_udc_dev *dev = ep->dev;
> +	unsigned int count;
> +
> +	if (list_empty(&ep->queue))
> +		return;
> +
> +	/* next request */
> +	req = list_entry(ep->queue.next, struct pch_udc_request, queue);
> +	if (!req || (req->td_data_last->status & PCH_UDC_BUFF_STS) !=
> +						PCH_UDC_BS_DMA_DONE) {
> +#ifdef DMA_PPB_WITH_DESC_UPDATE
> +		dev_dbg(&dev->pdev->dev, "%s: ep%d%s  DMA not Done",
> +			__func__, ep->num, (ep->in ? "in" : "out"));
> +		pch_udc_ep_set_rrdy(ep);
> +#endif
> +		return;
> +	}
> +	dev_dbg(&dev->pdev->dev, "%s: ep%d%s  DMA Done", __func__, ep->num,
> +		 (ep->in ? "in" : "out"));
> +	/* Disable DMA */
> +	pch_udc_clear_dma(ep->dev, DMA_DIR_RX);
> +#ifdef DMA_PPB_WITH_DESC_UPDATE
> +{

This should be indented.

> +	/* Get Rx bytes */
> +	struct pch_udc_data_dma_desc *td_data = req->td_data;
> +	for (i = 0, count = 0; i < req->chain_len; i++) {
> +		if ((td_data->status & PCH_UDC_RXTX_STS) != PCH_UDC_RTS_SUCC) {
> +			dev_err(&dev->pdev->dev, "Invalid RXTX status (0x%08x) "
> +				"epstatus=0x%08x\n",
> +				(td_data->status & PCH_UDC_RXTX_STS),
> +				(int)(ep->epsts));
> +			return;
> +		}
> +		count += td_data->status & PCH_UDC_RXTX_BYTES;
> +		td_data =
> +		  (struct pch_udc_data_dma_desc *) phys_to_virt(td_data->next);

Useless cast.
> +	}
> +}
> +#else

> +#endif

> +/**
> + * pch_udc_svc_data_out() - Handles interrupts from OUT endpoint
> + * @dev:	Reference to the device structure
> + * @ep_num:	Endpoint that generated the interrupt
> + */
> +static void pch_udc_svc_data_out(struct pch_udc_dev *dev, int ep_num)
> +{
> +	u32			epsts;
> +	struct pch_udc_ep		*ep;
> +	struct pch_udc_request		*req = NULL;
> +
> +	ep = &dev->ep[2*ep_num + 1];
> +	epsts = ep->epsts;
> +	ep->epsts = 0;
> +
> +	dev_dbg(&dev->pdev->dev, "%s: enter  ep%d%s status = 0x%08x", __func__,
> +		ep->num, (ep->in ? "in" : "out"), epsts);
> +	if (epsts & UDC_EPSTS_BNA) { /* Just log it; only in DMA mode */
> +		if (!list_empty(&ep->queue)) {

Those two ifs can be joined into one with &&.

[...]
> +		}
> +	}

> +}
> +
> +/**
> + * pch_udc_svc_control_in() - Handle Control IN endpoint interrupts
> + * @dev:	Reference to the device structure
> + */
> +static void pch_udc_svc_control_in(struct pch_udc_dev *dev)
> +{

> +	if (epsts & UDC_EPSTS_TXEMPTY) { /* Tx empty */
> +		dev_dbg(&dev->pdev->dev, "%s: TXEMPTY", __func__);
> +	}

Useless "{ ... }".

> +}
> +
> +/**
> + * pch_udc_svc_control_out() - Routine that handle Control
> + *					OUT endpoint interrupts
> + * @dev:	Reference to the device structure
> + */
> +static void pch_udc_svc_control_out(struct pch_udc_dev *dev)
> +{
> +	u32	stat;
> +	int setup_supported;
> +	struct pch_udc_ep	*ep;
> +
> +	ep = &dev->ep[UDC_EP0OUT_IDX];
> +	stat = ep->epsts;
> +	ep->epsts = 0;
> +
> +	if (stat & UDC_EPSTS_BNA)
> +		dev_dbg(&dev->pdev->dev, "%s: EP0: BNA", __func__);
> +		/* When we get a request, we will populate the descriptors. */
> +		/* Anything else to do? */
> +	/* If setup data */
> +	if (((stat & UDC_EPSTS_OUT_MASK) >> UDC_EPSTS_OUT_OFS) ==
> +	    UDC_EPSTS_OUT_SETUP) {
> +		dev->stall = 0;
> +		dev->ep[UDC_EP0IN_IDX].halted = 0;
> +		dev->ep[UDC_EP0OUT_IDX].halted = 0;
> +		/* In data not ready */
> +		pch_udc_ep_set_nak(&(dev->ep[UDC_EP0IN_IDX]));
> +		dev->setup_data.data[0] = ep->td_stp->data12;
> +		dev->setup_data.data[1] = ep->td_stp->data34;
> +		dev_dbg(&dev->pdev->dev, "%s: EP0 setup data12: 0x%x "
> +			"data34:0x%x", __func__, ep->td_stp->data12,
> +			ep->td_stp->data34);
> +		pch_udc_init_setup_buff(ep->td_stp);
> +		pch_udc_clear_dma(dev, DMA_DIR_TX);
> +		pch_udc_ep_fifo_flush(&(dev->ep[UDC_EP0IN_IDX]),
> +				      dev->ep[UDC_EP0IN_IDX].in);
> +		if ((dev->setup_data.request.bRequestType & USB_DIR_IN) != 0) {
> +			dev->gadget.ep0 = &dev->ep[UDC_EP0IN_IDX].ep;
> +		} else { /*	OUT */
> +			dev->gadget.ep0 = &ep->ep;
> +		}

Useless "{ ... }".

> +static void pch_udc_dev_isr(struct pch_udc_dev *dev, u32 dev_intr)
> +{
[...]
> +	/* RWKP interrupt */
> +	if (dev_intr & UDC_DEVINT_RWKP)
> +		dev_dbg(&dev->pdev->dev, "RWKP");
> +

Useless empty line.

> +}

> +static void pch_udc_pcd_reinit(struct pch_udc_dev *dev)
> +{
> +	static const char *ep_string[] = {

Why not static "const char *const ep_string[]"?

> +		ep0_string, "ep0out", "ep1in", "ep1out", "ep2in", "ep2out",
> +		"ep3in", "ep3out", "ep4in", "ep4out", "ep5in", "ep5out",
> +		"ep6in", "ep6out", "ep7in", "ep7out", "ep8in", "ep8out",
> +		"ep9in", "ep9out", "ep10in", "ep10out", "ep11in", "ep11out",
> +		"ep12in", "ep12out", "ep13in", "ep13out", "ep14in", "ep14out",
> +		"ep15in", "ep15out",
> +	};

> +}

Also, please run checkpatch.pl on the patch.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
