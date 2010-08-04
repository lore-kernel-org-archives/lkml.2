Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab0HDBxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:53:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59260 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab0HDBxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OvY0MO0T2HjJ/44qINL/KXxT9/cO7Hxx88vpBLrcXeMkPRRJf3gL3tpGSlOw0/VBpG
         3pdXh9KugztX+Gs014kRTd9//9f/Nc48gCANlk2ajlu3gYRSL5MJKS25x0Fp/hSN6pe5
         Z+S4j7I1h04rNYMqPuv3OG9R2e/PUrsTshV0I=
Subject: [PATCH] wm8350-core: fix wrong kfree in error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 04 Aug 2010 09:54:21 +0800
Message-Id: <1280886861.31990.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. fix wm8350_create_cache error path
   make sure wm8350->reg_cache is freed in error path.
2. fix wm8350_device_init error path
   no need to kfree(wm8350->reg_cache) in the case of goto out.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/wm8350-core.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index b580748..e81cc31 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -536,6 +536,7 @@ static int wm8350_create_cache(struct wm8350 *wm8350, int type, int mode)
 	}
 
 out:
+	kfree(wm8350->reg_cache);
 	return ret;
 }
 
@@ -700,7 +701,7 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 
 	ret = wm8350_irq_init(wm8350, irq, pdata);
 	if (ret < 0)
-		goto err;
+		goto err_free;
 
 	if (wm8350->irq_base) {
 		ret = request_threaded_irq(wm8350->irq_base +
@@ -738,8 +739,9 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 
 err_irq:
 	wm8350_irq_exit(wm8350);
-err:
+err_free:
 	kfree(wm8350->reg_cache);
+err:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(wm8350_device_init);
-- 
1.5.4.3



