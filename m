Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0LDDig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 22:38:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39445 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab0LDDie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 22:38:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=cwn6LE4QRsfx/8BittCIXNtIDpsnBRjEHhEFpkZGeHSuS+B4Vii0rvd6lzMhUznm/D
         /eOcwja0ty6oQnbW4tCnwWCfQcghz7BQ1IPw+e8vWzw7FcO5mMK4sTVUe2vaf8hPq3LX
         +IMkLNI9HxdrCkbM8BZFPK3MsQu/VefiiSZPY=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Joseph Chan <JosephChan@via.com.tw>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH] drivers/video/via/viafbdev.c: Check return value of strict_strtoul().
Date: Sat,  4 Dec 2010 01:38:23 -0200
Message-Id: <1dda71ee1b12baa2366520b894d83d7b0abefc5c.1291433779.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.3.2.343.g7d43d
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix the following warnings:

drivers/video/via/viafbdev.c:1144: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result
drivers/video/via/viafbdev.c:1214: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result
drivers/video/via/viafbdev.c:1272: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result
drivers/video/via/viafbdev.c:1311: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result
drivers/video/via/viafbdev.c:1380: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result
drivers/video/via/viafbdev.c:1417: warning: ignoring return value of ‘strict_strtoul’, declared with attribute warn_unused_result

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/video/via/viafbdev.c |   40 +++++++++++++++++++++++++++++++++-------
 1 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index d298cfc..7c35100 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1131,6 +1131,8 @@ static ssize_t viafb_dvp0_proc_write(struct file *file,
 	char buf[20], *value, *pbuf;
 	u8 reg_val = 0;
 	unsigned long length, i;
+	int ret;
+
 	if (count < 1)
 		return -EINVAL;
 	length = count > 20 ? 20 : count;
@@ -1141,7 +1143,10 @@ static ssize_t viafb_dvp0_proc_write(struct file *file,
 	for (i = 0; i < 3; i++) {
 		value = strsep(&pbuf, " ");
 		if (value != NULL) {
-			strict_strtoul(value, 0, (unsigned long *)&reg_val);
+			ret = strict_strtoul(value, 0, (unsigned long *)&reg_val);
+			if (ret)
+				return ret;
+
 			DEBUG_MSG(KERN_INFO "DVP0:reg_val[%l]=:%x\n", i,
 				  reg_val);
 			switch (i) {
@@ -1201,6 +1206,8 @@ static ssize_t viafb_dvp1_proc_write(struct file *file,
 	char buf[20], *value, *pbuf;
 	u8 reg_val = 0;
 	unsigned long length, i;
+	int ret;
+
 	if (count < 1)
 		return -EINVAL;
 	length = count > 20 ? 20 : count;
@@ -1211,7 +1218,10 @@ static ssize_t viafb_dvp1_proc_write(struct file *file,
 	for (i = 0; i < 3; i++) {
 		value = strsep(&pbuf, " ");
 		if (value != NULL) {
-			strict_strtoul(value, 0, (unsigned long *)&reg_val);
+			ret = strict_strtoul(value, 0, (unsigned long *)&reg_val);
+			if (ret)
+				return ret;
+
 			switch (i) {
 			case 0:
 				viafb_write_reg_mask(CR9B, VIACR,
@@ -1263,13 +1273,17 @@ static ssize_t viafb_dfph_proc_write(struct file *file,
 	char buf[20];
 	u8 reg_val = 0;
 	unsigned long length;
+	int ret;
+
 	if (count < 1)
 		return -EINVAL;
 	length = count > 20 ? 20 : count;
 	if (copy_from_user(&buf[0], buffer, length))
 		return -EFAULT;
 	buf[length - 1] = '\0';	/*Ensure end string */
-	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
+	ret = strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
+	if (ret)
+		return ret;
 	viafb_write_reg_mask(CR97, VIACR, reg_val, 0x0f);
 	return count;
 }
@@ -1302,13 +1316,17 @@ static ssize_t viafb_dfpl_proc_write(struct file *file,
 	char buf[20];
 	u8 reg_val = 0;
 	unsigned long length;
+	int ret;
+
 	if (count < 1)
 		return -EINVAL;
 	length = count > 20 ? 20 : count;
 	if (copy_from_user(&buf[0], buffer, length))
 		return -EFAULT;
 	buf[length - 1] = '\0';	/*Ensure end string */
-	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
+	ret = strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
+	if (ret)
+		return ret;
 	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
 	return count;
 }
@@ -1365,6 +1383,8 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
 	char buf[30], *value, *pbuf;
 	struct IODATA reg_val;
 	unsigned long length, i;
+	int ret;
+
 	if (count < 1)
 		return -EINVAL;
 	length = count > 30 ? 30 : count;
@@ -1377,8 +1397,11 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
 		for (i = 0; i < 2; i++) {
 			value = strsep(&pbuf, " ");
 			if (value != NULL) {
-				strict_strtoul(value, 0,
-					(unsigned long *)&reg_val.Data);
+				ret = strict_strtoul(value, 0,
+						(unsigned long *)&reg_val.Data);
+				if (ret)
+					return ret;
+
 				switch (i) {
 				case 0:
 					reg_val.Index = 0x08;
@@ -1414,8 +1437,11 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
 		for (i = 0; i < 2; i++) {
 			value = strsep(&pbuf, " ");
 			if (value != NULL) {
-				strict_strtoul(value, 0,
+				ret = strict_strtoul(value, 0,
 					(unsigned long *)&reg_val.Data);
+				if (ret)
+					return ret;
+
 				switch (i) {
 				case 0:
 					reg_val.Index = 0x08;
-- 
1.7.3.2.343.g7d43d

