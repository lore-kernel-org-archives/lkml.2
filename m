Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab1HCNcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:32:42 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:59062 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754828Ab1HCNcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:32:20 -0400
X-AuditID: 12074423-b7b31ae000000a3c-dd-4e394de7bbfe
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jeremy@goop.org,
        keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 4/6] x86-64/xen: Enable the vvar mapping
Date: Wed,  3 Aug 2011 09:31:52 -0400
Message-Id: <4659478ed2f3480938f96491c2ecbe2b2e113a23.1312378163.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
In-Reply-To: <cover.1312378163.git.luto@mit.edu>
References: <cover.1312378163.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsUixCmqrPvc19LPYOUhHYu+K0fZLR7Ne8Rq
	MXXZXFaLZYufMlpc3jWHzWL52XlsFj82PGa1uDflPbsDh8fOWXfZPTZfXM3ksWlVJ5vH5BvL
	GT229+1i9/j49BaLx+dNcgHsUVw2Kak5mWWpRfp2CVwZN78nFJzgqfj+iKOBcR1XFyMnh4SA
	icSlT1/ZIWwxiQv31rOB2EIC+xgl2m64dzFyAdnrGSXuXb3GDOE8ZZL4MfsIWAebgIpEx9IH
	TCC2iICTROuEj0wgRcwCzxglNh09wwySEBawlpj56iiYzSKgKtHWd5YFxOYVCJJ4ePcBG8Rq
	OYkjl5+DDeIUMJBYteA5UA0H0DZ9iQdr8nEIT2AUWMDIsIpRNiW3Sjc3MTOnODVZtzg5MS8v
	tUjXTC83s0QvNaV0EyMojNldlHcw/jmodIhRgINRiYeXUd7CT4g1say4MvcQoyQHk5Io73Iv
	Sz8hvqT8lMqMxOKM+KLSnNTiQ4wSHMxKIrztvEA53pTEyqrUonyYlDQHi5I4b673f18hgfTE
	ktTs1NSC1CKYrA4Hh8DZ22+5BVpm/w2XYsnLz0tVkuDlB8azkGBRanpqRVpmTglCORMHJ8gy
	HqBlNiA1vMUFibnFmekQ+VOMuhxXJxw+yigENkhKnNcQpEgApCijNA9uDiw9vWIUB3pTmJcB
	pIoHmNrgJr0CWsIEtOT/ewuQJSWJCCmpBsb6F0UF/n0LhfhV9QrfB9u9sLStO+d7cQ+fzIXF
	vksnXfnQsu783cosJ6HgRQ0qe9e94Ljt0jVb5O+Xxw8azaZUimVw/PEsDqupOfnoj1bwrmTl
	7WveC0WX9r8NnapmXrqm7IJJoZTEtCWH9mWWf8zO561WO+te8+eAs+EUecbUziXffc+1FSqx
	FGckGmoxFxUnAgA88RVXKgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f987bde..8cce339 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1916,6 +1916,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 # endif
 #else
 	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
+	case VVAR_PAGE:
 #endif
 	case FIX_TEXT_POKE0:
 	case FIX_TEXT_POKE1:
@@ -1956,7 +1957,8 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #ifdef CONFIG_X86_64
 	/* Replicate changes to map the vsyscall page into the user
 	   pagetable vsyscall mapping. */
-	if (idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) {
+	if ((idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) ||
+	    idx == VVAR_PAGE) {
 		unsigned long vaddr = __fix_to_virt(idx);
 		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
 	}
-- 
1.7.6

