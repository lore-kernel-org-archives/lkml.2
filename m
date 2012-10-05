Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2JEO4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:56:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58351 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab2JEO4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:56:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, Mike Rapoport <mike@compulab.co.il>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 14/16] ARM: pxa: armcore: fix PCI PIO warnings
Date: Fri,  5 Oct 2012 16:55:28 +0200
Message-Id: <1349448930-23976-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:UafO81VGNPEyXx9j+7dMuX0tKIkuxKmzg8Ieoa5rmeo
 uhEYMEMi5wfURsFitGVPF+lz/oJ/83ZpgaGcEet04H1vWKejnP
 +HoGXqToYD8ml4Rsrm2fDiek3rNPvNR2W/XdZ60tUtupLFSrU8
 nPpa+bR/2nUmcYrx5dyrh/V9OhU83GKc9K8vSmpMqm7WiLyRs1
 6GCFLOjovuUH2vSsaBH0GlDUt732pzEY/xWPAOtV38ML0VBFK2
 uCt7i8CDYcznCoqtIWtfJg9oK71azEV+5gLaLdpGeFwYmxIZqr
 Ux1odSICVGwQhVCo42L4U6GxyyogAKSrjZPr3Nu3W9yTF9QTJ0
 o4x62sngQDMVKHSpxLBp1KHvibbnNJA4JXg43K2SKQVj7Z4NBF
 T24Q4pc3/IsZNxwdjzO4eaSgk33OycwAig=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The it8152 PCI host used on the pxa/cm_x2xx machines
uses the old-style I/O window registration. This should
eventually get converted to pci_ioremap_io() but for
now, let's cast the IT8152_IO_BASE constant to an integer
type to get rid of the warnings.

Without this patch, building cm_x2xx_defconfig results in:

arch/arm/common/it8152.c: In function 'it8152_pci_setup':
arch/arm/common/it8152.c:287:18: warning: assignment makes integer from pointer without a cast [enabled by default]
arch/arm/common/it8152.c:288:16: warning: assignment makes integer from pointer without a cast [enabled by default]
arch/arm/common/it8152.c:291:17: warning: assignment makes integer from pointer without a cast [enabled by default]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Igor Grinberg <grinberg@compulab.co.il>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
---
 arch/arm/common/it8152.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/common/it8152.c b/arch/arm/common/it8152.c
index c4110d1..001f491 100644
--- a/arch/arm/common/it8152.c
+++ b/arch/arm/common/it8152.c
@@ -284,11 +284,17 @@ int dma_set_coherent_mask(struct device *dev, u64 mask)
 
 int __init it8152_pci_setup(int nr, struct pci_sys_data *sys)
 {
-	it8152_io.start = IT8152_IO_BASE + 0x12000;
-	it8152_io.end	= IT8152_IO_BASE + 0x12000 + 0x100000;
+	/*
+	 * FIXME: use pci_ioremap_io to remap the IO space here and
+	 * move over to the generic io.h implementation.
+	 * This requires solving the same problem for PXA PCMCIA
+	 * support.
+	 */
+	it8152_io.start = (unsigned long)IT8152_IO_BASE + 0x12000;
+	it8152_io.end	= (unsigned long)IT8152_IO_BASE + 0x12000 + 0x100000;
 
 	sys->mem_offset = 0x10000000;
-	sys->io_offset  = IT8152_IO_BASE;
+	sys->io_offset  = (unsigned long)IT8152_IO_BASE;
 
 	if (request_resource(&ioport_resource, &it8152_io)) {
 		printk(KERN_ERR "PCI: unable to allocate IO region\n");
-- 
1.7.10

