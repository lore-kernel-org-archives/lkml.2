Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab0KFOlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:41:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55386 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0KFOld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AS4XCqWYmxf0czEKiECn2a9t3uA+MqERnD/5uWpavutlp7DTaMAodX71KOUdXOcYIx
         77wEl5smwREjeRX9dEaCxfYEp2yrVkQEb9DdhMh/uhEtF97kxb8prksEARrpAuQUnBdG
         xYogtZBVFzRa/IPa620jf4YAKou9gzxtTeUEY=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andi Kleen <ak@linux.intel.com>, Chris Frey <cdfrey@foursquare.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: core: fix information leak to userland
Date: Sat,  6 Nov 2010 17:41:28 +0300
Message-Id: <1289054488-18233-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure usbdevfs_connectinfo is copied to userland with padding byted
after "slow" field uninitialized.  It leads to leaking of contents of
kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/usb/core/devio.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index f1aaff6..045bb4b 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -965,10 +965,11 @@ static int proc_getdriver(struct dev_state *ps, void __user *arg)
 
 static int proc_connectinfo(struct dev_state *ps, void __user *arg)
 {
-	struct usbdevfs_connectinfo ci;
+	struct usbdevfs_connectinfo ci = {
+		.devnum = ps->dev->devnum,
+		.slow = ps->dev->speed == USB_SPEED_LOW
+	};
 
-	ci.devnum = ps->dev->devnum;
-	ci.slow = ps->dev->speed == USB_SPEED_LOW;
 	if (copy_to_user(arg, &ci, sizeof(ci)))
 		return -EFAULT;
 	return 0;
-- 
1.7.0.4

