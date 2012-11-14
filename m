Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2KNFv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:51:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55333 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932432Ab2KNFvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:19 -0500
Message-Id: <20121114053936.662345761@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:53 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>, Peter Ross <pross@xvid.org>
Subject: [ 20/82] drm/i915: fixup infoframe support for sdvo
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

commit 81014b9d0b55fb0b48f26cd2a943359750d532db upstream.

At least the worst offenders:
- SDVO specifies that the encoder should compute the ecc. Testing also
  shows that we must not send the ecc field, so copy the dip_infoframe
  struct to a temporay place and avoid the ecc field. This way the avi
  infoframe is exactly 17 bytes long, which agrees with what the spec
  mandates as a minimal storage capacity (with the ecc field it would
  be 18 bytes).
- Only 17 when sending the avi infoframe. The SDVO spec explicitly
  says that sending more data than what the device announces results
  in undefined behaviour.
- Add __attribute__((packed)) to the avi and spd infoframes, for
  otherwise they're wrongly aligned. Noticed because the avi infoframe
  ended up being 18 bytes large instead of 17. We haven't noticed this
  yet because we don't use the uint16_t fields yet (which are the only
  ones that would be wrongly aligned).

This regression has been introduce by

3c17fe4b8f40a112a85758a9ab2aebf772bdd647 is the first bad commit
commit 3c17fe4b8f40a112a85758a9ab2aebf772bdd647
Author: David Härdeman <david@hardeman.nu>
Date:   Fri Sep 24 21:44:32 2010 +0200

    i915: enable AVI infoframe for intel_hdmi.c [v4]

Patch tested on my g33 with a sdvo hdmi adaptor.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=25732
Tested-by: Peter Ross <pross@xvid.org> (G35 SDVO-HDMI)
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_drv.h  |    4 ++--
 drivers/gpu/drm/i915/intel_sdvo.c |   11 +++++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index d51f27f..3e09188 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -280,12 +280,12 @@ struct dip_infoframe {
 			uint16_t bottom_bar_start;
 			uint16_t left_bar_end;
 			uint16_t right_bar_start;
-		} avi;
+		} __attribute__ ((packed)) avi;
 		struct {
 			uint8_t vn[8];
 			uint8_t pd[16];
 			uint8_t sdi;
-		} spd;
+		} __attribute__ ((packed)) spd;
 		uint8_t payload[27];
 	} __attribute__ ((packed)) body;
 } __attribute__((packed));
diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 7d3f238..125228e 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -887,17 +887,24 @@ static bool intel_sdvo_set_avi_infoframe(struct intel_sdvo *intel_sdvo)
 	};
 	uint8_t tx_rate = SDVO_HBUF_TX_VSYNC;
 	uint8_t set_buf_index[2] = { 1, 0 };
-	uint64_t *data = (uint64_t *)&avi_if;
+	uint8_t sdvo_data[4 + sizeof(avi_if.body.avi)];
+	uint64_t *data = (uint64_t *)sdvo_data;
 	unsigned i;
 
 	intel_dip_infoframe_csum(&avi_if);
 
+	/* sdvo spec says that the ecc is handled by the hw, and it looks like
+	 * we must not send the ecc field, either. */
+	memcpy(sdvo_data, &avi_if, 3);
+	sdvo_data[3] = avi_if.checksum;
+	memcpy(&sdvo_data[4], &avi_if.body, sizeof(avi_if.body.avi));
+
 	if (!intel_sdvo_set_value(intel_sdvo,
 				  SDVO_CMD_SET_HBUF_INDEX,
 				  set_buf_index, 2))
 		return false;
 
-	for (i = 0; i < sizeof(avi_if); i += 8) {
+	for (i = 0; i < sizeof(sdvo_data); i += 8) {
 		if (!intel_sdvo_set_value(intel_sdvo,
 					  SDVO_CMD_SET_HBUF_DATA,
 					  data, 8))


