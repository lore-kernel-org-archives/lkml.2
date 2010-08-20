Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228Ab0HTHqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 03:46:05 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34672 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab0HTHqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 03:46:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=n667FKwfQN9nyYyWZPGh7U6k3K0lUe/HyBRZcNELLHfwzIFnDDjTBAsSrJBKnv665U
         ln4oZSXldnzIYdMWdsL0y/yYT1+5rP0ifW/Cb0AFzOa5Q0SWN/ejI2YBQ83MMHqjw2ER
         zIpeW637W559tS2yCrozjhiHCIBccLziiWSmo=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv2] mmc: make mmc_dev_to_card() macro public
Date: Fri, 20 Aug 2010 10:46:46 +0300
Message-Id: <1282290406-13198-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100820002332.93b0c44d.akpm@linux-foundation.org>
References: <20100820002332.93b0c44d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Conversion from struct device to struct mmc_card is used more than in one
place. Due to this it's better to have public macro for such thing.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: linux-mmc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/mmc/card/mmc_test.c |    4 +---
 drivers/mmc/core/bus.c      |   15 +++++++--------
 drivers/mmc/core/bus.h      |    2 +-
 include/linux/mmc/card.h    |    2 ++
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index 5dd8576..b992725 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -1935,12 +1935,10 @@ static ssize_t mmc_test_show(struct device *dev,
 static ssize_t mmc_test_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	struct mmc_card *card;
+	struct mmc_card *card = mmc_dev_to_card(dev);
 	struct mmc_test_card *test;
 	int testcase;
 
-	card = container_of(dev, struct mmc_card, dev);
-
 	testcase = simple_strtol(buf, NULL, 10);
 
 	test = kzalloc(sizeof(struct mmc_test_card), GFP_KERNEL);
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 7cd9749..e70bd66 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -22,13 +22,12 @@
 #include "sdio_cis.h"
 #include "bus.h"
 
-#define dev_to_mmc_card(d)	container_of(d, struct mmc_card, dev)
 #define to_mmc_driver(d)	container_of(d, struct mmc_driver, drv)
 
 static ssize_t mmc_type_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 
 	switch (card->type) {
 	case MMC_TYPE_MMC:
@@ -62,7 +61,7 @@ static int mmc_bus_match(struct device *dev, struct device_driver *drv)
 static int
 mmc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 	const char *type;
 	int retval = 0;
 
@@ -105,7 +104,7 @@ mmc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 static int mmc_bus_probe(struct device *dev)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 
 	return drv->probe(card);
 }
@@ -113,7 +112,7 @@ static int mmc_bus_probe(struct device *dev)
 static int mmc_bus_remove(struct device *dev)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 
 	drv->remove(card);
 
@@ -123,7 +122,7 @@ static int mmc_bus_remove(struct device *dev)
 static int mmc_bus_suspend(struct device *dev, pm_message_t state)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 	int ret = 0;
 
 	if (dev->driver && drv->suspend)
@@ -134,7 +133,7 @@ static int mmc_bus_suspend(struct device *dev, pm_message_t state)
 static int mmc_bus_resume(struct device *dev)
 {
 	struct mmc_driver *drv = to_mmc_driver(dev->driver);
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 	int ret = 0;
 
 	if (dev->driver && drv->resume)
@@ -189,7 +188,7 @@ EXPORT_SYMBOL(mmc_unregister_driver);
 
 static void mmc_release_card(struct device *dev)
 {
-	struct mmc_card *card = dev_to_mmc_card(dev);
+	struct mmc_card *card = mmc_dev_to_card(dev);
 
 	sdio_free_common_cis(card);
 
diff --git a/drivers/mmc/core/bus.h b/drivers/mmc/core/bus.h
index 1817876..00a1971 100644
--- a/drivers/mmc/core/bus.h
+++ b/drivers/mmc/core/bus.h
@@ -14,7 +14,7 @@
 #define MMC_DEV_ATTR(name, fmt, args...)					\
 static ssize_t mmc_##name##_show (struct device *dev, struct device_attribute *attr, char *buf)	\
 {										\
-	struct mmc_card *card = container_of(dev, struct mmc_card, dev);	\
+	struct mmc_card *card = mmc_dev_to_card(dev);				\
 	return sprintf(buf, fmt, args);						\
 }										\
 static DEVICE_ATTR(name, S_IRUGO, mmc_##name##_show, NULL)
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 6b75250..7bd4923 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -173,6 +173,8 @@ static inline int mmc_blksz_for_byte_mode(const struct mmc_card *c)
 #define mmc_card_name(c)	((c)->cid.prod_name)
 #define mmc_card_id(c)		(dev_name(&(c)->dev))
 
+#define mmc_dev_to_card(d)	container_of(d, struct mmc_card, dev)
+
 #define mmc_list_to_card(l)	container_of(l, struct mmc_card, node)
 #define mmc_get_drvdata(c)	dev_get_drvdata(&(c)->dev)
 #define mmc_set_drvdata(c,d)	dev_set_drvdata(&(c)->dev, d)
-- 
1.6.3.3

