Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1FTFqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:46:51 -0400
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211]:40235
	"EHLO QMTA11.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254Ab1FTFph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:37 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/22] staging: usbip: userspace: utils.c: rewrite modify_match_busid
Date: Sun, 19 Jun 2011 22:44:41 -0700
Message-Id: <223467f4b1b6c2cfe9309929b63ce7df05f16b5e.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the function to use libsysfs.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/utils.c |   68 ++++++++++++++++-----------
 1 files changed, 40 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
index 9b31c78..2d4966e 100644
--- a/drivers/staging/usbip/userspace/src/utils.c
+++ b/drivers/staging/usbip/userspace/src/utils.c
@@ -1,64 +1,76 @@
 /*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
  *
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
 #include <sysfs/libsysfs.h>
 
-#include <limits.h>
 #include <errno.h>
 #include <stdio.h>
 #include <string.h>
 
-#include <fcntl.h>
-#include <libgen.h>
-#include <unistd.h>
-
 #include "usbip_common.h"
 #include "utils.h"
 
 int modify_match_busid(char *busid, int add)
 {
-	int fd;
-	int ret;
+	char bus_type[] = "usb";
+	char attr_name[] = "match_busid";
 	char buff[SYSFS_BUS_ID_SIZE + 4];
 	char sysfs_mntpath[SYSFS_PATH_MAX];
-	char match_busid_path[SYSFS_PATH_MAX];
+	char match_busid_attr_path[SYSFS_PATH_MAX];
+	struct sysfs_attribute *match_busid_attr;
+	int rc, ret = 0;
 
-	ret = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
-	if (ret < 0) {
-		err("sysfs must be mounted");
+	if (strnlen(busid, SYSFS_BUS_ID_SIZE) > SYSFS_BUS_ID_SIZE - 1) {
+		dbg("busid is too long");
 		return -1;
 	}
 
-	snprintf(match_busid_path, sizeof(match_busid_path),
-		 "%s/%s/usb/%s/%s/match_busid", sysfs_mntpath, SYSFS_BUS_NAME,
-		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME);
-
-	/* BUS_IS_SIZE includes NULL termination? */
-	if (strnlen(busid, SYSFS_BUS_ID_SIZE) > SYSFS_BUS_ID_SIZE - 1) {
-		dbg("busid is too long");
+	rc = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
+	if (rc < 0) {
+		err("sysfs must be mounted: %s", strerror(errno));
 		return -1;
 	}
 
-	fd = open(match_busid_path, O_WRONLY);
-	if (fd < 0)
+	snprintf(match_busid_attr_path, sizeof(match_busid_attr_path),
+		 "%s/%s/%s/%s/%s/%s", sysfs_mntpath, SYSFS_BUS_NAME, bus_type,
+		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME, attr_name);
+
+	match_busid_attr = sysfs_open_attribute(match_busid_attr_path);
+	if (!match_busid_attr) {
+		dbg("problem getting match_busid attribute: %s",
+		    strerror(errno));
 		return -1;
+	}
 
 	if (add)
 		snprintf(buff, SYSFS_BUS_ID_SIZE + 4, "add %s", busid);
 	else
 		snprintf(buff, SYSFS_BUS_ID_SIZE + 4, "del %s", busid);
 
-	dbg("write \"%s\" to %s", buff, match_busid_path);
+	dbg("write \"%s\" to %s", buff, match_busid_attr->path);
 
-	ret = write(fd, buff, sizeof(buff));
-	if (ret < 0) {
-		close(fd);
-		return -1;
+	rc = sysfs_write_attribute(match_busid_attr, buff, sizeof(buff));
+	if (rc < 0) {
+		dbg("failed to write match_busid: %s", strerror(errno));
+		ret = -1;
 	}
 
-	close(fd);
+	sysfs_close_attribute(match_busid_attr);
 
-	return 0;
+	return ret;
 }
-- 
1.7.5.2

