Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab2AITZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:25:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48990 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933053Ab2AITZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:25:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/8] drivers:misc: ti-st: DEBUG uart, baud rate mods
Date: Mon,  9 Jan 2012 11:25:03 -0800
Message-Id: <1326137105-9960-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1326137105-9960-1-git-send-email-gregkh@suse.de>
References: <20120109190736.GA9440@kroah.com>
 <1326137105-9960-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

To debug different UARTs at different baud-rates connected to the WiLink
connectivity combo-chipset, this patch enables the debugging code so that upon
boot different UARTs at different baud-rates can be tried out to verify the
interface with WiLink.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/ti-st/st_kim.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index bc8a571..a7a861c 100644
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
@@ -599,10 +621,18 @@ static struct kobj_attribute ldisc_install =
 __ATTR(install, 0444, (void *)show_install, NULL);
 
 static struct kobj_attribute uart_dev_name =
+#ifdef DEBUG	/* TODO: move this to debug-fs if possible */
+__ATTR(dev_name, 0644, (void *)show_dev_name, (void *)store_dev_name);
+#else
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
1.7.8

