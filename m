Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1HMIR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 04:17:56 -0400
Received: from www17.your-server.de ([213.133.104.17]:52734 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1HMIRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 04:17:53 -0400
Subject: [PATCH] i2c-dev: Use memdup_user
From: Thomas Meyer <thomas@m3y3r.de>
To: khali@linux-fr.org, linux-i2c@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 13 Aug 2011 10:17:06 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313223430.16820.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kmemdup_user rather than duplicating its implementation
 This is a little bit restricted to reduce false positives

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/memdup_user.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
--- a/drivers/i2c/i2c-dev.c 2011-04-14 10:34:17.670994023 +0200
+++ b/drivers/i2c/i2c-dev.c 2011-08-01 22:08:25.888046385 +0200
@@ -251,15 +251,10 @@ static noinline int i2cdev_ioctl_rdrw(st
 	if (rdwr_arg.nmsgs > I2C_RDRW_IOCTL_MAX_MSGS)
 		return -EINVAL;
 
-	rdwr_pa = kmalloc(rdwr_arg.nmsgs * sizeof(struct i2c_msg), GFP_KERNEL);
-	if (!rdwr_pa)
-		return -ENOMEM;
-
-	if (copy_from_user(rdwr_pa, rdwr_arg.msgs,
-			   rdwr_arg.nmsgs * sizeof(struct i2c_msg))) {
-		kfree(rdwr_pa);
-		return -EFAULT;
-	}
+	rdwr_pa = memdup_user(rdwr_arg.msgs,
+			      rdwr_arg.nmsgs * sizeof(struct i2c_msg));
+	if (IS_ERR(rdwr_pa))
+		return PTR_ERR(rdwr_pa);
 
 	data_ptrs = kmalloc(rdwr_arg.nmsgs * sizeof(u8 __user *), GFP_KERNEL);
 	if (data_ptrs == NULL) {


