Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab0KKCW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 21:22:58 -0500
Received: from mail.perches.com ([173.55.12.10]:4961 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab0KKCW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 21:22:57 -0500
Subject: Re: [PATCH v10] USB device driver of Topcliff PCH
From: Joe Perches <joe@perches.com>
To: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, "Wang, Qi" <qi.wang@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>
In-Reply-To: <4CDB514A.5090803@dsn.okisemi.com>
References: <4CDB514A.5090803@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 18:22:55 -0800
Message-ID: <1289442175.15905.119.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 11:13 +0900, Toshiharu Okada wrote:
> This patch adds the USB device driver of EG20T(Topcliff) PCH.

It seems several of the dev_<level> logging messages
need to be terminated with a "\n"

[]

> +static void pch_udc_csr_busy(struct pch_udc_dev *dev)
> +{
> +	unsigned int count = 200;
> +
> +	/* Wait till idle */
> +	while ((pch_udc_readl(dev, UDC_CSR_BUSY_ADDR) & UDC_CSR_BUSY)
> +		&& --count)
> +		cpu_relax();
> +	if (!count)
> +		dev_err(&dev->pdev->dev, "%s: wait error", __func__);
> +}

[]

> +static void pch_udc_ep_clear_nak(struct pch_udc_ep *ep)
> +{
> +	unsigned int loopcnt = 0;
> +	struct pch_udc_dev *dev = ep->dev;
> +
> +	if (!(pch_udc_ep_readl(ep, UDC_EPCTL_ADDR) & UDC_EPCTL_NAK))
> +		return;
> +	if (!ep->in) {
> +		loopcnt = 10000;
> +		while (!(pch_udc_read_ep_status(ep) & UDC_EPSTS_MRXFIFO_EMP) &&
> +			--loopcnt)
> +			udelay(5);
> +		if (!loopcnt)
> +			dev_err(&dev->pdev->dev, "%s: RxFIFO not Empty ",
> +				__func__);
> +	}
> +	loopcnt = 10000;
> +	while ((pch_udc_read_ep_control(ep) & UDC_EPCTL_NAK) && --loopcnt) {
> +		pch_udc_ep_bit_set(ep, UDC_EPCTL_ADDR, UDC_EPCTL_CNAK);
> +		udelay(5);
> +	}
> +	if (!loopcnt)
> +		dev_err(&dev->pdev->dev, "%s: Clear NAK not set for ep%d%s",
> +			__func__, ep->num, (ep->in ? "in" : "out"));
> +}

etc and several more...

Can you check these and verify the need for newlines at the
end of the formats and add them as appropriate?

