Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1JYJAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:00:24 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:39727 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab1JYJAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:00:22 -0400
Subject: [PATCH] mtd: clean up usage of MTD_DOCPROBE_ADDRESS
From: Paul Bolle <pebolle@tiscali.nl>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Oct 2011 11:00:07 +0200
Message-ID: <1319533207.2409.68.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on whether MTD_DOCPROBE_ADVANCED is set or not,
MTD_DOCPROBE_ADDRESS will default to either 0x0000 or 0. That should
lead to (basically) identical code in docprobe.c. The current two
defaults should be merged.

And, while we're at it, if MTD_DOCPROBE is set MTD_DOCPROBE_ADDRESS will
always be set. (MTD_DOCPROBE_ADDRESS depends on MTD_DOCPROBE and it has
a default value.) So the check whether CONFIG_MTD_DOCPROBE_ADDRESS is
defined is unnecessary and should be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only by running "make menuconfig" with different values and by
looking at the preprocessor's output (ie, running "make -C /[...] M=$PWD
EXTRA_CFLAGS=-E docprobe.ko").

 drivers/mtd/devices/Kconfig    |    3 +--
 drivers/mtd/devices/docprobe.c |    5 -----
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 35081ce..4fdc2fe 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -268,8 +268,7 @@ config MTD_DOCPROBE_ADVANCED
 config MTD_DOCPROBE_ADDRESS
 	hex "Physical address of DiskOnChip" if MTD_DOCPROBE_ADVANCED
 	depends on MTD_DOCPROBE
-	default "0x0000" if MTD_DOCPROBE_ADVANCED
-	default "0" if !MTD_DOCPROBE_ADVANCED
+	default "0x0"
 	---help---
 	  By default, the probe for DiskOnChip devices will look for a
 	  DiskOnChip at every multiple of 0x2000 between 0xC8000 and 0xEE000.
diff --git a/drivers/mtd/devices/docprobe.c b/drivers/mtd/devices/docprobe.c
index d374603..45116bb 100644
--- a/drivers/mtd/devices/docprobe.c
+++ b/drivers/mtd/devices/docprobe.c
@@ -50,11 +50,6 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/doc2000.h>
 
-/* Where to look for the devices? */
-#ifndef CONFIG_MTD_DOCPROBE_ADDRESS
-#define CONFIG_MTD_DOCPROBE_ADDRESS 0
-#endif
-
 
 static unsigned long doc_config_location = CONFIG_MTD_DOCPROBE_ADDRESS;
 module_param(doc_config_location, ulong, 0);
-- 
1.7.4.4



