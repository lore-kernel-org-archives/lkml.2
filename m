Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1IHB31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 21:29:27 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54420 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab1IHB30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 21:29:26 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] Kernel config option for number of devices
Date: Thu,  8 Sep 2011 08:29:14 +0700
Message-Id: <1315445357-14338-3-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315445357-14338-1-git-send-email-ngupta@vflare.org>
References: <1315445357-14338-1-git-send-email-ngupta@vflare.org>
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
index 03ec5a2..55f2c0e 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -781,6 +781,14 @@ static int __init zram_init(void)
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
@@ -795,11 +803,6 @@ static int __init zram_init(void)
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

