Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab1FTFrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:47:42 -0400
Received: from qmta13.westchester.pa.mail.comcast.net ([76.96.59.243]:43381
	"EHLO qmta13.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021Ab1FTFpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:33 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/22] staging: usbip: userspace: utils: remove libsysfs circumvention
Date: Sun, 19 Jun 2011 22:44:40 -0700
Message-Id: <028050918e70a4fb0bb632e9dcc3b602b514f58d.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes all of the helper functions that used a lot of hard-coded
values intead of libsysfs. Most of these functions were unused
anyway.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/utils.c |  250 ---------------------------
 drivers/staging/usbip/userspace/src/utils.h |   31 ++--
 2 files changed, 18 insertions(+), 263 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
index 2a25cec..9b31c78 100644
--- a/drivers/staging/usbip/userspace/src/utils.c
+++ b/drivers/staging/usbip/userspace/src/utils.c
@@ -62,253 +62,3 @@ int modify_match_busid(char *busid, int add)
 
 	return 0;
 }
-
-int read_integer(char *path)
-{
-	char buff[100];
-	int fd;
-	int ret = 0;
-
-	memset(buff, 0, sizeof(buff));
-
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
-		return -1;
-
-	ret = read(fd, buff, sizeof(buff));
-	if (ret < 0) {
-		close(fd);
-		return -1;
-	}
-
-	sscanf(buff, "%d", &ret);
-
-	close(fd);
-
-	return ret;
-}
-
-int read_string(char *path, char *string, size_t len)
-{
-	int fd;
-	int ret = 0;
-	char  *p;
-
-	memset(string, 0, len);
-
-	fd = open(path, O_RDONLY);
-	if (fd < 0) {
-		string = NULL;
-		return -1;
-	}
-
-	ret = read(fd, string, len-1);
-	if (ret < 0) {
-		string = NULL;
-		close(fd);
-		return -1;
-	}
-
-	p = strchr(string, '\n');
-	*p = '\0';
-
-	close(fd);
-
-	return 0;
-}
-
-int write_integer(char *path, int value)
-{
-	int fd;
-	int ret;
-	char buff[100];
-
-	snprintf(buff, sizeof(buff), "%d", value);
-
-	fd = open(path, O_WRONLY);
-	if (fd < 0)
-		return -1;
-
-	ret = write(fd, buff, strlen(buff));
-	if (ret < 0) {
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-int read_bConfigurationValue(char *busid)
-{
-	char path[PATH_MAX];
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bConfigurationValue", busid);
-
-	return read_integer(path);
-}
-
-int write_bConfigurationValue(char *busid, int config)
-{
-	char path[PATH_MAX];
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bConfigurationValue", busid);
-
-	return write_integer(path, config);
-}
-
-int read_bNumInterfaces(char *busid)
-{
-	char path[PATH_MAX];
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bNumInterfaces", busid);
-
-	return read_integer(path);
-}
-
-int read_bDeviceClass(char *busid)
-{
-	char path[PATH_MAX];
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/bDeviceClass", busid);
-
-	return read_integer(path);
-}
-
-int getdriver(char *busid, int conf, int infnum, char *driver, size_t len)
-{
-	char path[PATH_MAX];
-	char linkto[PATH_MAX];
-	const char none[] = "none";
-	int ret;
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s:%d.%d/driver", busid, conf, infnum);
-
-	/* readlink does not add NULL */
-	memset(linkto, 0, sizeof(linkto));
-	ret = readlink(path, linkto, sizeof(linkto)-1);
-	if (ret < 0) {
-		strncpy(driver, none, len);
-		return -1;
-	} else {
-		strncpy(driver, basename(linkto), len);
-		return 0;
-	}
-}
-
-int getdevicename(char *busid, char *name, size_t len)
-{
-	char path[PATH_MAX];
-	char idProduct[10], idVendor[10];
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/idVendor", busid);
-	read_string(path, idVendor, sizeof(idVendor));
-
-	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s/idProduct", busid);
-	read_string(path, idProduct, sizeof(idProduct));
-
-	if (!idVendor[0] || !idProduct[0])
-		return -1;
-
-	snprintf(name, len, "%s:%s", idVendor, idProduct);
-
-	return 0;
-}
-
-#define MAXLINE 100
-
-/* if this cannot read a whole line, return -1 */
-int readline(int sockfd, char *buff, int bufflen)
-{
-	int ret;
-	char c;
-	int index = 0;
-
-
-	while (index < bufflen) {
-		ret = read(sockfd, &c, sizeof(c));
-		if (ret < 0 && errno == EINTR)
-			continue;
-		if (ret <= 0) {
-			return -1;
-		}
-
-		buff[index] = c;
-
-		if ( index > 0 && buff[index-1] == '\r'  && buff[index] == '\n') {
-			/* end of line */
-			buff[index-1] = '\0';	/* get rid of delimitor */
-			return index;
-		} else
-			index++;
-	}
-
-	return -1;
-}
-
-#if 0
-int writeline(int sockfd, char *str, int strlen)
-{
-	int ret;
-	int index = 0;
-	int len;
-	char buff[MAXLINE];
-
-	if (strlen + 3 > MAXLINE)
-		return -1;
-
-	strncpy(buff, str, strlen);
-	buff[strlen+1] = '\r';
-	buff[strlen+2] = '\n';
-	buff[strlen+3] = '\0';
-
-	len = strlen + 3;
-
-	while (len > 0) {
-		ret = write(sockfd, buff+index, len);
-		if (ret <= 0) {
-			return -1;
-		}
-
-		len -= ret;
-		index += ret;
-	}
-
-	return index;
-}
-#endif
-
-int writeline(int sockfd, char *str, int strlen)
-{
-	int ret;
-	int index = 0;
-	int len;
-	char buff[MAXLINE];
-
-	len = strnlen(str, strlen);
-
-	if (strlen + 2 > MAXLINE)
-		return -1;
-
-	memcpy(buff, str, strlen);
-	buff[strlen] = '\r';
-	buff[strlen+1] = '\n';		/* strlen+1 <= MAXLINE-1 */
-
-	len = strlen + 2;
-
-	while (len > 0) {
-		ret = write(sockfd, buff+index, len);
-		if (ret < 0 && errno == EINTR)
-			continue;
-		if (ret <= 0) {
-			return -1;
-		}
-
-		len -= ret;
-		index += ret;
-	}
-
-	return index;
-}
-
diff --git a/drivers/staging/usbip/userspace/src/utils.h b/drivers/staging/usbip/userspace/src/utils.h
index b50e95a..fdcb14d 100644
--- a/drivers/staging/usbip/userspace/src/utils.h
+++ b/drivers/staging/usbip/userspace/src/utils.h
@@ -1,19 +1,24 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
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
+ */
+
 #ifndef __UTILS_H
 #define __UTILS_H
 
-#include <stdlib.h>
-
 int modify_match_busid(char *busid, int add);
-int read_string(char *path, char *, size_t len);
-int read_integer(char *path);
-int getdevicename(char *busid, char *name, size_t len);
-int getdriver(char *busid, int conf, int infnum, char *driver, size_t len);
-int read_bNumInterfaces(char *busid);
-int read_bConfigurationValue(char *busid);
-int write_integer(char *path, int value);
-int write_bConfigurationValue(char *busid, int config);
-int read_bDeviceClass(char *busid);
-int readline(int sockfd, char *str, int strlen);
-int writeline(int sockfd, char *buff, int bufflen);
 
 #endif /* __UTILS_H */
-- 
1.7.5.2

