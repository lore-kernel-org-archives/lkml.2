Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2IHX0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 19:26:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63717 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2IHX0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 19:26:10 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 5/5] driver core: implement asynchorous probe() inside driver_register
Date: Sun,  9 Sep 2012 07:25:20 +0800
Message-Id: <1347146720-28596-6-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
References: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/driver.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 9365076..67fb63c 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/async.h>
 #include "base.h"
 
 static struct device *next_device(struct klist_iter *i)
@@ -153,6 +154,13 @@ static void driver_remove_groups(struct device_driver *drv,
 			sysfs_remove_group(&drv->p->kobj, groups[i]);
 }
 
+static void async_driver_attach(void *data, async_cookie_t cookie)
+{
+	struct device_driver *drv = data;
+
+	driver_attach(drv);
+}
+
 /**
  * driver_register - register driver with bus
  * @drv: driver to register
@@ -193,8 +201,12 @@ int __driver_register(struct device_driver *drv, int sync)
 	kobject_uevent(&drv->p->kobj, KOBJ_ADD);
 
 	/* driver probe at the last minute */
-	if (drv->bus->p->drivers_autoprobe)
-		ret = driver_attach(drv);
+	if (drv->bus->p->drivers_autoprobe) {
+		if (sync)
+			ret = driver_attach(drv);
+		else
+			async_schedule(async_driver_attach, drv);
+	}
 
 	return ret;
 }
-- 
1.7.9.5

