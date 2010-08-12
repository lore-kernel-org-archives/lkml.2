Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891Ab0HLPoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:44:08 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36476 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760268Ab0HLPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:42:21 -0400
Date: Thu, 12 Aug 2010 17:43:51 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv8 08/13] usb: gadget: mass_storage: optional SCSI WRITE FUA bit
In-reply-to: <f07e8ff5f36d5893e62764b9e372da0cc305a2b5.1281625724.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Message-id: <550ddf8273d87cb418dd5716cbec906e74aa03d4.1281625724.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1281625724.git.m.nazarewicz@samsung.com>
 <76f0f5732bfbbb36d50baf05ecdd12bec3396275.1281625724.git.m.nazarewicz@samsung.com>
 <313ee18ecf53fb8f1c040656b697de869f0c0856.1281625724.git.m.nazarewicz@samsung.com>
 <48e2d6507f004252a012cf25bc0a06e5cb69808f.1281625724.git.m.nazarewicz@samsung.com>
 <f2f6babb8b593d5c6f6141604bd647658d59f124.1281625724.git.m.nazarewicz@samsung.com>
 <4addd8199cfd6a2aa582904cd6efa01bc77a5290.1281625724.git.m.nazarewicz@samsung.com>
 <9737a711d395932c8803511ba581722d46be5292.1281625724.git.m.nazarewicz@samsung.com>
 <f07e8ff5f36d5893e62764b9e372da0cc305a2b5.1281625724.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nofua parameter (optionally ignore SCSI WRITE FUA) was added
to the File Storage Gadget some time ago.  This patch adds the
same functionality to the Mass Storage Function.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/usb/gadget/f_mass_storage.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 32cce02..44e5ffe 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -73,6 +73,8 @@
  *				being removable.
  *	->cdrom		Flag specifying that LUN shall be reported as
  *				being a CD-ROM.
+ *	->nofua		Flag specifying that FUA flag in SCSI WRITE(10,12)
+ *				commands for this LUN shall be ignored.
  *
  *	lun_name_format	A printf-like format for names of the LUN
  *				devices.  This determines how the
@@ -127,6 +129,8 @@
  *			Default true, boolean for removable media.
  *	cdrom=b[,b...]	Default false, boolean for whether to emulate
  *				a CD-ROM drive.
+ *	nofua=b[,b...]	Default false, booleans for ignore FUA flag
+ *				in SCSI WRITE(10,12) commands
  *	luns=N		Default N = number of filenames, number of
  *				LUNs to support.
  *	stall		Default determined according to the type of
@@ -409,6 +413,7 @@ struct fsg_config {
 		char ro;
 		char removable;
 		char cdrom;
+		char nofua;
 	} luns[FSG_MAX_LUNS];
 
 	const char		*lun_name_format;
@@ -887,7 +892,7 @@ static int do_write(struct fsg_common *common)
 			curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 			return -EINVAL;
 		}
-		if (common->cmnd[1] & 0x08) {	/* FUA */
+		if (!curlun->nofua && (common->cmnd[1] & 0x08)) { /* FUA */
 			spin_lock(&curlun->filp->f_lock);
 			curlun->filp->f_flags |= O_SYNC;
 			spin_unlock(&curlun->filp->f_lock);
@@ -2662,6 +2667,7 @@ static int fsg_main_thread(void *common_)
 
 /* Write permission is checked per LUN in store_*() functions. */
 static DEVICE_ATTR(ro, 0644, fsg_show_ro, fsg_store_ro);
+static DEVICE_ATTR(nofua, 0644, fsg_show_nofua, fsg_store_nofua);
 static DEVICE_ATTR(file, 0644, fsg_show_file, fsg_store_file);
 
 
@@ -2768,6 +2774,9 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		rc = device_create_file(&curlun->dev, &dev_attr_file);
 		if (rc)
 			goto error_luns;
+		rc = device_create_file(&curlun->dev, &dev_attr_nofua);
+		if (rc)
+			goto error_luns;
 
 		if (lcfg->filename) {
 			rc = fsg_lun_open(curlun, lcfg->filename);
@@ -2911,6 +2920,7 @@ static void fsg_common_release(struct kref *ref)
 
 		/* In error recovery common->nluns may be zero. */
 		for (; i; --i, ++lun) {
+			device_remove_file(&lun->dev, &dev_attr_nofua);
 			device_remove_file(&lun->dev, &dev_attr_ro);
 			device_remove_file(&lun->dev, &dev_attr_file);
 			fsg_lun_close(lun);
@@ -3069,8 +3079,10 @@ struct fsg_module_parameters {
 	int		ro[FSG_MAX_LUNS];
 	int		removable[FSG_MAX_LUNS];
 	int		cdrom[FSG_MAX_LUNS];
+	int		nofua[FSG_MAX_LUNS];
 
 	unsigned int	file_count, ro_count, removable_count, cdrom_count;
+	unsigned int	nofua_count;
 	unsigned int	luns;	/* nluns */
 	int		stall;	/* can_stall */
 };
@@ -3096,6 +3108,8 @@ struct fsg_module_parameters {
 				"true to simulate removable media");	\
 	_FSG_MODULE_PARAM_ARRAY(prefix, params, cdrom, bool,		\
 				"true to simulate CD-ROM instead of disk"); \
+	_FSG_MODULE_PARAM_ARRAY(prefix, params, nofua, bool,		\
+				"true to ignore SCSI WRITE(10,12) FUA bit"); \
 	_FSG_MODULE_PARAM(prefix, params, luns, uint,			\
 			  "number of LUNs");				\
 	_FSG_MODULE_PARAM(prefix, params, stall, bool,			\
-- 
1.7.1

