Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0IRTQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:16:36 -0400
Received: from kroah.org ([198.145.64.141]:43959 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab0IRTQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:34 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:07 2010
Message-Id: <20100918191307.830488470@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [123/129] drm/i915/dp: Really try 5 times before giving up.
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 4f7f7b7eb94bd37c449f06932459bbed78826f8d upstream.

Only stop trying if the aux channel sucessfully reports that the
transmission was completed, otherwise try again. On the 5th failure,
bail and report that something is amiss.

This fixes a sporadic failure in reading the EDID for my external panel
over DP.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_dp.c |   58 +++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -229,7 +229,6 @@ intel_dp_aux_ch(struct intel_encoder *in
 	uint32_t ch_data = ch_ctl + 4;
 	int i;
 	int recv_bytes;
-	uint32_t ctl;
 	uint32_t status;
 	uint32_t aux_clock_divider;
 	int try, precharge;
@@ -253,41 +252,43 @@ intel_dp_aux_ch(struct intel_encoder *in
 	else
 		precharge = 5;
 
+	if (I915_READ(ch_ctl) & DP_AUX_CH_CTL_SEND_BUSY) {
+		DRM_ERROR("dp_aux_ch not started status 0x%08x\n",
+			  I915_READ(ch_ctl));
+		return -EBUSY;
+	}
+
 	/* Must try at least 3 times according to DP spec */
 	for (try = 0; try < 5; try++) {
 		/* Load the send data into the aux channel data registers */
-		for (i = 0; i < send_bytes; i += 4) {
-			uint32_t    d = pack_aux(send + i, send_bytes - i);
-	
-			I915_WRITE(ch_data + i, d);
-		}
-	
-		ctl = (DP_AUX_CH_CTL_SEND_BUSY |
-		       DP_AUX_CH_CTL_TIME_OUT_400us |
-		       (send_bytes << DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT) |
-		       (precharge << DP_AUX_CH_CTL_PRECHARGE_2US_SHIFT) |
-		       (aux_clock_divider << DP_AUX_CH_CTL_BIT_CLOCK_2X_SHIFT) |
-		       DP_AUX_CH_CTL_DONE |
-		       DP_AUX_CH_CTL_TIME_OUT_ERROR |
-		       DP_AUX_CH_CTL_RECEIVE_ERROR);
+		for (i = 0; i < send_bytes; i += 4)
+			I915_WRITE(ch_data + i,
+				   pack_aux(send + i, send_bytes - i));
 	
 		/* Send the command and wait for it to complete */
-		I915_WRITE(ch_ctl, ctl);
-		(void) I915_READ(ch_ctl);
+		I915_WRITE(ch_ctl,
+			   DP_AUX_CH_CTL_SEND_BUSY |
+			   DP_AUX_CH_CTL_TIME_OUT_400us |
+			   (send_bytes << DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT) |
+			   (precharge << DP_AUX_CH_CTL_PRECHARGE_2US_SHIFT) |
+			   (aux_clock_divider << DP_AUX_CH_CTL_BIT_CLOCK_2X_SHIFT) |
+			   DP_AUX_CH_CTL_DONE |
+			   DP_AUX_CH_CTL_TIME_OUT_ERROR |
+			   DP_AUX_CH_CTL_RECEIVE_ERROR);
 		for (;;) {
-			udelay(100);
 			status = I915_READ(ch_ctl);
 			if ((status & DP_AUX_CH_CTL_SEND_BUSY) == 0)
 				break;
+			udelay(100);
 		}
 	
 		/* Clear done status and any errors */
-		I915_WRITE(ch_ctl, (status |
-				DP_AUX_CH_CTL_DONE |
-				DP_AUX_CH_CTL_TIME_OUT_ERROR |
-				DP_AUX_CH_CTL_RECEIVE_ERROR));
-		(void) I915_READ(ch_ctl);
-		if ((status & DP_AUX_CH_CTL_TIME_OUT_ERROR) == 0)
+		I915_WRITE(ch_ctl,
+			   status |
+			   DP_AUX_CH_CTL_DONE |
+			   DP_AUX_CH_CTL_TIME_OUT_ERROR |
+			   DP_AUX_CH_CTL_RECEIVE_ERROR);
+		if (status & DP_AUX_CH_CTL_DONE)
 			break;
 	}
 
@@ -314,15 +315,12 @@ intel_dp_aux_ch(struct intel_encoder *in
 	/* Unload any bytes sent back from the other side */
 	recv_bytes = ((status & DP_AUX_CH_CTL_MESSAGE_SIZE_MASK) >>
 		      DP_AUX_CH_CTL_MESSAGE_SIZE_SHIFT);
-
 	if (recv_bytes > recv_size)
 		recv_bytes = recv_size;
 	
-	for (i = 0; i < recv_bytes; i += 4) {
-		uint32_t    d = I915_READ(ch_data + i);
-
-		unpack_aux(d, recv + i, recv_bytes - i);
-	}
+	for (i = 0; i < recv_bytes; i += 4)
+		unpack_aux(I915_READ(ch_data + i),
+			   recv + i, recv_bytes - i);
 
 	return recv_bytes;
 }


