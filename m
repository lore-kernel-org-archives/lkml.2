Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1HQORx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:17:53 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:34635 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab1HQORu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:17:50 -0400
From: David Wagner <david.wagner@free-electrons.com>
To: linux-mtd <linux-mtd@lists.infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Wagner <david.wagner@free-electrons.com>
Subject: [PATCH] Tools for controling ubiblk
Date: Wed, 17 Aug 2011 16:20:47 +0200
Message-Id: <1313590847-3839-1-git-send-email-david.wagner@free-electrons.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1313587042-30846-1-git-send-email-david.wagner@free-electrons.com>
References: <1313587042-30846-1-git-send-email-david.wagner@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ubiblk_ctrl sends an appropriate ioctl to ubiblk control node.

ubiblkadd and ubiblkdel are wrappers around ubiblk_ctrl.
The syntax is:
	ubiblk{add,del} x y
where x is the UBI device number and y the volume ID.

Signed-off-by: David Wagner <david.wagner@free-electrons.com>
---

This is a preliminary version: it has the control device node hardcoded which is
probably not nice.

 Makefile                  |    6 ++-
 include/mtd/ubiblk-user.h |   43 ++++++++++++++++++++
 ubi-utils/ubiblk_ctrl.c   |   95 +++++++++++++++++++++++++++++++++++++++++++++
 ubi-utils/ubiblkadd       |    2 +
 ubi-utils/ubiblkdel       |    2 +
 5 files changed, 147 insertions(+), 1 deletions(-)
 create mode 100644 include/mtd/ubiblk-user.h
 create mode 100644 ubi-utils/ubiblk_ctrl.c
 create mode 100755 ubi-utils/ubiblkadd
 create mode 100755 ubi-utils/ubiblkdel

diff --git a/Makefile b/Makefile
index 67e42ce..2859a8c 100644
--- a/Makefile
+++ b/Makefile
@@ -27,12 +27,16 @@ MTD_BINS = \
 	sumtool #jffs2reader
 UBI_BINS = \
 	ubiupdatevol ubimkvol ubirmvol ubicrc32 ubinfo ubiattach \
-	ubidetach ubinize ubiformat ubirename mtdinfo ubirsvol
+	ubidetach ubinize ubiformat ubirename mtdinfo ubirsvol \
+	ubiblk_ctrl
+UBI_SCRIPTS = \
+	ubiblkadd ubiblkdel
 
 BINS = $(MTD_BINS)
 BINS += mkfs.ubifs/mkfs.ubifs
 BINS += $(addprefix ubi-utils/,$(UBI_BINS))
 SCRIPTS = flash_eraseall
+SCRIPTS += $(addprefix ubi-utils/,$(UBI_SCRIPTS))
 
 TARGETS = $(BINS)
 TARGETS += lib/libmtd.a
diff --git a/include/mtd/ubiblk-user.h b/include/mtd/ubiblk-user.h
new file mode 100644
index 0000000..fa0d007
--- /dev/null
+++ b/include/mtd/ubiblk-user.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright © Free Electrons, 2011
+ * Copyright © International Business Machines Corp., 2006
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Author: David Wagner
+ * Some code taken from ubi-user.h
+ */
+
+#ifndef __UBIBLK_USER_H__
+#define __UBIBLK_USER_H__
+
+#include <linux/types.h>
+
+/* Structure to be passed to UBIBLK_IOCADD or IOCDEL ioctl */
+struct ubiblk_ctrl_req {
+	__s32 ubi_num;
+	__s32 vol_id;
+};
+
+/* ioctl commands of the UBI control character device */
+
+#define UBIBLK_CTRL_IOC_MAGIC 'O'
+
+/* Create a ubiblk device from a UBI volume */
+#define UBIBLK_IOCADD _IOW(UBIBLK_CTRL_IOC_MAGIC, 0x10, struct ubiblk_ctrl_req)
+/* Delete a ubiblk device */
+#define UBIBLK_IOCDEL _IOW(UBIBLK_CTRL_IOC_MAGIC, 0x11, struct ubiblk_ctrl_req)
+
+#endif
diff --git a/ubi-utils/ubiblk_ctrl.c b/ubi-utils/ubiblk_ctrl.c
new file mode 100644
index 0000000..1132f35
--- /dev/null
+++ b/ubi-utils/ubiblk_ctrl.c
@@ -0,0 +1,95 @@
+/*
+ * Copyright (c) Free Electrons, 2011
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ * Author: David Wagner
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <mtd/ubiblk-user.h>
+
+#define CONTROL_NODE "/dev/ubiblk_ctrl"
+
+void usage(char *exec_path)
+{
+	fprintf(stderr, "%s <-a|-d> <-u UBI_DEVICE_NUMBER> <-v VOLUME_ID>\n",
+			basename(exec_path));
+}
+
+int main(int argc, char *argv[])
+{
+	int ubi_num = -2, vol_id = -1;
+	int fd;
+	struct ubiblk_ctrl_req req;
+	int ret;
+	int command;
+
+	int option;
+
+	while ((option = getopt(argc, argv, "adu:v:")) != -1) {
+		switch (option) {
+		case 'a':
+			command = UBIBLK_IOCADD;
+			break;
+		case 'd':
+			command = UBIBLK_IOCDEL;
+			break;
+		case 'u':
+			ubi_num = atoi(optarg);
+			break;
+		case 'v':
+			vol_id = atoi(optarg);
+			break;
+		}
+	}
+	
+	if (command != UBIBLK_IOCDEL && command != UBIBLK_IOCADD) {
+		usage(argv[0]);
+		return EXIT_FAILURE;
+	}
+	if (vol_id == -1 || vol_id == -1) {
+		usage(argv[0]);
+		return EXIT_FAILURE;
+	}
+	
+	req.ubi_num = ubi_num;
+	req.vol_id = vol_id;
+
+	fd = open(CONTROL_NODE, O_RDONLY);
+	if (fd == -1) {
+		fprintf(stderr, "Error while opening the control node: %s\n",
+				strerror(errno));
+		return EXIT_FAILURE;
+	}	
+
+	ret = ioctl(fd, command, &req);
+	if (ret == -1) {
+		fprintf(stderr, "Error while ioctl: %s\n", strerror(errno));
+		close(fd);
+		return EXIT_FAILURE;
+	}
+	close(fd);
+	return EXIT_SUCCESS;
+}
diff --git a/ubi-utils/ubiblkadd b/ubi-utils/ubiblkadd
new file mode 100755
index 0000000..fd8fbdd
--- /dev/null
+++ b/ubi-utils/ubiblkadd
@@ -0,0 +1,2 @@
+#! /bin/sh
+ubiblk_ctrl -a -u $0 -v $1
diff --git a/ubi-utils/ubiblkdel b/ubi-utils/ubiblkdel
new file mode 100755
index 0000000..40a1fd1
--- /dev/null
+++ b/ubi-utils/ubiblkdel
@@ -0,0 +1,2 @@
+#! /bin/sh
+ubiblk_ctrl -d -u $0 -v $1
-- 
1.7.0.4

