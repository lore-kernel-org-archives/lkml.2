Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab0JVSZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:25:37 -0400
Received: from kroah.org ([198.145.64.141]:37781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758934Ab0JVSZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/31] base/platform: Safe handling for NULL platform data and resources
Date: Fri, 22 Oct 2010 11:24:55 -0700
Message-Id: <1287771916-15016-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <cbouatmailru@gmail.com>

Some users of platform_device_add_{data,resources}() assume that
NULL data and resources will be handled specially, i.e. just ignored.

But the platform core ends up calling kmemdup(NULL, 0, ...), which
returns a non-NULL result (i.e. ZERO_SIZE_PTR), which causes drivers
to oops on a valid code, something like:

  if (platform_data)
  	stuff = platform_data->stuff;

This patch makes the platform core a bit more safe for such cases.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index a01abf9..c794fec 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -192,6 +192,9 @@ int platform_device_add_resources(struct platform_device *pdev,
 {
 	struct resource *r;
 
+	if (!res)
+		return 0;
+
 	r = kmemdup(res, sizeof(struct resource) * num, GFP_KERNEL);
 	if (r) {
 		pdev->resource = r;
@@ -215,8 +218,12 @@ EXPORT_SYMBOL_GPL(platform_device_add_resources);
 int platform_device_add_data(struct platform_device *pdev, const void *data,
 			     size_t size)
 {
-	void *d = kmemdup(data, size, GFP_KERNEL);
+	void *d;
+
+	if (!data)
+		return 0;
 
+	d = kmemdup(data, size, GFP_KERNEL);
 	if (d) {
 		pdev->dev.platform_data = d;
 		return 0;
-- 
1.7.2

