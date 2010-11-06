Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0KFJHD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 05:07:03 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:38016 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab0KFJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 05:07:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH] x86: pci/xen, fix memory leak
Date: Sat,  6 Nov 2010 10:06:49 +0100
Message-Id: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that xen_setup_msi_irqs leaks memory when
xen_allocate_pirq fails. Free the memory in that fail path.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/pci/xen.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 117f5b8..d7b5109 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -147,8 +147,10 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		irq = xen_allocate_pirq(v[i], 0, /* not sharable */
 			(type == PCI_CAP_ID_MSIX) ?
 			"pcifront-msi-x" : "pcifront-msi");
-		if (irq < 0)
-			return -1;
+		if (irq < 0) {
+			ret = -1;
+			goto free;
+		}
 
 		ret = set_irq_msi(irq, msidesc);
 		if (ret)
@@ -164,7 +166,7 @@ error:
 	if (ret == -ENODEV)
 		dev_err(&dev->dev, "Xen PCI frontend has not registered" \
 			" MSI/MSI-X support!\n");
-
+free:
 	kfree(v);
 	return ret;
 }
-- 
1.7.3.1


