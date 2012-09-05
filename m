Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2IEQbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:31:49 -0400
Received: from masquerade.micron.com ([137.201.242.130]:65275 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2IEQbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:31:48 -0400
Message-ID: <50477E68.1080308@micron.com>
Date: Wed, 5 Sep 2012 22:01:36 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: [PATCH 2/6] mtip32xx: Handle NCQ commands during the security locked
 state
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19164.003
X-TM-AS-Result: No--8.577700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return error for NCQ commands when the drive is in security locked state

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Selvan Mani <smani@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   10 +++++++++-
 drivers/block/mtip32xx/mtip32xx.h |    2 ++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index a935f4f..2553c73 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1148,11 +1148,15 @@ static bool mtip_pause_ncq(struct mtip_port *port,
 	reply = port->rxfis + RX_FIS_D2H_REG;
 	task_file_data = readl(port->mmio+PORT_TFDATA);
 
-	if ((task_file_data & 1) || (fis->command == ATA_CMD_SEC_ERASE_UNIT))
+	if (fis->command == ATA_CMD_SEC_ERASE_UNIT)
+		clear_bit(MTIP_DDF_SEC_LOCK_BIT, &port->dd->dd_flag);
+
+	if ((task_file_data & 1))
 		return false;
 
 	if (fis->command == ATA_CMD_SEC_ERASE_PREP) {
 		set_bit(MTIP_PF_SE_ACTIVE_BIT, &port->flags);
+		set_bit(MTIP_DDF_SEC_LOCK_BIT, &port->dd->dd_flag);
 		port->ic_pause_timer = jiffies;
 		return true;
 	} else if ((fis->command == ATA_CMD_DOWNLOAD_MICRO) &&
@@ -3619,6 +3623,10 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 			bio_endio(bio, -ENODATA);
 			return;
 		}
+		if (unlikely(test_bit(MTIP_DDF_SEC_LOCK_BIT, &dd->dd_flag))) {
+			bio_endio(bio, -ENODATA);
+			return;
+		}
 	}
 
 	if (unlikely(!bio_has_data(bio))) {
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 0255d19..18627a1 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -137,10 +137,12 @@ enum {
 	MTIP_PF_SVC_THD_STOP_BIT    = 8,
 
 	/* below are bit numbers in 'dd_flag' defined in driver_data */
+	MTIP_DDF_SEC_LOCK_BIT	    = 0,
 	MTIP_DDF_REMOVE_PENDING_BIT = 1,
 	MTIP_DDF_OVER_TEMP_BIT      = 2,
 	MTIP_DDF_WRITE_PROTECT_BIT  = 3,
 	MTIP_DDF_STOP_IO      = ((1 << MTIP_DDF_REMOVE_PENDING_BIT) | \
+				(1 << MTIP_DDF_SEC_LOCK_BIT) | \
 				(1 << MTIP_DDF_OVER_TEMP_BIT) | \
 				(1 << MTIP_DDF_WRITE_PROTECT_BIT)),
 
-- 
1.7.1

