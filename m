Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0CWKBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:01:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54874 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab0CWKBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=WtO0OUFmi4fBKLY/BM9loy8c2P8uOQ6/TqAV8LVpbQNIVTMp8eKMkfm4Oqw4U0C7SC
         cMC6cxGNA+vajUS2U20Wl3ei0ooP1eEsoFJ7oH9UtoH8JYbxSmHpX2adUEcAoV8tML5S
         AmlhpsI0u8lYBoPxkCltNW7IVUS0CDeyYpZjE=
MIME-Version: 1.0
Date: Tue, 23 Mar 2010 11:01:28 +0100
Message-ID: <8cad0aa1003230301g44434763w13da24799f811faa@mail.gmail.com>
Subject: [PATCH]I2C device - release cleanup
From: Jean-Michel Hautbois <jhautbois@gmail.com>
To: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jean-Michel Hautbois <jhautbois@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

Here is a little patch which aims to cleanup the release function in i2c-dev.c.
This is only a call to single_release, instead of kfree and several things.

Signed-off-by: Jean-Michel Hautbois <jhautbois@gmail.com>
---
drivers/i2c/i2c-dev.c

--- linux-2.6.34-rc2/drivers/i2c/i2c-dev.c.orig	2010-03-23
10:19:26.000000000 +0100
+++ linux-2.6.34-rc2/drivers/i2c/i2c-dev.c	2010-03-23 10:55:54.000000000 +0100
@@ -36,6 +36,7 @@
 #include <linux/i2c-dev.h>
 #include <linux/jiffies.h>
 #include <asm/uaccess.h>
+#include <linux/seq_file.h>

 static struct i2c_driver i2cdev_driver;

@@ -477,12 +478,10 @@ static int i2cdev_open(struct inode *ino
 static int i2cdev_release(struct inode *inode, struct file *file)
 {
 	struct i2c_client *client = file->private_data;
-
+	
 	i2c_put_adapter(client->adapter);
-	kfree(client);
-	file->private_data = NULL;
-
-	return 0;
+	
+	return single_release(inode, file);
 }

 static const struct file_operations i2cdev_fops = {
