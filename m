Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2JVEx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 00:53:29 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47402 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2JVEx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 00:53:28 -0400
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 12:53:27 +0800
Message-ID: <CAPgLHd9Y99XNvGfDxRGMpos_K=_GGv=Djrb=9HhGdj=8=xrBPg@mail.gmail.com>
Subject: [PATCH] ARM: PCI: fix missing unlock on error
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linux@arm.linux.org.uk
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock on the error handle path in function
nanoengine_read_config() and nanoengine_write_config().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-sa1100/pci-nanoengine.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-sa1100/pci-nanoengine.c b/arch/arm/mach-sa1100/pci-nanoengine.c
index ff02e2d..6ff07d7 100644
--- a/arch/arm/mach-sa1100/pci-nanoengine.c
+++ b/arch/arm/mach-sa1100/pci-nanoengine.c
@@ -67,8 +67,10 @@ static int nanoengine_read_config(struct pci_bus *bus, unsigned int devfn, int w
 	spin_lock_irqsave(&nano_lock, flags);
 
 	ret = nanoengine_get_pci_address(bus, devfn, where, &address);
-	if (ret != PCIBIOS_SUCCESSFUL)
+	if (ret != PCIBIOS_SUCCESSFUL) {
+		spin_unlock_irqrestore(&nano_lock, flags);
 		return ret;
+	}
 	v = __raw_readl(address);
 
 	spin_unlock_irqrestore(&nano_lock, flags);
@@ -95,8 +97,10 @@ static int nanoengine_write_config(struct pci_bus *bus, unsigned int devfn, int
 	spin_lock_irqsave(&nano_lock, flags);
 
 	ret = nanoengine_get_pci_address(bus, devfn, where, &address);
-	if (ret != PCIBIOS_SUCCESSFUL)
+	if (ret != PCIBIOS_SUCCESSFUL) {
+		spin_unlock_irqrestore(&nano_lock, flags);
 		return ret;
+	}
 	v = __raw_readl(address);
 	switch (size) {
 	case 1:


