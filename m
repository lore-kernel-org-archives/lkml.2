Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0LSOdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 09:33:05 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:44533 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab0LSOdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 09:33:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IMZrwTzD/yC/N2pgbOLN3M0eETDFjqiNgMw0OtZC+D9Bz6sJTe7AcJiz4MDFBh6Qsy
         jC3UbJPiUnVB5n/6PWbe18mvv9IS29/q4X6axXXlq2AHe4+wjhCBaP3WPzERJv8+V4ke
         XzYw2d+qpl5lob/m//AMr5BcMLZWZdElOJFYQ=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: "Martin K. Petersen" <mkp@mkp.net>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zhangjin <wuzhangjin@gmail.com>, Zhang Le <r0bertz@gentoo.org>,
        Chen Jie <chenj@lemote.com>
Subject: [PATCH] [libata] pata_cs5536: Add support for non-X86_32 platforms
Date: Sun, 19 Dec 2010 22:32:40 +0800
Message-Id: <1292769160-24420-1-git-send-email-wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pata_cs5536 does work on the other platforms(e.g. Loongson, a MIPS
variant), so, remove the dependency of X86_32 and fix the building
errors under the other platforms via only reserving the X86_32 specific
parts for X86_32.

pata_amd also supports cs5536 IDE controller, but this one saves about
33k for the compressed kernel image(vmlinuz for MIPS).

Signed-off-by: Zhang Le <r0bertz@gentoo.org>
Signed-off-by: Chen Jie <chenj@lemote.com>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/ata/Kconfig       |    2 +-
 drivers/ata/pata_cs5536.c |   16 +++++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 11ec911..cfd04f4 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -366,7 +366,7 @@ config PATA_CS5535
 
 config PATA_CS5536
 	tristate "CS5536 PATA support"
-	depends on PCI && X86 && !X86_64
+	depends on PCI
 	help
 	  This option enables support for the AMD CS5536
 	  companion chip used with the Geode LX processor family.
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index 21ee23f..643488b 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -37,7 +37,17 @@
 #include <linux/delay.h>
 #include <linux/libata.h>
 #include <scsi/scsi_host.h>
+
+#ifdef CONFIG_X86_32
 #include <asm/msr.h>
+static int use_msr;
+module_param_named(msr, use_msr, int, 0644);
+MODULE_PARM_DESC(msr, "Force using MSR to configure IDE function (Default: 0)");
+#else
+#define rdmsr(x, y, z) do { } while (0)
+#define wrmsr(x, y, z) do { } while (0)
+#define use_msr 0
+#endif
 
 #define DRV_NAME	"pata_cs5536"
 #define DRV_VERSION	"0.0.7"
@@ -75,8 +85,6 @@ enum {
 	IDE_ETC_NODMA		= 0x03,
 };
 
-static int use_msr;
-
 static const u32 msr_reg[4] = {
 	MSR_IDE_CFG, MSR_IDE_DTC, MSR_IDE_CAST, MSR_IDE_ETC,
 };
@@ -88,7 +96,7 @@ static const u8 pci_reg[4] = {
 static inline int cs5536_read(struct pci_dev *pdev, int reg, u32 *val)
 {
 	if (unlikely(use_msr)) {
-		u32 dummy;
+		u32 dummy __maybe_unused;
 
 		rdmsr(msr_reg[reg], *val, dummy);
 		return 0;
@@ -294,8 +302,6 @@ MODULE_DESCRIPTION("low-level driver for the CS5536 IDE controller");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, cs5536);
 MODULE_VERSION(DRV_VERSION);
-module_param_named(msr, use_msr, int, 0644);
-MODULE_PARM_DESC(msr, "Force using MSR to configure IDE function (Default: 0)");
 
 module_init(cs5536_init);
 module_exit(cs5536_exit);
-- 
1.7.1

