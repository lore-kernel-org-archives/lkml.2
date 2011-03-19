Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab1CSTiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 15:38:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:43284 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab1CSTh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 15:37:58 -0400
Date: Sat, 19 Mar 2011 19:37:44 GMT
From: tip-bot for Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, tglx@linutronix.de,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
References: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] xen: update mask_rw_pte after kernel page tables init changes
Message-ID: <tip-d8aa5ec3382e6a545b8f25178d1e0992d4927f19@git.kernel.org>
Git-Commit-ID: d8aa5ec3382e6a545b8f25178d1e0992d4927f19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Mar 2011 19:37:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8aa5ec3382e6a545b8f25178d1e0992d4927f19
Gitweb:     http://git.kernel.org/tip/d8aa5ec3382e6a545b8f25178d1e0992d4927f19
Author:     Stefano Stabellini <stefano.stabellini@eu.citrix.com>
AuthorDate: Wed, 9 Mar 2011 14:22:05 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 19 Mar 2011 11:58:28 -0700

xen: update mask_rw_pte after kernel page tables init changes

After "x86-64, mm: Put early page table high" already existing kernel
page table pages can be mapped using early_ioremap too so we need to
update mask_rw_pte to make sure these pages are still mapped RO.
The reason why we have to do that is explain by the commit message of
fef5ba797991f9335bcfc295942b684f9bf613a1:

"Xen requires that all pages containing pagetable entries to be mapped
read-only.  If pages used for the initial pagetable are already mapped
then we can change the mapping to RO.  However, if they are initially
unmapped, we need to make sure that when they are later mapped, they
are also mapped RO.

..SNIP..

the pagetable setup code early_ioremaps the pages to write their
entries, so we must make sure that mappings created in the early_ioremap
fixmap area are mapped RW.  (Those mappings are removed before the pages
are presented to Xen as pagetable pages.)"

We accomplish all this in mask_rw_pte by mapping RO all the pages mapped
using early_ioremap apart from the last one that has been allocated
because it is not a page table page yet (it has not been hooked into the
page tables yet).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
LKML-Reference: <alpine.DEB.2.00.1103171739050.3382@kaball-desktop>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/xen/mmu.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6e27979..21058ad 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1488,10 +1488,12 @@ static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 	/*
 	 * If the new pfn is within the range of the newly allocated
 	 * kernel pagetable, and it isn't being mapped into an
-	 * early_ioremap fixmap slot, make sure it is RO.
+	 * early_ioremap fixmap slot as a freshly allocated page, make sure
+	 * it is RO.
 	 */
-	if (!is_early_ioremap_ptep(ptep) &&
-	    pfn >= pgt_buf_start && pfn < pgt_buf_end)
+	if (((!is_early_ioremap_ptep(ptep) &&
+			pfn >= pgt_buf_start && pfn < pgt_buf_end)) ||
+			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
 		pte = pte_wrprotect(pte);
 
 	return pte;
