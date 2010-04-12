Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0DLVdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:33:39 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:36060 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0DLVdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:33:36 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] pda_power: add function callbacks for suspend and resume
Date: Mon, 12 Apr 2010 23:33:22 +0200
Message-Id: <1271108002-15574-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function prototypes for power management events so they can be
handled and used by platform implementations.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/pda_power.c |    9 +++++++++
 include/linux/pda_power.h |    2 ++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index a232de6..0b27b9d 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -404,6 +404,12 @@ static int usb_wakeup_enabled;
 
 static int pda_power_suspend(struct platform_device *pdev, pm_message_t state)
 {
+	if (pdata->suspend) {
+		int ret = pdata->suspend(state);
+		if (ret)
+			return ret;
+	}
+
 	if (device_may_wakeup(&pdev->dev)) {
 		if (ac_irq)
 			ac_wakeup_enabled = !enable_irq_wake(ac_irq->start);
@@ -423,6 +429,9 @@ static int pda_power_resume(struct platform_device *pdev)
 			disable_irq_wake(ac_irq->start);
 	}
 
+	if (pdata->resume)
+		return pdata->resume();
+
 	return 0;
 }
 #else
diff --git a/include/linux/pda_power.h b/include/linux/pda_power.h
index d4cf7a2..c9e4d81 100644
--- a/include/linux/pda_power.h
+++ b/include/linux/pda_power.h
@@ -24,6 +24,8 @@ struct pda_power_pdata {
 	int (*is_usb_online)(void);
 	void (*set_charge)(int flags);
 	void (*exit)(struct device *dev);
+	int (*suspend)(pm_message_t state);
+	int (*resume)(void);
 
 	char **supplied_to;
 	size_t num_supplicants;
-- 
1.7.0.3

