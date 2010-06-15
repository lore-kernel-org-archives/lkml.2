Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab0FOAAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 20:00:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44737 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab0FOAAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 20:00:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 15 Jun 2010 02:00:11 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: remove unused variables
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <4C16AECD.50506@gmail.com>
Message-ID: <tkrat.07e788b7aad47c5e@s5r6.in-berlin.de>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
 <1276547208-26569-8-git-send-email-justinmattock@gmail.com>
 <tkrat.6f2ad8e8a9e281c2@s5r6.in-berlin.de> <4C16AECD.50506@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

which caused gcc 4.6 to warn about
    variable 'XYZ' set but not used.

sbp2.c, unit_characteristics:

The underlying problem which was spotted here --- an incomplete
implementation --- is already 50% fixed in drivers/firewire/sbp2.c which
observes mgt_ORB_timeout but not yet ORB_size.

raw1394.c, length_conflict; dv1394.c, ts_off:

Impossible to tell why these variables are there.  We can safely remove
them though because we don't need a compiler warning to realize that we
are dealing with (at least stylistically) flawed code here.

dv1394.c, packet_time:

This was used in debug macro that is only compiled in with
DV1394_DEBUG_LEVEL >= 2 defined at compile-time.  Just drop it since
nobody debugs dv1394 anymore.  Avoids noise in regular kernel builds.

dv1394.c, ohci; eth1394.c, priv:

These variables clearly can go away.  Somebody wanted to use them but
then didn't (or not anymore).

Note, all of this code is considered to be at its end of life and is
thus not really meant to receive janitorial updates anymore.  But if we
can easily remove noisy warnings from kernel builds, we should.

Reported-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Incorporates patch "ieee1394: sbp2: remove unused code".

 drivers/ieee1394/dv1394.c  |   14 ++------------
 drivers/ieee1394/eth1394.c |    3 ---
 drivers/ieee1394/raw1394.c |    3 +--
 drivers/ieee1394/sbp2.c    |   11 ++++-------
 4 files changed, 7 insertions(+), 24 deletions(-)

