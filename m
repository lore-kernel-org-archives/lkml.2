Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0IMEX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 00:23:58 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:35679 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762Ab0IMEXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 00:23:54 -0400
Message-ID: <000a01cb52fb$78fc2310$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Maurus Cuelenaere" <mcuelenaere@gmail.com>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Peter Korsgaard" <peter.korsgaard@barco.com>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "Michal Nazarewicz" <m.nazarewicz@samsung.com>,
        "linux-usb" <linux-usb@vger.kernel.org>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Fabien Chouteau" <fabien.chouteau@barco.com>,
        "david Brownell" <dbrownell@users.sourceforge.net>,
        "Christoph Egger" <siccegge@stud.informatik.uni-erlangen.de>,
        "LKML" <linux-kernel@vger.kernel.org>, "MeeGo" <meego-dev@meego.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Andrew" <andrew.chih.howe.khor@intel.com>,
        "Intel OTC" <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Arjan" <arjan@linux.intel.com>,
        "Toshiharu Okada" <okada533@dsn.okisemi.com>,
        "Takahiro Shimizu" <shimizu394@dsn.okisemi.com>,
        "Tomoya Morinaga" <morinaga526@dsn.okisemi.com>
References: <4C85EE6F.6000706@dsn.okisemi.com> <AANLkTikSb-16eACaR16Uh2c7K=2yT3e+Vna=Z2Tt-x=6@mail.gmail.com>
Subject: Re: [PATCH] USB device driver of Topcliff PCH
Date: Mon, 13 Sep 2010 13:23:21 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maurus

My reply comments are included in the following.
I will resubmit after modified

Thanks Ohtake

From: Maurus Cuelenaere <mcuelenaere@gmail.com>
Date: Tue, 7 Sep 2010 14:53:05 +0200
> 2010/9/7 Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> >
> > This patch adds the USB device driver of Topcliff PCH.
> > Topcliff PCH is the platform controller hub that is going to be used in
> > Intel's upcoming general embedded platform. All IO peripherals in
> > Topcliff PCH are actually devices sitting on AMBA bus.
> > Topcliff PCH has USB device I/F. Using this I/F, it is able to access system
> > devices connected to USB device.
> >
> > Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>
> No need to mail all these people, just the maintainers and appropriate mailing
> lists will do.

[masa]
I have question. Please tell me.
Whom should I submit patch to?
 TO: LKML and maintainers
Is it correct?

The maintainer was got the following scripts.
"./scripts/get_maintainer.pl"


>
> > ---
> > drivers/usb/gadget/Kconfig | 24 +
> > drivers/usb/gadget/Makefile | 2 +-
> > drivers/usb/gadget/gadget_chips.h | 7 +
> > drivers/usb/gadget/pch_udc.c | 3153 +++++++++++++++++++++++++++++++++++++
> > drivers/usb/gadget/pch_udc.h | 495 ++++++
> > 5 files changed, 3680 insertions(+), 1 deletions(-)
> > create mode 100755 drivers/usb/gadget/pch_udc.c
> > create mode 100755 drivers/usb/gadget/pch_udc.h
> >
> [snip]
> > diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
> > new file mode 100755
> > index 0000000..2065c11
> > --- /dev/null
> > +++ b/drivers/usb/gadget/pch_udc.c
> [snip]
> > +
> > +const char ep0_string[] = "ep0in";
> > +static DEFINE_SPINLOCK(udc_stall_spinlock); /* stall spin lock */
> > +static u32 pch_udc_base;
> > +static union pch_udc_setup_data setup_data; /* received setup data */
> > +static unsigned long ep0out_buf[64];
> > +static dma_addr_t dma_addr;
> > +struct pch_udc_dev *pch_udc; /* pointer to device object */
> > +int speed_fs;
>
> I'd put all these in struct phc_udc_dev or similar, so you could have multiple
> controllers.

[masa]
This will be modified.

