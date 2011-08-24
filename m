Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1HXBfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 21:35:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61219 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab1HXBfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 21:35:03 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] Kernel config option for number of devices
Date: Wed, 24 Aug 2011 08:34:47 +0700
Message-Id: <1314149690-3177-2-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314149690-3177-1-git-send-email-ngupta@vflare.org>
References: <1314149690-3177-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows configuring default number of zram devices
as kernel config option. User can override this
value using 'num_devices' module parameter.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zram/Kconfig    |    9 +++++++++
 drivers/staging/zram/zram_drv.c |   13 ++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
index 3bec4db..ca31cb3 100644
--- a/drivers/staging/zram/Kconfig
+++ b/drivers/staging/zram/Kconfig
@@ -21,6 +21,15 @@ config ZRAM
 	  See zram.txt for more information.
 	  Project home: http://compcache.googlecode.com/
 
+config ZRAM_NUM_DEVICES
+	int "Default number of zram devices"
+	depends on ZRAM
+	range 1 32
+	default 1
+	help
+	  Select default number of zram devices. You can override this value
+	  using 'num_devices' module parameter.
+
 config ZRAM_DEBUG
 	bool "Compressed RAM block device debug support"
 	depends on ZRAM
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index d70ec1a..207234e 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -780,6 +780,14 @@ static int __init zram_init(void)
 {
 	int ret, dev_id;
 
+	/*
+	 * Module parameter not specified by user. Use default
+	 * value as defined during kernel config.
+	 */
+	if (num_devices == 0) {
+		num_devices = CONFIG_ZRAM_NUM_DEVICES;
+	}
+
 	if (num_devices > max_num_devices) {
 		pr_warning("Invalid value for num_devices: %u\n",
 				num_devices);
@@ -794,11 +802,6 @@ static int __init zram_init(void)
 		goto out;
 	}
 
-	if (!num_devices) {
-		pr_info("num_devices not specified. Using default: 1\n");
-		num_devices = 1;
-	}
-
 	/* Allocate the device array and initialize each one */
 	pr_info("Creating %u devices ...\n", num_devices);
 	devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
-- 
1.7.6

