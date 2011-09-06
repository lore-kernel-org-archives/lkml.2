Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1IFIAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:00:41 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33671 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319Ab1IFIAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:00:20 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 3/5] spi-topcliff-pch: Fix CPU read complete condition issue
Date: Tue,  6 Sep 2011 16:58:32 +0900
Message-Id: <1315295914-6862-3-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315295914-6862-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1315295914-6862-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found Rx data sometimes drops.(with non-DMA transfer mode)
The cause is read complete condition is not true.

This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/spi/spi-topcliff-pch.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index b5c681a..c4d6fb9 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -320,16 +320,19 @@ static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
 
 	/* if transfer complete interrupt */
 	if (reg_spsr_val & SPSR_FI_BIT) {
-		if (tx_index < bpw_len)
+		if ((tx_index == bpw_len) && (rx_index == tx_index)) {
+			/* disable interrupts */
+			pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);
+
+			/* transfer is completed;
+			   inform pch_spi_process_messages */
+			data->transfer_complete = true;
+			data->transfer_active = false;
+			wake_up(&data->wait);
+		} else {
 			dev_err(&data->master->dev,
 				"%s : Transfer is not completed", __func__);
-		/* disable interrupts */
-		pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);
-
-		/* transfer is completed;inform pch_spi_process_messages */
-		data->transfer_complete = true;
-		data->transfer_active = false;
-		wake_up(&data->wait);
+		}
 	}
 }
 
-- 
1.7.4.4

