Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab1LGRLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:11:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab1LGQQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:16:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:23 2011
Message-Id: <20111207160823.124637685@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:26 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Alex Deucher <alexander.deucher@amd.com>,
        Jean Delvare <khali@linux-fr.org>, Dave Airlie <airlied@redhat.com>
Subject: [06/80] drm/radeon/kms: fix up gpio i2c mask bits for r4xx for real
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d724502a9d7a46f4a56a1663b1f50d2dc9d1ef40 upstream.

Fixes i2c test failures when i2c_algo_bit.bit_test=1.

The hw doesn't actually require a mask, so just set it
to the default mask bits for r1xx-r4xx radeon ddc.

I missed this part the first time through.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -169,6 +169,18 @@ void radeon_atombios_i2c_init(struct rad
 			gpio = &i2c_info->asGPIO_Info[i];
 			i2c.valid = false;
 
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


