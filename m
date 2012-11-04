Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab2KDUnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 15:43:13 -0500
Received: from mail.ispras.ru ([83.149.199.43]:40397 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab2KDUnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 15:43:12 -0500
X-Greylist: delayed 1373 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Nov 2012 15:43:12 EST
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] extcon: arizona: unlock mutex on error path in arizona_micdet()
Date: Sun,  4 Nov 2012 13:19:46 -0700
Message-Id: <1352060386-13610-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If regmap_read() failed, arizona_micdet() returns IRQ_NONE
leaving &info->lock mutex locked as opposed to all other return paths.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/extcon/extcon-arizona.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index cdab9e5..d876a54 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -166,6 +166,7 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 	ret = regmap_read(arizona->regmap, ARIZONA_MIC_DETECT_3, &val);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Failed to read MICDET: %d\n", ret);
+		mutex_unlock(&info->lock);
 		return IRQ_NONE;
 	}
 
-- 
1.7.9.5

