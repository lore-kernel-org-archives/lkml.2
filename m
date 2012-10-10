Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab2JJKdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:33:04 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:51108 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754763Ab2JJKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:32:59 -0400
From: Constantine Shulyupin <const@MakeLinux.com>
To: nsekhar@ti.com, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: Constantine Shulyupin <const@MakeLinux.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] USB: usb-skeleton.c: fix compilation error and restore kref_put on fail in skel_open
Date: Wed, 10 Oct 2012 12:32:54 +0200
Message-Id: <1349865174-21649-1-git-send-email-const@MakeLinux.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {1470:box668.bluehost.com:makelinu:makelinux.net} {sentby:smtp auth 77.127.105.163 authed with poster@makelinux.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Constantine Shulyupin <const@MakeLinux.com>

Function skel_open increments usage count for the device with kref_get and the usage count should be decremented on the function failure.

Some last changes in function skel_open and finally commit
52a7499 Revert "USB: usb-skeleton.c: fix open/disconnect race"
introduced a bug in function skel_open, which this patch fixes.

--
Changelog:
-- Fixed accordinly feedback of Oliver Neukum oneukum@suse.de: also need to drop the lock.

Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
---
 drivers/usb/usb-skeleton.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 0616f23..2025d03 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -113,8 +113,9 @@ static int skel_open(struct inode *inode, struct file *file)
 	mutex_lock(&dev->io_mutex);
 
 	retval = usb_autopm_get_interface(interface);
-	if (retval)
-		goto out_err;
+	if (retval) {
+		kref_put(&dev->kref, skel_delete);
+	}
 
 	/* save our object in the file's private structure */
 	file->private_data = dev;
-- 
1.7.9.5

