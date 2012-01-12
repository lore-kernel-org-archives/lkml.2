Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab2ALJzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:55:38 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41675 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab2ALJzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:55:33 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 12/15] arch/powerpc/sysdev/fsl_pci.c: add missing iounmap
Date: Thu, 12 Jan 2012 10:55:14 +0100
Message-Id: <1326362117-29371-12-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add missing iounmap in error handling code, in a case where the function
already preforms iounmap on some other execution path.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
statement S,S1;
int ret;
@@
e = \(ioremap\|ioremap_nocache\)(...)
... when != iounmap(e)
if (<+...e...+>) S
... when any
    when != iounmap(e)
*if (...)
   { ... when != iounmap(e)
     return ...; }
... when any
iounmap(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/powerpc/sysdev/fsl_pci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 4ce547e..bb025da 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -179,12 +179,12 @@ static void __init setup_pci_atmu(struct pci_controller *hose,
 
 	if (paddr_hi == paddr_lo) {
 		pr_err("%s: No outbound window space\n", name);
-		return ;
+		goto out;
 	}
 
 	if (paddr_lo == 0) {
 		pr_err("%s: No space for inbound window\n", name);
-		return ;
+		goto out;
 	}
 
 	/* setup PCSRBAR/PEXCSRBAR */
@@ -273,6 +273,7 @@ static void __init setup_pci_atmu(struct pci_controller *hose,
 			(u64)hose->dma_window_size);
 	}
 
+out:
 	iounmap(pci);
 }
 

