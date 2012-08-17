Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab2HQOIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:08:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab2HQOHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:07:45 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 3/3] firmware loader: fix build failure if FW_LOADER is m
Date: Fri, 17 Aug 2012 22:07:00 +0800
Message-Id: <1345212420-1707-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345212420-1707-1-git-send-email-ming.lei@canonical.com>
References: <1345212420-1707-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_cache_fw_images need to iterate devices in system,
so this patch applies the introduced dpm_for_each_dev to
avoid link failure if CONFIG_FW_LOADER is m.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 4c8d8ef..ed0510a 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -27,7 +27,6 @@
 #include <linux/suspend.h>
 
 #include "base.h"
-#include "power/power.h"
 
 MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
@@ -1093,7 +1092,7 @@ static int devm_name_match(struct device *dev, void *res,
 	return (fwn->magic == (unsigned long)match_data);
 }
 
-static void dev_cache_fw_image(struct device *dev)
+static void dev_cache_fw_image(struct device *dev, void *data)
 {
 	LIST_HEAD(todo);
 	struct fw_cache_entry *fce;
@@ -1148,7 +1147,6 @@ static void __device_uncache_fw_images(void)
 static void device_cache_fw_images(void)
 {
 	struct firmware_cache *fwc = &fw_cache;
-	struct device *dev;
 	int old_timeout;
 	DEFINE_WAIT(wait);
 
@@ -1165,10 +1163,7 @@ static void device_cache_fw_images(void)
 	old_timeout = loading_timeout;
 	loading_timeout = 10;
 
-	device_pm_lock();
-	list_for_each_entry(dev, &dpm_list, power.entry)
-		dev_cache_fw_image(dev);
-	device_pm_unlock();
+	dpm_for_each_dev(NULL, dev_cache_fw_image);
 
 	/* wait for completion of caching firmware for all devices */
 	spin_lock(&fwc->name_lock);
-- 
1.7.9.5

