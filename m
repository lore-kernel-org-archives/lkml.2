Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2DNPw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 11:52:28 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab2DNPwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 11:52:22 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, hughd@google.com,
        Richard Weinberger <richard@nod.at>, stable@kernel.org
Subject: [PATCH 1/2] um: Implement a custom pte_same() function
Date: Sat, 14 Apr 2012 17:52:10 +0200
Message-Id: <1334418731-16498-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML uses the _PAGE_NEWPAGE flag to mark pages which are not jet
installed on the host side using mmap().
pte_same() has to ignore this flag, otherwise unuse_pte_range()
is unable to unuse the page because two identical
page tables entries with different _PAGE_NEWPAGE flags would not
match and swapoff() would never return.

CC: stable@kernel.org
Analyzed-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/pgtable.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

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
-- 
1.7.7.3

