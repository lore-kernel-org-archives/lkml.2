Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2E2Qyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:54:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45659 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab2E2Qyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:54:49 -0400
From: Emil Goode <emilgoode@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] video: bfin_adv7393fb: Convert to kstrtouint_from_user
Date: Tue, 29 May 2012 18:57:00 +0200
Message-Id: <1338310620-6886-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a call to the deprecated simple_strtoul function
and simplifies the code by replacing two function calls with one
call to kstrtouint_from_user.

-Simplify the adv7393_write_proc function by replacing the
 simple_strtoul and copy_from_user calls with one call
 to kstrtouint_from_user.

-Change the count parameter from unsigned long to size_t as
 this is the type that the kstrtouint_from_user function expects.
 (size_t is what will be passed to the adv7393_write_proc function
 by the proc write handler function proc_file_write anyway)

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/video/bfin_adv7393fb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/bfin_adv7393fb.c b/drivers/video/bfin_adv7393fb.c
index 1a268a2..8c6edfd 100644
--- a/drivers/video/bfin_adv7393fb.c
+++ b/drivers/video/bfin_adv7393fb.c
@@ -353,18 +353,16 @@ adv7393_read_proc(char *page, char **start, off_t off,
 
 static int
 adv7393_write_proc(struct file *file, const char __user * buffer,
-		   unsigned long count, void *data)
+		   size_t count, void *data)
 {
 	struct adv7393fb_device *fbdev = data;
-	char line[8];
 	unsigned int val;
 	int ret;
 
-	ret = copy_from_user(line, buffer, count);
+	ret = kstrtouint_from_user(buffer, count, 0, &val);
 	if (ret)
 		return -EFAULT;
 
-	val = simple_strtoul(line, NULL, 0);
 	adv7393_write(fbdev->client, val >> 8, val & 0xff);
 
 	return count;
-- 
1.7.10

