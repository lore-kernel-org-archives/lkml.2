Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1IGQhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:37:12 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:52555 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1IGQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:37:09 -0400
Content-transfer-encoding: 7BIT
From: Eli Billauer <eli.billauer@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH] xsysace.c fixed to run reliably with 8-bit interface
Date: Wed, 07 Sep 2011 14:37:17 +0300
Message-id: <1315395437-25838-1-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It all started with the CompactFlash on my Xilinx SP605 board being horribly
unreliable. After a lot of work, it turned out that the problem is that
the System ACE chip (or its Xilinx core) sometimes ignores the first out_8()
in a series of writes (including the LSB of a 16-bit word in 8 bit mode).

This is worked around simply by a harmless dummy write before any series of
writes to the chip's register space. It's effective only in 8-bit mode.

With this patch, I have error-less access on the Compact Flash using an
ext2 filesystem. It has been tested with 150MB of data written and read back.
Before it, I was lucky if I managed to mount the filesystem even as read only.

The immediate result of the hardware problem was that sectors were read and
written from the wrong place every now and then. I've made quite some changes
to the driver, some of which are directly related to this problem, and some
are just a matter of being pedantic with the datasheet.

As I was trying to figure out what was wrong, I made quite a few changes in
the driver. Some of them are just a matter of being pedantic (e.g. following
the datasheet exactly) and others had to do with making the driver react
gracefully to things going horribly wrong, as necessary until I came up with
that simple workaround. Since the solution is quirky, I decided to leave
these now apparently unnecessary changes, as they have a low impact on
performance, and the nature of the hardware bug worked around isn't clear.

Here's a summary of the changes:

* The workaround mentioned above.

* Readback on the ACE_MPULBA register immediately after writing to it, and
  aborting if a wrong value is found. This is a silly check, but before the
  workaround, the register wasn't updated with the desired value every
  now and then (1:100 or so) causing the driver to read or write to the wrong
  sector. This problem was in fact what made me start working on this.
  Yup, this is very odd, but this readback check kicks in often enough.

* In order to support this, there are some changes in the FSM's logic,
  and an ACE_FSM_STATE_ABORT state was introduced. This state is also assigned
  when the a stalled FSM gets a timer kick. It's harmless, since the FSM's
  new logic keeps trying handling the same set of sectors until successful.
  Same goes for failed transfers, as indicated by interrupt.

* The reset and lock are now released after each transfer, as required by
  spec.

* The check for the existence of a CF card was removed, since it caused
  nasty false alarms under stress testing. This happened most likely while
  the FSM was in the middle of aborting something.

* Each __blk_end_request_cur() is seen as an independent request, and no
  continuity in sector numbers is assumed, even though it's that way in
  practice. I don't know if this is needed, but once implemented, it's a
  small overhead and more robust.

* The deprecated of_property_read_u32() call was replaced with
  of_get_property(). Default application was corrected as well.

* The ACE_BUF_PER_SECTOR define is used at all places applicable (a correct
  constant appeared in some places)

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 drivers/block/xsysace.c |  197 ++++++++++++++++++++++++++++++++--------------
 1 files changed, 137 insertions(+), 60 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index fb1975d..011d299 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -238,6 +238,15 @@ static u16 ace_in_8(struct ace_device *ace, int reg)
 static void ace_out_8(struct ace_device *ace, int reg, u16 val)
 {
 	void __iomem *r = ace->baseaddr + reg;
+	void __iomem *dummy = ace->baseaddr + ACE_BUSMODE;
+
+	/*
+	 * This is just a dummy write which works around some hardware bug.
+	 * Without this, some writes are missed by the System ACE chip.
+	 */
+
+	out_8(dummy, 0); /* Set bus to 8 bit (it's already...) */
+
 	out_8(r, val);
 	out_8(r + 1, val >> 8);
 }
