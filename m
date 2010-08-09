Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab0HIPCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:02:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36742 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab0HIPBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:01:14 -0400
Date: Mon, 09 Aug 2010 17:02:33 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv7 8/8] usb: gadget: mass_storage: optional SCSI WRITE FUA bit
In-reply-to: <1a8a7e76daf68acaeecf4334848703318355a3a2.1281365237.git.m.nazarewicz@samsung.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Message-id: <3e2dabb188e85bde4b942193be4414e53c604e04.1281365237.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1281365237.git.m.nazarewicz@samsung.com>
 <49ebe5a39e05aa55a19d33a2141736d215873f86.1281365237.git.m.nazarewicz@samsung.com>
 <b4fe56570ecb77ec6acbab4502f7ad87b72885e1.1281365237.git.m.nazarewicz@samsung.com>
 <9219d2c4e7b60f2ad1455b6c702604e84ef90e1b.1281365237.git.m.nazarewicz@samsung.com>
 <fd2e70a236743436c0c2e88eb3b32e4564571e32.1281365237.git.m.nazarewicz@samsung.com>
 <e37b282da3898486df3fc33cbb1de5e1b6bc26c3.1281365237.git.m.nazarewicz@samsung.com>
 <dadbebba90720630077702d19240acca9fdb2182.1281365237.git.m.nazarewicz@samsung.com>
 <1a8a7e76daf68acaeecf4334848703318355a3a2.1281365237.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nofua parameter (optionally ignore SCSI WRITE FUA) was added
to the File Storage Gadget some time ago.  This patch adds the
same functionality to the Mass Storage Function.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/usb/gadget/f_mass_storage.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 32cce02..ec97232 100644
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
@@ -3069,8 +3078,10 @@ struct fsg_module_parameters {
 	int		ro[FSG_MAX_LUNS];
 	int		removable[FSG_MAX_LUNS];
 	int		cdrom[FSG_MAX_LUNS];
+	int		nofua[FSG_MAX_LUNS];
 
 	unsigned int	file_count, ro_count, removable_count, cdrom_count;
+	unsigned int	nofua_count;
 	unsigned int	luns;	/* nluns */
 	int		stall;	/* can_stall */
 };
@@ -3096,6 +3107,8 @@ struct fsg_module_parameters {
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

