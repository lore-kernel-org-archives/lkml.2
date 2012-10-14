Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2JNOmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:42:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46180 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab2JNOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:10 -0400
Message-Id: <20121014143551.888316605@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 134/147] [SCSI] hpsa: dial down lockup detection during firmware flash
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit e85c59746957fd6e3595d02cf614370056b5816e upstream.

Dial back the aggressiveness of the controller lockup detection thread.
Currently it will declare the controller to be locked up if it goes
for 10 seconds with no interrupts and no change in the heartbeat
register.  Dial back this to 30 seconds with no heartbeat change, and
also snoop the ioctl path and if a firmware flash command is detected,
dial it back further to 4 minutes until the firmware flash command
completes.  The reason for this is that during the firmware flash
operation, the controller apparently doesn't update the heartbeat
register as frequently as it is supposed to, and we can get a false
positive.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/hpsa.c     |   39 ++++++++++++++++++++++++++++++++++-----
 drivers/scsi/hpsa.h     |    2 ++
 drivers/scsi/hpsa_cmd.h |    1 +
 3 files changed, 37 insertions(+), 5 deletions(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -532,12 +532,42 @@ static void set_performant_mode(struct c
 		c->busaddr |= 1 | (h->blockFetchTable[c->Header.SGList] << 1);
 }
 
+static int is_firmware_flash_cmd(u8 *cdb)
+{
+	return cdb[0] == BMIC_WRITE && cdb[6] == BMIC_FLASH_FIRMWARE;
+}
+
+/*
+ * During firmware flash, the heartbeat register may not update as frequently
+ * as it should.  So we dial down lockup detection during firmware flash. and
+ * dial it back up when firmware flash completes.
+ */
+#define HEARTBEAT_SAMPLE_INTERVAL_DURING_FLASH (240 * HZ)
+#define HEARTBEAT_SAMPLE_INTERVAL (30 * HZ)
+static void dial_down_lockup_detection_during_fw_flash(struct ctlr_info *h,
+		struct CommandList *c)
+{
+	if (!is_firmware_flash_cmd(c->Request.CDB))
+		return;
+	atomic_inc(&h->firmware_flash_in_progress);
+	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL_DURING_FLASH;
+}
+
+static void dial_up_lockup_detection_on_fw_flash_complete(struct ctlr_info *h,
+		struct CommandList *c)
+{
+	if (is_firmware_flash_cmd(c->Request.CDB) &&
+		atomic_dec_and_test(&h->firmware_flash_in_progress))
+		h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
+}
+
 static void enqueue_cmd_and_start_io(struct ctlr_info *h,
 	struct CommandList *c)
 {
 	unsigned long flags;
 
 	set_performant_mode(h, c);
+	dial_down_lockup_detection_during_fw_flash(h, c);
 	spin_lock_irqsave(&h->lock, flags);
 	addQ(&h->reqQ, c);
 	h->Qdepth++;
@@ -3032,6 +3062,7 @@ static inline int bad_tag(struct ctlr_in
 static inline void finish_cmd(struct CommandList *c, u32 raw_tag)
 {
 	removeQ(c);
+	dial_up_lockup_detection_on_fw_flash_complete(c->h, c);
 	if (likely(c->cmd_type == CMD_SCSI))
 		complete_scsi_command(c);
 	else if (c->cmd_type == CMD_IOCTL_PEND)
@@ -4172,9 +4203,6 @@ static void controller_lockup_detected(s
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
-#define HEARTBEAT_SAMPLE_INTERVAL (10 * HZ)
-#define HEARTBEAT_CHECK_MINIMUM_INTERVAL (HEARTBEAT_SAMPLE_INTERVAL / 2)
-
 static void detect_controller_lockup(struct ctlr_info *h)
 {
 	u64 now;
@@ -4185,7 +4213,7 @@ static void detect_controller_lockup(str
 	now = get_jiffies_64();
 	/* If we've received an interrupt recently, we're ok. */
 	if (time_after64(h->last_intr_timestamp +
-				(HEARTBEAT_CHECK_MINIMUM_INTERVAL), now))
+				(h->heartbeat_sample_interval), now))
 		return;
 
 	/*
@@ -4194,7 +4222,7 @@ static void detect_controller_lockup(str
 	 * otherwise don't care about signals in this thread.
 	 */
 	if (time_after64(h->last_heartbeat_timestamp +
-				(HEARTBEAT_CHECK_MINIMUM_INTERVAL), now))
+				(h->heartbeat_sample_interval), now))
 		return;
 
 	/* If heartbeat has not changed since we last looked, we're not ok. */
@@ -4236,6 +4264,7 @@ static void add_ctlr_to_lockup_detector_
 {
 	unsigned long flags;
 
+	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
 	spin_lock_irqsave(&lockup_detector_lock, flags);
 	list_add_tail(&h->lockup_list, &hpsa_ctlr_list);
 	spin_unlock_irqrestore(&lockup_detector_lock, flags);
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -124,6 +124,8 @@ struct ctlr_info {
 	u64 last_intr_timestamp;
 	u32 last_heartbeat;
 	u64 last_heartbeat_timestamp;
+	u32 heartbeat_sample_interval;
+	atomic_t firmware_flash_in_progress;
 	u32 lockup_detected;
 	struct list_head lockup_list;
 };
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -163,6 +163,7 @@ struct SenseSubsystem_info {
 #define BMIC_WRITE 0x27
 #define BMIC_CACHE_FLUSH 0xc2
 #define HPSA_CACHE_FLUSH 0x01	/* C2 was already being used by HPSA */
+#define BMIC_FLASH_FIRMWARE 0xF7
 
 /* Command List Structure */
 union SCSI3Addr {


