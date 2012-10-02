Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab2JBQlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:41:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50557 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab2JBQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:37:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 10/17] ARM: s3c24xx: fix multiple section mismatch warnings
Date: Tue,  2 Oct 2012 18:36:49 +0200
Message-Id: <1349195816-2225-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349195816-2225-1-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:DdiIwiYvzWkgNbI/HIxJ/RxdHgAgwD7RE0P1/zi//MB
 KpHl+VH7TFKasrXtdOGg6Ziw98tiaCFf7EgYyi+gC3/lrgAgoW
 PNr50pi9lM7o5vXJPCV7OIUHaFEt6ruHYe7UV9afZmjht+quOq
 Ha74DI0+Kh6un9GrzcxSEBt7TskrpY9zL9AeYLxN6OAiDgv6dx
 IEtH//K45i+QwRB+kjV5BAKuUL57Yoq4Hb74utK9hqFVl1Ss3x
 L81akPXHlOg0ZqKxvKqvtjYJ/vmD7SdgEE/1BhECzoZOVYtWLN
 ViKlLMJ/Tgwy9W3UCyygRCxovz4mxlN41oHovQcUHglSvI6o52
 2pi5+FtuIQ15oPfloVp9tDcN0A/LprAhoimy07hGIJ+LLtm5mz
 FeDp56i740uhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The *_irq_add function should not be marked __init because the driver
subsystem thinks they might be called at a later stage.

The usb_simtec_init function accesses initdata and should be marked
init. This is safe because the only caller is also an init function.

Without this patch, building s3c2410_defconfig results in:

WARNING: arch/arm/mach-s3c24xx/built-in.o(.data+0x1030): Section mismatch in reference from the variable s3c2416_irq_interface to the function .init.text:s3c2416_irq_add()
The variable s3c2416_irq_interface references
the function __init s3c2416_irq_add()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

WARNING: arch/arm/mach-s3c24xx/built-in.o(.data+0x1b08): Section mismatch in reference from the variable s3c2443_irq_interface to the function .init.text:s3c2443_irq_add()
The variable s3c2443_irq_interface references
the function __init s3c2443_irq_add()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

WARNING: arch/arm/mach-s3c24xx/built-in.o(.data+0xf44): Section mismatch in reference from the variable s3c2416_irq_interface to the function .init.text:s3c2416_irq_add()
The variable s3c2416_irq_interface references
the function __init s3c2416_irq_add()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

WARNING: arch/arm/mach-s3c24xx/built-in.o(.text+0x3f7c): Section mismatch in reference from the function usb_simtec_init() to the (unknown reference) .init.data:(unknown)
The function usb_simtec_init() references
the (unknown reference) __initdata (unknown).
This is often because usb_simtec_init lacks a __initdata
annotation or the annotation of (unknown) is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-s3c24xx/irq-s3c2416.c |    6 +++---
 arch/arm/mach-s3c24xx/irq-s3c2443.c |    4 ++--
 arch/arm/mach-s3c24xx/simtec-usb.c  |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/irq-s3c2416.c b/arch/arm/mach-s3c24xx/irq-s3c2416.c
index 23ec973..ff141b0 100644
--- a/arch/arm/mach-s3c24xx/irq-s3c2416.c
+++ b/arch/arm/mach-s3c24xx/irq-s3c2416.c
@@ -232,7 +232,7 @@ struct irq_chip s3c2416_irq_second = {
 
 /* IRQ initialisation code */
 
-static int __init s3c2416_add_sub(unsigned int base,
+static int s3c2416_add_sub(unsigned int base,
 				   void (*demux)(unsigned int,
 						 struct irq_desc *),
 				   struct irq_chip *chip,
@@ -251,7 +251,7 @@ static int __init s3c2416_add_sub(unsigned int base,
 	return 0;
 }
 
-static void __init s3c2416_irq_add_second(void)
+static void s3c2416_irq_add_second(void)
 {
 	unsigned long pend;
 	unsigned long last;
@@ -287,7 +287,7 @@ static void __init s3c2416_irq_add_second(void)
 	}
 }
 
-static int __init s3c2416_irq_add(struct device *dev,
+static int s3c2416_irq_add(struct device *dev,
 				  struct subsys_interface *sif)
 {
 	printk(KERN_INFO "S3C2416: IRQ Support\n");
diff --git a/arch/arm/mach-s3c24xx/irq-s3c2443.c b/arch/arm/mach-s3c24xx/irq-s3c2443.c
index ac2829f..5e69109 100644
--- a/arch/arm/mach-s3c24xx/irq-s3c2443.c
+++ b/arch/arm/mach-s3c24xx/irq-s3c2443.c
@@ -222,7 +222,7 @@ static struct irq_chip s3c2443_irq_cam = {
 
 /* IRQ initialisation code */
 
-static int __init s3c2443_add_sub(unsigned int base,
+static int s3c2443_add_sub(unsigned int base,
 				   void (*demux)(unsigned int,
 						 struct irq_desc *),
 				   struct irq_chip *chip,
@@ -241,7 +241,7 @@ static int __init s3c2443_add_sub(unsigned int base,
 	return 0;
 }
 
-static int __init s3c2443_irq_add(struct device *dev,
+static int s3c2443_irq_add(struct device *dev,
 				  struct subsys_interface *sif)
 {
 	printk("S3C2443: IRQ Support\n");
diff --git a/arch/arm/mach-s3c24xx/simtec-usb.c b/arch/arm/mach-s3c24xx/simtec-usb.c
index d91c1a7..c303d1b 100644
--- a/arch/arm/mach-s3c24xx/simtec-usb.c
+++ b/arch/arm/mach-s3c24xx/simtec-usb.c
@@ -104,7 +104,7 @@ static struct s3c2410_hcd_info usb_simtec_info __initdata = {
 };
 
 
-int usb_simtec_init(void)
+int __init usb_simtec_init(void)
 {
 	int ret;
 
-- 
1.7.10

