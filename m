Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab1IMKRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:17:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42570 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1IMKRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:17:37 -0400
Date: Tue, 13 Sep 2011 11:17:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Fwd: [PATCH] Fix build errors with gpio-generic.c
Message-ID: <20110913101715.GA8141@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.  Any chance of getting this in before 3.1 ?

----- Forwarded message from Russell King - ARM Linux <linux@arm.linux.org.uk> -----
Date: Mon, 15 Aug 2011 20:25:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix build errors with gpio-generic.c

From: Russell King <rmk+kernel@arm.linux.org.uk>
GPIO: Fix build errors with gpio-generic.c

Building a kernel with hotplug disabled results in a link failure:

`bgpio_remove' referenced in section `___ksymtab_gpl+bgpio_remove' of drivers/built-in.o: defined in discarded section `.devexit.text' of drivers/built-in.o

This is caused because of the bgpio_remove is exported.  It is illegal
to export symbols which are discarded either at link time or as part of
an init/exit section.

Fix this by dropping the __devexit attributation from bgpio_remove().
Also drop the __devinit attributation from bgpio_init().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/gpio/gpio-generic.c     |   15 +++++----------
 include/linux/basic_mmio_gpio.h |   15 +++++----------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index 231714d..4e24436 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -351,7 +351,7 @@ static int bgpio_setup_direction(struct bgpio_chip *bgc,
 	return 0;
 }
 
-int __devexit bgpio_remove(struct bgpio_chip *bgc)
+int bgpio_remove(struct bgpio_chip *bgc)
 {
 	int err = gpiochip_remove(&bgc->gc);
 
@@ -361,15 +361,10 @@ int __devexit bgpio_remove(struct bgpio_chip *bgc)
 }
 EXPORT_SYMBOL_GPL(bgpio_remove);
 
-int __devinit bgpio_init(struct bgpio_chip *bgc,
-			 struct device *dev,
-			 unsigned long sz,
-			 void __iomem *dat,
-			 void __iomem *set,
-			 void __iomem *clr,
-			 void __iomem *dirout,
-			 void __iomem *dirin,
-			 bool big_endian)
+int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
+	       unsigned long sz, void __iomem *dat, void __iomem *set,
+	       void __iomem *clr, void __iomem *dirout, void __iomem *dirin,
+	       bool big_endian)
 {
 	int ret;
 
diff --git a/include/linux/basic_mmio_gpio.h b/include/linux/basic_mmio_gpio.h
index 98999cf..feb91219 100644
--- a/include/linux/basic_mmio_gpio.h
+++ b/include/linux/basic_mmio_gpio.h
@@ -63,15 +63,10 @@ static inline struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
 	return container_of(gc, struct bgpio_chip, gc);
 }
 
-int __devexit bgpio_remove(struct bgpio_chip *bgc);
-int __devinit bgpio_init(struct bgpio_chip *bgc,
-			 struct device *dev,
-			 unsigned long sz,
-			 void __iomem *dat,
-			 void __iomem *set,
-			 void __iomem *clr,
-			 void __iomem *dirout,
-			 void __iomem *dirin,
-			 bool big_endian);
+int bgpio_remove(struct bgpio_chip *bgc);
+int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
+	       unsigned long sz, void __iomem *dat, void __iomem *set,
+	       void __iomem *clr, void __iomem *dirout, void __iomem *dirin,
+	       bool big_endian);
 
 #endif /* __BASIC_MMIO_GPIO_H */


----- End forwarded message -----
