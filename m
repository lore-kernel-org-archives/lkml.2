Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab0FQJnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 05:43:00 -0400
Received: from gw1.transmode.se ([213.115.205.20]:42086 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517Ab0FQJm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 05:42:58 -0400
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: rtc-linux@googlegroups.com, Paul Gortmaker <p_gortmaker@yahoo.com>,
       linux-kernel@vger.kernel.org
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH] rtc: fix ds1388 time corruption
Date: Thu, 17 Jun 2010 11:42:50 +0200
Message-Id: <1276767770-22531-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: git-send-email 1.7.1
X-MIMETrack: Itemize by SMTP Server on sesr04/Transmode(Release 8.5.1FP3|May 23, 2010) at
 2010-06-17 11:42:57,
	Serialize by Router on sesr04/Transmode(Release 8.5.1FP3|May 23, 2010) at
 2010-06-17 11:42:57,
	Serialize complete at 2010-06-17 11:42:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ds1307 driver misreads the ds1388 registers when
checking for 12 or 24 hour mode. Instead of
checking the hour register it reads the minute register.
Therefore the driver thinks minutes >= 40 has the
12HR bit set and resets the minute register by zeroing
the high bits. This results in minutes are reset
to 0-9, jumping back in time 40 or 50 minutes. The
time jump is also written back to the RTC.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---

This should go to Linus ASAP IMHO.

 drivers/rtc/rtc-ds1307.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index c4ec5c1..a01bbe2 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -775,7 +775,7 @@ static int __devinit ds1307_probe(struct i2c_client *client,
 
 read_rtc:
 	/* read RTC registers */
-	tmp = ds1307->read_block_data(ds1307->client, 0, 8, buf);
+	tmp = ds1307->read_block_data(ds1307->client, ds1307->offset, 8, buf);
 	if (tmp != 8) {
 		pr_debug("read error %d\n", tmp);
 		err = -EIO;
@@ -860,7 +860,7 @@ read_rtc:
 		if (ds1307->regs[DS1307_REG_HOUR] & DS1307_BIT_PM)
 			tmp += 12;
 		i2c_smbus_write_byte_data(client,
-				DS1307_REG_HOUR,
+				ds1307->offset + DS1307_REG_HOUR,
 				bin2bcd(tmp));
 	}
 
-- 
1.7.1

