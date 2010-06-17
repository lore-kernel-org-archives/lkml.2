Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab0FQKJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 06:09:11 -0400
Received: from server78.greatnet.de ([83.133.96.102]:57668 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0FQKJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 06:09:08 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jun 2010 06:09:08 EDT
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: JosephChan@via.com.tw, ScottFang@viatech.com.cn
Cc: corbet@lwn.net, FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH] fbdev: section cleanup in viafb driver
Date: Thu, 17 Jun 2010 12:01:24 +0200
Message-Id: <1276768884-19958-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves two functions from .devexit to .text,
which are called on the probe error path.
Also a function which is called by probe is moved
from .text to .devinit.

WARNING: vmlinux.o(.devinit.text+0x2ca5): Section mismatch in reference
from the function via_pci_probe() to the function
.devexit.text:via_teardown_subdevs()
The function __devinit via_pci_probe() references
a function __devexit via_teardown_subdevs().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
via_teardown_subdevs() so it may be used outside an exit section.

WARNING: vmlinux.o(.devinit.text+0x2cb1): Section mismatch in reference
from the function via_pci_probe() to the function
.devexit.text:via_pci_teardown_mmio()
The function __devinit via_pci_probe() references
a function __devexit via_pci_teardown_mmio().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
via_pci_teardown_mmio() so it may be used outside an exit section.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
This patch is compile tested against Linus lastest git kernel.

 drivers/video/via/via-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index e8cfe83..ec2e5aa 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -64,7 +64,7 @@ static inline int viafb_mmio_read(int reg)
  */
 static u32 viafb_enabled_ints;
 
-static void viafb_int_init(void)
+static void __devinit viafb_int_init(void)
 {
 	viafb_enabled_ints = 0;
 
@@ -489,7 +489,7 @@ out_unmap:
 	return ret;
 }
 
-static void __devexit via_pci_teardown_mmio(struct viafb_dev *vdev)
+static void via_pci_teardown_mmio(struct viafb_dev *vdev)
 {
 	iounmap(vdev->fbmem);
 	iounmap(vdev->engine_mmio);
@@ -548,7 +548,7 @@ static int __devinit via_setup_subdevs(struct viafb_dev *vdev)
 	return 0;
 }
 
-static void __devexit via_teardown_subdevs(void)
+static void via_teardown_subdevs(void)
 {
 	int i;
 
-- 
1.7.0.4

