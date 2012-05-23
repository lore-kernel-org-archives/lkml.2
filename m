Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870Ab2EWV2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 17:28:32 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:48032 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab2EWV2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 17:28:31 -0400
Date: Wed, 23 May 2012 23:28:21 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: x86@kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, linux-kernel@vger.kernel.org
Subject: [PATCH V2] x86/pci: sta2x11: fix a compiler warning
Message-ID: <20120523212821.GA10425@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb_free_coherent(), exported by lib/swiotlb.b, cannot be used in
dma_ops, because it doesn't want the "attrs" argument.  Add a wrapper,
like other users of the function already do.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---

[V2: same patch, message fixed (sorry, I made a mess in the editor)]

Actually, we may instead add "args" to the exported functions in
lib/swiotlb.  This would then remove a few other similar wrappers that
do nothing.  If it's considered useful, I can propose a patch for that.
arch/unicore32/mm/dma-swiotlb.c is especially interesting in this
respect, because it only has the two wrappers.

 arch/x86/pci/sta2x11-fixup.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index e06334b..1ab70dc 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -181,10 +181,17 @@ static void *sta2x11_swiotlb_alloc_coherent(struct device *dev,
 	return vaddr;
 }
 
+static void sta2x11_swiotlb_free_coherent(struct device *dev, size_t size,
+					  void *vaddr, dma_addr_t dma_addr,
+					  struct dma_attrs *attrs)
+{
+	swiotlb_free_coherent(dev, size, vaddr, dma_addr);
+}
+
 /* We have our own dma_ops: the same as swiotlb but from alloc (above) */
 static struct dma_map_ops sta2x11_dma_ops = {
 	.alloc = sta2x11_swiotlb_alloc_coherent,
-	.free = swiotlb_free_coherent,
+	.free = sta2x11_swiotlb_free_coherent,
 	.map_page = swiotlb_map_page,
 	.unmap_page = swiotlb_unmap_page,
 	.map_sg = swiotlb_map_sg_attrs,
-- 
1.7.7.2
