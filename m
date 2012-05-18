Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946825Ab2ERXIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:08:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946822Ab2ERXHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:07:52 -0400
Message-Id: <20120518212653.286608998@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 45/47] spi-topcliff-pch: add recovery processing in case wait-event timeout
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 0f57e168aa109775430c76cc663fb64909813d84 upstream.

Currently, pch_spi_start_transfer failure is not anticipated.
This patch adds the processing.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-topcliff-pch.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1266,8 +1266,16 @@ static void pch_spi_process_messages(str
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


