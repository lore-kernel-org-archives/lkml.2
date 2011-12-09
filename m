Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1LIEOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 23:14:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51544 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1LIEOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 23:14:32 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Wolfram Sang <w.sang@pengutronix.de>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 4/4] spi-topcliff-pch: add recovery processing in case wait-event timeout
Date: Fri,  9 Dec 2011 13:13:29 +0900
Message-Id: <1323404009-3476-3-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1323404009-3476-1-git-send-email-tomoya.rohm@gmail.com>
References: <1323404009-3476-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, pch_spi_start_transfer failure is not anticipated.
This patch adds the processing.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/spi/spi-topcliff-pch.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 1864555..10b684c 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1262,8 +1262,16 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 			char *save_rx_buf = data->cur_trans->rx_buf;
 			for (i = 0; i < cnt; i ++) {
 				pch_spi_handle_dma(data, &bpw);
-				if (!pch_spi_start_transfer(data))
+				if (!pch_spi_start_transfer(data)) {
+					data->transfer_complete = true;
+					data->current_msg->status = -EIO;
+					data->current_msg->complete
+						   (data->current_msg->context);
+					data->bcurrent_msg_processing = false;
+					data->current_msg = NULL;
+					data->cur_trans = NULL;
 					goto out;
+				}
 				pch_spi_copy_rx_data_for_dma(data, bpw);
 			}
 			data->cur_trans->rx_buf = save_rx_buf;
-- 
1.7.4.4

