Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0IRTCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:02:43 -0400
Received: from kroah.org ([198.145.64.141]:51319 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905Ab0IRTBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:36 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:56 2010
Message-Id: <20100918185956.425683583@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
        maximilian attems <max@stro.at>
Subject: [042/123] HID: fix suspend crash by moving initializations earlier
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=hid-fix-suspend-crash-by-moving-initializations-earlier.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit fde4e2f73208b8f34f123791e39c0cb6bc74b32a upstream.

Although the usbhid driver allocates its usbhid structure in the probe
routine, several critical fields in that structure don't get
initialized until usbhid_start().  However if report descriptor
parsing fails then usbhid_start() is never called.  This leads to
problems during system suspend -- the system will freeze.

This patch (as1378) fixes the bug by moving the initialization
statements up into usbhid_probe().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Tested-By: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/usbhid/hid-core.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1000,13 +1000,6 @@ static int usbhid_start(struct hid_devic
 		}
 	}
 
-	init_waitqueue_head(&usbhid->wait);
-	INIT_WORK(&usbhid->reset_work, hid_reset);
-	INIT_WORK(&usbhid->restart_work, __usbhid_restart_queues);
-	setup_timer(&usbhid->io_retry, hid_retry_timeout, (unsigned long) hid);
-
-	spin_lock_init(&usbhid->lock);
-
 	usbhid->urbctrl = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usbhid->urbctrl) {
 		ret = -ENOMEM;
@@ -1180,6 +1173,12 @@ static int usbhid_probe(struct usb_inter
 	usbhid->intf = intf;
 	usbhid->ifnum = interface->desc.bInterfaceNumber;
 
+	init_waitqueue_head(&usbhid->wait);
+	INIT_WORK(&usbhid->reset_work, hid_reset);
+	INIT_WORK(&usbhid->restart_work, __usbhid_restart_queues);
+	setup_timer(&usbhid->io_retry, hid_retry_timeout, (unsigned long) hid);
+	spin_lock_init(&usbhid->lock);
+
 	ret = hid_add_device(hid);
 	if (ret) {
 		if (ret != -ENODEV)


