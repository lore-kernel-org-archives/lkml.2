Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab2GYAc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 20:32:56 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:34040 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2GYAcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 20:32:54 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Colin Cross <ccross@android.com>, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Subject: [PATCH] leds: triggers: send uevent when changing triggers
Date: Tue, 24 Jul 2012 17:32:50 -0700
Message-Id: <1343176370-5856-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some triggers create sysfs files when they are enabled.  Send a uevent
"change" notification whenever the trigger is changed to allow userspace
processes such as udev to modify permissions on the new files.

Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/leds/led-triggers.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 46b4c76..a85ce09 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -102,6 +102,12 @@ ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr,
 void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 {
 	unsigned long flags;
+	char *event = NULL;
+	char *envp[2];
+	const char *name;
+
+	name = trigger ? trigger->name : "none";
+	event = kasprintf(GFP_KERNEL, "TRIGGER=%s", name);
 
 	/* Remove any existing trigger */
 	if (led_cdev->trigger) {
@@ -122,6 +128,13 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 		if (trigger->activate)
 			trigger->activate(led_cdev);
 	}
+
+	if (event) {
+		envp[0] = event;
+		envp[1] = NULL;
+		kobject_uevent_env(&led_cdev->dev->kobj, KOBJ_CHANGE, envp);
+		kfree(event);
+	}
 }
 EXPORT_SYMBOL_GPL(led_trigger_set);
 
-- 
1.7.7.3

