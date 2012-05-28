Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab2E1DqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:46:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52039 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab2E1D32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:28 -0400
Message-Id: <20120528031212.118966848@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Weinberger <richard@nod.at>
Subject: [ 067/117] um: Implement a custom pte_same() function
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit f15b9000eb1d09bbaa4b0a6b2089d7e1f64e84b3 upstream.

UML uses the _PAGE_NEWPAGE flag to mark pages which are not jet
installed on the host side using mmap().
pte_same() has to ignore this flag, otherwise unuse_pte_range()
is unable to unuse the page because two identical
page tables entries with different _PAGE_NEWPAGE flags would not
match and swapoff() would never return.

Analyzed-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/um/include/asm/pgtable.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/um/include/asm/pgtable.h b/arch/um/include/asm/pgtable.h
index 6a3f984..294254e 100644
--- a/arch/um/include/asm/pgtable.h
+++ b/arch/um/include/asm/pgtable.h
@@ -273,6 +273,12 @@ static inline void set_pte(pte_t *pteptr, pte_t pteval)
 }
 #define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 
+#define __HAVE_ARCH_PTE_SAME
+static inline int pte_same(pte_t pte_a, pte_t pte_b)
+{
+	return !((pte_val(pte_a) ^ pte_val(pte_b)) & ~_PAGE_NEWPAGE);
+}
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.


