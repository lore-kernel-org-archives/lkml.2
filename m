Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2FNMwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 08:52:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab2FNMwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 08:52:40 -0400
From: Kamil Dudka <kdudka@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, Kamil Dudka <kdudka@redhat.com>
Subject: [PATCH] i2o: avoid returning pointer to a local array in chtostr()
Date: Thu, 14 Jun 2012 14:51:42 +0200
Message-Id: <1339678302-23770-1-git-send-email-kdudka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer returned from chtostr() points to an array which is no longer valid
when being used in the calling function.  Although it may work, the behavior is
undefined.  Detected by cppcheck.

Signed-off-by: Kamil Dudka <kdudka@redhat.com>
---
 drivers/message/i2o/i2o_proc.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/message/i2o/i2o_proc.c b/drivers/message/i2o/i2o_proc.c
index 506c36f..8001aa6 100644
--- a/drivers/message/i2o/i2o_proc.c
+++ b/drivers/message/i2o/i2o_proc.c
@@ -255,9 +255,8 @@ static char *scsi_devices[] = {
 	"Array Controller Device"
 };
 
-static char *chtostr(u8 * chars, int n)
+static char *chtostr(char *tmp, u8 *chars, int n)
 {
-	char tmp[256];
 	tmp[0] = 0;
 	return strncat(tmp, (char *)chars, n);
 }
@@ -791,6 +790,7 @@ static int i2o_seq_show_ddm_table(struct seq_file *seq, void *v)
 	} *result;
 
 	i2o_exec_execute_ddm_table ddm_table;
+	char tmp[28 + 1];
 
 	result = kmalloc(sizeof(*result), GFP_KERNEL);
 	if (!result)
@@ -826,7 +826,7 @@ static int i2o_seq_show_ddm_table(struct seq_file *seq, void *v)
 		seq_printf(seq, "%-#7x", ddm_table.i2o_vendor_id);
 		seq_printf(seq, "%-#8x", ddm_table.module_id);
 		seq_printf(seq, "%-29s",
-			   chtostr(ddm_table.module_name_version, 28));
+			   chtostr(tmp, ddm_table.module_name_version, 28));
 		seq_printf(seq, "%9d  ", ddm_table.data_size);
 		seq_printf(seq, "%8d", ddm_table.code_size);
 
@@ -893,6 +893,7 @@ static int i2o_seq_show_drivers_stored(struct seq_file *seq, void *v)
 
 	i2o_driver_result_table *result;
 	i2o_driver_store_table *dst;
+	char tmp[28 + 1];
 
 	result = kmalloc(sizeof(i2o_driver_result_table), GFP_KERNEL);
 	if (result == NULL)
@@ -927,8 +928,9 @@ static int i2o_seq_show_drivers_stored(struct seq_file *seq, void *v)
 
 		seq_printf(seq, "%-#7x", dst->i2o_vendor_id);
 		seq_printf(seq, "%-#8x", dst->module_id);
-		seq_printf(seq, "%-29s", chtostr(dst->module_name_version, 28));
-		seq_printf(seq, "%-9s", chtostr(dst->date, 8));
+		seq_printf(seq, "%-29s",
+			   chtostr(tmp, dst->module_name_version, 28));
+		seq_printf(seq, "%-9s", chtostr(tmp, dst->date, 8));
 		seq_printf(seq, "%8d ", dst->module_size);
 		seq_printf(seq, "%8d ", dst->mpb_size);
 		seq_printf(seq, "0x%04x", dst->module_flags);
@@ -1248,6 +1250,7 @@ static int i2o_seq_show_dev_identity(struct seq_file *seq, void *v)
 	// == (allow) 512d bytes (max)
 	static u16 *work16 = (u16 *) work32;
 	int token;
+	char tmp[16 + 1];
 
 	token = i2o_parm_field_get(d, 0xF100, -1, &work32, sizeof(work32));
 
@@ -1260,13 +1263,13 @@ static int i2o_seq_show_dev_identity(struct seq_file *seq, void *v)
 	seq_printf(seq, "Owner TID     : %0#5x\n", work16[2]);
 	seq_printf(seq, "Parent TID    : %0#5x\n", work16[3]);
 	seq_printf(seq, "Vendor info   : %s\n",
-		   chtostr((u8 *) (work32 + 2), 16));
+		   chtostr(tmp, (u8 *) (work32 + 2), 16));
 	seq_printf(seq, "Product info  : %s\n",
-		   chtostr((u8 *) (work32 + 6), 16));
+		   chtostr(tmp, (u8 *) (work32 + 6), 16));
 	seq_printf(seq, "Description   : %s\n",
-		   chtostr((u8 *) (work32 + 10), 16));
+		   chtostr(tmp, (u8 *) (work32 + 10), 16));
 	seq_printf(seq, "Product rev.  : %s\n",
-		   chtostr((u8 *) (work32 + 14), 8));
+		   chtostr(tmp, (u8 *) (work32 + 14), 8));
 
 	seq_printf(seq, "Serial number : ");
 	print_serial_number(seq, (u8 *) (work32 + 16),
@@ -1303,6 +1306,8 @@ static int i2o_seq_show_ddm_identity(struct seq_file *seq, void *v)
 		u8 pad[256];	// allow up to 256 byte (max) serial number
 	} result;
 
+	char tmp[24 + 1];
+
 	token = i2o_parm_field_get(d, 0xF101, -1, &result, sizeof(result));
 
 	if (token < 0) {
@@ -1312,9 +1317,9 @@ static int i2o_seq_show_ddm_identity(struct seq_file *seq, void *v)
 
 	seq_printf(seq, "Registering DDM TID : 0x%03x\n", result.ddm_tid);
 	seq_printf(seq, "Module name         : %s\n",
-		   chtostr(result.module_name, 24));
+		   chtostr(tmp, result.module_name, 24));
 	seq_printf(seq, "Module revision     : %s\n",
-		   chtostr(result.module_rev, 8));
+		   chtostr(tmp, result.module_rev, 8));
 
 	seq_printf(seq, "Serial number       : ");
 	print_serial_number(seq, result.serial_number, sizeof(result) - 36);
@@ -1338,6 +1343,8 @@ static int i2o_seq_show_uinfo(struct seq_file *seq, void *v)
 		u8 instance_number[4];
 	} result;
 
+	char tmp[64 + 1];
+
 	token = i2o_parm_field_get(d, 0xF102, -1, &result, sizeof(result));
 
 	if (token < 0) {
@@ -1346,13 +1353,13 @@ static int i2o_seq_show_uinfo(struct seq_file *seq, void *v)
 	}
 
 	seq_printf(seq, "Device name     : %s\n",
-		   chtostr(result.device_name, 64));
+		   chtostr(tmp, result.device_name, 64));
 	seq_printf(seq, "Service name    : %s\n",
-		   chtostr(result.service_name, 64));
+		   chtostr(tmp, result.service_name, 64));
 	seq_printf(seq, "Physical name   : %s\n",
-		   chtostr(result.physical_location, 64));
+		   chtostr(tmp, result.physical_location, 64));
 	seq_printf(seq, "Instance number : %s\n",
-		   chtostr(result.instance_number, 4));
+		   chtostr(tmp, result.instance_number, 4));
 
 	return 0;
 }
-- 
1.7.1

