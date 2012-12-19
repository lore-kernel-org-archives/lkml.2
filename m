Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027Ab2LSJ3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 04:29:23 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:59729 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2LSJ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:29:14 -0500
Message-ID: <1355909344.11204.3.camel@phoenix>
Subject: [PATCH] rtc: tx4939: Kill get_tx4939rtc_plat_data() function
From: Axel Lin <axel.lin@ingics.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Dec 2012 17:29:04 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply use dev_get_drvdata() instead.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/rtc/rtc-tx4939.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index a12bfac..b570d02 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -22,11 +22,6 @@ struct tx4939rtc_plat_data {
 	spinlock_t lock;
 };
 
-static struct tx4939rtc_plat_data *get_tx4939rtc_plat_data(struct device *dev)
-{
-	return platform_get_drvdata(to_platform_device(dev));
-}
-
 static int tx4939_rtc_cmd(struct tx4939_rtc_reg __iomem *rtcreg, int cmd)
 {
 	int i = 0;
@@ -44,7 +39,7 @@ static int tx4939_rtc_cmd(struct tx4939_rtc_reg __iomem *rtcreg, int cmd)
 
 static int tx4939_rtc_set_mmss(struct device *dev, unsigned long secs)
 {
-	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev);
+	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
 	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
 	int i, ret;
 	unsigned char buf[6];
@@ -68,7 +63,7 @@ static int tx4939_rtc_set_mmss(struct device *dev, unsigned long secs)
 
 static int tx4939_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev);
+	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
 	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
 	int i, ret;
 	unsigned long sec;
@@ -93,7 +88,7 @@ static int tx4939_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 static int tx4939_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
-	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev);
+	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
 	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
 	int i, ret;
 	unsigned long sec;
@@ -125,7 +120,7 @@ static int tx4939_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 static int tx4939_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
-	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev);
+	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
 	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
 	int i, ret;
 	unsigned long sec;
@@ -154,7 +149,7 @@ static int tx4939_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 static int tx4939_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
-	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev);
+	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
 
 	spin_lock_irq(&pdata->lock);
 	tx4939_rtc_cmd(pdata->rtcreg,
@@ -166,7 +161,7 @@ static int tx4939_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 
 static irqreturn_t tx4939_rtc_interrupt(int irq, void *dev_id)
 {
-	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev_id);
+	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev_id);
 	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
 	unsigned long events = RTC_IRQF;
 
@@ -194,7 +189,7 @@ static ssize_t tx4939_rtc_nvram_read(struct file *filp, struct kobject *kobj,
 				     char *buf, loff_t pos, size_t size)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev);
+	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
 	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
 	ssize_t count;
 
@@ -213,7 +208,7 @@ static ssize_t tx4939_rtc_nvram_write(struct file *filp, struct kobject *kobj,
 				      char *buf, loff_t pos, size_t size)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
-	struct tx4939rtc_plat_data *pdata = get_tx4939rtc_plat_data(dev);
+	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
 	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
 	ssize_t count;
 
-- 
1.7.9.5



