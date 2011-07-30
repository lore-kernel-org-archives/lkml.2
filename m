Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1G3TNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:13:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61130 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab1G3TNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:13:42 -0400
Subject: [PATCH 3/3] loop: add BLK_DEV_LOOP_MIN_COUNT=%i to allow distros 0
 pre-allocated loop devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 30 Jul 2011 21:13:38 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.4 (3.1.4-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312053220.1187.14.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: loop: add BLK_DEV_LOOP_MIN_COUNT=%i to allow distros 0 pre-allocated loop devices

Instead of unconditionally creating a fixed number of dead loop
devices which need to be investigated by storage handling services,
even when they are never used, we allow distros start with 0
loop devices and have losetup(8) and similar switch to the dynamic
/dev/loop-control interface instead of searching /dev/loop%i for free
devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 Documentation/kernel-parameters.txt |    9 ++++++---
 drivers/block/Kconfig               |   15 +++++++++++++++
 drivers/block/loop.c                |   27 ++++++++++-----------------
 3 files changed, 31 insertions(+), 20 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1340,9 +1340,12 @@ bytes respectively. Such letter suffixes
 			it is equivalent to "nosmp", which also disables
 			the IO APIC.
 
-	max_loop=	[LOOP] Maximum number of loopback devices that can
-			be mounted
-			Format: <1-256>
+	max_loop=	[LOOP] The number of loop block devices that get
+	(loop.max_loop)	unconditionally pre-created at init time. The default
+			number is configured by BLK_DEV_LOOP_MIN_COUNT. Instead
+			of statically allocating a predefined number, loop
+			devices can be requested on-demand with the
+			/dev/loop-control interface.
 
 	mcatest=	[IA-64]
 
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -256,6 +256,21 @@ config BLK_DEV_LOOP
 
 	  Most users will answer N here.
 
+config BLK_DEV_LOOP_MIN_COUNT
+	int "Number of loop devices to pre-create at init time"
+	depends on BLK_DEV_LOOP
+	default 8
+	help
+	  Static number of loop devices to be unconditionally pre-created
+	  at init time.
+
+	  This default value can be overwritten on the kernel command
+	  line or with module-parameter loop.max_loop.
+
+	  The historic default is 8. If a late 2011 version of losetup(8)
+	  is used, it can be set to 0, since needed loop devices can be
+	  dynamically allocated with the /dev/loop-control interface.
+
 config BLK_DEV_CRYPTOLOOP
 	tristate "Cryptoloop Support"
 	select CRYPTO
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1793,21 +1793,6 @@ static int __init loop_init(void)
 	struct loop_device *lo;
 	int err;
 
-	/*
-	 * loop module now has a feature to instantiate underlying device
-	 * structure on-demand, provided that there is an access dev node.
-	 * However, this will not work well with user space tool that doesn't
-	 * know about such "feature".  In order to not break any existing
-	 * tool, we do the following:
-	 *
-	 * (1) if max_loop is specified, create that many upfront, and this
-	 *     also becomes a hard limit.
-	 * (2) if max_loop is not specified, create 8 loop device on module
-	 *     load, user can further extend loop device by create dev node
-	 *     themselves and have kernel automatically instantiate actual
-	 *     device on-demand.
-	 */
-
 	err = misc_register(&loop_misc);
 	if (err < 0)
 		return err;
@@ -1833,11 +1818,19 @@ static int __init loop_init(void)
 	if (max_loop > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 
+	/*
+	 * If max_loop is specified, create that many devices upfront.
+	 * This also becomes a hard limit. If max_loop is not specified,
+	 * create CONFIG_BLK_DEV_LOOP_MIN_COUNT loop devices at module
+	 * init time. Loop devices can be requested on-demand with the
+	 * /dev/loop-control interface, or be instantiated by accessing
+	 * a 'dead' device node.
+	 */
 	if (max_loop) {
 		nr = max_loop;
 		range = max_loop << part_shift;
 	} else {
-		nr = 8;
+		nr = CONFIG_BLK_DEV_LOOP_MIN_COUNT;
 		range = 1UL << MINORBITS;
 	}
 
@@ -1847,7 +1840,7 @@ static int __init loop_init(void)
 	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
 				  THIS_MODULE, loop_probe, NULL, NULL);
 
-	/* pre-create number devices of devices given by config or max_loop */
+	/* pre-create number of devices given by config or max_loop */
 	mutex_lock(&loop_index_mutex);
 	for (i = 0; i < nr; i++)
 		loop_add(&lo, i);


