Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2BFDEL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 22:04:11 -0500
Received: from stats.peacock.arvixe.com ([174.122.104.67]:60860 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753238Ab2BFDDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 22:03:46 -0500
X-Greylist: delayed 16076 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Feb 2012 22:03:45 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
	b=zXkceF1Blc6zYGWIw45s+jTDcNURyhZjTqHqaIUNx/z245SIvDcEujvEFvbN44lOxHaiZfhqv66f1beZvKQQhLIZLcNK/0x9Jp6TPaiOQUUxLAgybkaYCvW1IMFJLcBc;
From: Przemo Firszt <przemo@firszt.eu>
To: chris@cnpbagwell.com, pinglinux@gmail.com, jkosina@suse.cz,
        linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH] HID: wacom: Fix invalid power_supply_powers calls
Date: Sun,  5 Feb 2012 22:35:24 +0000
Message-Id: <1328481324-7241-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.6.4
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

power_supply_powers calls added in 35b4c01e29bdd9632dabf9784ed3486333f00427
have to be called after power device is created. This patch also fixes the
second call - it has to be "ac" instead of "battery"

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
Signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
---
 drivers/hid/hid-wacom.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index b47e58b..acab74c 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -531,7 +531,6 @@ static int wacom_probe(struct hid_device *hdev,
 	wdata->battery.type = POWER_SUPPLY_TYPE_BATTERY;
 	wdata->battery.use_for_apm = 0;
 
-	power_supply_powers(&wdata->battery, &hdev->dev);
 
 	ret = power_supply_register(&hdev->dev, &wdata->battery);
 	if (ret) {
@@ -540,6 +539,8 @@ static int wacom_probe(struct hid_device *hdev,
 		goto err_battery;
 	}
 
+	power_supply_powers(&wdata->battery, &hdev->dev);
+
 	wdata->ac.properties = wacom_ac_props;
 	wdata->ac.num_properties = ARRAY_SIZE(wacom_ac_props);
 	wdata->ac.get_property = wacom_ac_get_property;
@@ -547,14 +548,14 @@ static int wacom_probe(struct hid_device *hdev,
 	wdata->ac.type = POWER_SUPPLY_TYPE_MAINS;
 	wdata->ac.use_for_apm = 0;
 
-	power_supply_powers(&wdata->battery, &hdev->dev);
-
 	ret = power_supply_register(&hdev->dev, &wdata->ac);
 	if (ret) {
 		hid_warn(hdev,
 			 "can't create ac battery attribute, err: %d\n", ret);
 		goto err_ac;
 	}
+
+	power_supply_powers(&wdata->ac, &hdev->dev);
 #endif
 	return 0;
 
-- 
1.7.6.4

