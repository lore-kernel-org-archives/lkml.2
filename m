Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631Ab1CEBC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:02:26 -0500
Received: from kroah.org ([198.145.64.141]:50489 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510Ab1CEBBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:01:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:41 2011
Message-Id: <20110305005640.930758482@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sujith Manoharan <Sujith.Manoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [65/73] ath9k_htc: Fix an endian issue
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

commit 2c27392dc4d4f5ee8a3967a520b8f6cac0418031 upstream.

The stream length/tag fields have to be in little endian
format. Fixing this makes the driver work on big-endian
platforms.

Tested-by: raghunathan.kailasanathan@wipro.com
Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -210,8 +210,9 @@ static int __hif_usb_tx(struct hif_devic
 	struct tx_buf *tx_buf = NULL;
 	struct sk_buff *nskb = NULL;
 	int ret = 0, i;
-	u16 *hdr, tx_skb_cnt = 0;
+	u16 tx_skb_cnt = 0;
 	u8 *buf;
+	__le16 *hdr;
 
 	if (hif_dev->tx.tx_skb_cnt == 0)
 		return 0;
@@ -236,9 +237,9 @@ static int __hif_usb_tx(struct hif_devic
 
 		buf = tx_buf->buf;
 		buf += tx_buf->offset;
-		hdr = (u16 *)buf;
-		*hdr++ = nskb->len;
-		*hdr++ = ATH_USB_TX_STREAM_MODE_TAG;
+		hdr = (__le16 *)buf;
+		*hdr++ = cpu_to_le16(nskb->len);
+		*hdr++ = cpu_to_le16(ATH_USB_TX_STREAM_MODE_TAG);
 		buf += 4;
 		memcpy(buf, nskb->data, nskb->len);
 		tx_buf->len = nskb->len + 4;


