Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab2DDVsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:48:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47146 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158Ab2DDVsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:48:46 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 5/6] regmap: add runtime PM calls to debugfs file IO
Date: Wed,  4 Apr 2012 15:48:32 -0600
Message-Id: <1333576113-13196-5-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
References: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

It's quite probably that devices need to be active in order for their
registers to be read/written. In normal regmap usage by drivers, it's the
responsibility of the driver to assure this if needed. However, regmap
debugfs file handling is outside the driver's control, so we need to
explicitly ensure this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap-debugfs.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index df97c93..7a18fdb 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -15,6 +15,7 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/device.h>
+#include <linux/pm_runtime.h>
 
 #include "internal.h"
 
@@ -80,6 +81,8 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 	val_len = 2 * map->format.val_bytes;
 	tot_len = reg_len + val_len + 3;      /* : \n */
 
+	pm_runtime_get(map->dev);
+
 	for (i = 0; i < map->max_register + 1; i++) {
 		if (!regmap_readable(map, i))
 			continue;
@@ -112,6 +115,8 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 		p += tot_len;
 	}
 
+	pm_runtime_put(map->dev);
+
 	ret = buf_pos;
 
 	if (copy_to_user(user_buf, buf, buf_pos)) {
@@ -160,7 +165,9 @@ static ssize_t regmap_map_write_file(struct file *file,
 	/* Userspace has been fiddling around behind the kernel's back */
 	add_taint(TAINT_USER);
 
+	pm_runtime_get(map->dev);
 	regmap_write(map, reg, value);
+	pm_runtime_put(map->dev);
 	return buf_size;
 }
 #else
-- 
1.7.0.4

