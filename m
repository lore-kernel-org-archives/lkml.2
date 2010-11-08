Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0KHKXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:23:21 -0500
Received: from smtp.nokia.com ([147.243.1.48]:19368 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753289Ab0KHKXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:23:20 -0500
Date: Mon, 8 Nov 2010 12:22:40 +0200
From: Heikki Krogerus <heikki.krogerus@nokia.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: cbouatmailru@gmail.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, ameya.palande@nokia.com,
        markus.lehtonen@nokia.com
Subject: Re: [PATCH 4/4] power_supply: isp1704: Detect charger after probe
Message-ID: <20101108102240.GA7451@esdhcp041123.research.nokia.com>
References: <1288881109-18222-1-git-send-email-heikki.krogerus@nokia.com>
 <1288881109-18222-5-git-send-email-heikki.krogerus@nokia.com>
 <4CD41E9D.2000702@ru.mvista.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <4CD41E9D.2000702@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Fri, Nov 05, 2010 at 04:11:25PM +0100, ext Sergei Shtylyov wrote:
> > @@ -422,6 +422,23 @@ static int __devinit isp1704_charger_probe(struct platform_device *pdev)
> >
> >   	dev_info(isp->dev, "registered with product id %s\n", isp->model);
> >
> > +	/*
> > +	 * Taking over the D+ pullup.
> > +	 *
> > +	 * FIXME: The device will be disconnected if the it was already
>                                                       ^^^
>     "the" is not needed here.

Here's the fix removing the extra "the". Thanks.

-- 
heikki

--C7zPtVaVf+AK4Oqc
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-power_supply-isp1704-Detect-charger-after-probe.patch"

>From 22adc046938bdb57adca5acf59fd94539d5e0110 Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@nokia.com>
Date: Thu, 4 Nov 2010 16:14:22 +0200
Subject: [PATCH] power_supply: isp1704: Detect charger after probe

If the device is booted up with cable connected, or the
module is loaded after plugging in the cable, the
notification has come and gone, so not relying on it at
probe time. Instead this checks the VBUS level manually
after probe.

Signed-off-by: Heikki Krogerus <heikki.krogerus@nokia.com>
---
 drivers/power/isp1704_charger.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 77c11f1..2ad9b14 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -422,6 +422,23 @@ static int __devinit isp1704_charger_probe(struct platform_device *pdev)
 
 	dev_info(isp->dev, "registered with product id %s\n", isp->model);
 
+	/*
+	 * Taking over the D+ pullup.
+	 *
+	 * FIXME: The device will be disconnected if it was already
+	 * enumerated. The charger driver should be always loaded before any
+	 * gadget is loaded.
+	 */
+	if (isp->otg->gadget)
+		usb_gadget_disconnect(isp->otg->gadget);
+
+	/* Detect charger if VBUS is valid (the cable was already plugged). */
+	ret = otg_io_read(isp->otg, ULPI_USB_INT_STS);
+	if ((ret & ULPI_INT_VBUS_VALID) && !isp->otg->default_a) {
+		isp->event = USB_EVENT_VBUS;
+		schedule_work(&isp->work);
+	}
+
 	return 0;
 fail2:
 	power_supply_unregister(&isp->psy);
-- 
1.7.1


--C7zPtVaVf+AK4Oqc--
