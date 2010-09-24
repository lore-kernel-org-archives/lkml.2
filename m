Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab0IXQbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:31:04 -0400
Received: from kroah.org ([198.145.64.141]:38575 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561Ab0IXQ25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:57 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:21 2010
Message-Id: <20100924162621.121568776@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Morten H. Larsen" <m-larsen@post6.tele.dk>,
        Matt Turner <mattst88@gmail.com>
Subject: [71/80] Fix call to replaced SuperIO functions
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Morten H. Larsen <m-larsen@post6.tele.dk>

commit 59b25ed91400ace98d6cf0d59b1cb6928ad5cd37 upstream.

This patch fixes the failure to compile Alpha Generic because of
previously overlooked calls to ns87312_enable_ide(). The function has
been replaced by newer SuperIO code.

Tested-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Morten H. Larsen <m-larsen@post6.tele.dk>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/alpha/kernel/proto.h         |    3 ---
 arch/alpha/kernel/sys_cabriolet.c |   19 ++++++++++++++++---
 arch/alpha/kernel/sys_takara.c    |   11 +++++++++--
 3 files changed, 25 insertions(+), 8 deletions(-)

--- a/arch/alpha/kernel/proto.h
+++ b/arch/alpha/kernel/proto.h
@@ -156,9 +156,6 @@ extern void SMC669_Init(int);
 /* es1888.c */
 extern void es1888_init(void);
 
-/* ns87312.c */
-extern void ns87312_enable_ide(long ide_base);
-
 /* ../lib/fpreg.c */
 extern void alpha_write_fp_reg (unsigned long reg, unsigned long val);
 extern unsigned long alpha_read_fp_reg (unsigned long reg);
--- a/arch/alpha/kernel/sys_cabriolet.c
+++ b/arch/alpha/kernel/sys_cabriolet.c
@@ -33,7 +33,7 @@
 #include "irq_impl.h"
 #include "pci_impl.h"
 #include "machvec_impl.h"
-
+#include "pc873xx.h"
 
 /* Note mask bit is true for DISABLED irqs.  */
 static unsigned long cached_irq_mask = ~0UL;
@@ -236,17 +236,30 @@ cabriolet_map_irq(struct pci_dev *dev, u
 }
 
 static inline void __init
+cabriolet_enable_ide(void)
+{
+	if (pc873xx_probe() == -1) {
+		printk(KERN_ERR "Probing for PC873xx Super IO chip failed.\n");
+	 } else {
+		printk(KERN_INFO "Found %s Super IO chip at 0x%x\n",
+			pc873xx_get_model(), pc873xx_get_base());
+
+		pc873xx_enable_ide();
+	}
+}
+
+static inline void __init
 cabriolet_init_pci(void)
 {
 	common_init_pci();
-	ns87312_enable_ide(0x398);
+	cabriolet_enable_ide();
 }
 
 static inline void __init
 cia_cab_init_pci(void)
 {
 	cia_init_pci();
-	ns87312_enable_ide(0x398);
+	cabriolet_enable_ide();
 }
 
 /*
--- a/arch/alpha/kernel/sys_takara.c
+++ b/arch/alpha/kernel/sys_takara.c
@@ -29,7 +29,7 @@
 #include "irq_impl.h"
 #include "pci_impl.h"
 #include "machvec_impl.h"
-
+#include "pc873xx.h"
 
 /* Note mask bit is true for DISABLED irqs.  */
 static unsigned long cached_irq_mask[2] = { -1, -1 };
@@ -264,7 +264,14 @@ takara_init_pci(void)
 		alpha_mv.pci_map_irq = takara_map_irq_srm;
 
 	cia_init_pci();
-	ns87312_enable_ide(0x26e);
+
+	if (pc873xx_probe() == -1) {
+		printk(KERN_ERR "Probing for PC873xx Super IO chip failed.\n");
+	} else {
+		printk(KERN_INFO "Found %s Super IO chip at 0x%x\n",
+			pc873xx_get_model(), pc873xx_get_base());
+		pc873xx_enable_ide();
+	}
 }
 
 


