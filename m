Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab0DUPia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:38:30 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:54260 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab0DUPi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iRhQYwsmClRHmRUM2PREoX8NsiT6yqLDEtrParDn6vN+iuk0wgL+QpCgjXPs6jrYSe
         E/XsUNqpU2JpIsAT1S4WwSycgnakontX7GzdNSfGqT79DtLgeB9fEm70y+7+LcAzXUd/
         qMWUx6idLMtv8stywv980jFZQDrFS8CFzCYmI=
From: fabien.chouteau@gmail.com
To: linux-usb@vger.kernel.org
Cc: Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Mass storage gadget: Handle eject request
Date: Wed, 21 Apr 2010 17:38:22 +0200
Message-Id: <1271864304-4279-2-git-send-email-fabien.chouteau@gmail.com>
X-Mailer: git-send-email 1.7.0.5
In-Reply-To: <1271864304-4279-1-git-send-email-fabien.chouteau@gmail.com>
References: <1271864304-4279-1-git-send-email-fabien.chouteau@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabien Chouteau <fabien.chouteau@barco.com>


Signed-off-by: Fabien Chouteau <fabien.chouteau@barco.com>
---
 drivers/usb/gadget/f_mass_storage.c |   52 +++++++++++++++++++++++++++++++---
 drivers/usb/gadget/storage_common.c |   11 +++++++
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f4911c0..049f01b 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -1385,12 +1385,51 @@ static int do_mode_sense(struct fsg_common *common, struct fsg_buffhd *bh)
 
 static int do_start_stop(struct fsg_common *common)
 {
-	if (!common->curlun) {
+	struct fsg_lun	*curlun = common->curlun;
+	int		loej, start;
+
+	if (!curlun) {
 		return -EINVAL;
-	} else if (!common->curlun->removable) {
-		common->curlun->sense_data = SS_INVALID_COMMAND;
+	} else if (!curlun->removable) {
+		curlun->sense_data = SS_INVALID_COMMAND;
 		return -EINVAL;
 	}
+
+	loej = common->cmnd[4] & 0x02;
+	start = common->cmnd[4] & 0x01;
+
+	/* eject code from file_storage.c:do_start_stop() */
+
+	if ((common->cmnd[1] & ~0x01) != 0 ||	  /* Mask away Immed */
+		(common->cmnd[4] & ~0x03) != 0) { /* Mask LoEj, Start */
+		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
+		return -EINVAL;
+	}
+
+	if (!start) {
+		/* Are we allowed to unload the media? */
+		if (curlun->prevent_medium_removal) {
+			LDBG(curlun, "unload attempt prevented\n");
+			curlun->sense_data = SS_MEDIUM_REMOVAL_PREVENTED;
+			return -EINVAL;
+		}
+		if (loej) {	/* Simulate an unload/eject */
+			up_read(&common->filesem);
+			down_write(&common->filesem);
+			fsg_lun_close(curlun);
+			curlun->ejected = 1;
+			up_write(&common->filesem);
+			down_read(&common->filesem);
+		}
+	} else {
+
+		/* Our emulation doesn't support mounting; the medium is
+		 * available for use as soon as it is loaded. */
+		if (!fsg_lun_is_open(curlun)) {
+			curlun->sense_data = SS_MEDIUM_NOT_PRESENT;
+			return -EINVAL;
+		}
+	}
 	return 0;
 }
 
@@ -2412,7 +2451,6 @@ static void fsg_disable(struct usb_function *f)
 	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
 }
 
-
 /*-------------------------------------------------------------------------*/
 
 static void handle_exception(struct fsg_common *common)
@@ -2641,7 +2679,7 @@ static int fsg_main_thread(void *common_)
 /* Write permission is checked per LUN in store_*() functions. */
 static DEVICE_ATTR(ro, 0644, fsg_show_ro, fsg_store_ro);
 static DEVICE_ATTR(file, 0644, fsg_show_file, fsg_store_file);
-
+static DEVICE_ATTR(ejected, 0444, fsg_show_ejected, NULL);
 
 /****************************** FSG COMMON ******************************/
 
@@ -2747,6 +2785,9 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		rc = device_create_file(&curlun->dev, &dev_attr_file);
 		if (rc)
 			goto error_luns;
+		rc = device_create_file(&curlun->dev, &dev_attr_ejected);
+		if (rc)
+			goto error_luns;
 
 		if (lcfg->filename) {
 			rc = fsg_lun_open(curlun, lcfg->filename);
@@ -2887,6 +2928,7 @@ static void fsg_common_release(struct kref *ref)
 	for (; i; --i, ++lun) {
 		device_remove_file(&lun->dev, &dev_attr_ro);
 		device_remove_file(&lun->dev, &dev_attr_file);
+		device_remove_file(&lun->dev, &dev_attr_ejected);
 		fsg_lun_close(lun);
 		device_unregister(&lun->dev);
 	}
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 868d8ee..16ccebd 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -267,6 +267,7 @@ struct fsg_lun {
 	unsigned int	removable:1;
 	unsigned int	cdrom:1;
 	unsigned int	prevent_medium_removal:1;
+	unsigned int	ejected:1;
 	unsigned int	registered:1;
 	unsigned int	info_valid:1;
 
@@ -625,6 +626,7 @@ static int fsg_lun_open(struct fsg_lun *curlun, const char *filename)
 	curlun->filp = filp;
 	curlun->file_length = size;
 	curlun->num_sectors = num_sectors;
+	curlun->ejected = 0;
 	LDBG(curlun, "open backing file: %s\n", filename);
 	rc = 0;
 
@@ -776,3 +778,12 @@ static ssize_t fsg_store_file(struct device *dev, struct device_attribute *attr,
 	up_write(filesem);
 	return (rc < 0 ? rc : count);
 }
+
+static ssize_t fsg_show_ejected(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
+
+	return sprintf(buf, "%d\n", curlun->ejected);
+}
+
-- 
1.7.0.5

