Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920Ab0JZNgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:36:50 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41748 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0JZNgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:36:48 -0400
Date: Tue, 26 Oct 2010 15:38:52 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 1/7] USB: gadget: file_storage: put_device() in error recovery
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Alan Stern <stern@rowland.harvard.edu>
Message-id: <7214986593243afb11434ddb86da7e0460dc1f51.1288099890.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit fixes some issues with File-backed Storage Gadget
error recovery when registering LUN's devices.

First of all, when device_register() fails the device still
needs to be put.  However, because lun_release() decreases
fsg->ref reference counter the counter must be incremented
beforehand.

Second of all, after any of the device_create_file()s fails,
device_unregister() is called which in turn (indirectly) calls
lun_release() which decrements fsg->ref.  So, again, the
reference counter must be incremented beforehand.

Lastly, if the first or the second device_create_file()
succeeds, the files are never removed.  To fix it,
device_remove_file() needs to be called.  This is done by
simply marking LUN as registered prior to creating files so
that fsg_unbind() can handle removing files.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Reported-by: Rahul Ruikar <rahul.ruikar@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/gadget/file_storage.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

Rahul sent an invalid fix for the missing put_device() problem some time
ago.  This is, I believe, a correct one.  It also fixes the problem with
device files not being removed (as described in commit message); not sure
if the latter is a big issue though.

Hope I'm not late for 37?

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index d4fdf65..e0504a1 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3392,21 +3392,19 @@ static int __init fsg_bind(struct usb_gadget *gadget)
 		dev_set_name(&curlun->dev,"%s-lun%d",
 			     dev_name(&gadget->dev), i);
 
-		if ((rc = device_register(&curlun->dev)) != 0) {
+		kref_get(&fsg->ref);
+		rc = device_register(&curlun->dev);
+		if (rc) {
 			INFO(fsg, "failed to register LUN%d: %d\n", i, rc);
-			goto out;
-		}
-		if ((rc = device_create_file(&curlun->dev,
-					&dev_attr_ro)) != 0 ||
-				(rc = device_create_file(&curlun->dev,
-					&dev_attr_nofua)) != 0 ||
-				(rc = device_create_file(&curlun->dev,
-					&dev_attr_file)) != 0) {
-			device_unregister(&curlun->dev);
+			put_device(&curlun->dev);
 			goto out;
 		}
 		curlun->registered = 1;
-		kref_get(&fsg->ref);
+
+		if ((rc = device_create_file(&curlun->dev, &dev_attr_ro))  ||
+		    (rc = device_create_file(&curlun->dev, &dev_attr_nofua)) ||
+		    (rc = device_create_file(&curlun->dev, &dev_attr_file)))
+			goto out;
 
 		if (mod_data.file[i] && *mod_data.file[i]) {
 			if ((rc = fsg_lun_open(curlun,
-- 
1.7.1

