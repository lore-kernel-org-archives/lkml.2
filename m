Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789Ab0HEWXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:23:49 -0400
Received: from kroah.org ([198.145.64.141]:37558 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308Ab0HEWXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:23:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "jianwei.yang" <jianwei.yang@intel.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/67] max3110 sanity check a register
Date: Thu,  5 Aug 2010 15:22:33 -0700
Message-Id: <1281047014-23429-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jianwei.yang <jianwei.yang@intel.com>

MAX3111 is the SPI/UART IC installed on the MRST SPI Port Card as a serial
debug goal, and the SPI Port Card will be frequently mounted and unmounted
from the main board by developers depending whether debug serial is
required or not.

As the MAX3111 has no subvendor or product id registers available, the patch
will try to access one register to decide if this IC is present or not.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/mrst_max3110.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/mrst_max3110.c b/drivers/serial/mrst_max3110.c
index 273e7cb..f9c01ae 100644
--- a/drivers/serial/mrst_max3110.c
+++ b/drivers/serial/mrst_max3110.c
@@ -721,7 +721,7 @@ static int serial_m3110_probe(struct spi_device *spi)
 	struct uart_max3110 *max;
 	int ret;
 	unsigned char *buffer;
-
+	u16 res;
 	max = kzalloc(sizeof(*max), GFP_KERNEL);
 	if (!max)
 		return -ENOMEM;
@@ -753,7 +753,16 @@ static int serial_m3110_probe(struct spi_device *spi)
 
 	max->cur_conf = 0;
 	atomic_set(&max->irq_pending, 0);
-
+	/* Check if reading configuration register returns something sane */
+
+	res = RC_TAG;
+	ret = max3110_write_then_read(max, (u8 *)&res, (u8 *)&res, 2, 0);
+	if (ret < 0 || res == 0 || res == 0xffff) {
+		printk(KERN_ERR "MAX3111 deemed not present (conf reg %04x)",
+									res);
+		ret = -ENODEV;
+		goto err_get_page;
+	}
 	buffer = (unsigned char *)__get_free_page(GFP_KERNEL);
 	if (!buffer) {
 		ret = -ENOMEM;
-- 
1.7.2

