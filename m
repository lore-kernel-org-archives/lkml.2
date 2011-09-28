Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1I1WlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:41:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab1I1Wk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:33 2011
Message-Id: <20110928220133.540617131@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephan Raue <sraue@openelec.tv>, Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [078/244] [media] nuvoton-cir: simplify raw IR sample handling
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarod Wilson <jarod@redhat.com>

commit de4ed0c111ed078b8729a5cc49c23197740f5bad upstream.

The nuvoton-cir driver was storing up consecutive pulse-pulse and
space-space samples internally, for no good reason, since
ir_raw_event_store_with_filter() already merges back to back like
samples types for us. This should also fix a regression introduced late
in 3.0 that related to a timeout change, which actually becomes correct
when coupled with this change. Tested with RC6 and RC5 on my own
nuvoton-cir hardware atop vanilla 3.0.0, after verifying quirky
behavior in 3.0 due to the timeout change.

Reported-by: Stephan Raue <sraue@openelec.tv>
CC: Stephan Raue <sraue@openelec.tv>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/rc/nuvoton-cir.c |   45 +++++++----------------------------------
 drivers/media/rc/nuvoton-cir.h |    1 
 2 files changed, 8 insertions(+), 38 deletions(-)

--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -624,7 +624,6 @@ static void nvt_dump_rx_buf(struct nvt_d
 static void nvt_process_rx_ir_data(struct nvt_dev *nvt)
 {
 	DEFINE_IR_RAW_EVENT(rawir);
-	unsigned int count;
 	u32 carrier;
 	u8 sample;
 	int i;
@@ -637,65 +636,38 @@ static void nvt_process_rx_ir_data(struc
 	if (nvt->carrier_detect_enabled)
 		carrier = nvt_rx_carrier_detect(nvt);
 
-	count = nvt->pkts;
-	nvt_dbg_verbose("Processing buffer of len %d", count);
+	nvt_dbg_verbose("Processing buffer of len %d", nvt->pkts);
 
 	init_ir_raw_event(&rawir);
 
-	for (i = 0; i < count; i++) {
-		nvt->pkts--;
+	for (i = 0; i < nvt->pkts; i++) {
 		sample = nvt->buf[i];
 
 		rawir.pulse = ((sample & BUF_PULSE_BIT) != 0);
 		rawir.duration = US_TO_NS((sample & BUF_LEN_MASK)
 					  * SAMPLE_PERIOD);
 
-		if ((sample & BUF_LEN_MASK) == BUF_LEN_MASK) {
-			if (nvt->rawir.pulse == rawir.pulse)
-				nvt->rawir.duration += rawir.duration;
-			else {
-				nvt->rawir.duration = rawir.duration;
-				nvt->rawir.pulse = rawir.pulse;
-			}
-			continue;
-		}
-
-		rawir.duration += nvt->rawir.duration;
-
-		init_ir_raw_event(&nvt->rawir);
-		nvt->rawir.duration = 0;
-		nvt->rawir.pulse = rawir.pulse;
-
-		if (sample == BUF_PULSE_BIT)
-			rawir.pulse = false;
-
-		if (rawir.duration) {
-			nvt_dbg("Storing %s with duration %d",
-				rawir.pulse ? "pulse" : "space",
-				rawir.duration);
+		nvt_dbg("Storing %s with duration %d",
+			rawir.pulse ? "pulse" : "space", rawir.duration);
 
-			ir_raw_event_store_with_filter(nvt->rdev, &rawir);
-		}
+		ir_raw_event_store_with_filter(nvt->rdev, &rawir);
 
 		/*
 		 * BUF_PULSE_BIT indicates end of IR data, BUF_REPEAT_BYTE
 		 * indicates end of IR signal, but new data incoming. In both
 		 * cases, it means we're ready to call ir_raw_event_handle
 		 */
-		if ((sample == BUF_PULSE_BIT) && nvt->pkts) {
+		if ((sample == BUF_PULSE_BIT) && (i + 1 < nvt->pkts)) {
 			nvt_dbg("Calling ir_raw_event_handle (signal end)\n");
 			ir_raw_event_handle(nvt->rdev);
 		}
 	}
 
+	nvt->pkts = 0;
+
 	nvt_dbg("Calling ir_raw_event_handle (buffer empty)\n");
 	ir_raw_event_handle(nvt->rdev);
 
-	if (nvt->pkts) {
-		nvt_dbg("Odd, pkts should be 0 now... (its %u)", nvt->pkts);
-		nvt->pkts = 0;
-	}
-
 	nvt_dbg_verbose("%s done", __func__);
 }
 
@@ -1054,7 +1026,6 @@ static int nvt_probe(struct pnp_dev *pde
 
 	spin_lock_init(&nvt->nvt_lock);
 	spin_lock_init(&nvt->tx.lock);
-	init_ir_raw_event(&nvt->rawir);
 
 	ret = -EBUSY;
 	/* now claim resources */
--- a/drivers/media/rc/nuvoton-cir.h
+++ b/drivers/media/rc/nuvoton-cir.h
@@ -67,7 +67,6 @@ static int debug;
 struct nvt_dev {
 	struct pnp_dev *pdev;
 	struct rc_dev *rdev;
-	struct ir_raw_event rawir;
 
 	spinlock_t nvt_lock;
 


