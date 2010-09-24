Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0IXKv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 06:51:28 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33015 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0IXKv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 06:51:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=KkLJ5yQUtq4D/bMccpjIDfzFhBlZH6XhG08y2KIfWXhdb7Q/H6ZfNDgQ50KY87u58a
         0D+/ayOtjAQMv/Dh4OMR46tLdK+VB7I4X8ejMeTSB5cuuPImFs9n8+Bpja7TYvF4SrG1
         dMk0XZ1F6silzWnyYxtDRSRPOv77kgytSXluY=
From: Al Cho <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        yiyingc@ene.com.tw, jlee@novell.com, acho@novell.com
Subject: [PATCH] staging/keucr: fix keucr lost disconnect in transport
Date: Fri, 24 Sep 2010 18:50:11 +0800
Message-Id: <1285325411-24467-1-git-send-email-acho@novell.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The other part of keucr lost usb disconnect.
Unplug SDcard after thread scan,the wrong rule in usb_stor_port_reset,
so the driver still fail in stress test.

Signed-off-by: Al Cho <acho@novell.com>
---
 drivers/staging/keucr/transport.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index 7215429..445a62c 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -763,24 +763,19 @@ int usb_stor_port_reset(struct us_data *us)
 	int result, rc_lock;
 
 	//printk("transport --- usb_stor_port_reset\n");
-	result = rc_lock = usb_lock_device_for_reset(us->pusb_dev, us->pusb_intf);
+	result = usb_lock_device_for_reset(us->pusb_dev, us->pusb_intf);
 	if (result < 0)
 		printk("unable to lock device for reset: %d\n", result);
-	else
-	{
+	else {
 		/* Were we disconnected while waiting for the lock? */
-		if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
-		{
+		if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
 			result = -EIO;
 			//printk("No reset during disconnect\n");
-		}
-		else
-		{
+		} else {
 			result = usb_reset_device(us->pusb_dev);
 			//printk("usb_reset_composite_device returns %d\n", result);
 		}
-		if (rc_lock)
-			usb_unlock_device(us->pusb_dev);
+		usb_unlock_device(us->pusb_dev);
 	}
 	return result;
 }
-- 
1.7.1

