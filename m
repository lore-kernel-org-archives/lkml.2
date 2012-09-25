Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2IYQNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 12:13:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774Ab2IYQNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 12:13:45 -0400
From: mathieu.poirier@linaro.org
To: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Cc: mathieu.poirier@linaro.org
Subject: [PATCH 27/57] power: sysfs interface update
Date: Tue, 25 Sep 2012 10:12:24 -0600
Message-Id: <1348589574-25655-28-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

Add new sysfs interface to get current charge status

Signed-off-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Olivier CLERGEAUD <olivier.clergeaud@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/power/ab8500_charger.c  |    3 +++
 drivers/power/abx500_chargalg.c |   24 +++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 4129599..0a781a0 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2759,6 +2759,9 @@ static int ab8500_charger_usb_notifier_call(struct notifier_block *nb,
 	enum ab8500_usb_state bm_usb_state;
 	unsigned mA = *((unsigned *)power);
 
+	if (di == NULL)
+		return NOTIFY_DONE;
+
 	if (event != USB_EVENT_VBUS) {
 		dev_dbg(di->dev, "not a standard host, returning\n");
 		return NOTIFY_DONE;
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index d3efc2a..4e3d20f 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1679,6 +1679,27 @@ static int abx500_chargalg_get_property(struct power_supply *psy,
 	return 0;
 }
 
+/**
+ * abx500_chargalg_sysfs_show() - sysfs show operations
+ * @kobj:      pointer to the struct kobject
+ * @attr:      pointer to the struct attribute
+ * @buf:       buffer that holds the parameter to send to userspace
+ *
+ * Returns a buffer to be displayed in user space
+ */
+static ssize_t abx500_chargalg_sysfs_show(struct kobject *kobj,
+	struct attribute *attr, char *buf)
+{
+	struct abx500_chargalg *di = container_of(kobj,
+		struct abx500_chargalg, chargalg_kobject);
+
+	if ((di->susp_status.ac_suspended == true) &&
+		(di->susp_status.usb_suspended == true))
+		return sprintf(buf, "0\n");
+	else
+		return sprintf(buf, "1\n");
+}
+
 /* Exposure to the sysfs interface */
 
 /**
@@ -1749,7 +1770,7 @@ static ssize_t abx500_chargalg_sysfs_charger(struct kobject *kobj,
 static struct attribute abx500_chargalg_en_charger = \
 {
 	.name = "chargalg",
-	.mode = S_IWUGO,
+	.mode = S_IRUGO | S_IWUSR,
 };
 
 static struct attribute *abx500_chargalg_chg[] = {
@@ -1758,6 +1779,7 @@ static struct attribute *abx500_chargalg_chg[] = {
 };
 
 static const struct sysfs_ops abx500_chargalg_sysfs_ops = {
+	.show = abx500_chargalg_sysfs_show,
 	.store = abx500_chargalg_sysfs_charger,
 };
 
-- 
1.7.5.4

