Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0INNWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 09:22:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43457 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab0INNWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 09:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=g83a/v0b/SfmHyhhb4w4271dt2FJZ+FmJAKyZ3LIkaEHmp4A6JYsY9F/xVwbEg9Xae
         +4LSL+oLx7QodZD5WqTRUH+7IIW+hRUX4NUXLPl+c+B6O7GgRVG9NVzciQ+5w4ZmGVcs
         8HfUDSU6j7r382KLOmuqBvIJRPt/1XpK1qp2c=
Message-ID: <4C8F7717.4040400@gmail.com>
Date: Tue, 14 Sep 2010 15:22:31 +0200
From: Maurus Cuelenaere <mcuelenaere@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; nl; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: linux-usb <linux-usb@vger.kernel.org>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Arjan <arjan@linux.intel.com>
Subject: Re: [PATCH v2] USB device driver of Topcliff PCH
References: <4C8F35BE.8000707@dsn.okisemi.com>
In-Reply-To: <4C8F35BE.8000707@dsn.okisemi.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Op 14-09-10 10:43, Masayuki Ohtake schreef:
> This patch adds the USB device driver of Topcliff PCH.
>
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus.
> Topcliff PCH has USB device I/F. Using this I/F, it is able to access system
> devices connected to USB device.
>
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> ---
> drivers/usb/gadget/Kconfig | 24 +
> drivers/usb/gadget/Makefile | 2 +-
> drivers/usb/gadget/gadget_chips.h | 7 +
> drivers/usb/gadget/pch_udc.c | 3412 +++++++++++++++++++++++++++++++++++++
> 4 files changed, 3444 insertions(+), 1 deletions(-)
> create mode 100755 drivers/usb/gadget/pch_udc.c

pch_udc.c is still executable..

