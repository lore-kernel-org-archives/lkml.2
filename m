Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0ISJ2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 05:28:48 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:41408 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0ISJ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 05:28:46 -0400
From: Pekka Enberg <penberg@kernel.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Lars Lindley <lindley@coyote.org>, Pavel Machek <pavel@ucw.cz>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>
Subject: [PATCH 1/7] w35und: Kill dead HAL macros in wbhal_f.h
Date: Sun, 19 Sep 2010 12:28:37 +0300
Message-Id: <1284888523-9625-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes an uninitialized variable access in _rx_iq_calibration_loop_winbond():

    CC [M]  drivers/staging/winbond/phy_calibration.o
  drivers/staging/winbond/phy_calibration.c: In function ‘_rx_iq_calibration_loop_winbond’:
  drivers/staging/winbond/phy_calibration.c:1138: warning: ‘val’ is used uninitialized in this function

Cc: Lars Lindley <lindley@coyote.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ruslan Pisarev <ruslan@rpisarev.org.ua>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 drivers/staging/winbond/phy_calibration.c |   20 --------------------
 drivers/staging/winbond/wbhal_f.h         |   10 ----------
 2 files changed, 0 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 5c1f053..2b375ba 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -1132,18 +1132,6 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 	PHY_DEBUG(("[CAL] -> [5]_rx_iq_calibration_loop()\n"));
 	PHY_DEBUG(("[CAL] ** factor = %d\n", factor));
 
-
-/* RF Control Override */
-	hw_get_cxx_reg(phw_data, 0x80, &val);
-	val |= BIT(19);
-	hw_set_cxx_reg(phw_data, 0x80, val);
-
-/* RF_Ctrl */
-	hw_get_cxx_reg(phw_data, 0xE4, &val);
-	val |= BIT(0);
-	hw_set_cxx_reg(phw_data, 0xE4, val);
-	PHY_DEBUG(("[CAL] ** RF_CTRL(0xE4) = 0x%08X", val));
-
 	hw_set_dxx_reg(phw_data, 0x58, 0x44444444); /* IQ_Alpha */
 
 	/* b. */
@@ -1461,13 +1449,8 @@ void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 
 	PHY_DEBUG(("[CAL] -> phy_calibration_winbond()\n"));
 
-	/* 20040701 1.1.25.1000 kevin */
-	hw_get_cxx_reg(phw_data, 0x80, &mac_ctrl);
-	hw_get_cxx_reg(phw_data, 0xE4, &rf_ctrl);
 	hw_get_dxx_reg(phw_data, 0x58, &iq_alpha);
 
-
-
 	_rxadc_dc_offset_cancellation_winbond(phw_data, frequency);
 	/* _txidac_dc_offset_cancellation_winbond(phw_data); */
 	/* _txqdac_dc_offset_cacellation_winbond(phw_data); */
@@ -1482,11 +1465,8 @@ void phy_calibration_winbond(struct hw_data *phw_data, u32 frequency)
 	PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
 	/* i. Set RFIC to "Normal mode" */
-	hw_set_cxx_reg(phw_data, 0x80, mac_ctrl);
-	hw_set_cxx_reg(phw_data, 0xE4, rf_ctrl);
 	hw_set_dxx_reg(phw_data, 0x58, iq_alpha);
 
-
 	/*********************************************************************/
 	phy_init_rf(phw_data);
 
diff --git a/drivers/staging/winbond/wbhal_f.h b/drivers/staging/winbond/wbhal_f.h
index 401c024..fc78c14 100644
--- a/drivers/staging/winbond/wbhal_f.h
+++ b/drivers/staging/winbond/wbhal_f.h
@@ -78,14 +78,4 @@ u32 hal_get_bss_pk_cnt(struct hw_data *hw_data);
 #define hal_get_time_count(_P)		(_P->time_count / 10)
 #define hal_detect_error(_P)		(_P->WbUsb.DetectCount)
 
-/* The follow function is unused for IS89C35 */
-#define hal_disable_interrupt(_A)
-#define hal_enable_interrupt(_A)
-#define hal_get_interrupt_type(_A)
-#define hal_get_clear_interrupt(_A)
 #define hal_ibss_disconnect(_A)		(hal_stop_sync_bss(_A))
-#define hal_join_request_stop(_A)
-#define hw_get_cxx_reg(_A, _B, _C)
-#define hw_set_cxx_reg(_A, _B, _C)
-
-
-- 
1.6.3.3

