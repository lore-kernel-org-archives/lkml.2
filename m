Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab1E0Ioq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 04:44:46 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:48714
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758682Ab1E0Ioo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 04:44:44 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: usbip-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] staging: usbip: change the busid size
Date: Fri, 27 May 2011 01:44:12 -0700
Message-Id: <e7709711985d6b7818b7ada55628bdb32fef8e33.1306485772.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <ec9a733eb388e3057d46ca451448e23ca24bd7e9.1306485772.git.mfm@muteddisk.com>
References: <ec9a733eb388e3057d46ca451448e23ca24bd7e9.1306485772.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change busid size to correspond with SYSFS_BUS_ID_SIZE, which was
already being used in most cases. This eliminates the need to define
BUS_ID_SIZE in the userspace code.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub.h                     |    3 ++-
 drivers/staging/usbip/userspace/src/usbip_bind.c |   14 ++++++++------
 drivers/staging/usbip/userspace/src/utils.c      |    8 ++++----
 drivers/staging/usbip/userspace/src/utils.h      |    3 ---
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/usbip/stub.h b/drivers/staging/usbip/stub.h
index 2cc596e..132adc5 100644
--- a/drivers/staging/usbip/stub.h
+++ b/drivers/staging/usbip/stub.h
@@ -76,7 +76,8 @@ struct stub_unlink {
 	__u32 status;
 };
 
-#define BUSID_SIZE 20
+/* same as SYSFS_BUS_ID_SIZE */
+#define BUSID_SIZE 32
 
 struct bus_id_priv {
 	char name[BUSID_SIZE];
diff --git a/drivers/staging/usbip/userspace/src/usbip_bind.c b/drivers/staging/usbip/userspace/src/usbip_bind.c
index 9869db2..978b7aa 100644
--- a/drivers/staging/usbip/userspace/src/usbip_bind.c
+++ b/drivers/staging/usbip/userspace/src/usbip_bind.c
@@ -57,7 +57,7 @@ static int unbind_interface_busid(char *busid)
 		return -1;
 	}
 
-	ret = write(fd, busid, strnlen(busid, BUS_ID_SIZE));
+	ret = write(fd, busid, strnlen(busid, SYSFS_BUS_ID_SIZE));
 	if (ret < 0) {
 		dbg("write to unbind_path failed: %d", ret);
 		close(fd);
@@ -71,10 +71,11 @@ static int unbind_interface_busid(char *busid)
 
 static int unbind_interface(char *busid, int configvalue, int interface)
 {
-	char inf_busid[BUS_ID_SIZE];
+	char inf_busid[SYSFS_BUS_ID_SIZE];
 	dbg("unbinding interface");
 
-	snprintf(inf_busid, BUS_ID_SIZE, "%s:%d.%d", busid, configvalue, interface);
+	snprintf(inf_busid, SYSFS_BUS_ID_SIZE, "%s:%d.%d", busid, configvalue,
+		 interface);
 
 	return unbind_interface_busid(inf_busid);
 }
@@ -148,7 +149,7 @@ static int bind_interface_busid(char *busid, char *driver)
 	if (fd < 0)
 		return -1;
 
-	ret = write(fd, busid, strnlen(busid, BUS_ID_SIZE));
+	ret = write(fd, busid, strnlen(busid, SYSFS_BUS_ID_SIZE));
 	if (ret < 0) {
 		close(fd);
 		return -1;
@@ -161,9 +162,10 @@ static int bind_interface_busid(char *busid, char *driver)
 
 static int bind_interface(char *busid, int configvalue, int interface, char *driver)
 {
-	char inf_busid[BUS_ID_SIZE];
+	char inf_busid[SYSFS_BUS_ID_SIZE];
 
-	snprintf(inf_busid, BUS_ID_SIZE, "%s:%d.%d", busid, configvalue, interface);
+	snprintf(inf_busid, SYSFS_BUS_ID_SIZE, "%s:%d.%d", busid, configvalue,
+		 interface);
 
 	return bind_interface_busid(inf_busid, driver);
 }
diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
index 6dbfdbd..1da1109 100644
--- a/drivers/staging/usbip/userspace/src/utils.c
+++ b/drivers/staging/usbip/userspace/src/utils.c
@@ -20,7 +20,7 @@ int modify_match_busid(char *busid, int add)
 {
 	int fd;
 	int ret;
-	char buff[BUS_ID_SIZE + 4];
+	char buff[SYSFS_BUS_ID_SIZE + 4];
 	char sysfs_mntpath[SYSFS_PATH_MAX];
 	char match_busid_path[SYSFS_PATH_MAX];
 
@@ -35,7 +35,7 @@ int modify_match_busid(char *busid, int add)
 		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME);
 
 	/* BUS_IS_SIZE includes NULL termination? */
-	if (strnlen(busid, BUS_ID_SIZE) > BUS_ID_SIZE - 1) {
+	if (strnlen(busid, SYSFS_BUS_ID_SIZE) > SYSFS_BUS_ID_SIZE - 1) {
 		dbg("busid is too long");
 		return -1;
 	}
@@ -45,9 +45,9 @@ int modify_match_busid(char *busid, int add)
 		return -1;
 
 	if (add)
-		snprintf(buff, BUS_ID_SIZE + 4, "add %s", busid);
+		snprintf(buff, SYSFS_BUS_ID_SIZE + 4, "add %s", busid);
 	else
-		snprintf(buff, BUS_ID_SIZE + 4, "del %s", busid);
+		snprintf(buff, SYSFS_BUS_ID_SIZE + 4, "del %s", busid);
 
 	dbg("write \"%s\" to %s", buff, match_busid_path);
 
diff --git a/drivers/staging/usbip/userspace/src/utils.h b/drivers/staging/usbip/userspace/src/utils.h
index 36ee8d5..b50e95a 100644
--- a/drivers/staging/usbip/userspace/src/utils.h
+++ b/drivers/staging/usbip/userspace/src/utils.h
@@ -3,9 +3,6 @@
 
 #include <stdlib.h>
 
-/* Be sync to kernel header */
-#define BUS_ID_SIZE 20
-
 int modify_match_busid(char *busid, int add);
 int read_string(char *path, char *, size_t len);
 int read_integer(char *path);
-- 
1.7.5.1

