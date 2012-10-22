Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab2JVVIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:08:16 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:56433 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932255Ab2JVVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:08:12 -0400
From: Constantine Shulyupin <const@MakeLinux.com>
To: gregkh@linuxfoundation.org, oneukum@suse.de
Cc: Constantine Shulyupin <const@MakeLinux.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v3] USB: usb-skeleton.c: fix compilation error and restored kref_put on fail in skel_open
Date: Mon, 22 Oct 2012 23:08:15 +0200
Message-Id: <1350940095-1106-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 84.229.180.233 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

Fixing compilaton error.
Incrementing usage counter only on successful execution of skel_open.
Removing redundant locking

Some last changes in function skel_open and finally commit
52a7499 Revert "USB: usb-skeleton.c: fix open/disconnect race"
introduced a bug in function skel_open, which this patch fixes.

--

Changelog:
Changes since v2:
- refactoring
- Removing redundant mutex synchronization.

Changes since v1:
- Fixed accordingly feedback of Oliver Neukum oneukum@suse.de: also need to drop the lock.

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 drivers/usb/usb-skeleton.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 0616f23..ce31017 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -105,20 +105,15 @@ static int skel_open(struct inode *inode, struct file *file)
 		goto exit;
 	}
 
-	/* increment our usage count for the device */
-	kref_get(&dev->kref);
-
-	/* lock the device to allow correctly handling errors
-	 * in resumption */
-	mutex_lock(&dev->io_mutex);
-
 	retval = usb_autopm_get_interface(interface);
 	if (retval)
-		goto out_err;
+		goto exit;
+
+	/* increment our usage count for the device */
+	kref_get(&dev->kref);
 
 	/* save our object in the file's private structure */
 	file->private_data = dev;
-	mutex_unlock(&dev->io_mutex);
 
 exit:
 	return retval;
-- 
1.7.9.5

