Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab0J1Pbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:31:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63317 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab0J1Pbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to;
        b=bTUrsOEDJwwIOw53b6Rq2RuSlWkvYmNFtWBnNofLZzQ0qE17A45GMWz638jEcAmSQc
         h+x4ktLo3um2DEMmEqnyxv+21g4aPtokNbWeeQF/lPSfnLOyZV1dJMSMOafSwVKJuLBW
         lPAMiNg+D42MFVk+/SSJGGN0JVetQC2O2q+S4=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv2 1/7] USB: gadget: file_storage: put_device() in error recovery
Date: Thu, 28 Oct 2010 17:31:18 +0200
Message-Id: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <Pine.LNX.4.44L0.1010261002210.1634-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/gadget/file_storage.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

> On Tue, 26 Oct 2010, Michal Nazarewicz wrote:
>> +		if ((rc = device_create_file(&curlun->dev, &dev_attr_ro))  ||
>> +		    (rc = device_create_file(&curlun->dev, &dev_attr_nofua)) ||
>> +		    (rc = device_create_file(&curlun->dev, &dev_attr_file)))
>> +			goto out;

On Tue, 26 Oct 2010 16:09:27 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> As long as you're changing these anyway, you may as well use the style
> most developers seem to prefer:
>
>		rc = device_create_file(&curlun->dev, &dev_attr_ro);
>		if (rc)
>			goto out;

As requested, this commit changes exacly that.

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index d4fdf65..a6eacb5 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3392,25 +3392,28 @@ static int __init fsg_bind(struct usb_gadget *gadget)
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
+		rc = device_create_file(&curlun->dev, &dev_attr_ro);
+		if (rc)
+			goto out;
+		rc = device_create_file(&curlun->dev, &dev_attr_nofua);
+		if (rc)
+			goto out;
+		rc = device_create_file(&curlun->dev, &dev_attr_file);
+		if (rc)
+			goto out;
 
 		if (mod_data.file[i] && *mod_data.file[i]) {
-			if ((rc = fsg_lun_open(curlun,
-					mod_data.file[i])) != 0)
+			rc = fsg_lun_open(curlun, mod_data.file[i]);
+			if (rc)
 				goto out;
 		} else if (!mod_data.removable) {
 			ERROR(fsg, "no file given for LUN%d\n", i);
-- 
1.7.1

