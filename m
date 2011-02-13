Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1BMLvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 06:51:35 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:58501 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab1BMLul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 06:50:41 -0500
From: Julia Lawall <julia@diku.dk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel-janitors@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] arch/x86/pci/direct.c: Convert release_resource to release_region/release_mem_region
Date: Sun, 13 Feb 2011 13:12:11 +0100
Message-Id: <1297599132-7226-5-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297599132-7226-1-git-send-email-julia@diku.dk>
References: <1297599132-7226-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request_region should be used with release_region, not release_resource.

The local variables region and region2 are dropped and the calls to
release_resource are replaced with calls to release_region, using the first
two arguments of the corresponding calls to request_region.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,E;
@@
(
*x = request_region(...)
|
*x = request_mem_region(...)
)
... when != release_region(x)
    when != x = E
* release_resource(x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Compiled, not tested.

 arch/x86/pci/direct.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index bd33620..e6fd847 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -280,12 +280,9 @@ void __init pci_direct_init(int type)
 
 int __init pci_direct_probe(void)
 {
-	struct resource *region, *region2;
-
 	if ((pci_probe & PCI_PROBE_CONF1) == 0)
 		goto type2;
-	region = request_region(0xCF8, 8, "PCI conf1");
-	if (!region)
+	if (!request_region(0xCF8, 8, "PCI conf1"))
 		goto type2;
 
 	if (pci_check_type1()) {
@@ -293,16 +290,14 @@ int __init pci_direct_probe(void)
 		port_cf9_safe = true;
 		return 1;
 	}
-	release_resource(region);
+	release_region(0xCF8, 8);
 
  type2:
 	if ((pci_probe & PCI_PROBE_CONF2) == 0)
 		return 0;
-	region = request_region(0xCF8, 4, "PCI conf2");
-	if (!region)
+	if (!request_region(0xCF8, 4, "PCI conf2"))
 		return 0;
-	region2 = request_region(0xC000, 0x1000, "PCI conf2");
-	if (!region2)
+	if (!request_region(0xC000, 0x1000, "PCI conf2"))
 		goto fail2;
 
 	if (pci_check_type2()) {
@@ -311,8 +306,8 @@ int __init pci_direct_probe(void)
 		return 2;
 	}
 
-	release_resource(region2);
+	release_region(0xC000, 0x1000);
  fail2:
-	release_resource(region);
+	release_region(0xCF8, 4);
 	return 0;
 }

