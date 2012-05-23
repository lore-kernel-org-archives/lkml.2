Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927Ab2EWG5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:57:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51871 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab2EWG5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:57:33 -0400
Date: Tue, 22 May 2012 23:57:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [patch -linus] regmap: REMAP_IRQ should select IRQ_DOMAIN itself
In-Reply-To: <4FBBAF1B.1070702@xenotime.net>
Message-ID: <alpine.DEB.2.00.1205222339030.9290@chino.kir.corp.google.com>
References: <20120522183037.75ec03c9d8881ec188e7f787@canb.auug.org.au> <4FBBAF1B.1070702@xenotime.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Randy Dunlap wrote:

> on i386:
> 
> drivers/base/regmap/regmap-irq.c: In function 'regmap_irq_thread':
> drivers/base/regmap/regmap-irq.c:146:4: error: implicit declaration of function 'irq_find_mapping'
> drivers/base/regmap/regmap-irq.c: At top level:
> drivers/base/regmap/regmap-irq.c:179:11: error: 'irq_domain_xlate_twocell' undeclared here (not in a function)
> drivers/base/regmap/regmap-irq.c: In function 'regmap_add_irq_chip':
> drivers/base/regmap/regmap-irq.c:272:3: error: implicit declaration of function 'irq_domain_add_legacy'
> drivers/base/regmap/regmap-irq.c:272:13: warning: assignment makes pointer from integer without a cast
> drivers/base/regmap/regmap-irq.c:276:3: error: implicit declaration of function 'irq_domain_add_linear'
> drivers/base/regmap/regmap-irq.c:276:13: warning: assignment makes pointer from integer without a cast
> drivers/base/regmap/regmap-irq.c: In function 'regmap_irq_get_virq':
> drivers/base/regmap/regmap-irq.c:349:2: error: implicit declaration of function 'irq_create_mapping'
> 
> Full randconfig file is attached.
> 

This brekage has already made it to Linus and doesn't only affect i386.  
It happens because CONFIG_MFD_PALMAS doesn't select CONFIG_IRQ_DOMAIN like 
the rest of the options that were patched in 4af8be67fd99 ("regmap: 
Convert regmap_irq to use irq_domain").  This is the only remaining 
Kconfig entry that selects CONFIG_REGMAP_IRQ and misses CONFIG_IRQ_DOMAIN.


regmap: REMAP_IRQ should select IRQ_DOMAIN itself

CONFIG_REGMAP_IRQ relies on CONFIG_IRQ_DOMAIN since 4af8be67fd99 ("regmap: 
Convert regmap_irq to use irq_domain").

Instead of ensuring all options that select REGMAP_IRQ also select 
IRQ_DOMAIN, just make the former select the latter itself.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/base/regmap/Kconfig |    1 +
 drivers/mfd/Kconfig         |    3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
--- a/drivers/base/regmap/Kconfig
+++ b/drivers/base/regmap/Kconfig
@@ -19,3 +19,4 @@ config REGMAP_MMIO
 
 config REGMAP_IRQ
 	bool
+	select IRQ_DOMAIN
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -377,7 +377,6 @@ config PMIC_DA9052
 
 config MFD_DA9052_SPI
 	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with SPI"
-	select IRQ_DOMAIN
 	select REGMAP_SPI
 	select REGMAP_IRQ
 	select PMIC_DA9052
@@ -390,7 +389,6 @@ config MFD_DA9052_SPI
 
 config MFD_DA9052_I2C
 	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with I2C"
-	select IRQ_DOMAIN
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	select PMIC_DA9052
@@ -561,7 +559,6 @@ config MFD_WM8994
 	bool "Support Wolfson Microelectronics WM8994"
 	select MFD_CORE
 	select REGMAP_I2C
-	select IRQ_DOMAIN
 	select REGMAP_IRQ
 	depends on I2C=y && GENERIC_HARDIRQS
 	help
