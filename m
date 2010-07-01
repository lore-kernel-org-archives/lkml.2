Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab0GAVQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:16:07 -0400
Received: from kroah.org ([198.145.64.141]:60923 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759001Ab0GAVNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:52 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:53 2010
Message-Id: <20100701174253.175571610@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Li Yang <leoli@freescale.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Kumar Gala <galak@kernel.crashing.org>
Subject: [080/200] powerpc: Fix ioremap_flags() with book3e pte definition
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 55052eeca6d71d76f7c3f156c0501814d8e5e6d3 upstream.

We can't just clear the user read permission in book3e pte, because
that will also clear supervisor read permission.  This surely isn't
desired.  Fix the problem by adding the supervisor read back.

BenH: Slightly simplified the ifdef and applied to ppc64 too

Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/pgtable_32.c |    8 ++++++++
 arch/powerpc/mm/pgtable_64.c |    8 ++++++++
 2 files changed, 16 insertions(+)

--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -146,6 +146,14 @@ ioremap_flags(phys_addr_t addr, unsigned
 	/* we don't want to let _PAGE_USER and _PAGE_EXEC leak out */
 	flags &= ~(_PAGE_USER | _PAGE_EXEC);
 
+#ifdef _PAGE_BAP_SR
+	/* _PAGE_USER contains _PAGE_BAP_SR on BookE using the new PTE format
+	 * which means that we just cleared supervisor access... oops ;-) This
+	 * restores it
+	 */
+	flags |= _PAGE_BAP_SR;
+#endif
+
 	return __ioremap_caller(addr, size, flags, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_flags);
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -265,6 +265,14 @@ void __iomem * ioremap_flags(phys_addr_t
 	/* we don't want to let _PAGE_USER and _PAGE_EXEC leak out */
 	flags &= ~(_PAGE_USER | _PAGE_EXEC);
 
+#ifdef _PAGE_BAP_SR
+	/* _PAGE_USER contains _PAGE_BAP_SR on BookE using the new PTE format
+	 * which means that we just cleared supervisor access... oops ;-) This
+	 * restores it
+	 */
+	flags |= _PAGE_BAP_SR;
+#endif
+
 	if (ppc_md.ioremap)
 		return ppc_md.ioremap(addr, size, flags, caller);
 	return __ioremap_caller(addr, size, flags, caller);


