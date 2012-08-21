Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab2HUEQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 00:16:20 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48868 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab2HUEQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 00:16:17 -0400
MIME-Version: 1.0
Date: Tue, 21 Aug 2012 12:16:16 +0800
Message-ID: <CAPgLHd8fm6BysDeifRnaG8PPRKynEuAWp1ZXHkcoiF_NJPQkzQ@mail.gmail.com>
Subject: [PATCH] spi-topcliff-pch: fix to use list_for_each_entry_safe() when
 delete items
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@secretlab.ca
Cc: yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Since we will be removing items off the list using list_del() we need
to use a safer version of the list_for_each_entry() macro aptly named
list_for_each_entry_safe(). We should use the safe macro if the loop
involves deletions of items.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/spi/spi-topcliff-pch.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index cd56dcf..309b717 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -615,7 +615,7 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw)
 	int size;
 	u32 n_writes;
 	int j;
-	struct spi_message *pmsg;
+	struct spi_message *pmsg, *tmp;
 	const u8 *tx_buf;
 	const u16 *tx_sbuf;
 
@@ -656,7 +656,7 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw)
 	if (!data->pkt_rx_buff) {
 		/* flush queue and set status of all transfers to -ENOMEM */
 		dev_err(&data->master->dev, "%s :kzalloc failed\n", __func__);
-		list_for_each_entry(pmsg, data->queue.next, queue) {
+		list_for_each_entry_safe(pmsg, tmp, data->queue.next, queue) {
 			pmsg->status = -ENOMEM;
 
 			if (pmsg->complete != 0)
@@ -703,7 +703,7 @@ static void pch_spi_set_tx(struct pch_spi_data *data, int *bpw)
 
 static void pch_spi_nomore_transfer(struct pch_spi_data *data)
 {
-	struct spi_message *pmsg;
+	struct spi_message *pmsg, *tmp;
 	dev_dbg(&data->master->dev, "%s called\n", __func__);
 	/* Invoke complete callback
 	 * [To the spi core..indicating end of transfer] */
@@ -740,7 +740,7 @@ static void pch_spi_nomore_transfer(struct pch_spi_data *data)
 		dev_dbg(&data->master->dev,
 			"%s suspend/remove initiated, flushing queue\n",
 			__func__);
-		list_for_each_entry(pmsg, data->queue.next, queue) {
+		list_for_each_entry_safe(pmsg, tmp, data->queue.next, queue) {
 			pmsg->status = -EIO;
 
 			if (pmsg->complete)
@@ -1187,7 +1187,7 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 
 static void pch_spi_process_messages(struct work_struct *pwork)
 {
-	struct spi_message *pmsg;
+	struct spi_message *pmsg, *tmp;
 	struct pch_spi_data *data;
 	int bpw;
 
@@ -1199,7 +1199,7 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 	if (data->board_dat->suspend_sts || (data->status == STATUS_EXITING)) {
 		dev_dbg(&data->master->dev, "%s suspend/remove initiated,"
 			"flushing queue\n", __func__);
-		list_for_each_entry(pmsg, data->queue.next, queue) {
+		list_for_each_entry_safe(pmsg, tmp, data->queue.next, queue) {
 			pmsg->status = -EIO;
 
 			if (pmsg->complete != 0) {


