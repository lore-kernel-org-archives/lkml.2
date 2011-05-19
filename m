Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179Ab1ESSOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:14:35 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53009 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934089Ab1ESSJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:06 -0400
X-Sasl-enc: GIeCRF0PD5eb5rIkRufXohIrKzddXVNXj0sGhkXUXV3g 1305828545
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:59 2011
Message-Id: <20110519180559.186030418@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [51/71] drm/radeon/kms: fix extended lvds info parsing
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 05fa7ea7d23980de0014417a0e0af2048a0f9fc1 upstream.

On rev <= 1.1 tables, the offset is absolute,
on newer tables, it's relative.

Fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=700326

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1574,9 +1574,17 @@ struct radeon_encoder_atom_dig *radeon_a
 			ATOM_FAKE_EDID_PATCH_RECORD *fake_edid_record;
 			ATOM_PANEL_RESOLUTION_PATCH_RECORD *panel_res_record;
 			bool bad_record = false;
-			u8 *record = (u8 *)(mode_info->atom_context->bios +
-					    data_offset +
-					    le16_to_cpu(lvds_info->info.usModePatchTableOffset));
+			u8 *record;
+
+			if ((frev == 1) && (crev < 2))
+				/* absolute */
+				record = (u8 *)(mode_info->atom_context->bios +
+						le16_to_cpu(lvds_info->info.usModePatchTableOffset));
+			else
+				/* relative */
+				record = (u8 *)(mode_info->atom_context->bios +
+						data_offset +
+						le16_to_cpu(lvds_info->info.usModePatchTableOffset));
 			while (*record != ATOM_RECORD_END_TYPE) {
 				switch (*record) {
 				case LCD_MODE_PATCH_RECORD_MODE_TYPE:


