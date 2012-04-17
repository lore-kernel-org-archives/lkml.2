Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2DQUgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:36:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2DQUgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:36:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v2 1/8] ohci-nxp: Driver cleanup
Date: Tue, 17 Apr 2012 20:36:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
References: <1334682507-15055-1-git-send-email-stigge@antcom.de> <1334682507-15055-2-git-send-email-stigge@antcom.de>
In-Reply-To: <1334682507-15055-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204172036.15663.arnd@arndb.de>
X-Provags-ID: V02:K0:szUekddliB0olICofX4h14kiCiwQMUyI7a2m7IkM+s9
 KL5hUOe0IkPhBYyaJJlc0A4iesiV51XjZb/dEfDuLlIvBBIJDF
 LQLbJWHiehf3xWRIMYHQ23TpKCAdQqMoKo8Sm4E2Ydre3PXUR3
 DzALpQPnomJFyMPC8WqFJJaI1RMbu/8IP/5nw2WufWvDCXcmxP
 fLvWUG082+VHhw38tZO3Pzh0rheGHeRLeVMHaPJxzWHP4zx7+p
 q1334+iaQvVQgoPDauzqW8sn2yitc+M/eqD+6D3Eg73YhnUmtU
 e6DEwDfkOQPR5OQrzK6XFBkxTk+QeFnKtSfj5pQxgjrIGlRl8m
 W4J6akBXTjxWEnCw/F/E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2012, Roland Stigge wrote:
>Cleanup for ohci-nxp.c:
>
>* Cleanup of resource handling (mem and irq), use devm_request_and_ioremap()
>* Fixed controller initialization (bits)
>* Use DMA_BIT_MASK()
>* Don't remove __devinit
>* Removed obsolete gpio.h include
>* More consistent bit access symbols
>* Removed unused extern declaration ocpi_enable()
>* Added error handling on i2c_get_adapter()
>* Better USB host and device differentiation, since on LPC32xx, the same
>  controller can be used as USB device controller
>* Whitespace cleanup
>
>Signed-off-by: Roland Stigge <stigge@antcom.de>

Looks almost good, I just found one more bug that you introduce:

> +
> +       hcd->regs = devm_request_and_ioremap(&pdev->dev, res);
> +       if (!hcd->regs) {
> +               err("Failed to devm_request_and_ioremap");
>                 ret =  -ENOMEM;
>                 goto out4;
>         }
> -       hcd->regs = (void __iomem *)pdev->resource[0].start;
> +       hcd->rsrc_start = (u64)(u32)hcd->regs;
> +       hcd->rsrc_len = resource_size(res);

This is wrong in multiple ways:

* rsrc_start is a physical address, not an __iomem token.
* you cannot cast a pointer to u32 in general, only to unsigned long.

The fact that you need an ugly type cast like above could have told
you that you are doing something wrong here. I guess it should
be

	hcd->rsrc_start = res->start;

	Arnd
