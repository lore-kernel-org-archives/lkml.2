Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2JOHAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:00:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40326 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab2JOHAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:00:47 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: martin.wilck@ts.fujitsu.com, kexec@lists.infradead.org, hbabu@us.ibm.com,
        andi@firstfloor.org, ddutile@redhat.com, vgoyal@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, mingo@redhat.com,
        Takao Indoh <indou.takao@jp.fujitsu.com>, khalid@gonehiking.org
Message-Id: <20121015065535.2832.76673.sendpatchset@indoh>
In-Reply-To: <20121015065516.2832.42378.sendpatchset@indoh>
References: <20121015065516.2832.42378.sendpatchset@indoh>
Subject: [PATCH v4 2/2] x86, pci: Enable PCI INTx when MSI is disabled
Date: Mon, 15 Oct 2012 16:00:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables INTx if MSI is disabled in pcibios_enable_device().
In normal case interrupt disable bit in command register is 0b on boot
time, but in case of kdump, this bit may be 1b. It causes problems of
some drivers. At leaset I confirmed mptsas driver does not work in such
a case. This patch fix this problem.

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 arch/x86/pci/common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 720e973..2bb7ecc 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -615,8 +615,10 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
 	if ((err = pci_enable_resources(dev, mask)) < 0)
 		return err;
 
-	if (!pci_dev_msi_enabled(dev))
+	if (!pci_dev_msi_enabled(dev)) {
+		pci_intx(dev, true);
 		return pcibios_enable_irq(dev);
+	}
 	return 0;
 }
 

