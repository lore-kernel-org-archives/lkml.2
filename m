Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1EYFoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 01:44:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44943 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1EYFoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 01:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jpEq6oqorlBP975NjybUo9SyNTGlyadG+Wlj9Ul9y8/0J4X81udWvgdzlEFpvW1hAr
         gcPMYa3CYFhOOFs+w7fxKv+5PustvOc20lqFE0iIpGQpFqIwB/+sJv6LMSNRQ727+Joj
         z0x8ym00TNPTT5jCfXPbj0CjtdKyHtZaHh4f0=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>
Subject: [PATCH] loop: export module parameters
Date: Wed, 25 May 2011 14:44:02 +0900
Message-Id: <1306302242-7019-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export 'max_loop' and 'max_part' parameters to sysfs so user can know
that how many devices are allowed and how many partitions are supported.

If 'max_loop' is 0, there is no restriction on the number of loop devices.
User can create/use the devices as many as minor numbers available. If
'max_part' is 0, it means simply the device doesn't support partitioning.

Also note that 'max_part' can be adjusted to power of 2 minus 1 form if
needed. User should check this value after the module loading if he/she
want to use that number correctly (i.e. fdisk, mknod, etc.).

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
---
 drivers/block/loop.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c59a672a3de0..76c8da78212b 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1540,9 +1540,9 @@ static const struct block_device_operations lo_fops = {
  * And now the modules code and kernel interface.
  */
 static int max_loop;
-module_param(max_loop, int, 0);
+module_param(max_loop, int, S_IRUGO);
 MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
-module_param(max_part, int, 0);
+module_param(max_part, int, S_IRUGO);
 MODULE_PARM_DESC(max_part, "Maximum number of partitions per loop device");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
@@ -1688,9 +1688,20 @@ static int __init loop_init(void)
 	 */
 
 	part_shift = 0;
-	if (max_part > 0)
+	if (max_part > 0) {
 		part_shift = fls(max_part);
 
+		/*
+		 * Adjust max_part according to part_shift as it is exported
+		 * to user space so that user can decide correct minor number
+		 * if [s]he want to create more devices.
+		 *
+		 * Note that -1 is required because partition 0 is reserved
+		 * for the whole disk.
+		 */
+		max_part = (1UL << part_shift) - 1;
+	}
+
 	if ((1UL << part_shift) > DISK_MAX_PARTS)
 		return -EINVAL;
 
-- 
1.7.5.2

