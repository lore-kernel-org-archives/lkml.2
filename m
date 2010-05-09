Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0EIXnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 19:43:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34247 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab0EIXne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 19:43:34 -0400
Date: Mon, 10 May 2010 09:43:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the wireless-current tree with a fix up
 patch
Message-Id: <20100510094332.9b1114f8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless-current tree got a conflict in
drivers/net/wireless/ath/ar9170/usb.c between a fix I am carrying in the
linux-next tree and commit 160b82420ab41f1e67fbf2e56dc587837ef39ce0
("ar9170: wait for asynchronous firmware loading") from the
wireless-current tree.

I fixed it up (see at the bottom or this email).

John, can you put this following small patch in your wireless-current
tree, please?  This is to cope with an upcoming API change and applies to
Linus' tree (the device_lock/unlock wrappers are already in Linus' tree).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 3 Mar 2010 17:08:11 +1100
Subject: [PATCH] ar9170: fix for driver-core ABI change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/ath/ar9170/usb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 4e30197..7fc1034 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -41,6 +41,7 @@
 #include <linux/usb.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
+#include <linux/device.h>
 #include <net/mac80211.h>
 #include "ar9170.h"
 #include "cmd.h"
@@ -726,10 +727,10 @@ static void ar9170_usb_firmware_failed(struct ar9170_usb *aru)
 
 	/* unbind anything failed */
 	if (parent)
-		down(&parent->sem);
+		device_lock(parent);
 	device_release_driver(&aru->udev->dev);
 	if (parent)
-		up(&parent->sem);
+		device_unlock(parent);
 }
 
 static void ar9170_usb_firmware_finish(const struct firmware *fw, void *context)
-- 
1.7.0

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/ath/ar9170/usb.c
index 5f0477b,24dc555..0000000
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@@ -728,12 -726,16 +728,16 @@@ static void ar9170_usb_firmware_failed(
  {
  	struct device *parent = aru->udev->dev.parent;
  
+ 	complete(&aru->firmware_loading_complete);
+ 
  	/* unbind anything failed */
  	if (parent)
 -		down(&parent->sem);
 +		device_lock(parent);
  	device_release_driver(&aru->udev->dev);
  	if (parent)
 -		up(&parent->sem);
 +		device_unlock(parent);
+ 
+ 	usb_put_dev(aru->udev);
  }
  
  static void ar9170_usb_firmware_finish(const struct firmware *fw, void *context)
