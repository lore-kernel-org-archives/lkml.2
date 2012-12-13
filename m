Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab2LMOA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:00:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43954 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab2LMOA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:00:57 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paulo Zanoni <przanoni@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 004/241] drm/i915: clear the entire sdvo infoframe buffer
Date: Thu, 13 Dec 2012 11:56:09 -0200
Message-Id: <1355407206-17100-5-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/intel_sdvo.c      |   62 +++++++++++++++++++++-----------
 drivers/gpu/drm/i915/intel_sdvo_regs.h |    2 ++
 2 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 74d47a3..9bb8168 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -882,6 +882,45 @@ static void intel_sdvo_dump_hdmi_buf(struct intel_sdvo *intel_sdvo)
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
@@ -889,11 +928,7 @@ static bool intel_sdvo_set_avi_infoframe(struct intel_sdvo *intel_sdvo)
 		.ver = DIP_VERSION_AVI,
 		.len = DIP_LEN_AVI,
 	};
-	uint8_t tx_rate = SDVO_HBUF_TX_VSYNC;
-	uint8_t set_buf_index[2] = { 1, 0 };
 	uint8_t sdvo_data[4 + sizeof(avi_if.body.avi)];
-	uint64_t *data = (uint64_t *)sdvo_data;
-	unsigned i;
 
 	intel_dip_infoframe_csum(&avi_if);
 
@@ -903,22 +938,9 @@ static bool intel_sdvo_set_avi_infoframe(struct intel_sdvo *intel_sdvo)
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
-- 
1.7.9.5

