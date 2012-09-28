Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907Ab2I1S5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:57:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964878Ab2I1S5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:57:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Chris Ball <cjb@laptop.org>
Subject: [ 076/262] mmc: atmel-mci: not busy flag has also to be used for read operations
Date: Fri, 28 Sep 2012 11:50:05 -0700
Message-Id: <20120928183007.041428196@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ludovic Desroches <ludovic.desroches@atmel.com>

commit 077d40731edc90ee9dedf63249034c8cd5f694ce upstream.

Even if the datasheet says that the not busy flag has to be used only
for write operations, it's false except for version lesser than v2xx.

Not waiting on the not busy flag for read operations can cause the
controller to hang-up during the initialization of some SD cards
with DMA after the first CMD6 -- the next command is sent too early.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/atmel-mci.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -81,6 +81,7 @@ struct atmel_mci_caps {
 	bool	has_bad_data_ordering;
 	bool	need_reset_after_xfer;
 	bool	need_blksz_mul_4;
+	bool	need_notbusy_for_read_ops;
 };
 
 struct atmel_mci_dma {
@@ -1619,7 +1620,8 @@ static void atmci_tasklet_func(unsigned
 				__func__);
 			atmci_set_completed(host, EVENT_XFER_COMPLETE);
 
-			if (host->data->flags & MMC_DATA_WRITE) {
+			if (host->caps.need_notbusy_for_read_ops ||
+			   (host->data->flags & MMC_DATA_WRITE)) {
 				atmci_writel(host, ATMCI_IER, ATMCI_NOTBUSY);
 				state = STATE_WAITING_NOTBUSY;
 			} else if (host->mrq->stop) {
@@ -2212,6 +2214,7 @@ static void __init atmci_get_cap(struct
 	host->caps.has_bad_data_ordering = 1;
 	host->caps.need_reset_after_xfer = 1;
 	host->caps.need_blksz_mul_4 = 1;
+	host->caps.need_notbusy_for_read_ops = 0;
 
 	/* keep only major version number */
 	switch (version & 0xf00) {
@@ -2232,6 +2235,7 @@ static void __init atmci_get_cap(struct
 	case 0x200:
 		host->caps.has_rwproof = 1;
 		host->caps.need_blksz_mul_4 = 0;
+		host->caps.need_notbusy_for_read_ops = 1;
 	case 0x100:
 		host->caps.has_bad_data_ordering = 0;
 		host->caps.need_reset_after_xfer = 0;


