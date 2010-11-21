Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0KURkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:40:20 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43618 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab0KURkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:40:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=CvmbUsUMmZU33/3HF8jmRmi9k8zAFBN1sVRLcydPQ6UDIp7uXPA87IeXwfGQPRNpAq
         TywimHHXpWWCoMFBIKnGQaH9ALqzugUlRlAgyZ3VwvGZVtGJRrOwJyeUfUEybL4RMVZS
         4buc+4+uHqRsXaV05lEOd0kz5AdNTilxi4XFk=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Jaya Kumar <jayalk@intworks.biz>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: arcfb: fix buffer overflow
Date: Sun, 21 Nov 2010 20:40:01 +0300
Message-Id: <1290361202-15065-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(count + p) is not checked for integer overflow.  If p < fbmemlength
and count == (size_t)(1 - p) (very big unsigned integer) then
count + p == 1 < fbmemlength and copy_to_user(base_addr+p, buf, count)
overflows base_addr.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/video/arcfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
index 3ec4923..67a4cd4 100644
--- a/drivers/video/arcfb.c
+++ b/drivers/video/arcfb.c
@@ -454,7 +454,7 @@ static ssize_t arcfb_write(struct fb_info *info, const char __user *buf,
 	xres = info->var.xres;
 	fbmemlength = (xres * info->var.yres)/8;
 
-	if (p > fbmemlength)
+	if (p > fbmemlength || (p + count < p))
 		return -ENOSPC;
 
 	err = 0;
-- 
1.7.0.4

