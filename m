Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab1LGQP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:15:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab1LGQPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:15:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:23 2011
Message-Id: <20111207160823.707222262@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:33 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Alex Deucher <alexander.deucher@amd.com>,
        Jean Delvare <khali@linux-fr.org>, Dave Airlie <airlied@redhat.com>
Subject: [13/80] drm/radeon/kms: fix up gpio i2c mask bits for r4xx
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 6c47e5c23aa2a7c54ad7ac13af4bd56cd9e703bf upstream.

Fixes i2c test failures when i2c_algo_bit.bit_test=1.

The hw doesn't actually require a mask, so just set it
to the default mask bits for r1xx-r4xx radeon ddc.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -85,6 +85,18 @@ static inline struct radeon_i2c_bus_rec
 		for (i = 0; i < num_indices; i++) {
 			gpio = &i2c_info->asGPIO_Info[i];
 
+			/* r4xx mask is technically not used by the hw, so patch in the legacy mask bits */
+			if ((rdev->family == CHIP_R420) ||
+			    (rdev->family == CHIP_R423) ||
+			    (rdev->family == CHIP_RV410)) {
+				if ((le16_to_cpu(gpio->usClkMaskRegisterIndex) == 0x0018) ||
+				    (le16_to_cpu(gpio->usClkMaskRegisterIndex) == 0x0019) ||
+				    (le16_to_cpu(gpio->usClkMaskRegisterIndex) == 0x001a)) {
+					gpio->ucClkMaskShift = 0x19;
+					gpio->ucDataMaskShift = 0x18;
+				}
+			}
+
 			/* some evergreen boards have bad data for this entry */
 			if (ASIC_IS_DCE4(rdev)) {
 				if ((i == 7) &&


