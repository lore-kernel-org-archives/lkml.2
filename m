Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab2AJXPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:15:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934077Ab2AJXB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:01:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:22 2012
Message-Id: <20120110215022.874156314@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [23/42] USB: isight: fix kernel bug when loading firmware
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 59bf5cf94f0fa3b08fb1258b52649077b7d0914d upstream.

We were sending data on the stack when uploading firmware, which causes
some machines fits, and is not allowed.  Fix this by using the buffer we
already had around for this very purpose.

Reported-by: Wouter M. Koolen <wmkoolen@cwi.nl>
Tested-by: Wouter M. Koolen <wmkoolen@cwi.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/isight_firmware.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/isight_firmware.c
+++ b/drivers/usb/misc/isight_firmware.c
@@ -55,8 +55,9 @@ static int isight_firmware_load(struct u
 
 	ptr = firmware->data;
 
+	buf[0] = 0x01;
 	if (usb_control_msg
-	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, "\1", 1,
+	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, buf, 1,
 	     300) != 1) {
 		printk(KERN_ERR
 		       "Failed to initialise isight firmware loader\n");
@@ -100,8 +101,9 @@ static int isight_firmware_load(struct u
 		}
 	}
 
+	buf[0] = 0x00;
 	if (usb_control_msg
-	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, "\0", 1,
+	    (dev, usb_sndctrlpipe(dev, 0), 0xa0, 0x40, 0xe600, 0, buf, 1,
 	     300) != 1) {
 		printk(KERN_ERR "isight firmware loading completion failed\n");
 		ret = -ENODEV;


