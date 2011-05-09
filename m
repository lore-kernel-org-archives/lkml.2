Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab1EIRtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 13:49:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:39313 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1EIRtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 13:49:17 -0400
Date: Mon, 9 May 2011 19:49:10 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 7/7] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110509174910.GA7025@linutronix.de>
References: <1304853414-10234-1-git-send-email-tlinder@codeaurora.org>
 <1304853414-10234-8-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1304853414-10234-8-git-send-email-tlinder@codeaurora.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tatyana Brokhman | 2011-05-08 14:16:48 [+0300]:

> static int dummy_hcd_probe(struct platform_device *pdev)
> {
>-	struct usb_hcd		*hcd;
>+	struct usb_hcd		*hs_hcd;
>+	struct usb_hcd		*ss_hcd;
> 	int			retval;
> 
> 	dev_info(&pdev->dev, "%s, driver " DRIVER_VERSION "\n", driver_desc);
> 
>-	hcd = usb_create_hcd(&dummy_hcd, &pdev->dev, dev_name(&pdev->dev));
>-	if (!hcd)
>+	hs_hcd = usb_create_hcd(&dummy_hcd, &pdev->dev, dev_name(&pdev->dev));
>+	if (!hs_hcd)
> 		return -ENOMEM;
>-	the_controller = hcd_to_dummy (hcd);
> 
>-	retval = usb_add_hcd(hcd, 0, 0);
>-	if (retval != 0) {
>-		usb_put_hcd (hcd);
>-		the_controller = NULL;
>+	hs_hcd->speed = HCD_USB2;
Why do you overwrite the speed here and in ->reset()?

>+
>+	retval = usb_add_hcd(hs_hcd, 0, IRQF_DISABLED | IRQF_SHARED);
Why IRQF_DISABLED | IRQF_SHARED? you don't interrupts at all.

>+	if (retval != 0)
>+		usb_put_hcd(hs_hcd);
Your error recovery is broken here. You have to leave instead of
continue with SS.

>+	dev_set_drvdata(&pdev->dev, hs_hcd);
This is already done by usb_add_hcd()

>+
>+	ss_hcd = usb_create_shared_hcd(&dummy_hcd, &pdev->dev,
>+				dev_name(&pdev->dev), hs_hcd);
>+	if (!ss_hcd) {
>+		retval = -ENOMEM;
>+		goto dealloc_usb2_hcd;
> 	}
>+
>+	retval = usb_add_hcd(ss_hcd, 0, IRQF_DISABLED | IRQF_SHARED);
>+	if (retval)
>+		goto put_usb3_hcd;
>+
>+	return 0;
>+
>+put_usb3_hcd:
>+	usb_put_hcd(ss_hcd);
>+dealloc_usb2_hcd:
>+	usb_put_hcd(hs_hcd);
>+	the_controller.hs_hcd = the_controller.ss_hcd = NULL;
> 	return retval;
> }

Sebastian
