Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2GONWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 09:22:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38731 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2GONWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 09:22:10 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH] powerpc/BSR: cleanup the error path of bsr_init
Date: Sun, 15 Jul 2012 18:52:02 +0530
Message-Id: <1342358522-10956-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

class_create if succeeded returns a pointer to the struct class,
and if it fails, it returns a value enclosed by the pointer, which
can be read by using PTR_ERR.

Handle the error and return it.

result is for error checking of the alloc_chrdev_region, instead
ret can be used, and also if the alloc_chrdev_region fail,
we are still returning -ENODEV, use ret and the error path will
take care of returning of the ret.

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
	This patch is not compile tested because i dont have the
	powerpc toolchain, i am trying hard to setit up one,

 drivers/char/bsr.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
index 0c68823..9746705 100644
--- a/drivers/char/bsr.c
+++ b/drivers/char/bsr.c
@@ -297,7 +297,6 @@ static int __init bsr_init(void)
 	struct device_node *np;
 	dev_t bsr_dev;
 	int ret = -ENODEV;
-	int result;
 
 	np = of_find_compatible_node(NULL, NULL, "ibm,bsr");
 	if (!np)
@@ -306,13 +305,14 @@ static int __init bsr_init(void)
 	bsr_class = class_create(THIS_MODULE, "bsr");
 	if (IS_ERR(bsr_class)) {
 		printk(KERN_ERR "class_create() failed for bsr_class\n");
+		ret = PTR_ERR(bsr_class);
 		goto out_err_1;
 	}
 	bsr_class->dev_attrs = bsr_dev_attrs;
 
-	result = alloc_chrdev_region(&bsr_dev, 0, BSR_MAX_DEVS, "bsr");
+	ret = alloc_chrdev_region(&bsr_dev, 0, BSR_MAX_DEVS, "bsr");
 	bsr_major = MAJOR(bsr_dev);
-	if (result < 0) {
+	if (ret < 0) {
 		printk(KERN_ERR "alloc_chrdev_region() failed for bsr\n");
 		goto out_err_2;
 	}
-- 
1.7.0.4

