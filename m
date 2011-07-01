Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab1GAJfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:35:31 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:37733 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1GAJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:35:27 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>, stable@kernel.org,
        Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS NOTEBOOKS
	AN...),
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 01/16] asus-wmi: fix hwmon/pwm1
Date: Fri,  1 Jul 2011 11:34:26 +0200
Message-Id: <1309512881-2901-2-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code was completly broken, and should never had been sent
to the kernel. That's what happens when you write code without
hardware to test it.

Cc: stable@kernel.org
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 00460cb..d1ddb4a 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -797,8 +797,8 @@ exit:
  * Hwmon device
  */
 static ssize_t asus_hwmon_pwm1(struct device *dev,
-			    struct device_attribute *attr,
-			    char *buf)
+			       struct device_attribute *attr,
+			       char *buf)
 {
 	struct asus_wmi *asus = dev_get_drvdata(dev);
 	u32 value;
@@ -809,7 +809,7 @@ static ssize_t asus_hwmon_pwm1(struct device *dev,
 	if (err < 0)
 		return err;
 
-	value |= 0xFF;
+	value &= 0xFF;
 
 	if (value == 1) /* Low Speed */
 		value = 85;
@@ -869,7 +869,7 @@ static mode_t asus_hwmon_sysfs_is_visible(struct kobject *kobj,
 		 * - reverved bits are non-zero
 		 * - sfun and presence bit are not set
 		 */
-		if (value != ASUS_WMI_UNSUPPORTED_METHOD || value & 0xFFF80000
+		if (value == ASUS_WMI_UNSUPPORTED_METHOD || value & 0xFFF80000
 		    || (!asus->sfun && !(value & ASUS_WMI_DSTS_PRESENCE_BIT)))
 			ok = false;
 	}
@@ -904,6 +904,7 @@ static int asus_wmi_hwmon_init(struct asus_wmi *asus)
 		pr_err("Could not register asus hwmon device\n");
 		return PTR_ERR(hwmon);
 	}
+	dev_set_drvdata(hwmon, asus);
 	asus->hwmon_device = hwmon;
 	result = sysfs_create_group(&hwmon->kobj, &hwmon_attribute_group);
 	if (result)
-- 
1.7.3.4

