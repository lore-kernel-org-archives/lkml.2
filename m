Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab1BVGmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 01:42:38 -0500
Received: from smtp-out-090.synserver.de ([212.40.185.90]:1049 "EHLO
	smtp-out-090.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab1BVGmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 01:42:32 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 18504
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Pali Rohar <pali.rohar@gmail.com>, Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 02/16] power_suply: Initialize changed_work before calling device_add
Date: Tue, 22 Feb 2011 07:37:47 +0100
Message-Id: <1298356681-8317-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298356681-8317-1-git-send-email-lars@metafoo.de>
References: <1298356681-8317-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling device_add causes an inital uevent for that device to be generated.
The power_supply uevent function calls the drivers get_property function,
which might causes the driver to update its state, which again might
causes the driver to call power_supply_changed(). Since the power_supplys
changed_work has not been initialized at this point the behavior is
undefined and can result in an OOPS.

This patch fixes the issue by initializing the power_supplys changed_work
prior to adding the power_supplys device to the device tree.

Reported-by: Grazvydas Ignotas <notasas@gmail.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Tested-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/power_supply_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 970f733..329b46b 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -171,6 +171,8 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	dev_set_drvdata(dev, psy);
 	psy->dev = dev;
 
+	INIT_WORK(&psy->changed_work, power_supply_changed_work);
+
 	rc = kobject_set_name(&dev->kobj, "%s", psy->name);
 	if (rc)
 		goto kobject_set_name_failed;
@@ -179,8 +181,6 @@ int power_supply_register(struct device *parent, struct power_supply *psy)
 	if (rc)
 		goto device_add_failed;
 
-	INIT_WORK(&psy->changed_work, power_supply_changed_work);
-
 	rc = power_supply_create_triggers(psy);
 	if (rc)
 		goto create_triggers_failed;
-- 
1.7.2.3

