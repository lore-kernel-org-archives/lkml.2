Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0KKSBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:01:18 -0500
Received: from smtp-out-138.synserver.de ([212.40.180.138]:1101 "HELO
	smtp-out-138.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755230Ab0KKSBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:01:16 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 9573
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        stable@kernel.org
Subject: [PATCH] POWER: jz4740-battery: Protect against concurrent battery readings
Date: Thu, 11 Nov 2010 19:00:52 +0100
Message-Id: <1289498453-9938-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can not handle more then one ADC request at a time to the battery. The patch
adds a mutex around the ADC read code to ensure this.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: stable@kernel.org
---
 drivers/power/jz4740-battery.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)
---
This patch should also go into the 2.6.36.x stable tree

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index a8108a7..2bbe04a 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -47,6 +47,8 @@ struct jz_battery {
 
 	struct power_supply battery;
 	struct delayed_work work;
+
+	struct mutex lock;
 };
 
 static inline struct jz_battery *psy_to_jz_battery(struct power_supply *psy)
@@ -68,6 +70,8 @@ static long jz_battery_read_voltage(struct jz_battery *battery)
 	unsigned long val;
 	long voltage;
 
+	mutex_lock(&battery->lock);
+
 	INIT_COMPLETION(battery->read_completion);
 
 	enable_irq(battery->irq);
@@ -91,6 +95,8 @@ static long jz_battery_read_voltage(struct jz_battery *battery)
 	battery->cell->disable(battery->pdev);
 	disable_irq(battery->irq);
 
+	mutex_unlock(&battery->lock);
+
 	return voltage;
 }
 
@@ -291,6 +297,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 	jz_battery->pdev = pdev;
 
 	init_completion(&jz_battery->read_completion);
+	mutex_init(&jz_battery->lock);
 
 	INIT_DELAYED_WORK(&jz_battery->work, jz_battery_work);
 
-- 
1.5.6.5