Index: b/drivers/ieee1394/sbp2.c
===================================================================
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1350,12 +1350,11 @@ static void sbp2_parse_unit_directory(st
 	struct csr1212_keyval *kv;
 	struct csr1212_dentry *dentry;
 	u64 management_agent_addr;
-	u32 unit_characteristics, firmware_revision, model;
+	u32 firmware_revision, model;
 	unsigned workarounds;
 	int i;
 
 	management_agent_addr = 0;
-	unit_characteristics = 0;
 	firmware_revision = SBP2_ROM_VALUE_MISSING;
 	model = ud->flags & UNIT_DIRECTORY_MODEL_ID ?
 				ud->model_id : SBP2_ROM_VALUE_MISSING;
@@ -1372,17 +1371,15 @@ static void sbp2_parse_unit_directory(st
 				lu->lun = ORB_SET_LUN(kv->value.immediate);
 			break;
 
-		case SBP2_UNIT_CHARACTERISTICS_KEY:
-			/* FIXME: This is ignored so far.
-			 * See SBP-2 clause 7.4.8. */
-			unit_characteristics = kv->value.immediate;
-			break;
 
 		case SBP2_FIRMWARE_REVISION_KEY:
 			firmware_revision = kv->value.immediate;
 			break;
 
 		default:
+			/* FIXME: Check for SBP2_UNIT_CHARACTERISTICS_KEY
+			 * mgt_ORB_timeout and ORB_size, SBP-2 clause 7.4.8. */
+
 			/* FIXME: Check for SBP2_DEVICE_TYPE_AND_LUN_KEY.
 			 * Its "ordered" bit has consequences for command ORB
 			 * list handling. See SBP-2 clauses 4.6, 7.4.11, 10.2 */
Index: b/drivers/ieee1394/raw1394.c
===================================================================
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -1015,7 +1015,7 @@ static int arm_write(struct hpsb_host *h
 	struct arm_addr *arm_addr = NULL;
 	struct arm_request *arm_req = NULL;
 	struct arm_response *arm_resp = NULL;
-	int found = 0, size = 0, rcode = -1, length_conflict = 0;
+	int found = 0, size = 0, rcode = -1;
 	struct arm_request_response *arm_req_resp = NULL;
 
 	DBGMSG("arm_write called by node: %X "
@@ -1054,7 +1054,6 @@ static int arm_write(struct hpsb_host *h
 	}
 	if (arm_addr->rec_length < length) {
 		DBGMSG("arm_write blocklength too big -> rcode_data_error");
-		length_conflict = 1;
 		rcode = RCODE_DATA_ERROR;	/* hardware error, data is unavailable */
 	}
 	if (rcode == -1) {
Index: b/drivers/ieee1394/dv1394.c
===================================================================
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -610,7 +610,7 @@ static void frame_prepare(struct video_c
 	} else {
 
 		u32 transmit_sec, transmit_cyc;
-		u32 ts_cyc, ts_off;
+		u32 ts_cyc;
 
 		/* DMA is stopped, so this is the very first frame */
 		video->active_frame = this_frame;
@@ -636,7 +636,6 @@ static void frame_prepare(struct video_c
 		transmit_sec += transmit_cyc/8000;
 		transmit_cyc %= 8000;
 
-		ts_off = ct_off;
 		ts_cyc = transmit_cyc + 3;
 		ts_cyc %= 8000;
 
@@ -2004,7 +2003,7 @@ static void ir_tasklet_func(unsigned lon
 
 		int sof=0; /* start-of-frame flag */
 		struct frame *f;
-		u16 packet_length, packet_time;
+		u16 packet_length;
 		int i, dbc=0;
 		struct DMA_descriptor_block *block = NULL;
 		u16 xferstatus;
@@ -2024,11 +2023,6 @@ static void ir_tasklet_func(unsigned lon
 						sizeof(struct packet));
 
 			packet_length = le16_to_cpu(p->data_length);
-			packet_time   = le16_to_cpu(p->timestamp);
-
-			irq_printk("received packet %02d, timestamp=%04x, length=%04x, sof=%02x%02x\n", video->current_packet,
-				   packet_time, packet_length,
-				   p->data[0], p->data[1]);
 
 			/* get the descriptor based on packet_buffer cursor */
 			f = video->frames[video->current_packet / MAX_PACKETS];
@@ -2320,7 +2314,6 @@ static void dv1394_add_host(struct hpsb_
 
 static void dv1394_host_reset(struct hpsb_host *host)
 {
-	struct ti_ohci *ohci;
 	struct video_card *video = NULL, *tmp_vid;
 	unsigned long flags;
 
@@ -2328,9 +2321,6 @@ static void dv1394_host_reset(struct hps
 	if (strcmp(host->driver->name, OHCI1394_DRIVER_NAME))
 		return;
 
-	ohci = (struct ti_ohci *)host->hostdata;
-
-
 	/* find the corresponding video_cards */
 	spin_lock_irqsave(&dv1394_cards_lock, flags);
 	list_for_each_entry(tmp_vid, &dv1394_cards, list) {
Index: b/drivers/ieee1394/eth1394.c
===================================================================
--- a/drivers/ieee1394/eth1394.c
+++ b/drivers/ieee1394/eth1394.c
@@ -1258,7 +1258,6 @@ static void ether1394_iso(struct hpsb_is
 	char *buf;
 	struct eth1394_host_info *hi;
 	struct net_device *dev;
-	struct eth1394_priv *priv;
 	unsigned int len;
 	u32 specifier_id;
 	u16 source_id;
@@ -1288,8 +1287,6 @@ static void ether1394_iso(struct hpsb_is
 			       (be32_to_cpu(data[1]) & 0xff000000) >> 24;
 		source_id = be32_to_cpu(data[0]) >> 16;
 
-		priv = netdev_priv(dev);
-
 		if (info->channel != (iso->host->csr.broadcast_channel & 0x3f)
 		    || specifier_id != ETHER1394_GASP_SPECIFIER_ID) {
 			/* This packet is not for us */


-- 
Stefan Richter
-=====-==-=- -==- -====
http://arcgraph.de/sr/

