Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab0HUJaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:30:22 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36385 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab0HUJaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:30:19 -0400
Date: Sat, 21 Aug 2010 11:30:17 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/mn10300/mm: eliminate NULL dereference
Message-ID: <Pine.LNX.4.64.1008211129440.2637@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

dev_name always dereferences its argument, so it should not be called if
the argument is NULL.  The function indeed later tests the argument for
being NULL.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression dev,E;
@@

*dev_name(dev)
... when != dev = E
(
*dev == NULL
|
*dev != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/mn10300/mm/dma-alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mn10300/mm/dma-alloc.c b/arch/mn10300/mm/dma-alloc.c
index 4e34880..159acb0 100644
--- a/arch/mn10300/mm/dma-alloc.c
+++ b/arch/mn10300/mm/dma-alloc.c
@@ -25,7 +25,8 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 	unsigned long addr;
 	void *ret;
 
-	printk("dma_alloc_coherent(%s,%zu,,%x)\n", dev_name(dev), size, gfp);
+	pr_debug("dma_alloc_coherent(%s,%zu,%x)\n",
+		 dev ? dev_name(dev) : "?", size, gfp);
 
 	if (0xbe000000 - pci_sram_allocated >= size) {
 		size = (size + 255) & ~255;
