Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab1HMItk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 04:49:40 -0400
Received: from www17.your-server.de ([213.133.104.17]:54133 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1HMIti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 04:49:38 -0400
Subject: [PATCH] staging: spectra: Use memdup_user
From: Thomas Meyer <thomas@m3y3r.de>
To: gregkh@suse.de, devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 13 Aug 2011 10:48:57 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313225341.16820.19.camel@localhost.localdomain>
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

diff --git a/drivers/staging/spectra/ffsport.c b/drivers/staging/spectra/ffsport.c
index 506547b..86d556d 100644
--- a/drivers/staging/spectra/ffsport.c
+++ b/drivers/staging/spectra/ffsport.c
@@ -227,19 +227,12 @@ static int ioctl_write_page_data(unsigned long arg)
 	if (copy_from_user(&info, (void __user *)arg, sizeof(info)))
 		return -EFAULT;
 
-	buf = kmalloc(IdentifyDeviceData.PageDataSize, GFP_ATOMIC);
-	if (!buf) {
-		printk(KERN_ERR "ioctl_write_page_data: "
-		       "failed to allocate memory\n");
-		return -ENOMEM;
-	}
-
-	if (copy_from_user(buf, (void __user *)info.data,
-			   IdentifyDeviceData.PageDataSize)) {
+	buf = memdup_user((void __user *)info.data,
+			  IdentifyDeviceData.PageDataSize);
+	if (IS_ERR(buf)) {
 		printk(KERN_ERR "ioctl_write_page_data: "
 		       "failed to copy user data\n");
-		kfree(buf);
-		return -EFAULT;
+		return PTR_ERR(buf);
 	}
 
 	mutex_lock(&spectra_lock);