>
> > +
> > +module_param_named(speed_fs, speed_fs, bool, S_IRUGO);
> > +MODULE_PARM_DESC(speed_fs, "true for Full speed operation");
> > +MODULE_DESCRIPTION("OKISEMI PCH UDC - USB Device Controller");
> > +MODULE_LICENSE("GPL");
> > +
> > +/**
> > + * pch_udc_write_csr - Write the command and status registers.
> > + * @val: value to be written to CSR register
> > + * @addr: address of CSR register
> > + */
> > +inline void pch_udc_write_csr(unsigned long val, unsigned long addr)
>
> Make all these functions static.

[masa]
This will be modified.

>
> > +{
> > + int count = MAX_LOOP;
> > +
> > + /* Wait till idle */
> > + while ((count > 0) &&\
> > + (ioread32((u32 *)(PCH_UDC_CSR_BUSY_ADDR + pch_udc_base)) &
> > + PCH_UDC_CSR_BUSY))
>
> Why not define PCH_UDC_* as (void __iomem*) so no casting is necessary.

[masa]
This will be modified.

>
> > + count--;
> > +
> > + if (count < 0)
> > + pr_debug("%s: wait error; count = %x", __func__, count);
> > +
> > + iowrite32(val, (u32 *)addr);
> > + /* Wait till idle */
> > + count = MAX_LOOP;
> > + while ((count > 0) &&
> > + (ioread32((u32 *)(PCH_UDC_CSR_BUSY_ADDR + pch_udc_base)) &
> > + PCH_UDC_CSR_BUSY))
> > + count--;
> > +
> > + if (count < 0)
> > + pr_debug("%s: wait error; count = %x", __func__, count);
> > +
> > +}
> > +
> > +/**
> > + * pch_udc_read_csr - Read the command and status registers.
> > + * @addr: address of CSR register
> > + * Returns
> > + * content of CSR register
> > + */
> > +inline u32 pch_udc_read_csr(unsigned long addr)
>
> void __iomem *addr

[masa]
This will be modified.

