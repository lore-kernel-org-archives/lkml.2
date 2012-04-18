Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2DRTsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab2DRTsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:48:06 -0400
Message-ID: <1334778468.15535.19.camel@mop>
Subject: [PATCH] driver-core: extend dev_printk() to pass structured data
From: Kay Sievers <kay@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>
Date: Wed, 18 Apr 2012 21:47:48 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay@vrfy.org>
Subject: driver-core: extend dev_printk() to pass structured data

Extends dev_printk() to attach a dictionary with a device identifier
and the driver core subsystem name to logged messages, which makes
dev_prink() reliable machine-readable. In addition to the printed
plain text message, it creates these properties:
    SUBSYSTEM=     - the driver-core subsytem name
    DEVICE=
      b12:8        - block dev_t
      c127:3       - char dev_t
      n8           - netdev ifindex
      +sound:card0 - subsystem:devname

Tested-by: William Douglas <william.douglas@intel.com>
Signed-off-by: Kay Sievers <kay@vrfy.org>
---
 drivers/base/core.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -25,6 +25,7 @@
 #include <linux/mutex.h>
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
+#include <linux/netdevice.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -1843,15 +1844,60 @@ void device_shutdown(void)
  */
 
 #ifdef CONFIG_PRINTK
-
 int __dev_printk(const char *level, const struct device *dev,
 		 struct va_format *vaf)
 {
+	char dict[128];
+	size_t dictlen = 0;
+	const char *subsys;
+
 	if (!dev)
 		return printk("%s(NULL device *): %pV", level, vaf);
 
-	return printk("%s%s %s: %pV",
-		      level, dev_driver_string(dev), dev_name(dev), vaf);
+	if (dev->class)
+		subsys = dev->class->name;
+	else if (dev->bus)
+		subsys = dev->bus->name;
+	else
+		goto skip;
+
+	dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
+			    "SUBSYSTEM=%s", subsys);
+
+	/*
+	 * Add device identifier DEVICE=:
+	 *   b12:8         block dev_t
+	 *   c127:3        char dev_t
+	 *   n8            netdev ifindex
+	 *   +sound:card0  subsystem:devname
+	 */
+	if (MAJOR(dev->devt)) {
+		char c;
+
+		if (strcmp(subsys, "block") == 0)
+			c = 'b';
+		else
+			c = 'c';
+		dictlen++;
+		dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
+				   "DEVICE=%c%u:%u",
+				   c, MAJOR(dev->devt), MINOR(dev->devt));
+	} else if (strcmp(subsys, "net") == 0) {
+		struct net_device *net = to_net_dev(dev);
+
+		dictlen++;
+		dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
+				    "DEVICE=n%u", net->ifindex);
+	} else {
+		dictlen++;
+		dictlen += snprintf(dict + dictlen, sizeof(dict) - dictlen,
+				    "DEVICE=+%s:%s", subsys, dev_name(dev));
+	}
+skip:
+	return printk_emit(0, level[1] - '0',
+			   dictlen ? dict : NULL, dictlen,
+			   "%s %s: %pV",
+			   dev_driver_string(dev), dev_name(dev), vaf);
 }
 EXPORT_SYMBOL(__dev_printk);
 


