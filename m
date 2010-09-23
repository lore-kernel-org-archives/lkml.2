Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab0IWC6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 22:58:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43254 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0IWC6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 22:58:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=DUPjPbUCZTCuYjobC494uGhMDgtusyu7LapjX3iu+868FewQtjloldfHrV5D5CZbrt
         FGE+e8dfu90wPvk/YuXgLF+m8rHQGrRM7zi/j43XubihHBf7u1p4v95krnZQmoc1/uDR
         w+h+BID7QIiN7JSfmYUgLtyXfBXh8Xhagnmjo=
MIME-Version: 1.0
Date: Wed, 22 Sep 2010 22:58:00 -0400
Message-ID: <AANLkTimpuAfRw85ECVQ+FJxFpNaPC=zHCL1i0Y6AjiAf@mail.gmail.com>
Subject: [PATCH 3/5] scsi: megaraid_sas - Add input parameter for max_sectors
From: bo yang <boyang1288@gmail.com>
To: bo.yang@lsi.com, linux-scsi@vger.kernel.org, akpm@osdl.org,
        linux-kernel@vger.kernel.org, James.Bottomley@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver add the input parameters support for max_sectors for megaraid
sas gen2 chip.  Customer can set the max_sectors support to 1MB for
gen2 chip during the driver load.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |   30 ++++++++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h |    1 +
 2 files changed, 31 insertions(+)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c
new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-09-17 03:19:31.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-09-17 03:20:49.000000000 -0400
@@ -57,6 +57,15 @@ module_param_named(poll_mode_io, poll_mo
 MODULE_PARM_DESC(poll_mode_io,
 	"Complete cmds from IO path, (default=0)");

+/*
+ * Number of sectors per IO command
+ * Will be set in megasas_init_mfi if user does not provide
+ */
+static unsigned int max_sectors;
+module_param_named(max_sectors, max_sectors, int, 0);
+MODULE_PARM_DESC(max_sectors,
+	"Maximum number of sectors per IO command");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux@lsi.com");
@@ -3587,6 +3596,27 @@ static int megasas_io_attach(struct mega
 			instance->max_fw_cmds - MEGASAS_INT_CMDS;
 	host->this_id = instance->init_id;
 	host->sg_tablesize = instance->max_num_sge;
+	/*
+	 * Check if the module parameter value for max_sectors can be used
+	 */
+	if (max_sectors && max_sectors < instance->max_sectors_per_req)
+		instance->max_sectors_per_req = max_sectors;
+	else {
+		if (max_sectors) {
+			if (((instance->pdev->device ==
+				PCI_DEVICE_ID_LSI_SAS1078GEN2) ||
+				(instance->pdev->device ==
+				PCI_DEVICE_ID_LSI_SAS0079GEN2)) &&
+				(max_sectors <= MEGASAS_MAX_SECTORS)) {
+				instance->max_sectors_per_req = max_sectors;
+			} else {
+			printk(KERN_INFO "megasas: max_sectors should be > 0"
+				"and <= %d (or < 1MB for GEN2 controller)\n",
+				instance->max_sectors_per_req);
+			}
+		}
+	}
+
 	host->max_sectors = instance->max_sectors_per_req;
 	host->cmd_per_lun = 128;
 	host->max_channel = MEGASAS_MAX_CHANNELS - 1;
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h
new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h	2010-09-17 02:19:46.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2010-09-17 02:19:46.000000000 -0400
@@ -706,6 +706,7 @@ struct megasas_ctrl_info {
 #define MEGASAS_MAX_LD_IDS			(MEGASAS_MAX_LD_CHANNELS * \
 						MEGASAS_MAX_DEV_PER_CHANNEL)

+#define MEGASAS_MAX_SECTORS                    (2*1024)
 #define MEGASAS_DBG_LVL				1

 #define MEGASAS_FW_BUSY				1