>
> > +{
> > + int count = MAX_LOOP;
> > +
> > + /* Wait till idle */
> > + while ((count > 0) &&
> > + (ioread32((u32 *)(PCH_UDC_CSR_BUSY_ADDR + pch_udc_base)) &
> > + PCH_UDC_CSR_BUSY))
> > + count--;
> > +
> > + if (count < 0)
> > + pr_debug("%s: wait error; count = %x", __func__, count);
> > + /* Dummy read */
> > + ioread32((u32 *)addr);
> > + count = MAX_LOOP;
> > + /* Wait till idle */
> > + while ((count > 0) &&
> > + (ioread32((u32 *)(PCH_UDC_CSR_BUSY_ADDR + pch_udc_base)) &
> > + PCH_UDC_CSR_BUSY))
> > + count--;
> > + /* actual read */
> > + if (count < 0)
> > + pr_debug("%s: wait error; count = %x", __func__, count);
> > +
> > + return ioread32((u32 *)addr);
> > +}
> > +
> > +/**
> > + * pch_udc_rmt_wakeup - Initiate for remote wakeup
> > + * @dev: Reference to pch_udc_regs structure
> > + */
> > +inline void pch_udc_rmt_wakeup(struct pch_udc_regs *dev)
> > +{
> > + PCH_UDC_BIT_SET(&dev->devctl, 1 << UDC_DEVCTL_RES);
> > + mdelay(1);
> > + PCH_UDC_BIT_CLR(&dev->devctl, 1 << UDC_DEVCTL_RES);
> > +}
> > +
> > +/**
> > + * pch_udc_get_frame - Get the current frame from device status register
> > + * @dev: Reference to pch_udc_regs structure
> > + * Retern current frame
> > + */
> > +inline int pch_udc_get_frame(struct pch_udc_regs *dev)
> > +{
> > + u32 frame;
> > +
> > + frame = ioread32(&dev->devsts);
>
> Why not just get rid of struct pch_udc_regs and do something like:
>
> static inline u32 pch_readl(struct pch_udc_dev *dev, unsigned long reg)
> {
> return ioread32(dev->base_addr + reg);
> }
>
> (and similar for pch_writel)

[masa]
This will be modified.

>
> > + return (frame & UDC_DEVSTS_TS_MASK) >> UDC_DEVSTS_TS_OFS;
> > +}
> [snip]
> > +static struct usb_request *pch_udc_alloc_request(struct usb_ep *usbep,
> > + gfp_t gfp)
> > +{
> > + struct pch_udc_request *req;
> > + struct pch_udc_ep *ep;
> > +
> > + pr_debug("%s: enter", __func__);
> > + if (usbep == NULL)
> > + return NULL;
> > +
> > + ep = container_of(usbep, struct pch_udc_ep, ep);
> > + pr_debug("%s: ep %s", __func__, usbep->name);
> > + req = kzalloc(sizeof(struct pch_udc_request), gfp);
> > + if (req == NULL) {
> > + pr_debug("%s: no memory for request", __func__);
> > + return NULL;
> > + }
> > + memset(req, 0, sizeof(struct pch_udc_request));
>
> kzalloc does this..

[masa]
memset() is removed

>
> > + req->req.dma = DMA_ADDR_INVALID;
> > + INIT_LIST_HEAD(&req->queue);
> > +
> > + if (ep->dma != NULL) {
> > + struct pch_udc_data_dma_desc *dma_desc;
> > +
> > + /* ep0 in requests are allocated from data pool here */
> > + dma_desc = pci_pool_alloc(ep->dev->data_requests, gfp,
> > + &req->td_data_phys);
> > + if (NULL == dma_desc) {
> > + kfree(req);
> > + return NULL;
> > + }
> > +
> > + pr_debug("%s: req = 0x%p dma_desc = 0x%p, "
> > + "td_phys = 0x%08lx", __func__,
> > + req, dma_desc, (unsigned long)req->td_data_phys);
> > +
> > + /* prevent from using desc. - set HOST BUSY */
> > + dma_desc->status |= PCH_UDC_BS_HST_BSY;
> > + dma_desc->dataptr = __constant_cpu_to_le32(DMA_ADDR_INVALID);
> > + req->td_data = dma_desc;
> > + req->td_data_last = dma_desc;
> > + req->chain_len = 1;
> > + }
> > + return &req->req;
> > +}
> [snip]
> > +
> > +/**
> > + * pch_udc_start_next_txrequest - This function starts
> > + * the next transmission requirement
> > + * @ep: Reference to the endpoint structure
> > + */
> > +static void pch_udc_start_next_txrequest(struct pch_udc_ep *ep)
> > +{
> > + struct pch_udc_request *req;
> > +
> > + pr_debug("%s: enter", __func__);
> > + if (pch_udc_read_ep_control(ep->regs) & (1 << UDC_EPCTL_P))
> > + return;
> > +
> > + if (!list_empty(&ep->queue)) {
>
> Convert this into:
> if (list_empty(&ep->queue))
> return;
>
> That way you get rid of the unnecessary spacing below

[masa]
This will be modified.

>
> > + /* next request */
> > + req = list_entry(ep->queue.next, struct pch_udc_request, queue);
> > + if (req && !req->dma_going) {
> > + pr_debug("%s: Set request: req=%p req->td_data=%p",
> > + __func__, req, req->td_data);
> > + if (req->td_data) {
> > + struct pch_udc_data_dma_desc *td_data;
> > +
> > + while (pch_udc_read_ep_control(ep->regs) &
> > + (1 << UDC_EPCTL_S))
> > + udelay(100);
> > +
> > + req->dma_going = 1;
> > + /* Clear the descriptor pointer */
> > + pch_udc_ep_set_ddptr(ep->regs, 0);
> > +
> > + td_data = req->td_data;
> > + while (1) {
> > + td_data->status = (td_data->status &
> > + ~PCH_UDC_BUFF_STS) |
> > + PCH_UDC_BS_HST_RDY;
> > + if ((td_data->status &
> > + PCH_UDC_DMA_LAST) ==
> > + PCH_UDC_DMA_LAST)
> > + break;
> > +
> > + td_data =
> > + (struct pch_udc_data_dma_desc *)\
> > + phys_to_virt(td_data->next);
> > + }
> > + /* Write the descriptor pointer */
> > + pch_udc_ep_set_ddptr(ep->regs,
> > + req->td_data_phys);
> > + pch_udc_set_dma(ep->dev->regs, DMA_DIR_TX);
> > + /* Set the poll demand bit */
> > + pch_udc_ep_set_pd(ep->regs);
> > + pch_udc_enable_ep_interrupts(ep->dev->regs,
> > + 1 << (ep->in ? ep->num :\
> > + ep->num + UDC_EPINT_OUT_EP0));
> > + pch_udc_ep_clear_nak(ep->regs);
> > + }
> > + }
> > + }
> > +}
> > +
> > +/**
> > + * pch_udc_complete_transfer - This function completes a transfer
> > + * @ep: Reference to the endpoint structure
> > + */
> > +static void pch_udc_complete_transfer(struct pch_udc_ep *ep)
> > +{
> > + struct pch_udc_request *req;
> > +
> > + pr_debug("%s: enter", __func__);
> > + if (!list_empty(&ep->queue)) {
>
> Same here

[masa]
This will be modified.

>
> > + pr_debug("%s: list_entry", __func__);
> > + req = list_entry(ep->queue.next, struct pch_udc_request, queue);
> > + if (req && ((req->td_data_last->status & PCH_UDC_BUFF_STS) ==
> > + PCH_UDC_BS_DMA_DONE)) {
> > +#ifdef DMA_PPB_WITH_DESC_UPDATE
> > + struct pch_udc_data_dma_desc *td_data = req->td_data;
> > + for (i = 0; i < req->chain_len; i++) {
> > + if ((td_data->status & PCH_UDC_RXTX_STS) !=
> > + PCH_UDC_RTS_SUCC) {
> > + pr_err("Invalid RXTX status (0x%08x)"
> > + " epstatus=0x%08x\n",
> > + (td_data->status &
> > + PCH_UDC_RXTX_STS),
> > + (int)(ep->epsts));
> > + return;
> > + }
> > + td_data = (struct pch_udc_data_dma_desc *)
> > + phys_to_virt(td_data->next);
> > + }
> > +#else
> > + if ((req->td_data_last->status & PCH_UDC_RXTX_STS) !=
> > + PCH_UDC_RTS_SUCC) {
> > + pr_err("Invalid RXTX status (0x%08x)"
> > + " epstatus=0x%08x\n",
> > + (req->td_data_last->status &
> > + PCH_UDC_RXTX_STS),
> > + (int)(ep->epsts));
> > + return;
> > + }
> > +#endif
> > + req->req.actual = req->req.length;
> > + req->td_data_last->status = PCH_UDC_BS_HST_BSY |
> > + PCH_UDC_DMA_LAST;
> > + req->td_data->status = PCH_UDC_BS_HST_BSY |
> > + PCH_UDC_DMA_LAST;
> > + /* complete req */
> > + complete_req(ep, req, 0);
> > + req->dma_going = 0;
> > + if (!list_empty(&ep->queue)) {
> > + while (pch_udc_read_ep_control(ep->regs) &
> > + (1 << UDC_EPCTL_S))
> > + udelay(100);
> > +
> > + pch_udc_ep_clear_nak(ep->regs);
> > + pch_udc_enable_ep_interrupts(ep->dev->regs,
> > + 1 << (ep->in ? ep->num : ep->num +
> > + UDC_EPINT_OUT_EP0));
> > + } else {
> > + pch_udc_disable_ep_interrupts(ep->dev->regs,
> > + 1 << (ep->in ? ep->num : ep->num +
> > + UDC_EPINT_OUT_EP0));
> > + }
> > + }
> > + }
> > +}
> [snip]
> > +
> > +/**
> > + * pch_udc_svc_enum_interrupt - This function handles a USB speed enumeration
> > + * done interrupt
> > + * @dev: Reference to driver structure
> > + */
> > +void
> > +pch_udc_svc_enum_interrupt(struct pch_udc_dev *dev)
> > +{
> > + u32 dev_stat, dev_speed;
> > + u32 speed = USB_SPEED_FULL;
> > +
> > + pr_debug("%s: enter", __func__);
> > + dev_stat = pch_udc_read_device_status(dev->regs);
> > + dev_speed = (dev_stat & UDC_DEVSTS_ENUM_SPEED_MASK) >>
> > + UDC_DEVSTS_ENUM_SPEED_OFS;
> > +
> > + pr_debug("%s: dev_speed = 0x%08x", __func__, dev_speed);
> > +
> > + if (dev_speed == UDC_DEVSTS_ENUM_SPEED_HIGH) {
> > + pr_debug("HighSpeed");
> > + speed = USB_SPEED_HIGH;
> > + } else if (dev_speed == UDC_DEVSTS_ENUM_SPEED_FULL) {
> > + pr_debug("FullSpeed");
> > + speed = USB_SPEED_FULL;
> > + } else if (dev_speed == UDC_DEVSTS_ENUM_SPEED_LOW) {
> > + pr_debug("LowSpeed?");
> > + speed = USB_SPEED_LOW;
> > + } else {
> > + pr_debug("FullSpeed?");
>
> BUG() perhaps? Also, change this into a switch statement

[masa]
This will be modified.


>
> > + }
> > + dev->gadget.speed = speed;
> > +
> > + pch_udc_activate_control_ep(dev);
> > +
> > + /* enable ep0 interrupts */
> > + pch_udc_enable_ep_interrupts(dev->regs, 1 << UDC_EPINT_IN_EP0 |
> > + 1 << UDC_EPINT_OUT_EP0);
> > + /* enable DMA */
> > + pch_udc_set_dma(dev->regs, DMA_DIR_TX);
> > + pch_udc_set_dma(dev->regs, DMA_DIR_RX);
> > + pch_udc_ep_set_rrdy(dev->ep[UDC_EP0OUT_IDX].regs);
> > +
> > +
> > + pr_debug("%s: EP mask set to %x", __func__,
> > + ioread32(&dev->regs->epirqmsk));
> > +}
> [snip]
> > +
> > +int pch_udc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> > +{
> > + unsigned long resource;
> > + unsigned long len;
> > + int retval = 0;
> > + struct pch_udc_dev *dev;
> > +
> > + dev_dbg(&pdev->dev, "%s: enter", __func__);
> > + /* one udc only */
> > + if (pch_udc != NULL) {
> > + dev_err(&pdev->dev, "%s: already probed", __func__);
> > + return -EBUSY;
> > + }
> > +
> > + /* init */
> > + dev = kzalloc(sizeof(struct pch_udc_dev), GFP_KERNEL);
> > + if (dev == NULL) {
> > + dev_err(&pdev->dev, "%s: no memory for device structure",
> > + __func__);
> > + return -ENOMEM;
> > + }
> > + memset(dev, 0, sizeof(struct pch_udc_dev));
>
> kzalloc already does this for you

[masa]
memset is removed.

>
> > + /* pci setup */
> > + if (pci_enable_device(pdev) < 0) {
> > + kfree(dev);
> > + dev_err(&pdev->dev, "%s: pci_enable_device failed", __func__);
> > + return -ENODEV;
> > + }
> > + dev->active = 1;
> > + pci_set_drvdata(pdev, dev);
> > +
> > + /* PCI resource allocation */
> > + resource = pci_resource_start(pdev, 1);
> > + len = pci_resource_len(pdev, 1);
> > + dev_dbg(&pdev->dev, "%s: resource %lx, len %ld",
> > + __func__, resource, len);
> > +
> > + if (request_mem_region(resource, len, KBUILD_MODNAME) == NULL) {
> > + dev_err(&pdev->dev, "%s: pci device used already", __func__);
> > + retval = -EBUSY;
> > + goto finished;
> > + }
> > + dev->phys_addr = resource;
> > + dev->mem_region = 1;
> > +
> > + dev->virt_addr = ioremap_nocache(resource, len);
> > + if (dev->virt_addr == NULL) {
> > + dev_err(&pdev->dev, "%s: device memory cannot be mapped",
> > + __func__);
> > + retval = -ENOMEM;
> > + goto finished;
> > + }
> > + dev_dbg(&pdev->dev, "%s: device memory mapped at %x", __func__,
> > + (int)dev->virt_addr);
> > +
> > + if (pdev->irq == 0) {
> > + dev_err(&pdev->dev, "%s: irq not set", __func__);
> > + retval = -ENODEV;
> > + goto finished;
> > + }
> > +
> > + pch_udc = dev;
> > +
> > + /* initialize the hardware */
> > + if (pch_udc_pcd_init(dev) != 0)
> > + goto finished;
> > +
> > + if (request_irq(pdev->irq, pch_udc_isr, IRQF_SHARED,
> > + KBUILD_MODNAME, dev) != 0) {
> > + dev_err(&pdev->dev, "%s: request_irq(%d) fail", __func__,
> > + pdev->irq);
> > + retval = -ENODEV;
> > + goto finished;
> > + }
> > + dev->irq = pdev->irq;
> > + dev->irq_registered = 1;
> > +
> > + pci_set_master(pdev);
> > + pci_try_set_mwi(pdev);
> > +
> > + /* device struct setup */
> > + spin_lock_init(&dev->lock);
> > + dev->pdev = pdev;
> > + dev->gadget.ops = &pch_udc_ops;
> > +
> > + retval = init_dma_pools(dev);
> > + if (retval != 0)
> > + goto finished;
> > +
> > + dev_set_name(&dev->gadget.dev, "gadget");
> > + dev->gadget.dev.parent = &pdev->dev;
> > + dev->gadget.dev.dma_mask = pdev->dev.dma_mask;
> > + dev->gadget.dev.release = gadget_release;
> > + dev->gadget.name = KBUILD_MODNAME;
> > + dev->gadget.is_dualspeed = 1;
> > +
> > + retval = device_register(&dev->gadget.dev);
> > + if (retval != 0)
> > + goto finished;
> > + dev->registered = 1;
> > +
> > + /* Put the device in disconnected state till a driver is bound */
> > + pch_udc_set_disconnect(dev->regs);
> > + return 0;
> > +
> > +finished:
> > + pch_udc_remove(pdev);
> > + return retval;
> > +}
> > +
> > +static const struct pci_device_id pch_udc_pcidev_id[] = {
> > + {
> > + PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH1_UDC),
> > + .class = (PCI_CLASS_SERIAL_USB << 8) | 0xfe,
> > + .class_mask = 0xffffffff,
> > + },
> > + { 0 },
> > +};
> > +
> > +MODULE_DEVICE_TABLE(pci, pch_udc_pcidev_id);
> > +
> > +
> > +static struct pci_driver pch_udc_driver = {
> > + .name = KBUILD_MODNAME,
> > + .id_table = pch_udc_pcidev_id,
> > + .probe = pch_udc_probe,
> > + .remove = pch_udc_remove,
> > + .suspend = pch_udc_suspend,
> > + .resume = pch_udc_resume,
> > + .shutdown = pch_udc_shutdown,
>
> Make all these functions static

[masa]
This will be modified.

>
> > +};
> > +
> > +static int __init pch_udc_pci_init(void)
> > +{
> > + return pci_register_driver(&pch_udc_driver);
> > +}
> > +module_init(pch_udc_pci_init);
> > +
> > +static void __exit pch_udc_pci_exit(void)
> > +{
> > + pci_unregister_driver(&pch_udc_driver);
> > +}
> > +module_exit(pch_udc_pci_exit);
> > diff --git a/drivers/usb/gadget/pch_udc.h b/drivers/usb/gadget/pch_udc.h
> > new file mode 100755
> > index 0000000..55c22ef
> > --- /dev/null
> > +++ b/drivers/usb/gadget/pch_udc.h
> > @@ -0,0 +1,495 @@
> > +/*
> > + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
> > + */
> > +
> > +#ifndef _PCH_UDC_H_
> > +#define _PCH_UDC_H_
> > +
> > +/* Address offset of Registers */
> > +#define UDC_EPIN_REGS_ADDR 0x000
> > +#define UDC_EPOUT_REGS_ADDR 0x200
> > +#define UDC_EP_REG_OFS 0x20 /* Offset to next EP */
> > +#define UDC_DEVCFG_ADDR 0x400
> > +#define PCH_UDC_CSR_BUSY_ADDR 0x4f0
> > +#define PCH_UDC_SRST_ADDR 0x4fc
> > +#define UDC_CSR_ADDR 0x500
> > +
> > +/* Bit position in UDC CSR Busy status Register */
> > +#define PCH_UDC_CSR_BUSY 1
> > +/* Bit position in UDC Soft reset Register */
> > +#define PCH_UDC_PSRST 1
> > +#define PCH_UDC_SRST 0
> > +
> [snip]
> > +
> > +/**
> > + * pch_udc_csrs - Structure to Endpoint configuration registers
> > + */
> > +struct pch_udc_csrs {
> > + u32 ne[PCH_UDC_USED_EP_NUM * 2];
>
> Why not do away with the structs and do something like:
>
> #define PCH_UDC_CSR(ep) (UDC_CSR_ADDR + ep*4)
>
> (and similar for the others)

[masa]
This will be modified.

>
> > +/* Starting bit position */
> > +#define UDC_CSR_NE_NUM_OFS 0
> > +#define UDC_CSR_NE_DIR_OFS 4
> > +#define UDC_CSR_NE_TYPE_OFS 5
> > +#define UDC_CSR_NE_CFG_OFS 7
> > +#define UDC_CSR_NE_INTF_OFS 11
> > +#define UDC_CSR_NE_ALT_OFS 15
> > +#define UDC_CSR_NE_MAX_PKT_OFS 19
> > +/* Mask patern */
> > +#define UDC_CSR_NE_NUM_MASK 0x0000000f
> > +#define UDC_CSR_NE_DIR_MASK 0x00000010
> > +#define UDC_CSR_NE_TYPE_MASK 0x00000060
> > +#define UDC_CSR_NE_CFG_MASK 0x00000780
> > +#define UDC_CSR_NE_INTF_MASK 0x00007800
> > +#define UDC_CSR_NE_ALT_MASK 0x00078000
> > +#define UDC_CSR_NE_MAX_PKT_MASK 0x3ff80000
> > +};
> > +
> [snip]
> > +
> > +/**
> > + * pch_udc_request - Structure holding a PCH USB device request
> > + * @req embedded ep request
> > + * @td_data_phys phys. address
> > + * @td_data first dma desc. of chain
> > + * @td_data_last last dma desc. of chain
> > + * @queue associated queue
> > + * @dma_going DMA in progress for request
> > + * @dma_mapped DMA memory mapped for request
> > + * @dma_done DMA completed for request
> > + * @chain_len chain length
> > + */
> > +struct pch_udc_request /* request packet */
> > +{
>
> I don't see any reason to not put this in the main .c file?
> (same for struct pch_udc_{ep,request})

[masa]
This moves to main.c.

>
> > + struct usb_request req;
> > + dma_addr_t td_data_phys;
> > + struct pch_udc_data_dma_desc *td_data;
> > + struct pch_udc_data_dma_desc *td_data_last;
> > + struct list_head queue;
> > + unsigned dma_going:1,
> > + dma_mapped:1,
> > + dma_done:1;
> > + unsigned chain_len;
> > +};
> > +
> [snip]
> > +
> > +struct pch_udc_dev {
> > + struct usb_gadget gadget;
> > + struct usb_gadget_driver *driver;
> > + struct pci_dev *pdev;
> > + /* all endpoints */
> > + struct pch_udc_ep ep[PCH_UDC_EP_NUM];
> > + spinlock_t lock;
> > + unsigned active:1,
> > + stall:1,
> > + prot_stall:1,
> > + irq_registered:1,
> > + mem_region:1,
> > + registered:1,
> > + suspended:1,
> > + connected:1,
> > + set_cfg_not_acked:1,
> > + waiting_zlp_ack:1;
> > + struct pch_udc_csrs __iomem *csr;
> > + struct pch_udc_regs __iomem *regs;
> > + struct pch_udc_ep_regs __iomem *ep_regs;
>
> These pointers just seem unnecessary, especially as you could easily construct
> them in-place by adding the appropriate offset to your base address..

[masa]
This will be deleted.




