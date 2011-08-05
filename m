Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1HEFiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 01:38:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:45413 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab1HEFit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 01:38:49 -0400
Date: Fri, 5 Aug 2011 05:38:38 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-5d5791af4c0d4fd32093882357506355c3357503@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        konrad.wilk@oracle.com, luto@mit.edu, tglx@linutronix.de,
        hpa@linux.intel.com, luto@mit.edu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, konrad.wilk@oracle.com, tglx@linutronix.de,
        hpa@linux.intel.com, luto@mit.edu
In-Reply-To: <4659478ed2f3480938f96491c2ecbe2b2e113a23.1312378163.git.luto@mit.edu>
References: <4659478ed2f3480938f96491c2ecbe2b2e113a23.1312378163.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64, xen: Enable the vvar mapping
Git-Commit-ID: 5d5791af4c0d4fd32093882357506355c3357503
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Aug 2011 05:38:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d5791af4c0d4fd32093882357506355c3357503
Gitweb:     http://git.kernel.org/tip/5d5791af4c0d4fd32093882357506355c3357503
Author:     Andy Lutomirski <luto@MIT.EDU>
AuthorDate: Wed, 3 Aug 2011 09:31:52 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 4 Aug 2011 16:13:47 -0700

x86-64, xen: Enable the vvar mapping

Xen needs to handle VVAR_PAGE, introduced in git commit:
9fd67b4ed0714ab718f1f9bd14c344af336a6df7
x86-64: Give vvars their own page

Otherwise we die during bootup with a message like:

(XEN) mm.c:940:d10 Error getting mfn 1888 (pfn 1e3e48) from L1 entry
      8000000001888465 for l1e_owner=10, pg_owner=10
(XEN) mm.c:5049:d10 ptwr_emulate: could not get_page_from_l1e()
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at (null)
[    0.000000] IP: [<ffffffff8103a930>] xen_set_pte+0x20/0xe0

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/4659478ed2f3480938f96491c2ecbe2b2e113a23.1312378163.git.luto@mit.edu
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/xen/mmu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 0ccccb6..2e78619 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1829,6 +1829,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 # endif
 #else
 	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
+	case VVAR_PAGE:
 #endif
 	case FIX_TEXT_POKE0:
 	case FIX_TEXT_POKE1:
@@ -1869,7 +1870,8 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #ifdef CONFIG_X86_64
 	/* Replicate changes to map the vsyscall page into the user
 	   pagetable vsyscall mapping. */
-	if (idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) {
+	if ((idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) ||
+	    idx == VVAR_PAGE) {
 		unsigned long vaddr = __fix_to_virt(idx);
 		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
 	}
