Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1BIHSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 02:18:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33376 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab1BIHSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 02:18:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aiYhy00T0QYeDDAivS06ys+3xs4KdY3ZBO/eOQtY0QRT8ZT7YIHgyxVkfaHhLQVXDP
         5SLeK/p1a2ubRdTIPbuPEAqMMkU/JUI7RmPi7eAj7mcQL3CDQxBdPGez1XR2IprHpOHy
         weJZTMgreTR3SFdmkhKfBQkI37b8kmRMCBNIU=
From: Alexander Strakh <cromlehg@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: rydberg@euromail.se, oneukum@suse.de, oblivian@users.sourceforge.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Strakh <cromlehg@gmail.com>,
        Alexander Strakh <strakh@ispras.ru>
Subject: [PATCH 1/1] Fix error path in wacom_probe
Date: Wed,  9 Feb 2011 10:37:28 +0300
Message-Id: <1297237048-32714-1-git-send-email-strakh@ispras.ru>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Strakh <cromlehg@gmail.com>

  In file drivers/input/tablet/wacom_sys.c in
wacom_probe after error we can goto label2. In
 this case function usb_free was not called. 
 It will be right goto for the label tail3.

        wacom->irq = usb_alloc_urb(0, GFP_KERNEL);

	...

        /* Retrieve the physical and logical size for OEM devices */
        error = wacom_retrieve_hid_descriptor(intf, features);
        if (error)
                goto fail2;
	...
	 fail3: usb_free_urb(wacom->irq);
	 fail2: usb_free_coherent(dev, WACOM_PKGLEN_MAX, wacom_wac->data, wacom->data_dma);

Replaced wrong transition.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>
---
 drivers/input/tablet/wacom_sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index fc38149..cf8fb9f 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -519,7 +519,7 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 	/* Retrieve the physical and logical size for OEM devices */
 	error = wacom_retrieve_hid_descriptor(intf, features);
 	if (error)
-		goto fail2;
+		goto fail3;
 
 	wacom_setup_device_quirks(features);
 
-- 
1.7.1

