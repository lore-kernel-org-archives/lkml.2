Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1H0NYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 09:24:45 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:42917 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836Ab1H0NYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 09:24:43 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-10.arcor-online.net 19D2E2D6714
Subject: [PATCH 2/5] HID: roccat: Pyra now reports external profile changes
 via roccat device
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Aug 2011 15:24:41 +0200
Message-ID: <1314451481.24216.73.camel@neuromancer.tessier-ashpool>
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
 drivers/hid/hid-roccat-pyra.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 8140776b..df05c1b 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -298,6 +298,7 @@ static ssize_t pyra_sysfs_write_settings(struct file *fp,
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int retval = 0;
 	int difference;
+	struct pyra_roccat_report roccat_report;
 
 	if (off != 0 || count != sizeof(struct pyra_settings))
 		return -EINVAL;
@@ -307,17 +308,23 @@ static ssize_t pyra_sysfs_write_settings(struct file *fp,
 	if (difference) {
 		retval = pyra_set_settings(usb_dev,
 				(struct pyra_settings const *)buf);
-		if (!retval)
-			memcpy(&pyra->settings, buf,
-					sizeof(struct pyra_settings));
-	}
-	mutex_unlock(&pyra->pyra_lock);
+		if (retval) {
+			mutex_unlock(&pyra->pyra_lock);
+			return retval;
+		}
 
-	if (retval)
-		return retval;
+		memcpy(&pyra->settings, buf,
+				sizeof(struct pyra_settings));
 
-	profile_activated(pyra, pyra->settings.startup_profile);
+		profile_activated(pyra, pyra->settings.startup_profile);
 
+		roccat_report.type = PYRA_MOUSE_EVENT_BUTTON_TYPE_PROFILE_2;
+		roccat_report.value = pyra->settings.startup_profile + 1;
+		roccat_report.key = 0;
+		roccat_report_event(pyra->chrdev_minor,
+				(uint8_t const *)&roccat_report);
+	}
+	mutex_unlock(&pyra->pyra_lock);
 	return sizeof(struct pyra_settings);
 }
 
-- 
1.7.3.4



