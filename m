Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0LMAGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:06:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36316 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab0LLXrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:17 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: alexdeucher@gmail.com, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [131/223] drm/radeon/kms: add workaround for dce3 ddc line vbios bug
Message-Id: <20101212234713.423D6B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

commit 3074adc8b6d9bf28b574a58241b958057a69a7a0 upstream.

fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=23752

[AK: Dropped hunk for non existing i2c code in .35]
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux/drivers/gpu/drm/radeon/radeon_atombios.c
===================================================================
--- linux.orig/drivers/gpu/drm/radeon/radeon_atombios.c
+++ linux/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -84,6 +84,14 @@ static inline struct radeon_i2c_bus_rec
 		for (i = 0; i < num_indices; i++) {
 			gpio = &i2c_info->asGPIO_Info[i];
 
+			/* some DCE3 boards have bad data for this entry */
+			if (ASIC_IS_DCE3(rdev)) {
+				if ((i == 4) &&
+				    (gpio->usClkMaskRegisterIndex == 0x1fda) &&
+				    (gpio->sucI2cId.ucAccess == 0x94))
+					gpio->sucI2cId.ucAccess = 0x14;
+			}
+
 			if (gpio->sucI2cId.ucAccess == id) {
 				i2c.mask_clk_reg = le16_to_cpu(gpio->usClkMaskRegisterIndex) * 4;
 				i2c.mask_data_reg = le16_to_cpu(gpio->usDataMaskRegisterIndex) * 4;
