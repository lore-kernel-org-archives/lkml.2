Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab0FORRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:17:23 -0400
Received: from rain.florz.de ([62.216.164.86]:59028 "EHLO
	rain.florz.dyndns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754383Ab0FORRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:17:21 -0400
Date: Tue, 15 Jun 2010 18:53:54 +0200
From: Florian Zumbiehl <florz@florz.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Wrong page aligned size calculation in ioremapping code
Message-ID: <20100615165353.GA15436@florz.florz.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

over the years since when I last reported this (and then lost track of it)
this has been fixed in most places/architectures - but two instances still
remain (or have appeared newly?), so here is the fix, and this time
I'm gonna make sure it gets applied ;-)

The patch is untested, but I guess it's simple enough ...

Florian
---------------------------------------------------------------------------
parisc __ioremap()/x86 early_iounmap(): fix off-by-one error in page
alignment of allocation size for sizes where size%PAGE_SIZE==1.

Signed-off-by: Florian Zumbiehl <florz@florz.de>

diff --git a/arch/parisc/mm/ioremap.c b/arch/parisc/mm/ioremap.c
index 92d496a..838d025 100644
--- a/arch/parisc/mm/ioremap.c
+++ b/arch/parisc/mm/ioremap.c
@@ -71,7 +71,7 @@ void __iomem * __ioremap(unsigned long phys_addr, unsigned long size, unsigned l
 	 */
 	offset = phys_addr & ~PAGE_MASK;
 	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr) - phys_addr;
+	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
 
 	/*
 	 * Ok, go for it..
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 12e4d2d..a4643e5 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -613,7 +613,7 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 		return;
 	}
 	offset = virt_addr & ~PAGE_MASK;
-	nrpages = PAGE_ALIGN(offset + size - 1) >> PAGE_SHIFT;
+	nrpages = PAGE_ALIGN(offset + size) >> PAGE_SHIFT;
 
 	idx = FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*slot;
 	while (nrpages > 0) {
