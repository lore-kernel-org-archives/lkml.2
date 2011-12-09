Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1LIWoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:44:23 -0500
Received: from claw.goop.org ([74.207.240.146]:35589 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab1LIWnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:43:33 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Richard Hughes <richard@hughsie.com>
Subject: [PATCH RFC V2 2/4] power_supply: allow a power supply to explicitly point to powered device
Date: Fri,  9 Dec 2011 14:43:17 -0800
Message-Id: <8351665195cec6d2b73cce8b66f02d6dde246a8e.1323454016.git.jeremy@goop.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <cover.1323454016.git.jeremy@goop.org>
References: <cover.1323454016.git.jeremy@goop.org>
In-Reply-To: <cover.1323454016.git.jeremy@goop.org>
References: <cover.1323454016.git.jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a power supply has a scope of "Device", then allow the power supply
to indicate what device it actually powers. This is represented in the
power supply's sysfs directory as a symlink named "powers", which points to
the sysfs directory of the powered device.

If the device has children, then the sub-devices are also powered by
the same power supply.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Richard Hughes <richard@hughsie.com>
---
 drivers/power/power_supply_core.c |    7 +++++++
 include/linux/power_supply.h      |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 329b46b..b10c121 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -147,6 +147,12 @@ struct power_supply *power_supply_get_by_name(char *name)
 }
 EXPORT_SYMBOL_GPL(power_supply_get_by_name);
 
+int power_supply_powers(struct power_supply *psy, struct device *dev)
+{
+	return sysfs_create_link_nowarn(&psy->dev->kobj, &dev->kobj, "powers");
+}
+EXPORT_SYMBOL_GPL(power_supply_powers);
+
 static void power_supply_dev_release(struct device *dev)
 {
 	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
@@ -202,6 +208,7 @@ EXPORT_SYMBOL_GPL(power_supply_register);
 void power_supply_unregister(struct power_supply *psy)
 {
 	cancel_work_sync(&psy->changed_work);
+	sysfs_remove_link(&psy->dev->kobj, "powers");
 	power_supply_remove_triggers(psy);
 	device_unregister(psy->dev);
 }
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 040a7b0..2e3c827 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -218,6 +218,7 @@ static inline int power_supply_is_system_supplied(void) { return -ENOSYS; }
 extern int power_supply_register(struct device *parent,
 				 struct power_supply *psy);
 extern void power_supply_unregister(struct power_supply *psy);
+extern int power_supply_powers(struct power_supply *psy, struct device *dev);
 
 /* For APM emulation, think legacy userspace. */
 extern struct class *power_supply_class;
-- 
1.7.7.3

