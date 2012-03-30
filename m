Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966055Ab2C3VVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:21:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966015Ab2C3VVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:21:13 -0400
Message-Id: <20120330194842.361704605@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 088/175] target: Set peripheral device type consistently in INQUIRY response
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 089461dda1770c10fea0b988ff74519a9be81d7e upstream.

Current code sets the peripheral device type to 0x3f == "not present
unknown" for virtual LUN 0 for standard INQUIRY commands, but leaves it
as 0 == "connected direct access block" for VPD INQUIRY commands.  This
is just because the check for LUN 0 only happens in some code paths.

Make our peripheral device type consistent by moving the LUN 0 check
into the common emulate_inquiry() code.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_cdb.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -70,15 +70,11 @@ target_emulate_inquiry_std(struct se_cmd
 {
 	struct se_lun *lun = cmd->se_lun;
 	struct se_device *dev = cmd->se_dev;
-	struct se_portal_group *tpg = lun->lun_sep->sep_tpg;
 
-	if (dev == tpg->tpg_virt_lun0.lun_se_dev) {
-		buf[0] = 0x3f; /* Not connected */
-	} else {
-		buf[0] = dev->transport->get_device_type(dev);
-		if (buf[0] == TYPE_TAPE)
-			buf[1] = 0x80;
-	}
+	/* Set RMB (removable media) for tape devices */
+	if (dev->transport->get_device_type(dev) == TYPE_TAPE)
+		buf[1] = 0x80;
+
 	buf[2] = dev->transport->get_device_rev(dev);
 
 	/*
@@ -606,6 +602,7 @@ int target_emulate_inquiry(struct se_tas
 {
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
+	struct se_portal_group *tpg = cmd->se_lun->lun_sep->sep_tpg;
 	unsigned char *buf, *map_buf;
 	unsigned char *cdb = cmd->t_task_cdb;
 	int p, ret;
@@ -630,6 +627,11 @@ int target_emulate_inquiry(struct se_tas
 		buf = map_buf;
 	}
 
+	if (dev == tpg->tpg_virt_lun0.lun_se_dev)
+		buf[0] = 0x3f; /* Not connected */
+	else
+		buf[0] = dev->transport->get_device_type(dev);
+
 	if (!(cdb[1] & 0x1)) {
 		if (cdb[2]) {
 			pr_err("INQUIRY with EVPD==0 but PAGE CODE=%02x\n",
@@ -643,8 +645,6 @@ int target_emulate_inquiry(struct se_tas
 		goto out;
 	}
 
-	buf[0] = dev->transport->get_device_type(dev);
-
 	for (p = 0; p < ARRAY_SIZE(evpd_handlers); ++p) {
 		if (cdb[2] == evpd_handlers[p].page) {
 			buf[1] = cdb[2];


