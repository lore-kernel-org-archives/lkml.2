Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab2EDAX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 20:23:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:42509 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759074Ab2EDAXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 20:23:25 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+CckwwIWuCGq8BGckUXUCAwVgDoRymGa3CIh0LAL
	VUBT4djQeumuBL
From: Peter Huewe <peterhuewe@gmx.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH v2] video/via: Convert to kstrtou8_from_user
Date: Fri,  4 May 2012 02:23:17 +0200
Message-Id: <1336090997-23727-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <CACVxJT96rXRqMoeabdDyNEjXCubuAnQ_fonisbopQvYL=Qhp2w@mail.gmail.com>
References: <CACVxJT96rXRqMoeabdDyNEjXCubuAnQ_fonisbopQvYL=Qhp2w@mail.gmail.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the code for getting an number from a
userspace buffer by a simple call to kstrou8_from_user.
This makes it easier to read and less error prone.

v2:
removed initialization of reg_val and dropped check if count < 1

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
@Alexey: Thanks for the review/feedback!
 drivers/video/via/viafbdev.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index a13c258..88bf5ba 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1279,17 +1279,12 @@ static int viafb_dfph_proc_open(struct inode *inode, struct file *file)
 static ssize_t viafb_dfph_proc_write(struct file *file,
 	const char __user *buffer, size_t count, loff_t *pos)
 {
-	char buf[20];
-	u8 reg_val = 0;
-	unsigned long length;
-	if (count < 1)
-		return -EINVAL;
-	length = count > 20 ? 20 : count;
-	if (copy_from_user(&buf[0], buffer, length))
-		return -EFAULT;
-	buf[length - 1] = '\0';	/*Ensure end string */
-	if (kstrtou8(buf, 0, &reg_val) < 0)
-		return -EINVAL;
+	int err;
+	u8 reg_val;
+	err = kstrtou8_from_user(buffer, count, 0, &reg_val);
+	if (err)
+		return err;
+
 	viafb_write_reg_mask(CR97, VIACR, reg_val, 0x0f);
 	return count;
 }
@@ -1319,17 +1314,12 @@ static int viafb_dfpl_proc_open(struct inode *inode, struct file *file)
 static ssize_t viafb_dfpl_proc_write(struct file *file,
 	const char __user *buffer, size_t count, loff_t *pos)
 {
-	char buf[20];
-	u8 reg_val = 0;
-	unsigned long length;
-	if (count < 1)
-		return -EINVAL;
-	length = count > 20 ? 20 : count;
-	if (copy_from_user(&buf[0], buffer, length))
-		return -EFAULT;
-	buf[length - 1] = '\0';	/*Ensure end string */
-	if (kstrtou8(buf, 0, &reg_val) < 0)
-		return -EINVAL;
+	int err;
+	u8 reg_val;
+	err = kstrtou8_from_user(buffer, count, 0, &reg_val);
+	if (err)
+		return err;
+
 	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
 	return count;
 }
-- 
1.7.3.4

