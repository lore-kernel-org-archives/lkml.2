Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab1LTUe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:34:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43345 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1LTUeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:34:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 20 Dec 2011 21:34:12 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Carl Karsten <carl@personnelware.com>
Subject: [PATCH 3/3] firewire: sbp2: use dev_printk API
Message-ID: <20111220213412.43c37768@stein>
In-Reply-To: <20111220213017.75ff380c@stein>
References: <20111220213017.75ff380c@stein>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All messages are uniformly prefixed by driver name and device name now.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |   93 ++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 42 deletions(-)

Index: b/drivers/firewire/sbp2.c
===================================================================
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -165,7 +165,6 @@ static void sbp2_queue_work(struct sbp2_
  */
 struct sbp2_target {
 	struct fw_unit *unit;
-	const char *bus_id;
 	struct list_head lu_list;
 
 	u64 management_agent_address;
@@ -181,11 +180,21 @@ struct sbp2_target {
 	int blocked;	/* ditto */
 };
 
-static struct fw_device *target_device(struct sbp2_target *tgt)
+static struct fw_device *target_parent_device(struct sbp2_target *tgt)
 {
 	return fw_parent_device(tgt->unit);
 }
 
+static const struct device *tgt_dev(const struct sbp2_target *tgt)
+{
+	return &tgt->unit->device;
+}
+
+static const struct device *lu_dev(const struct sbp2_logical_unit *lu)
+{
+	return &lu->tgt->unit->device;
+}
+
 /* Impossible login_id, to detect logout attempt before successful login */
 #define INVALID_LOGIN_ID 0x10000
 
@@ -430,7 +439,8 @@ static void sbp2_status_write(struct fw_
 		memcpy(status.data, payload + 8, length - 8);
 
 	if (STATUS_GET_SOURCE(status) == 2 || STATUS_GET_SOURCE(status) == 3) {
-		fw_notify("non-orb related status write, not handled\n");
+		dev_notice(lu_dev(lu),
+			   "non-ORB related status write, not handled\n");
 		fw_send_response(card, request, RCODE_COMPLETE);
 		return;
 	}
@@ -451,7 +461,7 @@ static void sbp2_status_write(struct fw_
 		orb->callback(orb, &status);
 		kref_put(&orb->kref, free_orb); /* orb callback reference */
 	} else {
-		fw_error("status write for unknown orb\n");
+		dev_err(lu_dev(lu), "status write for unknown ORB\n");
 	}
 
 	fw_send_response(card, request, RCODE_COMPLETE);
@@ -492,7 +502,7 @@ static void complete_transaction(struct
 static void sbp2_send_orb(struct sbp2_orb *orb, struct sbp2_logical_unit *lu,
 			  int node_id, int generation, u64 offset)
 {
-	struct fw_device *device = target_device(lu->tgt);
+	struct fw_device *device = target_parent_device(lu->tgt);
 	struct sbp2_pointer orb_pointer;
 	unsigned long flags;
 
@@ -513,7 +523,7 @@ static void sbp2_send_orb(struct sbp2_or
 
 static int sbp2_cancel_orbs(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = target_device(lu->tgt);
+	struct fw_device *device = target_parent_device(lu->tgt);
 	struct sbp2_orb *orb, *next;
 	struct list_head list;
 	unsigned long flags;
@@ -552,7 +562,7 @@ static int sbp2_send_management_orb(stru
 				    int generation, int function,
 				    int lun_or_login_id, void *response)
 {
-	struct fw_device *device = target_device(lu->tgt);
+	struct fw_device *device = target_parent_device(lu->tgt);
 	struct sbp2_management_orb *orb;
 	unsigned int timeout;
 	int retval = -ENOMEM;
@@ -612,20 +622,20 @@ static int sbp2_send_management_orb(stru
 
 	retval = -EIO;
 	if (sbp2_cancel_orbs(lu) == 0) {
-		fw_error("%s: orb reply timed out, rcode=0x%02x\n",
-			 lu->tgt->bus_id, orb->base.rcode);
+		dev_err(lu_dev(lu), "ORB reply timed out, rcode 0x%02x\n",
+			orb->base.rcode);
 		goto out;
 	}
 
 	if (orb->base.rcode != RCODE_COMPLETE) {
-		fw_error("%s: management write failed, rcode 0x%02x\n",
-			 lu->tgt->bus_id, orb->base.rcode);
+		dev_err(lu_dev(lu), "management write failed, rcode 0x%02x\n",
+			orb->base.rcode);
 		goto out;
 	}
 
 	if (STATUS_GET_RESPONSE(orb->status) != 0 ||
 	    STATUS_GET_SBP_STATUS(orb->status) != 0) {
-		fw_error("%s: error status: %d:%d\n", lu->tgt->bus_id,
+		dev_err(lu_dev(lu), "error status: %d:%d\n",
 			 STATUS_GET_RESPONSE(orb->status),
 			 STATUS_GET_SBP_STATUS(orb->status));
 		goto out;
@@ -648,7 +658,7 @@ static int sbp2_send_management_orb(stru
 
 static void sbp2_agent_reset(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = target_device(lu->tgt);
+	struct fw_device *device = target_parent_device(lu->tgt);
 	__be32 d = 0;
 
 	fw_run_transaction(device->card, TCODE_WRITE_QUADLET_REQUEST,
@@ -665,7 +675,7 @@ static void complete_agent_reset_write_n
 
 static void sbp2_agent_reset_no_wait(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = target_device(lu->tgt);
+	struct fw_device *device = target_parent_device(lu->tgt);
 	struct fw_transaction *t;
 	static __be32 d;
 
@@ -704,7 +714,7 @@ static inline void sbp2_allow_block(stru
 static void sbp2_conditionally_block(struct sbp2_logical_unit *lu)
 {
 	struct sbp2_target *tgt = lu->tgt;
-	struct fw_card *card = target_device(tgt)->card;
+	struct fw_card *card = target_parent_device(tgt)->card;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 	unsigned long flags;
@@ -728,7 +738,7 @@ static void sbp2_conditionally_block(str
 static void sbp2_conditionally_unblock(struct sbp2_logical_unit *lu)
 {
 	struct sbp2_target *tgt = lu->tgt;
-	struct fw_card *card = target_device(tgt)->card;
+	struct fw_card *card = target_parent_device(tgt)->card;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 	unsigned long flags;
@@ -753,7 +763,7 @@ static void sbp2_conditionally_unblock(s
  */
 static void sbp2_unblock(struct sbp2_target *tgt)
 {
-	struct fw_card *card = target_device(tgt)->card;
+	struct fw_card *card = target_parent_device(tgt)->card;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 	unsigned long flags;
@@ -794,7 +804,7 @@ static int sbp2_lun2int(u16 lun)
  */
 static void sbp2_set_busy_timeout(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = target_device(lu->tgt);
+	struct fw_device *device = target_parent_device(lu->tgt);
 	__be32 d = cpu_to_be32(SBP2_CYCLE_LIMIT | SBP2_RETRY_LIMIT);
 
 	fw_run_transaction(device->card, TCODE_WRITE_QUADLET_REQUEST,
@@ -809,7 +819,7 @@ static void sbp2_login(struct work_struc
 	struct sbp2_logical_unit *lu =
 		container_of(work, struct sbp2_logical_unit, work.work);
 	struct sbp2_target *tgt = lu->tgt;
-	struct fw_device *device = target_device(tgt);
+	struct fw_device *device = target_parent_device(tgt);
 	struct Scsi_Host *shost;
 	struct scsi_device *sdev;
 	struct sbp2_login_response response;
@@ -833,8 +843,8 @@ static void sbp2_login(struct work_struc
 		if (lu->retries++ < 5) {
 			sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
 		} else {
-			fw_error("%s: failed to login to LUN %04x\n",
-				 tgt->bus_id, lu->lun);
+			dev_err(tgt_dev(tgt), "failed to login to LUN %04x\n",
+				lu->lun);
 			/* Let any waiting I/O fail from now on. */
 			sbp2_unblock(lu->tgt);
 		}
@@ -851,8 +861,8 @@ static void sbp2_login(struct work_struc
 		      << 32) | be32_to_cpu(response.command_block_agent.low);
 	lu->login_id = be32_to_cpu(response.misc) & 0xffff;
 
-	fw_notify("%s: logged in to LUN %04x (%d retries)\n",
-		  tgt->bus_id, lu->lun, lu->retries);
+	dev_notice(tgt_dev(tgt), "logged in to LUN %04x (%d retries)\n",
+		   lu->lun, lu->retries);
 
 	/* set appropriate retry limit(s) in BUSY_TIMEOUT register */
 	sbp2_set_busy_timeout(lu);
@@ -919,7 +929,7 @@ static void sbp2_reconnect(struct work_s
 	struct sbp2_logical_unit *lu =
 		container_of(work, struct sbp2_logical_unit, work.work);
 	struct sbp2_target *tgt = lu->tgt;
-	struct fw_device *device = target_device(tgt);
+	struct fw_device *device = target_parent_device(tgt);
 	int generation, node_id, local_node_id;
 
 	if (fw_device_is_shutdown(device))
@@ -943,7 +953,7 @@ static void sbp2_reconnect(struct work_s
 		smp_rmb(); /* get current card generation */
 		if (generation == device->card->generation ||
 		    lu->retries++ >= 5) {
-			fw_error("%s: failed to reconnect\n", tgt->bus_id);
+			dev_err(tgt_dev(tgt), "failed to reconnect\n");
 			lu->retries = 0;
 			PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
 		}
@@ -957,8 +967,8 @@ static void sbp2_reconnect(struct work_s
 	smp_wmb();	  /* node IDs must not be older than generation */
 	lu->generation	  = generation;
 
-	fw_notify("%s: reconnected to LUN %04x (%d retries)\n",
-		  tgt->bus_id, lu->lun, lu->retries);
+	dev_notice(tgt_dev(tgt), "reconnected to LUN %04x (%d retries)\n",
+		   lu->lun, lu->retries);
 
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
@@ -1068,8 +1078,8 @@ static void sbp2_clamp_management_orb_ti
 	unsigned int timeout = tgt->mgt_orb_timeout;
 
 	if (timeout > 40000)
-		fw_notify("%s: %ds mgt_ORB_timeout limited to 40s\n",
-			  tgt->bus_id, timeout / 1000);
+		dev_notice(tgt_dev(tgt), "%ds mgt_ORB_timeout limited to 40s\n",
+			   timeout / 1000);
 
 	tgt->mgt_orb_timeout = clamp_val(timeout, 5000, 40000);
 }
@@ -1081,9 +1091,9 @@ static void sbp2_init_workarounds(struct
 	unsigned int w = sbp2_param_workarounds;
 
 	if (w)
-		fw_notify("Please notify linux1394-devel@lists.sourceforge.net "
-			  "if you need the workarounds parameter for %s\n",
-			  tgt->bus_id);
+		dev_notice(tgt_dev(tgt),
+			   "Please notify linux1394-devel@lists.sf.net "
+			   "if you need the workarounds parameter\n");
 
 	if (w & SBP2_WORKAROUND_OVERRIDE)
 		goto out;
@@ -1103,9 +1113,9 @@ static void sbp2_init_workarounds(struct
 	}
  out:
 	if (w)
-		fw_notify("Workarounds for %s: 0x%x "
-			  "(firmware_revision 0x%06x, model_id 0x%06x)\n",
-			  tgt->bus_id, w, firmware_revision, model);
+		dev_notice(tgt_dev(tgt), "workarounds 0x%x "
+			   "(firmware_revision 0x%06x, model_id 0x%06x)\n",
+			   w, firmware_revision, model);
 	tgt->workarounds = w;
 }
 
@@ -1133,7 +1143,6 @@ static int sbp2_probe(struct device *dev
 	dev_set_drvdata(&unit->device, tgt);
 	tgt->unit = unit;
 	INIT_LIST_HEAD(&tgt->lu_list);
-	tgt->bus_id = dev_name(&unit->device);
 	tgt->guid = (u64)device->config_rom[3] << 32 | device->config_rom[4];
 
 	if (fw_device_enable_phys_dma(device) < 0)
@@ -1239,7 +1248,7 @@ static int sbp2_remove(struct device *de
 		kfree(lu);
 	}
 	scsi_remove_host(shost);
-	fw_notify("released %s, target %d:0:0\n", tgt->bus_id, shost->host_no);
+	dev_notice(dev, "released target %d:0:0\n", shost->host_no);
 
 	scsi_host_put(shost);
 	return 0;
@@ -1325,7 +1334,7 @@ static void complete_command_orb(struct
 {
 	struct sbp2_command_orb *orb =
 		container_of(base_orb, struct sbp2_command_orb, base);
-	struct fw_device *device = target_device(orb->lu->tgt);
+	struct fw_device *device = target_parent_device(orb->lu->tgt);
 	int result;
 
 	if (status != NULL) {
@@ -1433,7 +1442,7 @@ static int sbp2_scsi_queuecommand(struct
 				  struct scsi_cmnd *cmd)
 {
 	struct sbp2_logical_unit *lu = cmd->device->hostdata;
-	struct fw_device *device = target_device(lu->tgt);
+	struct fw_device *device = target_parent_device(lu->tgt);
 	struct sbp2_command_orb *orb;
 	int generation, retval = SCSI_MLQUEUE_HOST_BUSY;
 
@@ -1442,7 +1451,7 @@ static int sbp2_scsi_queuecommand(struct
 	 * transfer direction not handled.
 	 */
 	if (cmd->sc_data_direction == DMA_BIDIRECTIONAL) {
-		fw_error("Can't handle DMA_BIDIRECTIONAL, rejecting command\n");
+		dev_err(lu_dev(lu), "cannot handle bidirectional command\n");
 		cmd->result = DID_ERROR << 16;
 		cmd->scsi_done(cmd);
 		return 0;
@@ -1450,7 +1459,7 @@ static int sbp2_scsi_queuecommand(struct
 
 	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
 	if (orb == NULL) {
-		fw_notify("failed to alloc orb\n");
+		dev_notice(lu_dev(lu), "failed to alloc ORB\n");
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1550,7 +1559,7 @@ static int sbp2_scsi_abort(struct scsi_c
 {
 	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 
-	fw_notify("%s: sbp2_scsi_abort\n", lu->tgt->bus_id);
+	dev_notice(lu_dev(lu), "sbp2_scsi_abort\n");
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
 


-- 
Stefan Richter
-=====-==-== ==-- =-=--
http://arcgraph.de/sr/
