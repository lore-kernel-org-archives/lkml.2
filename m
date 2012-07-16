Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2GPSoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:44:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48499 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2GPSo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:44:29 -0400
From: <manjunatha_halli@ti.com>
To: <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <dan.carpenter@oracle.com>,
        Manjunatha Halli <x0130808@ti.com>
Subject: [PATCH] wl12xx: Fix for overflow while getting irq status
Date: Mon, 16 Jul 2012 13:44:24 -0500
Message-ID: <1342464264-15069-1-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <x0130808@ti.com>

->dlen is 8 bit long and so while memcpy there is a chance
that fmdev->irq_info.flag will overflow.

So this patch removes memcpy and instead copies the 16bit flag
register value from skb->data to fmdev->irq_info.flag directly.

Change-Id: I37604b91b2777ed9e56a7e1c1ecefe32e9024170
Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 drivers/media/radio/wl128x/fmdrv_common.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index bf867a6..54c549b 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -584,18 +584,16 @@ static void fm_irq_send_flag_getcmd(struct fmdev *fmdev)
 static void fm_irq_handle_flag_getcmd_resp(struct fmdev *fmdev)
 {
 	struct sk_buff *skb;
-	struct fm_event_msg_hdr *fm_evt_hdr;
 
 	if (check_cmdresp_status(fmdev, &skb))
 		return;
 
-	fm_evt_hdr = (void *)skb->data;
-
 	/* Skip header info and copy only response data */
 	skb_pull(skb, sizeof(struct fm_event_msg_hdr));
-	memcpy(&fmdev->irq_info.flag, skb->data, fm_evt_hdr->dlen);
 
-	fmdev->irq_info.flag = be16_to_cpu(fmdev->irq_info.flag);
+	/* Copy 16 bit flag register value from skb->data */
+	fmdev->irq_info.flag = (u16) ((skb->data[0] << 8) | skb->data[1]);
+
 	fmdbg("irq: flag register(0x%x)\n", fmdev->irq_info.flag);
 
 	/* Continue next function in interrupt handler table */
-- 
1.7.4.1

