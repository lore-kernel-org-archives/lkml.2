Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1GIFzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:55:55 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40015 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408Ab1GIFyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:54:50 -0400
X-Sasl-enc: eyYHICvdzXcN98gJcr5f8lscKMhgowVeVIJlGjtWLLzK 1310190889
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 15:51:20 2011
Message-Id: <20110708225120.021763733@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 15:50:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Fainelli <florian@openwrt.org>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [12/35] watchdog: mtx1-wdt: request gpio before using it
In-Reply-To: <20110708225343.GA14402@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Fainelli <florian@openwrt.org>

commit 9b19d40aa3ebaf1078779da10555da2ab8512422 upstream.

Otherwise, the gpiolib autorequest feature will produce a WARN_ON():

WARNING: at drivers/gpio/gpiolib.c:101 0x8020ec6c()
autorequest GPIO-215
[...]

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/mtx-1_wdt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -211,6 +211,12 @@ static int __devinit mtx1_wdt_probe(stru
 	int ret;
 
 	mtx1_wdt_device.gpio = pdev->resource[0].start;
+	ret = gpio_request_one(mtx1_wdt_device.gpio,
+				GPIOF_OUT_INIT_HIGH, "mtx1-wdt");
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to request gpio");
+		return ret;
+	}
 
 	spin_lock_init(&mtx1_wdt_device.lock);
 	init_completion(&mtx1_wdt_device.stop);
@@ -236,6 +242,8 @@ static int __devexit mtx1_wdt_remove(str
 		mtx1_wdt_device.queue = 0;
 		wait_for_completion(&mtx1_wdt_device.stop);
 	}
+
+	gpio_free(mtx1_wdt_device.gpio);
 	misc_deregister(&mtx1_wdt_misc);
 	return 0;
 }


