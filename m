Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853Ab0GSSNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:13:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58504 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760784Ab0GSSNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:13:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=IGSft4t1BwfDT5pp0FOpWGVLq1h8gcddkSSKN5wReEsToBV3cffymEysukCPrM/WG
	bmdVyizJF+xtKoCDcBh1Q==
MIME-Version: 1.0
Date: Mon, 19 Jul 2010 14:13:27 -0400
Message-ID: <AANLkTimoosNfYOG4FSJYvlOVpEFpukF9dwxBbXA8k6yc@mail.gmail.com>
Subject: [patch] usbnet: fix 100% CPU use on suspended device
From: Elly Jones <ellyjones@google.com>
To: dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Elly Jones <ellyjones@google.com>

This patch causes the usbnet module not to attempt to submit URBs to the device
if the device is not ready to accept them. This fixes a misbehavior trigged by
the Qualcomm Gobi driver (released under GPL through their Code Aurora
initiative) which causes the usbnet core to consume 100% of CPU attempting and
failing to submit URBs. This patch is against Linus's 2.6 repo commit
a9f7f2e74ae0e6a801a2433dc8e9124d73da0cb4.
Signed-off-by: Elizabeth Jones <ellyjones@google.com>
---
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 81c76ad..df7e72e 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1172,6 +1172,7 @@ static void usbnet_bh (unsigned long param)
 	// or are we maybe short a few urbs?
 	} else if (netif_running (dev->net) &&
 		   netif_device_present (dev->net) &&
+		   dev->udev->can_submit &&
 		   !timer_pending (&dev->delay) &&
 		   !test_bit (EVENT_RX_HALT, &dev->flags)) {
 		int	temp = dev->rxq.qlen;
