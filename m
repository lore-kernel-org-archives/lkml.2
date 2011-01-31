Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1AaQbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:31:16 -0500
Received: from kroah.org ([198.145.64.141]:46368 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab1AaQbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:31:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] tty: use for_each_console() and WARN() on sysfs failures
Date: Mon, 31 Jan 2011 08:31:07 -0800
Message-Id: <1296491470-23096-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110131162852.GA22875@kroah.com>
References: <20110131162852.GA22875@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This fixes the build warnings in the tty code, and uses the proper
function for iterating over the console devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_io.c |    4 ++--
 drivers/tty/vt/vt.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 464d09d..dae6fc9 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3257,7 +3257,7 @@ static ssize_t show_cons_active(struct device *dev,
 	ssize_t count = 0;
 
 	acquire_console_sem();
-	for (c = console_drivers; c; c = c->next) {
+	for_each_console(c) {
 		if (!c->device)
 			continue;
 		if (!c->write)
@@ -3306,7 +3306,7 @@ int __init tty_init(void)
 	if (IS_ERR(consdev))
 		consdev = NULL;
 	else
-		device_create_file(consdev, &dev_attr_active);
+		WARN_ON(device_create_file(consdev, &dev_attr_active) < 0);
 
 #ifdef CONFIG_VT
 	vty_init(&console_fops);
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 4f6ae05..9550618 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2994,7 +2994,7 @@ int __init vty_init(const struct file_operations *console_fops)
 	if (IS_ERR(tty0dev))
 		tty0dev = NULL;
 	else
-		device_create_file(tty0dev, &dev_attr_active);
+		WARN_ON(device_create_file(tty0dev, &dev_attr_active) < 0);
 
 	vcs_init();
 
-- 
1.7.1

