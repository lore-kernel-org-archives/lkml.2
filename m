Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1HCX1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:27:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab1HCX13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:27:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:48 2011
Message-Id: <20110803221248.803122673@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Glisse <jglisse@redhat.com>, Dave Airlie <airlied@redhat.com>
Subject: [048/102] drm/radeon/kms: fix DP training for DPEncoderService revision bigger than 1.1
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 5a96a899bbdee86024ab9ea6d02b9e242faacbed upstream.

DPEncoderService newer than 1.1 can't properly program the DP (display port)
link training. When facing such version use the DIGxEncoderControl method
instead. Fix DP link training on some R7XX.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_dp.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -627,6 +627,7 @@ struct radeon_dp_link_train_info {
 	u8 train_set[4];
 	u8 link_status[DP_LINK_STATUS_SIZE];
 	u8 tries;
+	bool use_dpencoder;
 };
 
 static void radeon_dp_update_vs_emph(struct radeon_dp_link_train_info *dp_info)
@@ -646,7 +647,7 @@ static void radeon_dp_set_tp(struct rade
 	int rtp = 0;
 
 	/* set training pattern on the source */
-	if (ASIC_IS_DCE4(dp_info->rdev)) {
+	if (ASIC_IS_DCE4(dp_info->rdev) || !dp_info->use_dpencoder) {
 		switch (tp) {
 		case DP_TRAINING_PATTERN_1:
 			rtp = ATOM_ENCODER_CMD_DP_LINK_TRAINING_PATTERN1;
@@ -706,7 +707,7 @@ static int radeon_dp_link_train_init(str
 	radeon_write_dpcd_reg(dp_info->radeon_connector, DP_LINK_BW_SET, tmp);
 
 	/* start training on the source */
-	if (ASIC_IS_DCE4(dp_info->rdev))
+	if (ASIC_IS_DCE4(dp_info->rdev) || !dp_info->use_dpencoder)
 		atombios_dig_encoder_setup(dp_info->encoder,
 					   ATOM_ENCODER_CMD_DP_LINK_TRAINING_START, 0);
 	else
@@ -731,7 +732,7 @@ static int radeon_dp_link_train_finish(s
 			      DP_TRAINING_PATTERN_DISABLE);
 
 	/* disable the training pattern on the source */
-	if (ASIC_IS_DCE4(dp_info->rdev))
+	if (ASIC_IS_DCE4(dp_info->rdev) || !dp_info->use_dpencoder)
 		atombios_dig_encoder_setup(dp_info->encoder,
 					   ATOM_ENCODER_CMD_DP_LINK_TRAINING_COMPLETE, 0);
 	else
@@ -869,7 +870,8 @@ void radeon_dp_link_train(struct drm_enc
 	struct radeon_connector *radeon_connector;
 	struct radeon_connector_atom_dig *dig_connector;
 	struct radeon_dp_link_train_info dp_info;
- 	u8 tmp;
+	int index;
+	u8 tmp, frev, crev;
 
 	if (!radeon_encoder->enc_priv)
 		return;
@@ -884,6 +886,18 @@ void radeon_dp_link_train(struct drm_enc
 	    (dig_connector->dp_sink_type != CONNECTOR_OBJECT_ID_eDP))
 		return;
 
+	/* DPEncoderService newer than 1.1 can't program properly the
+	 * training pattern. When facing such version use the
+	 * DIGXEncoderControl (X== 1 | 2)
+	 */
+	dp_info.use_dpencoder = true;
+	index = GetIndexIntoMasterTable(COMMAND, DPEncoderService);
+	if (atom_parse_cmd_header(rdev->mode_info.atom_context, index, &frev, &crev)) {
+		if (crev > 1) {
+			dp_info.use_dpencoder = false;
+		}
+	}
+
 	dp_info.enc_id = 0;
 	if (dig->dig_encoder)
 		dp_info.enc_id |= ATOM_DP_CONFIG_DIG2_ENCODER;


