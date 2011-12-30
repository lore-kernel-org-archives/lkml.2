Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1L3BqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 20:46:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab1L3Bpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 20:45:43 -0500
From: NeilBrown <neilb@suse.de>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Dec 2011 11:58:49 +1100
Subject: [PATCH 1/5] Fix w1_bq27000
Message-ID: <20111230005849.11559.79397.stgit@notabene.brown>
In-Reply-To: <20111230004947.11559.81184.stgit@notabene.brown>
References: <20111230004947.11559.81184.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

w1_bq27000 adds a bq27000-battery platform device but does not provide
platform data for it. This causes the bq27x00 driver to dereference a NULL
pointer.
So provide the appropriate platform data.  This requires modifying
w1_bq27000_read so that it find the w1 device as the parent of the bq device.

Also there is no point exporting w1_bq27000_read as nothing else uses it
or could use it.  So make it static.

Finally, as there is no way to track how many batteries have been found, and
we will probably only find one, use an id number of '-1' to assert that this
is a unique instance.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/w1/slaves/w1_bq27000.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/slaves/w1_bq27000.c b/drivers/w1/slaves/w1_bq27000.c
index 8f4c91f..8f10fd2 100644
--- a/drivers/w1/slaves/w1_bq27000.c
+++ b/drivers/w1/slaves/w1_bq27000.c
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
+#include <linux/power/bq27x00_battery.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
@@ -39,10 +40,10 @@ void w1_bq27000_write(struct device *dev, u8 buf, u8 reg)
 }
 EXPORT_SYMBOL(w1_bq27000_write);
 
-int w1_bq27000_read(struct device *dev, u8 reg)
+static int w1_bq27000_read(struct device *dev, unsigned int reg)
 {
 	u8 val;
-	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+	struct w1_slave *sl = container_of(dev->parent, struct w1_slave, dev);
 
 	if (!dev)
 		return 0;
@@ -52,19 +53,25 @@ int w1_bq27000_read(struct device *dev, u8 reg)
 
 	return val;
 }
-EXPORT_SYMBOL(w1_bq27000_read);
+
+static struct bq27000_platform_data bq27000_battery_info = {
+	.read   = w1_bq27000_read,
+	.name   = "bq27000-battery",
+};
 
 static int w1_bq27000_add_slave(struct w1_slave *sl)
 {
 	int ret;
-	int id = 1;
 	struct platform_device *pdev;
 
-	pdev = platform_device_alloc("bq27000-battery", id);
+	pdev = platform_device_alloc("bq27000-battery", -1);
 	if (!pdev) {
 		ret = -ENOMEM;
 		return ret;
 	}
+	ret = platform_device_add_data(pdev,
+				       &bq27000_battery_info,
+				       sizeof(bq27000_battery_info));
 	pdev->dev.parent = &sl->dev;
 
 	ret = platform_device_add(pdev);


