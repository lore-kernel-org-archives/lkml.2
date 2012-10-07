Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2JGJ5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 05:57:22 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:50721 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750743Ab2JGJ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 05:57:17 -0400
From: Constantine Shulyupin <const@MakeLinux.com>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Constantine Shulyupin <const@MakeLinux.com>
Subject: [PATCH] USB: usb-skeleton.c: fix compilation error and restore kref_put on fail in skel_open
Date: Sun,  7 Oct 2012 11:57:12 +0200
Message-Id: <1349603832-26424-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 84.229.204.199 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

Function skel_open increments usage count for the device with kref_get and the usage count should be decremented on the function failure.

Some last changes in function skel_open and finally commit
52a7499 Revert "USB: usb-skeleton.c: fix open/disconnect race"
introduced a bug in function skel_open, which this patch fixes.

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 drivers/usb/usb-skeleton.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 0616f23..027005b 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -113,8 +113,10 @@ static int skel_open(struct inode *inode, struct file *file)
 	mutex_lock(&dev->io_mutex);
 
 	retval = usb_autopm_get_interface(interface);
-	if (retval)
-		goto out_err;
+	if (retval) {
+		kref_put(&dev->kref, skel_delete);
+		goto exit;
+	}
 
 	/* save our object in the file's private structure */
 	file->private_data = dev;
-- 
1.7.9.5

