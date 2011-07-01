Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1GAJiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:38:01 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:38988 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab1GAJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:35:30 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS NOTEBOOKS
	AN...),
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 12/16] asus-wmi: check for temp1 presence
Date: Fri,  1 Jul 2011 11:34:37 +0200
Message-Id: <1309512881-2901-13-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index cc947cc..be9e89a 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -967,7 +967,7 @@ static struct attribute *hwmon_attributes[] = {
 };
 
 static mode_t asus_hwmon_sysfs_is_visible(struct kobject *kobj,
-				    struct attribute *attr, int idx)
+					  struct attribute *attr, int idx)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct platform_device *pdev = to_platform_device(dev->parent);
@@ -978,6 +978,8 @@ static mode_t asus_hwmon_sysfs_is_visible(struct kobject *kobj,
 
 	if (attr == &sensor_dev_attr_pwm1.dev_attr.attr)
 		dev_id = ASUS_WMI_DEVID_FAN_CTRL;
+	else if (attr == &sensor_dev_attr_temp1_input.dev_attr.attr)
+		dev_id = ASUS_WMI_DEVID_THERMAL_CTRL;
 
 	if (dev_id != -1) {
 		int err = asus_wmi_get_devstate(asus, dev_id, &value);
@@ -998,6 +1000,10 @@ static mode_t asus_hwmon_sysfs_is_visible(struct kobject *kobj,
 		if (value == ASUS_WMI_UNSUPPORTED_METHOD || value & 0xFFF80000
 		    || (!asus->sfun && !(value & ASUS_WMI_DSTS_PRESENCE_BIT)))
 			ok = false;
+	} else if (dev_id == ASUS_WMI_DEVID_THERMAL_CTRL) {
+		/* If value is zero, something is clearly wrong */
+		if (value == 0)
+			ok = false;
 	}
 
 	return ok ? attr->mode : 0;
-- 
1.7.3.4

