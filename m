Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2HGUg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:36:28 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43704 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab2HGUg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:36:26 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, Colin Cross <ccross@android.com>
Subject: [PATCH v2] leds: triggers: send uevent when changing triggers
Date: Tue,  7 Aug 2012 12:58:15 -0700
Message-Id: <1344369495-21943-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some triggers create sysfs files when they are enabled.  Send a uevent
"change" notification whenever the trigger is changed to allow userspace
processes such as udev to modify permissions on the new files.

A change notification will also be sent during registration of led class
devices or led triggers if the default trigger of an led class device
is found.

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

