Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1G0SYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:24:36 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:13830 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031Ab1G0SYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:24:34 -0400
From: Daniel Drake <dsd@laptop.org>
To: cbou@mail.ru
To: dwmw2@infradead.org
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] olpc_battery: add wakeup support
Message-Id: <20110727182426.9EE599D401D@zog.reactivated.net>
Date: Wed, 27 Jul 2011 19:24:26 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=7A8QoG2UdyIA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=8DgI5CuxNwjYZL_WLIcA:9 a=rab-LXelTIMD8oiw0SkA:7 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Battery and AC events can now be used to wake up the system from suspend.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/power/olpc_battery.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

Depends on power management patches that were merged into linus master
yesterday.

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 9972268..46a2f07 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -533,6 +533,24 @@ void olpc_battery_trigger_uevent(unsigned long cause)
 		kobject_uevent(&olpc_bat.dev->kobj, KOBJ_CHANGE);
 }
 
+static int olpc_battery_suspend(struct platform_device *pdev,
+				pm_message_t state)
+{
+	if (device_may_wakeup(olpc_ac.dev))
+		olpc_ec_wakeup_set(EC_SCI_SRC_ACPWR);
+	else
+		olpc_ec_wakeup_clear(EC_SCI_SRC_ACPWR);
+
+	if (device_may_wakeup(olpc_bat.dev))
+		olpc_ec_wakeup_set(EC_SCI_SRC_BATTERY | EC_SCI_SRC_BATSOC
+				   | EC_SCI_SRC_BATERR);
+	else
+		olpc_ec_wakeup_clear(EC_SCI_SRC_BATTERY | EC_SCI_SRC_BATSOC
+				     | EC_SCI_SRC_BATERR);
+
+	return 0;
+}
+
 static int __devinit olpc_battery_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -578,6 +596,11 @@ static int __devinit olpc_battery_probe(struct platform_device *pdev)
 	if (ret)
 		goto error_failed;
 
+	if (olpc_ec_wakeup_available()) {
+		device_set_wakeup_capable(olpc_ac.dev, true);
+		device_set_wakeup_capable(olpc_bat.dev, true);
+	}
+
 	return 0;
 
 error_failed:
@@ -612,6 +635,7 @@ static struct platform_driver olpc_battery_drv = {
 	},
 	.probe = olpc_battery_probe,
 	.remove = __devexit_p(olpc_battery_remove),
+	.suspend = olpc_battery_suspend,
 };
 
 static int __init olpc_bat_init(void)
-- 
1.7.6

