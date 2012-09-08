Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2IHX0d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 19:26:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63717 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab2IHXZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 19:25:41 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH 1/5] driver core: driver probe at the last minute in driver_register
Date: Sun,  9 Sep 2012 07:25:16 +0800
Message-Id: <1347146720-28596-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
References: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be correct to probe driver at the last minute in
driver_register since it will be so in !auto_probe case and
driver_register on no matched devices case.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/bus.c    |    5 -----
 drivers/base/driver.c |    4 ++++
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 181ed26..00d841d 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -714,11 +714,6 @@ int bus_add_driver(struct device_driver *drv)
 	if (error)
 		goto out_unregister;
 
-	if (drv->bus->p->drivers_autoprobe) {
-		error = driver_attach(drv);
-		if (error)
-			goto out_unregister;
-	}
 	klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
 	module_add_driver(drv->owner, drv);
 
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 974e301..27f4c85 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -191,6 +191,10 @@ int driver_register(struct device_driver *drv)
 	}
 	kobject_uevent(&drv->p->kobj, KOBJ_ADD);
 
+	/* driver probe at the last minute */
+	if (drv->bus->p->drivers_autoprobe)
+		ret = driver_attach(drv);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(driver_register);
-- 
1.7.9.5

