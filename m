Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab1HXOfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:35:36 -0400
Received: from 64-198-47-7.ip.mcleodusa.net ([64.198.47.7]:51762 "EHLO
	mail02.indesign-llc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab1HXOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:35:33 -0400
Message-ID: <4E550C32.4010802@indesign-llc.com>
Date: Wed, 24 Aug 2011 10:35:30 -0400
From: Clifton Barnes <cabarnes@indesign-llc.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: <akpm@linux-foundation.org>
CC: <ryan@bluewatersys.com>, <haojian.zhuang@marvell.com>,
        <johnpol@2ka.mipt.ru>, <simon.inizan@goobie.fr>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] w1: ds2780, add a nolock function to w1 interface
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a nolock function to the w1 interface to avoid locking the
mutex if needed.

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
---
 drivers/w1/slaves/w1_ds2780.c |   48 +++++++++++++++++++++++++++++-----------
 drivers/w1/slaves/w1_ds2780.h |    2 +
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2780.c b/drivers/w1/slaves/w1_ds2780.c
index 274c8f3..505b17d 100644
--- a/drivers/w1/slaves/w1_ds2780.c
+++ b/drivers/w1/slaves/w1_ds2780.c
@@ -26,20 +26,14 @@
 #include "../w1_family.h"
 #include "w1_ds2780.h"
 
-int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
-			int io)
+static int w1_ds2780_do_io(struct device *dev, char *buf, int addr,
+			size_t count, int io)
 {
 	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
 
-	if (!dev)
-		return -ENODEV;
+	if (addr > DS2780_DATA_SIZE || addr < 0)
+		return 0;
 
-	mutex_lock(&sl->master->mutex);
-
-	if (addr > DS2780_DATA_SIZE || addr < 0) {
-		count = 0;
-		goto out;
-	}
 	count = min_t(int, count, DS2780_DATA_SIZE - addr);
 
 	if (w1_reset_select_slave(sl) == 0) {
@@ -47,7 +41,6 @@ int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
 			w1_write_8(sl->master, W1_DS2780_WRITE_DATA);
 			w1_write_8(sl->master, addr);
 			w1_write_block(sl->master, buf, count);
-			/* XXX w1_write_block returns void, not n_written */
 		} else {
 			w1_write_8(sl->master, W1_DS2780_READ_DATA);
 			w1_write_8(sl->master, addr);
@@ -55,13 +48,42 @@ int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
 		}
 	}
 
-out:
+	return count;
+}
+
+int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
+			int io)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+	int ret;
+
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&sl->master->mutex);
+
+	ret = w1_ds2780_do_io(dev, buf, addr, count, io);
+
 	mutex_unlock(&sl->master->mutex);
 
-	return count;
+	return ret;
 }
 EXPORT_SYMBOL(w1_ds2780_io);
 
+int w1_ds2780_io_nolock(struct device *dev, char *buf, int addr, size_t count,
+			int io)
+{
+	int ret;
+
+	if (!dev)
+		return -ENODEV;
+
+	ret = w1_ds2780_do_io(dev, buf, addr, count, io);
+
+	return ret;
+}
+EXPORT_SYMBOL(w1_ds2780_io_nolock);
+
 int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd)
 {
 	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
diff --git a/drivers/w1/slaves/w1_ds2780.h b/drivers/w1/slaves/w1_ds2780.h
index a1fba79..7373793 100644
--- a/drivers/w1/slaves/w1_ds2780.h
+++ b/drivers/w1/slaves/w1_ds2780.h
@@ -124,6 +124,8 @@
 
 extern int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
 			int io);
+extern int w1_ds2780_io_nolock(struct device *dev, char *buf, int addr,
+			size_t count, int io);
 extern int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd);
 
 #endif /* !_W1_DS2780_H */
-- 
1.7.6

