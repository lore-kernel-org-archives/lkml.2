Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030917Ab2ERC7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:59:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40563 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030726Ab2ERCwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:49 -0400
Message-Id: <20120518023259.116734346@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 35/53] spi-topcliff-pch: add recovery processing in case wait-event timeout
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 0f57e168aa109775430c76cc663fb64909813d84 upstream.

Currently, pch_spi_start_transfer failure is not anticipated.
This patch adds the processing.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/spi/spi-topcliff-pch.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 5a477e9..c9e1fcc 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1266,8 +1266,16 @@ static void pch_spi_process_messages(struct work_struct *pwork)
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
1.7.10



