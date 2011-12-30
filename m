Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab1L3CsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 21:48:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab1L3CsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 21:48:19 -0500
From: NeilBrown <neilb@suse.de>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Dec 2011 11:58:49 +1100
Subject: [PATCH 5/5] bq27x00 - don't report power-supply change so often.
Message-ID: <20111230005849.11559.78948.stgit@notabene.brown>
In-Reply-To: <20111230004947.11559.81184.stgit@notabene.brown>
References: <20111230004947.11559.81184.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A power_supply_changed should only be reported on significant changes
such as transition between charging and not.  Incremental changes
such as charge increasing should not be reported - that can easily
be polled for.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/power/bq27x00_battery.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index bb16f5b..7993a17 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -57,11 +57,15 @@
 #define BQ27000_FLAG_CHGS		BIT(7)
 #define BQ27000_FLAG_FC			BIT(5)
 
+#define BQ27000_FLAGS_IMPORTANT		(BQ27000_FLAG_FC|BQ27000_FLAG_CHGS|BIT(31))
+
 #define BQ27500_REG_SOC			0x2C
 #define BQ27500_REG_DCAP		0x3C /* Design capacity */
 #define BQ27500_FLAG_DSC		BIT(0)
 #define BQ27500_FLAG_FC			BIT(9)
 
+#define BQ27500_FLAGS_IMPORTANT		(BQ27500_FLAG_FC|BQ27500_FLAG_DSC|BIT(31))
+
 #define BQ27000_RS			20 /* Resistor sense */
 
 struct bq27x00_device_info;
@@ -259,6 +263,7 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 {
 	struct bq27x00_reg_cache cache = {0, };
 	bool is_bq27500 = di->chip == BQ27500;
+	int flags_changed;
 
 	cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, is_bq27500);
 	if (cache.flags >= 0) {
@@ -280,10 +285,14 @@ static void bq27x00_update(struct bq27x00_device_info *di)
 
 	/* Ignore current_now which is a snapshot of the current battery state
 	 * and is likely to be different even between two consecutive reads */
-	if (memcmp(&di->cache, &cache, sizeof(cache) - sizeof(int)) != 0) {
-		di->cache = cache;
+	flags_changed = di->cache.flags ^ cache.flags;
+	di->cache = cache;
+	if (is_bq27500)
+		flags_changed &= BQ27500_FLAGS_IMPORTANT;
+	else
+		flags_changed &= BQ27000_FLAGS_IMPORTANT;
+	if (flags_changed)
 		power_supply_changed(&di->bat);
-	}
 
 	di->last_update = jiffies;
 }


