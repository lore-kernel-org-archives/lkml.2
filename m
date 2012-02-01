Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2BAOtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:49:42 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52323 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2BAOtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:49:40 -0500
Date: Wed, 1 Feb 2012 14:49:31 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [RFC PATCH 1/2] thermal: Add a new trip type to use cooling
 device instance number
Message-ID: <20120201144931.GC30184@srcf.ucam.org>
References: <1323789196-4942-1-git-send-email-amit.kachhap@linaro.org>
 <1323789196-4942-2-git-send-email-amit.kachhap@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323789196-4942-2-git-send-email-amit.kachhap@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not really a fan of this as it stands - the name isn't very 
intuitive and the code's pretty difficult to read. Would the following 
(incomplete and obviously untested) not have the effect you want? Then 
you register multiple trip points with the same cooling device but 
different private values, and the state set does whatever you want it 
to. Or am I misunderstanding the problem you're trying to solve?

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 220ce7e..817f2ba 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -50,6 +50,7 @@ struct thermal_cooling_device_instance {
 	char attr_name[THERMAL_NAME_LENGTH];
 	struct device_attribute attr;
 	struct list_head node;
+	unsigned long private;
 };
 
 static DEFINE_IDR(thermal_tz_idr);
@@ -909,7 +910,8 @@ static struct class thermal_class = {
  * @ops:		standard thermal cooling devices callbacks.
  */
 struct thermal_cooling_device *thermal_cooling_device_register(
-     char *type, void *devdata, const struct thermal_cooling_device_ops *ops)
+	char *type, void *devdata, const struct thermal_cooling_device_ops *ops,
+	unsigned long private)
 {
 	struct thermal_cooling_device *cdev;
 	struct thermal_zone_device *pos;
@@ -936,6 +938,7 @@ struct thermal_cooling_device *thermal_cooling_device_register(
 	cdev->ops = ops;
 	cdev->device.class = &thermal_class;
 	cdev->devdata = devdata;
+	cdev->private = private;
 	dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
 	result = device_register(&cdev->device);
 	if (result) {
@@ -1079,11 +1082,14 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 					continue;
 
 				cdev = instance->cdev;
-
-				if (temp >= trip_temp)
-					cdev->ops->set_cur_state(cdev, 1);
-				else
-					cdev->ops->set_cur_state(cdev, 0);
+				if (cdev->private) {
+					cdev->ops->set_cur_state(cdev, cdev->private);
+				} else {
+					if (temp >= trip_temp)
+						cdev->ops->set_cur_state(cdev, 1);
+					else
+						cdev->ops->set_cur_state(cdev, 0);
+				}
 			}
 			break;
 		case THERMAL_TRIP_PASSIVE:
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 796f1ff..04aac09 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -148,7 +148,7 @@ int thermal_zone_unbind_cooling_device(struct thermal_zone_device *, int,
 				       struct thermal_cooling_device *);
 void thermal_zone_device_update(struct thermal_zone_device *);
 struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
-		const struct thermal_cooling_device_ops *);
+		     const struct thermal_cooling_device_ops *, unsigned long private);
 void thermal_cooling_device_unregister(struct thermal_cooling_device *);
 
 #ifdef CONFIG_NET


-- 
Matthew Garrett | mjg59@srcf.ucam.org
