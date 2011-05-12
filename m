Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1ELFSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 01:18:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20231 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab1ELFST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 01:18:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6343"; a="90724931"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <1304853414-10234-1-git-send-email-tlinder@codeaurora.org> <1304853414-10234-8-git-send-email-tlinder@codeaurora.org> <20110509174910.GA7025@linutronix.de>
In-Reply-To: <20110509174910.GA7025@linutronix.de>
Subject: RE: [PATCH v9 7/7] usb: Adding SuperSpeed support to dummy_hcd
Date: Thu, 12 May 2011 08:19:53 +0300
Message-ID: <000b01cc1064$3b7e51d0$b27af570$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwOcWCA6Xitw5ERQGqTUPosrPaxIAB8WbuA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > static int dummy_hcd_probe(struct platform_device *pdev)
> > {
> >-	struct usb_hcd		*hcd;
> >+	struct usb_hcd		*hs_hcd;
> >+	struct usb_hcd		*ss_hcd;
> > 	int			retval;
> >
> > 	dev_info(&pdev->dev, "%s, driver " DRIVER_VERSION "\n",
> driver_desc);
> >
> >-	hcd = usb_create_hcd(&dummy_hcd, &pdev->dev, dev_name(&pdev-
> >dev));
> >-	if (!hcd)
> >+	hs_hcd = usb_create_hcd(&dummy_hcd, &pdev->dev, dev_name(&pdev-
> >dev));
> >+	if (!hs_hcd)
> > 		return -ENOMEM;
> >-	the_controller = hcd_to_dummy (hcd);
> >
> >-	retval = usb_add_hcd(hcd, 0, 0);
> >-	if (retval != 0) {
> >-		usb_put_hcd (hcd);
> >-		the_controller = NULL;
> >+	hs_hcd->speed = HCD_USB2;
> Why do you overwrite the speed here and in ->reset()?

You're right. No need for this. I'll remove the above line and the speed
will be set at dummy_setup (->reset())

> >+
> >+	retval = usb_add_hcd(hs_hcd, 0, IRQF_DISABLED | IRQF_SHARED);
> Why IRQF_DISABLED | IRQF_SHARED? you don't interrupts at all.

I used xhci as reference for this patch. This is the way xhci driver adds
the hcds. You can find it in xhci_pci_probe(). 
I'm not very familiar with how this two hcds (main and shared shcd) will
work together so I thought these flags are needed for their co-operation. 
Was my assumption mistaken? What flags should I use? 

Also, Sergei pointed out that IRQF_DISABLED is deprecated so it seems to me
that xhci needs an update as well....

> >+	if (retval != 0)
> >+		usb_put_hcd(hs_hcd);
> Your error recovery is broken here. You have to leave instead of
> continue with SS.
> 

Thanks for catching that!


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




