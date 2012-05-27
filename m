Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2E0A6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 20:58:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56104 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2E0A6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:58:39 -0400
Message-Id: <20120527002617.052179824@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:34 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Weinberger <richard@nod.at>
Subject: [ 21/55] um: Implement a custom pte_same() function
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/um/include/asm/pgtable.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/um/include/asm/pgtable.h
+++ b/arch/um/include/asm/pgtable.h
@@ -271,6 +271,12 @@ static inline void set_pte(pte_t *pteptr
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


