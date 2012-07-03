Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2GCA1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 20:27:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:28627 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab2GCA1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 20:27:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="172728582"
From: Andi Kleen <andi@firstfloor.org>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] floppy: Run floppy initialization asynchronous
Date: Mon,  2 Jul 2012 17:27:04 -0700
Message-Id: <1341275224-31696-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

floppy_init is quite slow, 3s on my test system to determine
that there is no floppy. Run it asynchronous to the other
init calls to improve boot time.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/block/floppy.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cce7df3..8b5769b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -191,6 +191,7 @@ static int print_unex = 1;
 #include <linux/mutex.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/async.h>
 
 /*
  * PS/2 floppies have much slower step rates than regular floppies.
@@ -4122,7 +4123,7 @@ static struct kobject *floppy_find(dev_t dev, int *part, void *data)
 	return get_disk(disks[drive]);
 }
 
-static int __init floppy_init(void)
+static int __init do_floppy_init(void)
 {
 	int i, unit, drive;
 	int err, dr;
@@ -4337,6 +4338,24 @@ out_put_disk:
 	return err;
 }
 
+#ifndef MODULE
+static __init void floppy_async_init(void *data, async_cookie_t cookie)
+{
+	do_floppy_init();
+}
+#endif
+
+static int __init floppy_init(void)
+{
+#ifdef MODULE
+	return do_floppy_init(void);
+#else
+	/* Don't hold up the bootup by the floppy initialization */
+	async_schedule(floppy_async_init, NULL);
+	return 0;
+#endif
+}
+
 static const struct io_region {
 	int offset;
 	int size;
-- 
1.7.7.6

