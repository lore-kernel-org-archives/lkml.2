Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0LXCnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 21:43:31 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:8398 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601Ab0LXCna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 21:43:30 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] spi_topcliff_pch: Fix data transfer issue
Date: Fri, 24 Dec 2010 11:45:47 +0900
Message-Id: <1293158747-3270-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I forget to add "--CCs"

It seems spi_topcliff_pch of linux-2.6.37-rc6 degraded by previous patch.
In fact, data transfer fails on evaluation board testing.
I found like the following register miss-setting line.
Using this patch, I have confirmed data transfer can work well.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/spi/spi_topcliff_pch.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
index 58e187f..56b7588 100644
--- a/drivers/spi/spi_topcliff_pch.c
+++ b/drivers/spi/spi_topcliff_pch.c
@@ -267,7 +267,7 @@ static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
 	if (reg_spsr_val & SPSR_FI_BIT) {
 		/* disable FI & RFI interrupts */
 		pch_spi_setclr_reg(data->master, PCH_SPCR, 0,
-				   SPCR_FIE_BIT | SPCR_TFIE_BIT);
+				   SPCR_FIE_BIT | SPCR_RFIE_BIT);
 
 		/* transfer is completed;inform pch_spi_process_messages */
 		data->transfer_complete = true;
@@ -679,11 +679,11 @@ static void pch_spi_set_ir(struct pch_spi_data *data)
 	if ((data->bpw_len) > PCH_MAX_FIFO_DEPTH) {
 		/* set receive threhold to PCH_RX_THOLD */
 		pch_spi_setclr_reg(data->master, PCH_SPCR,
-				   PCH_RX_THOLD << SPCR_TFIC_FIELD,
-				   ~MASK_TFIC_SPCR_BITS);
+				   PCH_RX_THOLD << SPCR_RFIC_FIELD,
+				   ~MASK_RFIC_SPCR_BITS);
 		/* enable FI and RFI interrupts */
 		pch_spi_setclr_reg(data->master, PCH_SPCR,
-				   SPCR_RFIE_BIT | SPCR_TFIE_BIT, 0);
+				   SPCR_RFIE_BIT | SPCR_FIE_BIT, 0);
 	} else {
 		/* set receive threhold to maximum */
 		pch_spi_setclr_reg(data->master, PCH_SPCR,
-- 
1.6.0.6

