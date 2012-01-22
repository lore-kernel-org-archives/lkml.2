Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab2AVTCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:02:48 -0500
Received: from www17.your-server.de ([213.133.104.17]:46617 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2AVTCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:02:46 -0500
Message-ID: <1327253391.1434.68.camel@localhost.localdomain>
Subject: [PATCH] Staging: bcm: Use memdup_user rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Jan 2012 18:29:51 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a little bit restricted to reduce false positives

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup_user.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
--- a/drivers/staging/bcm/Bcmchar.c 2012-01-10 08:19:54.749655047 +0100
+++ b/drivers/staging/bcm/Bcmchar.c 2012-01-22 11:48:39.794793650 +0100
@@ -728,14 +728,10 @@ static long bcm_char_ioctl(struct file *
 		if (IoBuffer.InputLength > MAX_CNTL_PKT_SIZE)
 			return -EINVAL;
 
-		pvBuffer = kmalloc(IoBuffer.InputLength, GFP_KERNEL);
-		if (!pvBuffer)
-			return -ENOMEM;
-
-		if (copy_from_user(pvBuffer, IoBuffer.InputBuffer, IoBuffer.InputLength)) {
-			kfree(pvBuffer);
-			return -EFAULT;
-		}
+		pvBuffer = memdup_user(IoBuffer.InputBuffer,
+				       IoBuffer.InputLength);
+		if (IS_ERR(pvBuffer))
+			return PTR_ERR(pvBuffer);
 
 		down(&Adapter->LowPowerModeSync);
 		Status = wait_event_interruptible_timeout(Adapter->lowpower_mode_wait_queue,
@@ -1140,15 +1136,10 @@ cntrlEnd:
 		if (IoBuffer.InputLength < sizeof(ULONG) * 2)
 			return -EINVAL;
 
-		pvBuffer = kmalloc(IoBuffer.InputLength, GFP_KERNEL);
-		if (!pvBuffer)
-			return -ENOMEM;
-
-		/* Get WrmBuffer structure */
-		if (copy_from_user(pvBuffer, IoBuffer.InputBuffer, IoBuffer.InputLength)) {
-			kfree(pvBuffer);
-			return -EFAULT;
-		}
+		pvBuffer = memdup_user(IoBuffer.InputBuffer,
+				       IoBuffer.InputLength);
+		if (IS_ERR(pvBuffer))
+			return PTR_ERR(pvBuffer);
 
 		pBulkBuffer = (PBULKWRM_BUFFER)pvBuffer;
 
@@ -1308,14 +1299,10 @@ cntrlEnd:
 			return STATUS_FAILURE;
 		}
 
-		pReadData = kzalloc(stNVMReadWrite.uiNumBytes, GFP_KERNEL);
-		if (!pReadData)
-			return -ENOMEM;
-
-		if (copy_from_user(pReadData, stNVMReadWrite.pBuffer, stNVMReadWrite.uiNumBytes)) {
-			kfree(pReadData);
-			return -EFAULT;
-		}
+		pReadData = memdup_user(stNVMReadWrite.pBuffer,
+					stNVMReadWrite.uiNumBytes);
+		if (IS_ERR(pReadData))
+			return PTR_ERR(pReadData);
 
 		do_gettimeofday(&tv0);
 		if (IOCTL_BCM_NVM_READ == cmd) {