[snip]
> +
> +/**
> + * pch_udc_write_csr() - Write the command and status registers.
> + * @val: value to be written to CSR register
> + * @addr: address of CSR register
> + */
> +static void pch_udc_write_csr(struct pch_udc_dev *dev, unsigned long val,
> + unsigned long reg)
> +{
> + unsigned int count = MAX_LOOP;
> +
> + /* Wait till idle */
> + while ((pch_udc_readl(dev, UDC_CSR_BUSY_ADDR) & UDC_CSR_BUSY)
> + && (count > 0))
> + count--;
> + if (!count)
> + dev_err(&dev->pdev->dev, "%s: wait error; count = %x",
> + __func__, count);

Moving this to pch_udc_wait_csr_busy() seems like a good idea

> + pch_udc_writel(dev, val, reg);
> + /* Wait till idle */
> + count = MAX_LOOP;
> + while ((pch_udc_readl(dev, UDC_CSR_BUSY_ADDR) & UDC_CSR_BUSY)
> + && (count > 0))
> + count--;
> + if (!count)
> + dev_err(&dev->pdev->dev, "%s: wait error; count = %x",
> + __func__, count);

Same here

> +}
> +
> +/**
> + * pch_udc_read_csr() - Read the command and status registers.
> + * @addr: address of CSR register
> + * Returns
> + * content of CSR register
> + */
> +static u32 pch_udc_read_csr(struct pch_udc_dev *dev, unsigned long reg)
> +{
> + unsigned int count = MAX_LOOP;
> +
> + /* Wait till idle */
> + while ((pch_udc_readl(dev, UDC_CSR_BUSY_ADDR) & UDC_CSR_BUSY)
> + && (count > 0))
> + count--;
> + if (!count)
> + dev_err(&dev->pdev->dev, "%s: wait error; count = %x",
> + __func__, count);

And here

> + /* Dummy read */
> + pch_udc_readl(dev, reg);
> + count = MAX_LOOP;
> + /* Wait till idle */
> + while ((pch_udc_readl(dev, UDC_CSR_BUSY_ADDR) & UDC_CSR_BUSY)
> + && (count > 0))
> + count--;
> + if (!count)
> + dev_err(&dev->pdev->dev, "%s: wait error; count = %x",
> + __func__, count);

And here

> + return pch_udc_readl(dev, reg);
> +}
> +
[snip]
> +static void pch_udc_ep_clear_nak(struct pch_udc_ep *ep)
> +{
> + unsigned int loopcnt = 0;
> + struct pch_udc_dev *dev = ep->dev;
> +
> + if (!(pch_udc_readl(ep->dev, ep->offset_addr + UDC_EPCTL_ADDR) &
> + UDC_EPCTL_NAK))
> + return;
> + if (!ep->in) {
> + while ((pch_udc_read_ep_status(ep) &
> + UDC_EPSTS_MRXFIFO_EMP) == 0) {
> + if (loopcnt++ > 100000) {
> + dev_dbg(&dev->pdev->dev, "%s: RxFIFO not Empty "
> + "loop count = %d", __func__, loopcnt);
> + break;
> + }
> + udelay(100);
> + }
> + }

Shouldn't you reinitialise loopcnt to 0 here?

> + while (pch_udc_readl(ep->dev, ep->offset_addr + UDC_EPCTL_ADDR) &
> + UDC_EPCTL_NAK) {
> + PCH_UDC_BIT_SET(ep->dev, ep->offset_addr + UDC_EPCTL_ADDR,
> + UDC_EPCTL_CNAK);
> + udelay(5);
> + if (loopcnt++ >= 25) {
> + dev_dbg(&dev->pdev->dev, "%s: Clear NAK not set "
> + "for ep%d%s: counter=%d", __func__, ep->num,
> + (ep->in ? "in" : "out"), loopcnt);
> + break;
> + }
> + }
> +}
> +
[snip]
> +static void pch_udc_ep_enable(struct pch_udc_ep *ep,
> + struct pch_udc_cfg_data *cfg,
> + const struct usb_endpoint_descriptor *desc)
> +{
> + struct pch_udc_dev *dev = ep->dev;
> + u32 val = 0;
> + u32 buff_size = 0;
> +
> + dev_dbg(&dev->pdev->dev, "%s: ep%x%s bmAttributes = %d wMaxPacketSize"
> + " = %d", __func__, ep->num, (ep->in ? "in" : "out"),
> + desc->bmAttributes, desc->wMaxPacketSize);
> + /* set traffic type */
> + pch_udc_ep_set_trfr_type(ep, desc->bmAttributes);
> + /* Set buff size */
> + if (ep->in)
> + buff_size = UDC_EPIN_BUFF_SIZE;
> + else
> + buff_size = UDC_EPOUT_BUFF_SIZE;
> +
> + pch_udc_ep_set_bufsz(ep, buff_size, ep->in);
> + /* Set max packet size */
> + pch_udc_ep_set_maxpkt(ep, le16_to_cpu(desc->wMaxPacketSize));
> + /* Set NAK */
> + pch_udc_ep_set_nak(ep);
> + /* Flush fifo */
> + pch_udc_ep_fifo_flush(ep, ep->in);
> + /* Configure the endpoint */
> + val = ep->num << UDC_CSR_NE_NUM_OFS | ep->in << UDC_CSR_NE_DIR_OFS |
> + ((desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) <<
> + UDC_CSR_NE_TYPE_OFS) |
> + (cfg->cur_cfg << UDC_CSR_NE_CFG_OFS) |
> + (cfg->cur_intf << UDC_CSR_NE_INTF_OFS) |
> + (cfg->cur_alt << UDC_CSR_NE_ALT_OFS) |
> + le16_to_cpu(desc->wMaxPacketSize) << UDC_CSR_NE_MAX_PKT_OFS;
> +
> + if (ep->in)
> + pch_udc_write_csr(ep->dev, val, (UDC_CSR_ADDR +
> + (ep->num * 2) * 4));
> + else
> + pch_udc_write_csr(ep->dev, val, (UDC_CSR_ADDR +
> + (ep->num * 2 + 1) * 4));

Why not reuse PCH_UDC_CSR() here?

Even better, why not change pch_udc_write_csr() to
pch_udc_write_csr(struct pch_udc_dev *dev, unsigned long val, int ep)
and do the PCH_UDC_CSR() calculation in the function itself?

> + dev_dbg(&dev->pdev->dev, "%s: Endpoint register = 0x%08x", __func__,
> + val);
> +}

--
Maurus Cuelenaere
