Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab1CLWdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:33:07 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54903 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab1CLWca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:32:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=YMwaIu5a0Bi5kXsiAI3bkZVP6OmDF6W1YHqzWfIgdC3p6Pw+pZym1d9eqFbrQF+wnk
         K+gemZ7eG9JwUPkJ4BWyCp6h/19rW4gsQOWdD0tUvpyI56XuljNvgWAzotpi1fPp9+12
         l+QNgZHWBoN/c4hV9jDwtsXH3oZbGApgALRns=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 3/4] PLATFORM: Introduce async platform_data attach api
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: patches@linaro.org, Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:32:27 +0000
Message-ID: <20110312223227.27020.83925.stgit@otae.warmcat.com>
In-Reply-To: <20110312222633.27020.19543.stgit@otae.warmcat.com>
References: <20110312222633.27020.19543.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces a platform API so busses can allow platform_data to
be attached to any struct device they create from probing in one step.

The function checks through the async platform_data map if one was
previously registered, and checks the device's device path for itself
and its parents against the mapped device path names.

If it sees a match, it attaches the associated platform_data and sets
that map entry's device_path to NULL so no further time is spent trying
to match it.

Signed-off-by: Andy Green <andy.green@linaro.org>
---

 drivers/base/platform.c         |   70 +++++++++++++++++++++++++++++++++++++++
 include/linux/platform_device.h |    2 +
 2 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 180e372..534bf3a 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -1353,3 +1353,73 @@ void platform_async_platform_data_register(
 	platform_async_platform_data_count = count;
 }
 EXPORT_SYMBOL_GPL(platform_async_platform_data_register);
+
+/**
+ * platform_async_platform_data_attach - if there is any async devname map
+ *			defined, go through it looking for a match with the
+ *			device's path considering its parent device names.
+ *			If a match is found, attach the corresponding
+ *			platform_data and the entry in the map table set to
+ *			NULL so it won't be looked for again.
+ *
+ * @dev:	device to have data attched to if it matches any map entry
+ */
+void platform_async_platform_data_attach(struct device *dev)
+{
+	struct platform_async_platform_data *map;
+	const char *path;
+	int count;
+	const char *p;
+	int len;
+	struct device *devn;
+
+	map = platform_async_platform_data_map;
+	count = platform_async_platform_data_count;
+
+	while (count--) {
+
+		if (map->device_path == NULL) {
+			map++;
+			continue;
+		}
+
+		p = map->device_path + strlen(map->device_path);
+		devn = dev;
+
+		while (devn) {
+
+			path = dev_name(devn);
+			len = strlen(path);
+
+			if ((p - map->device_path) < len) {
+				devn = NULL;
+				continue;
+			}
+
+			p -= len;
+
+			if (strncmp(path, p, len)) {
+				devn = NULL;
+				continue;
+			}
+
+			devn = devn->parent;
+			if (p == map->device_path) {
+				dev_info(dev, "Attched async platform data\n");
+				dev->platform_data = map->platform_data;
+				map->device_path = NULL;
+				return;
+			}
+
+			if (devn != NULL && (p - map->device_path) < 2)
+				devn = NULL;
+
+			p--;
+			if (devn != NULL && *p != '/')
+				devn = NULL;
+		}
+
+		map++;
+	}
+}
+EXPORT_SYMBOL_GPL(platform_async_platform_data_attach);
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 19ea497..4b5fa12 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -213,4 +213,6 @@ struct platform_async_platform_data {
 extern void platform_async_platform_data_register(
 			   struct platform_async_platform_data *map, int count);
 
+extern void platform_async_platform_data_attach(struct device *dev);
+
 #endif /* _PLATFORM_DEVICE_H_ */

