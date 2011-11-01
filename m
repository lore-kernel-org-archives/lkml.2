Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934891Ab1KAArh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:47:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55006 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934827Ab1KAAr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:47:26 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        David Woodhouse <dwmw2@infradead.org>
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 9/9] bq27x00: Fix OOPS caused by unregistring bq27x00 driver
Date: Tue,  1 Nov 2011 01:43:11 +0100
Message-Id: <1320108191-6647-9-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320108191-6647-1-git-send-email-pali.rohar@gmail.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
 <1320108191-6647-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* power_supply_unregister call bq27x00_battery_get_property which call bq27x00_battery_poll
* make sure that bq27x00_battery_poll will not call schedule_delayed_work again after unregister (which cause OOPS)

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/power/bq27x00_battery.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 15ecd42..29ce907 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -722,6 +722,10 @@ static int bq27x00_powersupply_init(struct bq27x00_device_info *di)
 
 static void bq27x00_powersupply_unregister(struct bq27x00_device_info *di)
 {
+	/* power_supply_unregister call bq27x00_battery_get_property which call bq27x00_battery_poll */
+	/* make sure that bq27x00_battery_poll will not call schedule_delayed_work again after unregister (which cause OOPS) */
+	poll_interval = 0;
+
 	cancel_delayed_work_sync(&di->work);
 
 	bq27x00_battery_reg_exit(di);
-- 
1.7.5.4

