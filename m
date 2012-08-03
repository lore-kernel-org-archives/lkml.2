Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2HCTqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:46:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56385 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab2HCTqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:46:24 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH v2 5/6] drivers/misc/ti-st: fix read fw version cmd
Date: Fri, 3 Aug 2012 14:46:16 -0500
Message-ID: <1344023177-21167-6-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1344023177-21167-5-git-send-email-pavan_savoy@ti.com>
References: <1344023177-21167-1-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-2-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-3-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-4-git-send-email-pavan_savoy@ti.com>
 <1344023177-21167-5-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

If the read firmware version response from the chip is split into multiple
frames of UART buffer being received by the host, the TI-ST driver as of today
is unable to put the pieces of response together unlike other responses.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |   40 +++++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 0f36db3..04a8199 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -66,7 +66,24 @@ static struct platform_device *st_get_plat_device(int id)
 static void validate_firmware_response(struct kim_data_s *kim_gdata)
 {
 	struct sk_buff *skb = kim_gdata->rx_skb;
-	if (unlikely(skb->data[5] != 0)) {
+	if (!skb)
+		return;
+
+	/* these magic numbers are the position in the response buffer which
+	 * allows us to distinguish whether the response is for the read
+	 * version info. command
+	 */
+	if (skb->data[2] == 0x01 && skb->data[3] == 0x01 &&
+			skb->data[4] == 0x10 && skb->data[5] == 0x00) {
+		/* fw version response */
+		memcpy(kim_gdata->resp_buffer,
+				kim_gdata->rx_skb->data,
+				kim_gdata->rx_skb->len);
+		complete_all(&kim_gdata->kim_rcvd);
+		kim_gdata->rx_state = ST_W4_PACKET_TYPE;
+		kim_gdata->rx_skb = NULL;
+		kim_gdata->rx_count = 0;
+	} else if (unlikely(skb->data[5] != 0)) {
 		pr_err("no proper response during fw download");
 		pr_err("data6 %x", skb->data[5]);
 		kfree_skb(skb);
@@ -213,10 +230,13 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 		return -ETIMEDOUT;
 	}
 	INIT_COMPLETION(kim_gdata->kim_rcvd);
+	/* the positions 12 & 13 in the response buffer provide with the
+	 * chip, major & minor numbers
+	 */
 
 	version =
-		MAKEWORD(kim_gdata->resp_buffer[13],
-				kim_gdata->resp_buffer[14]);
+		MAKEWORD(kim_gdata->resp_buffer[12],
+				kim_gdata->resp_buffer[13]);
 	chip = (version & 0x7C00) >> 10;
 	min_ver = (version & 0x007F);
 	maj_ver = (version & 0x0380) >> 7;
@@ -410,16 +430,10 @@ void st_kim_recv(void *disc_data, const unsigned char *data, long count)
 	struct st_data_s	*st_gdata = (struct st_data_s *)disc_data;
 	struct kim_data_s	*kim_gdata = st_gdata->kim_data;
 
-	/* copy to local buffer */
-	if (unlikely(data[4] == 0x01 && data[5] == 0x10 && data[0] == 0x04)) {
-		/* must be the read_ver_cmd */
-		memcpy(kim_gdata->resp_buffer, data, count);
-		complete_all(&kim_gdata->kim_rcvd);
-		return;
-	} else {
-		kim_int_recv(kim_gdata, data, count);
-		/* either completes or times out */
-	}
+	/* proceed to gather all data and distinguish read fw version response
+	 * from other fw responses when data gathering is complete
+	 */
+	kim_int_recv(kim_gdata, data, count);
 	return;
 }
 
-- 
1.7.4.1

