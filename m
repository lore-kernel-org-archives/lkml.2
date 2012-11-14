Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab2KNFve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:51:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55324 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932391Ab2KNFvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:17 -0500
Message-Id: <20121114053936.802223398@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:54 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <przanoni@gmail.com>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>
Subject: [ 21/82] drm/i915: clear the entire sdvo infoframe buffer
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit b6e0e543f75729f207b9c72b0162ae61170635b2 upstream.

Like in the case of native hdmi, which is fixed already in

commit adf00b26d18e1b3570451296e03bcb20e4798cdd
Author: Paulo Zanoni <paulo.r.zanoni@intel.com>
Date:   Tue Sep 25 13:23:34 2012 -0300

    drm/i915: make sure we write all the DIP data bytes

we need to clear the entire sdvo buffer to avoid upsetting the
display.

Since infoframe buffer writing is now a bit more elaborate, extract it
into it's own function. This will be useful if we ever get around to
properly update the ELD for sdvo. Also #define proper names for the
two buffer indexes with fixed usage.

v2: Cite the right commit above, spotted by Paulo Zanoni.

v3: I'm too stupid to paste the right commit.

v4: Ben Hutchings noticed that I've failed to handle an underflow in
my loop logic, breaking it for i >= length + 8. Since I've just lost C
programmer license, use his solution. Also, make the frustrated 0-base
buffer size a notch more clear.

Reported-and-tested-by: Jürg Billeter <j@bitron.ch>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=25732
Cc: Paulo Zanoni <przanoni@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_sdvo.c      |   62 +++++++++++++++++++++-----------
 drivers/gpu/drm/i915/intel_sdvo_regs.h |    2 ++
 2 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index c01d97d..79d308d 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -894,6 +894,45 @@ static void intel_sdvo_dump_hdmi_buf(struct intel_sdvo *intel_sdvo)
 }
 #endif
 
+static bool intel_sdvo_write_infoframe(struct intel_sdvo *intel_sdvo,
+				       unsigned if_index, uint8_t tx_rate,
+				       uint8_t *data, unsigned length)
+{
+	uint8_t set_buf_index[2] = { if_index, 0 };
+	uint8_t hbuf_size, tmp[8];
+	int i;
+
+	if (!intel_sdvo_set_value(intel_sdvo,
+				  SDVO_CMD_SET_HBUF_INDEX,
+				  set_buf_index, 2))
+		return false;
+
+	if (!intel_sdvo_get_value(intel_sdvo, SDVO_CMD_GET_HBUF_INFO,
+				  &hbuf_size, 1))
+		return false;
+
+	/* Buffer size is 0 based, hooray! */
+	hbuf_size++;
+
+	DRM_DEBUG_KMS("writing sdvo hbuf: %i, hbuf_size %i, hbuf_size: %i\n",
+		      if_index, length, hbuf_size);
+
+	for (i = 0; i < hbuf_size; i += 8) {
+		memset(tmp, 0, 8);
+		if (i < length)
+			memcpy(tmp, data + i, min_t(unsigned, 8, length - i));
+
+		if (!intel_sdvo_set_value(intel_sdvo,
+					  SDVO_CMD_SET_HBUF_DATA,
+					  tmp, 8))
+			return false;
+	}
+
+	return intel_sdvo_set_value(intel_sdvo,
+				    SDVO_CMD_SET_HBUF_TXRATE,
+				    &tx_rate, 1);
+}
+
 static bool intel_sdvo_set_avi_infoframe(struct intel_sdvo *intel_sdvo)
 {
 	struct dip_infoframe avi_if = {
@@ -901,11 +940,7 @@ static bool intel_sdvo_set_avi_infoframe(struct intel_sdvo *intel_sdvo)
 		.ver = DIP_VERSION_AVI,
 		.len = DIP_LEN_AVI,
 	};
-	uint8_t tx_rate = SDVO_HBUF_TX_VSYNC;
-	uint8_t set_buf_index[2] = { 1, 0 };
 	uint8_t sdvo_data[4 + sizeof(avi_if.body.avi)];
-	uint64_t *data = (uint64_t *)sdvo_data;
-	unsigned i;
 
 	intel_dip_infoframe_csum(&avi_if);
 
@@ -915,22 +950,9 @@ static bool intel_sdvo_set_avi_infoframe(struct intel_sdvo *intel_sdvo)
 	sdvo_data[3] = avi_if.checksum;
 	memcpy(&sdvo_data[4], &avi_if.body, sizeof(avi_if.body.avi));
 
-	if (!intel_sdvo_set_value(intel_sdvo,
-				  SDVO_CMD_SET_HBUF_INDEX,
-				  set_buf_index, 2))
-		return false;
-
-	for (i = 0; i < sizeof(sdvo_data); i += 8) {
-		if (!intel_sdvo_set_value(intel_sdvo,
-					  SDVO_CMD_SET_HBUF_DATA,
-					  data, 8))
-			return false;
-		data++;
-	}
-
-	return intel_sdvo_set_value(intel_sdvo,
-				    SDVO_CMD_SET_HBUF_TXRATE,
-				    &tx_rate, 1);
+	return intel_sdvo_write_infoframe(intel_sdvo, SDVO_HBUF_INDEX_AVI_IF,
+					  SDVO_HBUF_TX_VSYNC,
+					  sdvo_data, sizeof(sdvo_data));
 }
 
 static bool intel_sdvo_set_tv_format(struct intel_sdvo *intel_sdvo)
diff --git a/drivers/gpu/drm/i915/intel_sdvo_regs.h b/drivers/gpu/drm/i915/intel_sdvo_regs.h
index 9d03014..770bdd6 100644
--- a/drivers/gpu/drm/i915/intel_sdvo_regs.h
+++ b/drivers/gpu/drm/i915/intel_sdvo_regs.h
@@ -708,6 +708,8 @@ struct intel_sdvo_enhancements_arg {
 #define SDVO_CMD_SET_AUDIO_STAT		0x91
 #define SDVO_CMD_GET_AUDIO_STAT		0x92
 #define SDVO_CMD_SET_HBUF_INDEX		0x93
+  #define SDVO_HBUF_INDEX_ELD		0
+  #define SDVO_HBUF_INDEX_AVI_IF	1
 #define SDVO_CMD_GET_HBUF_INDEX		0x94
 #define SDVO_CMD_GET_HBUF_INFO		0x95
 #define SDVO_CMD_SET_HBUF_AV_SPLIT	0x96


