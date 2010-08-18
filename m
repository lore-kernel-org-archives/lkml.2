Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0HRNbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:31:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59454 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0HRNbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:31:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BCDfUjxgM+keMjkq07mvHFsWGMkDnVComejS24Z63YrTrMjdoHCKMlpLLW+CvbTDsL
         cZtBDjn2eOAn2XjbDMHQEDpILr8GnV7Ntyb3n8DetjNB0oMDQCUy9tIouRLwJ69oGhfR
         IeFRMrA5l1uR2s9r9cPRaiiiGiuA0hZCySggc=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org
Subject: [PATCH] mmc: make dev_to_mmc_card() macro public
Date: Wed, 18 Aug 2010 16:31:18 +0300
Message-Id: <1282138278-22304-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conversion from struct device to struct mmc_card is used more than in one
place. Due to this it's better to have public macro for such thing.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: linux-mmc@vger.kernel.org
---
 drivers/mmc/card/mmc_test.c |    4 +---
 drivers/mmc/core/bus.c      |    1 -
 drivers/mmc/core/bus.h      |    2 +-
 include/linux/mmc/card.h    |    2 ++
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 5dd8576..82d39bd 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -1935,12 +1935,10 @@ static ssize_t mmc_test_show(struct device *dev,
 static ssize_t mmc_test_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct mmc_card *card;
+	struct mmc_card *card = dev_to_mmc_card(dev);
 	struct mmc_test_card *test;
 	int testcase;
 
-	card = container_of(dev, struct mmc_card, dev);
-
 	testcase = simple_strtol(buf, NULL, 10);
 
 	test = kzalloc(sizeof(struct mmc_test_card), GFP_KERNEL);
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 7cd9749..27326c4 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -22,7 +22,6 @@
 #include "sdio_cis.h"
 #include "bus.h"
 
-#define dev_to_mmc_card(d)	container_of(d, struct mmc_card, dev)
 #define to_mmc_driver(d)	container_of(d, struct mmc_driver, drv)
 
 static ssize_t mmc_type_show(struct device *dev,
diff --git a/drivers/mmc/core/bus.h b/drivers/mmc/core/bus.h
index 1817876..7813954 100644
--- a/drivers/mmc/core/bus.h
+++ b/drivers/mmc/core/bus.h
@@ -14,7 +14,7 @@
 #define MMC_DEV_ATTR(name, fmt, args...)					\
 static ssize_t mmc_##name##_show (struct device *dev, struct device_attribute *attr, char *buf)	\
 {										\
-	struct mmc_card *card = container_of(dev, struct mmc_card, dev);	\
+	struct mmc_card *card = dev_to_mmc_card(dev);				\
 	return sprintf(buf, fmt, args);						\
 }										\
 static DEVICE_ATTR(name, S_IRUGO, mmc_##name##_show, NULL)
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 6b75250..71acf19 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -173,6 +173,8 @@ static inline int mmc_blksz_for_byte_mode(const struct mmc_card *c)
 #define mmc_card_name(c)	((c)->cid.prod_name)
 #define mmc_card_id(c)		(dev_name(&(c)->dev))
 
+#define dev_to_mmc_card(d)	container_of(d, struct mmc_card, dev)
+
 #define mmc_list_to_card(l)	container_of(l, struct mmc_card, node)
 #define mmc_get_drvdata(c)	dev_get_drvdata(&(c)->dev)
 #define mmc_set_drvdata(c,d)	dev_set_drvdata(&(c)->dev, d)
-- 
1.6.3.3

