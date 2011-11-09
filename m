Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936107Ab1KJELw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:11:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936026Ab1KJDnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:43:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:59 2011
Message-Id: <20111109213159.018170203@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Clifton Barnes <cabarnes@indesign-llc.com>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [167/264] drivers/power/ds2780_battery.c: fix deadlock upon insertion and removal
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clifton Barnes <cabarnes@indesign-llc.com>

commit 0e053fcbbbc4d945247cb32cad2767b483cb65f8 upstream.

Fixes the deadlock when inserting and removing the ds2780.

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/power/ds2780_battery.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/power/ds2780_battery.c
+++ b/drivers/power/ds2780_battery.c
@@ -39,6 +39,7 @@ struct ds2780_device_info {
 	struct device *dev;
 	struct power_supply bat;
 	struct device *w1_dev;
+	struct task_struct *mutex_holder;
 };
 
 enum current_types {
@@ -63,6 +64,9 @@ static inline struct power_supply *to_po
 static inline int ds2780_battery_io(struct ds2780_device_info *dev_info,
 	char *buf, int addr, size_t count, int io)
 {
+	if (dev_info->mutex_holder == current)
+		return w1_ds2780_io_nolock(dev_info->w1_dev, buf, addr, count, io);
+	else
 		return w1_ds2780_io(dev_info->w1_dev, buf, addr, count, io);
 }
 
@@ -775,6 +779,7 @@ static int __devinit ds2780_battery_prob
 	dev_info->bat.properties	= ds2780_battery_props;
 	dev_info->bat.num_properties	= ARRAY_SIZE(ds2780_battery_props);
 	dev_info->bat.get_property	= ds2780_battery_get_property;
+	dev_info->mutex_holder		= current;
 
 	ret = power_supply_register(&pdev->dev, &dev_info->bat);
 	if (ret) {
@@ -804,6 +809,8 @@ static int __devinit ds2780_battery_prob
 		goto fail_remove_bin_file;
 	}
 
+	dev_info->mutex_holder = NULL;
+
 	return 0;
 
 fail_remove_bin_file:
@@ -823,6 +830,8 @@ static int __devexit ds2780_battery_remo
 {
 	struct ds2780_device_info *dev_info = platform_get_drvdata(pdev);
 
+	dev_info->mutex_holder = current;
+
 	/* remove attributes */
 	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
 