@@ -254,9 +263,17 @@ static void ace_datain_8(struct ace_device *ace)
 
 static void ace_dataout_8(struct ace_device *ace)
 {
-	void __iomem *r = ace->baseaddr + 0x40;
+	void __iomem *r = ace->baseaddr + 0x40;
+	void __iomem *dummy = ace->baseaddr + ACE_BUSMODE;
 	u8 *src = ace->data_ptr;
 	int i = ACE_FIFO_SIZE;
+
+	/*
+	 * This is just a dummy write which works around some hardware bug.
+	 * Without this, some writes are missed by the System ACE chip.
+	 */
+	out_8(dummy, 0); /* Set bus to 8 bit (it's already...) */
+
 	while (i--)
 		out_8(r++, *src++);
 	ace->data_ptr = src;
@@ -439,9 +456,10 @@ void ace_fix_driveid(u16 *id)
 #define ACE_FSM_STATE_IDENTIFY_COMPLETE  6
 #define ACE_FSM_STATE_REQ_PREPARE        7
 #define ACE_FSM_STATE_REQ_TRANSFER       8
-#define ACE_FSM_STATE_REQ_COMPLETE       9
+#define ACE_FSM_STATE_UNLOCK       9
 #define ACE_FSM_STATE_ERROR             10
-#define ACE_FSM_NUM_STATES              11
+#define ACE_FSM_STATE_ABORT             11
+#define ACE_FSM_NUM_STATES              12
 
 /* Set flag to exit FSM loop and reschedule tasklet */
 static inline void ace_fsm_yield(struct ace_device *ace)
@@ -487,37 +505,11 @@ static void ace_fsm_dostate(struct ace_device *ace)
 	dev_dbg(ace->dev, "fsm_state=%i, id_req_count=%i\n",
 		ace->fsm_state, ace->id_req_count);
 #endif
-
-	/* Verify that there is actually a CF in the slot. If not, then
-	 * bail out back to the idle state and wake up all the waiters */
-	status = ace_in32(ace, ACE_STATUS);
-	if ((status & ACE_STATUS_CFDETECT) == 0) {
-		ace->fsm_state = ACE_FSM_STATE_IDLE;
-		ace->media_change = 1;
-		set_capacity(ace->gd, 0);
-		dev_info(ace->dev, "No CF in slot\n");
-
-		/* Drop all in-flight and pending requests */
-		if (ace->req) {
-			__blk_end_request_all(ace->req, -EIO);
-			ace->req = NULL;
-		}
-		while ((req = blk_fetch_request(ace->queue)) != NULL)
-			__blk_end_request_all(req, -EIO);
-
-		/* Drop back to IDLE state and notify waiters */
-		ace->fsm_state = ACE_FSM_STATE_IDLE;
-		ace->id_result = -EIO;
-		while (ace->id_req_count) {
-			complete(&ace->id_completion);
-			ace->id_req_count--;
-		}
-	}
-
 	switch (ace->fsm_state) {
 	case ACE_FSM_STATE_IDLE:
 		/* See if there is anything to do */
-		if (ace->id_req_count || ace_get_next_request(ace->queue)) {
+		if (ace->req ||
+		    ace->id_req_count || ace_get_next_request(ace->queue)) {
 			ace->fsm_iter_num++;
 			ace->fsm_state = ACE_FSM_STATE_REQ_LOCK;
 			mod_timer(&ace->stall_timer, jiffies + HZ);
@@ -646,26 +638,41 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		break;
 
 	case ACE_FSM_STATE_REQ_PREPARE:
-		req = ace_get_next_request(ace->queue);
-		if (!req) {
-			ace->fsm_state = ACE_FSM_STATE_IDLE;
-			break;
-		}
-		blk_start_request(req);
+		if (!ace->req) {
+			req = ace_get_next_request(ace->queue);
+			if (!req) {
+				ace->fsm_state = ACE_FSM_STATE_IDLE;
+				break;
+			}
+			blk_start_request(req);
+
+			dev_dbg(ace->dev,
+				"request: sec=%llx hcnt=%x, ccnt=%x, dir=%i\n",
+				(unsigned long long)blk_rq_pos(req),
+				blk_rq_sectors(req), blk_rq_cur_sectors(req),
+				rq_data_dir(req));
 
-		/* Okay, it's a data request, set it up for transfer */
-		dev_dbg(ace->dev,
-			"request: sec=%llx hcnt=%x, ccnt=%x, dir=%i\n",
-			(unsigned long long)blk_rq_pos(req),
-			blk_rq_sectors(req), blk_rq_cur_sectors(req),
-			rq_data_dir(req));
+			ace->req = req;
+		} else {
+			req = ace->req;
+		}
 
-		ace->req = req;
 		ace->data_ptr = req->buffer;
 		ace->data_count = blk_rq_cur_sectors(req) * ACE_BUF_PER_SECTOR;
 		ace_out32(ace, ACE_MPULBA, blk_rq_pos(req) & 0x0FFFFFFF);
 
-		count = blk_rq_sectors(req);
+		if (ace_in32(ace, ACE_MPULBA) != blk_rq_pos(req)) {
+			dev_dbg(ace->dev,
+				"ACE_MPULBA = %d != %d = blk_rq_pos(req)\n",
+				ace_in32(ace, ACE_MPULBA),
+				(u32) blk_rq_pos(req));
+
+			ace->fsm_state = ACE_FSM_STATE_ABORT;
+			break;
+		}
+
+		count = blk_rq_cur_sectors(req);
+
 		if (rq_data_dir(req)) {
 			/* Kick off write request */
 			dev_dbg(ace->dev, "write data\n");
@@ -699,7 +706,8 @@ static void ace_fsm_dostate(struct ace_device *ace)
 			dev_dbg(ace->dev,
 				"CFBSY set; t=%i iter=%i c=%i dc=%i irq=%i\n",
 				ace->fsm_task, ace->fsm_iter_num,
-				blk_rq_cur_sectors(ace->req) * 16,
+				blk_rq_cur_sectors(ace->req) *
+				ACE_BUF_PER_SECTOR,
 				ace->data_count, ace->in_irq);
 			ace_fsm_yield(ace);	/* need to poll CFBSY bit */
 			break;
@@ -708,7 +716,8 @@ static void ace_fsm_dostate(struct ace_device *ace)
 			dev_dbg(ace->dev,
 				"DATABUF not set; t=%i iter=%i c=%i dc=%i irq=%i\n",
 				ace->fsm_task, ace->fsm_iter_num,
-				blk_rq_cur_sectors(ace->req) * 16,
+				blk_rq_cur_sectors(ace->req) *
+				ACE_BUF_PER_SECTOR,
 				ace->data_count, ace->in_irq);
 			ace_fsm_yieldirq(ace);
 			break;
@@ -721,7 +730,10 @@ static void ace_fsm_dostate(struct ace_device *ace)
 			ace->reg_ops->datain(ace);
 		ace->data_count--;
 
-		/* If there are still buffers to be transfers; jump out here */
+		/*
+		 * If there are still buffers to be transferred,
+		 * jump out here
+		 */
 		if (ace->data_count != 0) {
 			ace_fsm_yieldirq(ace);
 			break;
@@ -733,22 +745,68 @@ static void ace_fsm_dostate(struct ace_device *ace)
 			 *      blk_rq_sectors(ace->req),
 			 *      blk_rq_cur_sectors(ace->req));
 			 */
-			ace->data_ptr = ace->req->buffer;
-			ace->data_count = blk_rq_cur_sectors(ace->req) * 16;
-			ace_fsm_yieldirq(ace);
+
+			/*
+			 * Going to IDLE effectively means starting over
+			 * immediately with the next chunk, because ace->req
+			 * is non-NULL.
+			 */
+
+			ace->fsm_state = ACE_FSM_STATE_UNLOCK;
 			break;
 		}
 
-		ace->fsm_state = ACE_FSM_STATE_REQ_COMPLETE;
+		ace->req = NULL;
+		ace->fsm_state = ACE_FSM_STATE_UNLOCK;
 		break;
 
-	case ACE_FSM_STATE_REQ_COMPLETE:
-		ace->req = NULL;
+	case ACE_FSM_STATE_UNLOCK:
+		/* The datasheet requires clearing reset and then unlock */
+
+		val = ace_in(ace, ACE_CTRL);
+		ace_out(ace, ACE_CTRL, val & ~ACE_CTRL_CFGRESET);
 
-		/* Finished request; go to idle state */
+		val = ace_in(ace, ACE_CTRL);
+		ace_out(ace, ACE_CTRL,
+			val & ~ACE_CTRL_LOCKREQ & ~ACE_CTRL_FORCELOCKREQ);
+
 		ace->fsm_state = ACE_FSM_STATE_IDLE;
 		break;
 
+	case ACE_FSM_STATE_ABORT:
+		/* Take the lock by force if necessary. */
+
+		if (!(ace_in(ace, ACE_STATUS) & ACE_STATUS_MPULOCK)) {
+			val = ace_in(ace, ACE_CTRL);
+			ace_out(ace, ACE_CTRL, val | ACE_CTRL_FORCELOCKREQ);
+		}
+
+		/*
+		 * If there's still data in the buffer, it has to be
+		 * drained, or the chip will refuse to give the lock
+		 * again later on. Since we can reach this point from
+		 * basically anywhere, it's safest to use a dedicated
+		 * 32-byte buffer.
+		 */
+
+		if (ace_in(ace, ACE_STATUS) & ACE_STATUS_DATABUFRDY) {
+			u16 junkbuffer[ACE_FIFO_SIZE/2];
+
+			ace->data_ptr = junkbuffer;
+
+			if (ace_in(ace, ACE_STATUS) & ACE_STATUS_DATABUFMODE)
+				ace->reg_ops->dataout(ace);
+			else
+				ace->reg_ops->datain(ace);
+
+			ace_fsm_yield(ace);
+			break;
+		}
+
+		ace_out(ace, ACE_SECCNTCMD, ACE_SECCNTCMD_ABORT);
+		ace->fsm_state = ACE_FSM_STATE_UNLOCK;
+		break;
+
 	default:
 		ace->fsm_state = ACE_FSM_STATE_IDLE;
 		break;
@@ -779,12 +837,20 @@ static void ace_stall_timer(unsigned long data)
 		 "kicking stalled fsm; state=%i task=%i iter=%i dc=%i\n",
 		 ace->fsm_state, ace->fsm_task, ace->fsm_iter_num,
 		 ace->data_count);
+
 	spin_lock_irqsave(&ace->lock, flags);
 
 	/* Rearm the stall timer *before* entering FSM (which may then
 	 * delete the timer) */
 	mod_timer(&ace->stall_timer, jiffies + HZ);
 
+	/*
+	 * Attempt to abort the current operation. Since ace->req doesn't
+	 * change, and is taken into account in the IDLE state, this
+	 * aggressive measure is not expected to cause any data loss.
+	 */
+	ace->fsm_state = ACE_FSM_STATE_ABORT;
+
 	/* Loop over state machine until told to stop */
 	ace->fsm_continue_flag = 1;
 	while (ace->fsm_continue_flag)
@@ -804,8 +870,11 @@ static int ace_interrupt_checkstate(struct ace_device *ace)
 	/* Check for error occurrence */
 	if ((sreg & (ACE_STATUS_CFGERROR | ACE_STATUS_CFCERROR)) &&
 	    (creg & ACE_CTRL_ERRORIRQ)) {
-		dev_err(ace->dev, "transfer failure\n");
+		dev_err(ace->dev, "Transfer failure.\n");
 		ace_dump_regs(ace);
+
+		ace->fsm_state = ACE_FSM_STATE_ABORT;
+
 		return -EIO;
 	}
 
@@ -928,7 +997,8 @@ static int ace_release(struct gendisk *disk, fmode_t mode)
 	ace->users--;
 	if (ace->users == 0) {
 		val = ace_in(ace, ACE_CTRL);
-		ace_out(ace, ACE_CTRL, val & ~ACE_CTRL_LOCKREQ);
+		ace_out(ace, ACE_CTRL,
+			val & ~ACE_CTRL_LOCKREQ & ~ACE_CTRL_FORCELOCKREQ);
 	}
 	spin_unlock_irqrestore(&ace->lock, flags);
 	mutex_unlock(&xsysace_mutex);
@@ -1056,6 +1126,7 @@ static int __devinit ace_setup(struct ace_device *ace)
 
 	ace->media_change = 1;
 	ace_revalidate_disk(ace->gd);
+	ace->req = NULL;
 
 	/* Make the sysace device 'live' */
 	add_disk(ace->gd);
@@ -1155,16 +1226,22 @@ static int __devinit ace_probe(struct platform_device *dev)
 {
 	resource_size_t physaddr = 0;
 	int bus_width = ACE_BUS_WIDTH_16; /* FIXME: should not be hard coded */
-	u32 id = dev->id;
+	u32 id;
+	const u32 *id_p;
 	int irq = NO_IRQ;
 	int i;
 
 	dev_dbg(&dev->dev, "ace_probe(%p)\n", dev);
 
 	/* device id and bus width */
-	of_property_read_u32(dev->dev.of_node, "port-number", &id);
-	if (id < 0)
+
+	id_p = of_get_property(dev->dev.of_node, "port-number", NULL);
+
+	if (id_p)
+		id = be32_to_cpu(*id_p);
+	else
 		id = 0;
+
 	if (of_find_property(dev->dev.of_node, "8-bit", NULL))
 		bus_width = ACE_BUS_WIDTH_8;
 
-- 
1.7.2.3

