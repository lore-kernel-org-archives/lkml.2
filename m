Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1H0NYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 09:24:51 -0400
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:38488 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab1H0NYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 09:24:48 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-10.arcor-online.net 8BBCB2D6724
Subject: [PATCH 3/5] HID: roccat: Kovaplus now reports external profile
 changes via roccat device
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Aug 2011 15:24:45 +0200
Message-ID: <1314451485.24216.74.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Profile changes were only reported when issued mouse internal. Now all
changes are reported.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kovaplus.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 1f8336e..112d934 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -323,6 +323,7 @@ static ssize_t kovaplus_sysfs_set_actual_profile(struct device *dev,
 	struct usb_device *usb_dev;
 	unsigned long profile;
 	int retval;
+	struct kovaplus_roccat_report roccat_report;
 
 	dev = dev->parent->parent;
 	kovaplus = hid_get_drvdata(dev_get_drvdata(dev));
@@ -337,10 +338,22 @@ static ssize_t kovaplus_sysfs_set_actual_profile(struct device *dev,
 
 	mutex_lock(&kovaplus->kovaplus_lock);
 	retval = kovaplus_set_actual_profile(usb_dev, profile);
+	if (retval) {
+		mutex_unlock(&kovaplus->kovaplus_lock);
+		return retval;
+	}
+
 	kovaplus_profile_activated(kovaplus, profile);
+
+	roccat_report.type = KOVAPLUS_MOUSE_REPORT_BUTTON_TYPE_PROFILE_1;
+	roccat_report.profile = profile + 1;
+	roccat_report.button = 0;
+	roccat_report.data1 = profile + 1;
+	roccat_report.data2 = 0;
+	roccat_report_event(kovaplus->chrdev_minor,
+			(uint8_t const *)&roccat_report);
+
 	mutex_unlock(&kovaplus->kovaplus_lock);
-	if (retval)
-		return retval;
 
 	return size;
 }
-- 
1.7.3.4



