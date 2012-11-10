Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2KJOnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 09:43:24 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58074 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2KJOnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 09:43:22 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] bq27x00_battery: Do not report nominal available capaciy if battery is not calibrated
Date: Sat, 10 Nov 2012 15:42:48 +0100
Message-Id: <1352558568-30607-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/bq27x00_battery.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 5860d4d..41b3328 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -230,6 +230,14 @@ static int bq27x00_battery_read_charge(struct bq27x00_device_info *di, u8 reg)
  */
 static inline int bq27x00_battery_read_nac(struct bq27x00_device_info *di)
 {
+	int flags;
+	bool is_bq27500 = di->chip == BQ27500;
+	bool is_higher = bq27xxx_is_chip_version_higher(di);
+
+	flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
+	if (flags >= 0 && !is_higher && (flags & BQ27000_FLAG_CI))
+		return -ENODATA;
+
 	return bq27x00_battery_read_charge(di, BQ27x00_REG_NAC);
 }
 
-- 
1.7.10.4

