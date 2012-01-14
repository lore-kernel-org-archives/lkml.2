Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab2ANUu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:50:57 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62512 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab2ANUuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:50:55 -0500
From: Grazvydas Ignotas <notasas@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Grazvydas Ignotas <notasas@gmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] bq27x00_battery: fix flag register read
Date: Sat, 14 Jan 2012 22:50:49 +0200
Message-Id: <1326574249-31334-1-git-send-email-notasas@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading flags, bq27x00_read() argument is inverted and causes
reads 2 of bytes for bq27200 and 1 byte for bq27500, while their register
sizes are 1 and 2 bytes respectively. This causes bq27500 upper flag
bits always to be returned as 0, causing full charge state to never be
reported correctly, so fix it.

Cc: Pali Rohár <pali.rohar@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/bq27x00_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 98bf567..86decb4 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -312,7 +312,7 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 	struct bq27x00_reg_cache cache = {0, };
 	bool is_bq27500 = di->chip == BQ27500;
 
-	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
+	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
 	if (cache.flags >= 0) {
 		if (!is_bq27500 && (cache.flags & BQ27000_FLAG_CI)) {
 			dev_info(di->dev, "battery is not calibrated! ignoring capacity values\n");
-- 
1.7.0.4

