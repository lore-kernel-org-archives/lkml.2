Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab0LYGDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 01:03:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49554 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0LYGDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 01:03:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HoKfogtNA85Dhz8VXP0EMy6PhwqsqM/hNt/xSMPrBF7RQ3K/Rhf6B3lxZnMzqM9T3Z
         1eUQ/C+NGKtaYe+fGqJ6zmJhMDeaRwN/sLNfzLxCWkTc9OoRdju+XXJA59o9wViUSm5R
         MBWXjkwLDFZ7VgI9ogRM8CxInpHWcHeTQpJDA=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] airo: use simple_write_to_buffer
Date: Sat, 25 Dec 2010 15:03:58 +0900
Message-Id: <1293257039-2580-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify write file operation for /proc files by using
simple_write_to_buffer().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/airo.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index a36e787..57a79b0 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -4652,24 +4652,18 @@ static ssize_t proc_write( struct file *file,
 			   size_t len,
 			   loff_t *offset )
 {
-	loff_t pos = *offset;
+	ssize_t ret;
 	struct proc_data *priv = file->private_data;
 
 	if (!priv->wbuffer)
 		return -EINVAL;
 
-	if (pos < 0)
-		return -EINVAL;
-	if (pos >= priv->maxwritelen)
-		return 0;
-	if (len > priv->maxwritelen - pos)
-		len = priv->maxwritelen - pos;
-	if (copy_from_user(priv->wbuffer + pos, buffer, len))
-		return -EFAULT;
-	if ( pos + len > priv->writelen )
-		priv->writelen = len + file->f_pos;
-	*offset = pos + len;
-	return len;
+	ret = simple_write_to_buffer(priv->wbuffer, priv->maxwritelen, offset,
+					buffer, len);
+	if (ret > 0)
+		priv->writelen = max_t(int, priv->writelen, *offset);
+
+	return ret;
 }
 
 static int proc_status_open(struct inode *inode, struct file *file)
-- 
1.7.3.4

