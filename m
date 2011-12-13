Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1LMR4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 12:56:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37853 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1LMR40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 12:56:26 -0500
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 3/3] drivers:misc: ti-st: DEBUG uart, baud rate mods
Date: Tue, 13 Dec 2011 11:56:20 -0600
Message-ID: <1323798980-6597-4-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1323798980-6597-3-git-send-email-pavan_savoy@ti.com>
References: <1323798980-6597-1-git-send-email-pavan_savoy@ti.com>
 <1323798980-6597-2-git-send-email-pavan_savoy@ti.com>
 <1323798980-6597-3-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

To debug different UARTs at different baud-rates connected to the WiLink
connectivity combo-chipset, this patch enables the debugging code so that upon
boot different UARTs at different baud-rates can be tried out to verify the
interface with WiLink.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index bc8a571..55ab031 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -573,6 +573,28 @@ static ssize_t show_install(struct device *dev,
 	return sprintf(buf, "%d\n", kim_data->ldisc_install);
 }
 
+#ifdef DEBUG
+static ssize_t store_dev_name(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct kim_data_s *kim_data = dev_get_drvdata(dev);
+	pr_debug("storing dev name >%s<", buf);
+	strncpy(kim_data->dev_name, buf, count);
+	pr_debug("stored dev name >%s<", kim_data->dev_name);
+	return count;
+}
+
+static ssize_t store_baud_rate(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct kim_data_s *kim_data = dev_get_drvdata(dev);
+	pr_debug("storing baud rate >%s<", buf);
+	sscanf(buf, "%ld", &kim_data->baud_rate);
+	pr_debug("stored baud rate >%ld<", kim_data->baud_rate);
+	return count;
+}
+#endif	/* if DEBUG */
+
 static ssize_t show_dev_name(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -598,11 +620,19 @@ static ssize_t show_flow_cntrl(struct device *dev,
 static struct kobj_attribute ldisc_install =
 __ATTR(install, 0444, (void *)show_install, NULL);
 
+#ifdef DEBUG	/* TODO: move this to debug-fs if possible */
+__ATTR(dev_name, 0644, (void *)show_dev_name, (void *)store_dev_name);
+#else
 static struct kobj_attribute uart_dev_name =
 __ATTR(dev_name, 0444, (void *)show_dev_name, NULL);
+#endif
 
 static struct kobj_attribute uart_baud_rate =
+#ifdef DEBUG	/* TODO: move to debugfs */
+__ATTR(baud_rate, 0644, (void *)show_baud_rate, (void *)store_baud_rate);
+#else
 __ATTR(baud_rate, 0444, (void *)show_baud_rate, NULL);
+#endif
 
 static struct kobj_attribute uart_flow_cntrl =
 __ATTR(flow_cntrl, 0444, (void *)show_flow_cntrl, NULL);
-- 
1.7.4.1

