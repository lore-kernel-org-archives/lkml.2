Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab1GASnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:43:55 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:49479 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753462Ab1GASnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:43:52 -0400
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: [PATCH] mtrr: use pci_dev->revision
Content-Disposition: inline
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
Cc: linux-kernel@vger.kernel.org
Date: Fri, 1 Jul 2011 22:42:08 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107012242.08347.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it wasn't
converted by commit 44c10138fd4bbc4b6d6bff0873c24902f2a9da65 (PCI: Change all
drivers to use pci_device->revision) before being moved to arch/x86/...

Do it now at last -- and save one level of indentation...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.

 arch/x86/kernel/cpu/mtrr/main.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -79,7 +79,6 @@ void set_mtrr_ops(const struct mtrr_ops 
 static int have_wrcomb(void)
 {
 	struct pci_dev *dev;
-	u8 rev;
 
 	dev = pci_get_class(PCI_CLASS_BRIDGE_HOST << 8, NULL);
 	if (dev != NULL) {
@@ -89,13 +88,11 @@ static int have_wrcomb(void)
 		 * chipsets to be tagged
 		 */
 		if (dev->vendor == PCI_VENDOR_ID_SERVERWORKS &&
-		    dev->device == PCI_DEVICE_ID_SERVERWORKS_LE) {
-			pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
-			if (rev <= 5) {
-				pr_info("mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.\n");
-				pci_dev_put(dev);
-				return 0;
-			}
+		    dev->device == PCI_DEVICE_ID_SERVERWORKS_LE &&
+		    dev->revision <= 5) {
+			pr_info("mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.\n");
+			pci_dev_put(dev);
+			return 0;
 		}
 		/*
 		 * Intel 450NX errata # 23. Non ascending cacheline evictions to
