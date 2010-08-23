Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab0HWNcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 09:32:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab0HWNcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:32:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] arch/mn10300/mm: eliminate NULL dereference
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>,
        David Howells <dhowells@redhat.com>
Date: Mon, 23 Aug 2010 14:31:34 +0100
Message-ID: <20100823133134.25674.77240.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/mm/dma-alloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


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

