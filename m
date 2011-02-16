Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab1BPB13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:27:29 -0500
Received: from kroah.org ([198.145.64.141]:39477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757247Ab1BPAWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:22:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:39 2011
Message-Id: <20110216001439.340522638@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Mundt <lethal@linux-sh.org>
Subject: [143/272] sh: Fix up legacy PTEA space attribute mapping.
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Mundt <lethal@linux-sh.org>

commit efb3e34b6176d30c4fe8635fa8e1beb6280cc2cd upstream.

When p3_ioremap() was converted to ioremap_prot() there was some breakage
introduced where the 29-bit segmentation logic would trap the area range
and return an identity mapping without having allowed the area
specification to force mapping through page tables. This wires up a PCC
mask for pgprot verification to work out whether to short-circuit the
identity mapping on legacy parts, restoring the previous behaviour.

Reported-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sh/include/asm/io.h         |   10 +++++++++-
 arch/sh/include/asm/pgtable_32.h |    7 ++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -322,7 +322,15 @@ __ioremap_29bit(phys_addr_t offset, unsi
 	 * mapping must be done by the PMB or by using page tables.
 	 */
 	if (likely(PXSEG(offset) < P3SEG && PXSEG(last_addr) < P3SEG)) {
-		if (unlikely(pgprot_val(prot) & _PAGE_CACHABLE))
+		u64 flags = pgprot_val(prot);
+
+		/*
+		 * Anything using the legacy PTEA space attributes needs
+		 * to be kicked down to page table mappings.
+		 */
+		if (unlikely(flags & _PAGE_PCC_MASK))
+			return NULL;
+		if (unlikely(flags & _PAGE_CACHABLE))
 			return (void __iomem *)P1SEGADDR(offset);
 
 		return (void __iomem *)P2SEGADDR(offset);
--- a/arch/sh/include/asm/pgtable_32.h
+++ b/arch/sh/include/asm/pgtable_32.h
@@ -76,6 +76,10 @@
 /* Wrapper for extended mode pgprot twiddling */
 #define _PAGE_EXT(x)		((unsigned long long)(x) << 32)
 
+#ifdef CONFIG_X2TLB
+#define _PAGE_PCC_MASK	0x00000000	/* No legacy PTEA support */
+#else
+
 /* software: moves to PTEA.TC (Timing Control) */
 #define _PAGE_PCC_AREA5	0x00000000	/* use BSC registers for area5 */
 #define _PAGE_PCC_AREA6	0x80000000	/* use BSC registers for area6 */
@@ -89,7 +93,8 @@
 #define _PAGE_PCC_ATR8	0x60000000	/* Attribute Memory space, 8 bit bus */
 #define _PAGE_PCC_ATR16	0x60000001	/* Attribute Memory space, 6 bit bus */
 
-#ifndef CONFIG_X2TLB
+#define _PAGE_PCC_MASK	0xe0000001
+
 /* copy the ptea attributes */
 static inline unsigned long copy_ptea_attributes(unsigned long x)
 {


