Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2JPBA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:00:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39249 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2JPBA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:00:56 -0400
Date: Tue, 16 Oct 2012 12:00:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20121016120041.57f0bb718ca0389707dc3083@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Oct_2012_12_00_41_+1100_F.gQOPAC.X0AuRjy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Oct_2012_12_00_41_+1100_F.gQOPAC.X0AuRjy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
mm/huge_memory.c between commit 325adeb55e32 ("mm: huge_memory: Fix build
error") from Linus' tree and commit 39d6cb39a817 ("mm/mpol: Use special
PROT_NONE to migrate pages") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc mm/huge_memory.c
index 40f17c3,d14c8b2..0000000
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@@ -17,7 -17,7 +17,8 @@@
  #include <linux/khugepaged.h>
  #include <linux/freezer.h>
  #include <linux/mman.h>
 +#include <linux/pagemap.h>
+ #include <linux/migrate.h>
  #include <asm/tlb.h>
  #include <asm/pgalloc.h>
  #include "internal.h"
@@@ -1347,59 -1428,55 +1418,54 @@@ static int __split_huge_page_map(struc
  	spin_lock(&mm->page_table_lock);
  	pmd =3D page_check_address_pmd(page, mm, address,
  				     PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG);
- 	if (pmd) {
- 		pgtable =3D pgtable_trans_huge_withdraw(mm);
- 		pmd_populate(mm, &_pmd, pgtable);
-=20
- 		haddr =3D address;
- 		for (i =3D 0; i < HPAGE_PMD_NR; i++, haddr +=3D PAGE_SIZE) {
- 			pte_t *pte, entry;
- 			BUG_ON(PageCompound(page+i));
- 			entry =3D mk_pte(page + i, vma->vm_page_prot);
- 			entry =3D maybe_mkwrite(pte_mkdirty(entry), vma);
- 			if (!pmd_write(*pmd))
- 				entry =3D pte_wrprotect(entry);
- 			else
- 				BUG_ON(page_mapcount(page) !=3D 1);
- 			if (!pmd_young(*pmd))
- 				entry =3D pte_mkold(entry);
- 			pte =3D pte_offset_map(&_pmd, haddr);
- 			BUG_ON(!pte_none(*pte));
- 			set_pte_at(mm, haddr, pte, entry);
- 			pte_unmap(pte);
- 		}
+ 	if (!pmd)
+ 		goto unlock;
 =20
- 		smp_wmb(); /* make pte visible before pmd */
- 		/*
- 		 * Up to this point the pmd is present and huge and
- 		 * userland has the whole access to the hugepage
- 		 * during the split (which happens in place). If we
- 		 * overwrite the pmd with the not-huge version
- 		 * pointing to the pte here (which of course we could
- 		 * if all CPUs were bug free), userland could trigger
- 		 * a small page size TLB miss on the small sized TLB
- 		 * while the hugepage TLB entry is still established
- 		 * in the huge TLB. Some CPU doesn't like that. See
- 		 * http://support.amd.com/us/Processor_TechDocs/41322.pdf,
- 		 * Erratum 383 on page 93. Intel should be safe but is
- 		 * also warns that it's only safe if the permission
- 		 * and cache attributes of the two entries loaded in
- 		 * the two TLB is identical (which should be the case
- 		 * here). But it is generally safer to never allow
- 		 * small and huge TLB entries for the same virtual
- 		 * address to be loaded simultaneously. So instead of
- 		 * doing "pmd_populate(); flush_tlb_range();" we first
- 		 * mark the current pmd notpresent (atomically because
- 		 * here the pmd_trans_huge and pmd_trans_splitting
- 		 * must remain set at all times on the pmd until the
- 		 * split is complete for this pmd), then we flush the
- 		 * SMP TLB and finally we write the non-huge version
- 		 * of the pmd entry with pmd_populate.
- 		 */
- 		pmdp_invalidate(vma, address, pmd);
- 		pmd_populate(mm, pmd, pgtable);
- 		ret =3D 1;
+ 	prot =3D pmd_pgprot(*pmd);
 -	pgtable =3D get_pmd_huge_pte(mm);
++	pgtable =3D pgtable_trans_huge_withdraw(mm);
+ 	pmd_populate(mm, &_pmd, pgtable);
+=20
+ 	for (i =3D 0, haddr =3D address; i < HPAGE_PMD_NR; i++, haddr +=3D PAGE_=
SIZE) {
+ 		pte_t *pte, entry;
+=20
+ 		BUG_ON(PageCompound(page+i));
+ 		entry =3D mk_pte(page + i, prot);
+ 		entry =3D pte_mkdirty(entry);
+ 		if (!pmd_young(*pmd))
+ 			entry =3D pte_mkold(entry);
+ 		pte =3D pte_offset_map(&_pmd, haddr);
+ 		BUG_ON(!pte_none(*pte));
+ 		set_pte_at(mm, haddr, pte, entry);
+ 		pte_unmap(pte);
  	}
+=20
+ 	smp_wmb(); /* make ptes visible before pmd, see __pte_alloc */
+ 	/*
+ 	 * Up to this point the pmd is present and huge.
+ 	 *
+ 	 * If we overwrite the pmd with the not-huge version, we could trigger
+ 	 * a small page size TLB miss on the small sized TLB while the hugepage
+ 	 * TLB entry is still established in the huge TLB.
+ 	 *
+ 	 * Some CPUs don't like that. See
+ 	 * http://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum 383
+ 	 * on page 93.
+ 	 *
+ 	 * Thus it is generally safer to never allow small and huge TLB entries
+ 	 * for overlapping virtual addresses to be loaded. So we first mark the
+ 	 * current pmd not present, then we flush the TLB and finally we write
+ 	 * the non-huge version of the pmd entry with pmd_populate.
+ 	 *
+ 	 * The above needs to be done under the ptl because pmd_trans_huge and
+ 	 * pmd_trans_splitting must remain set on the pmd until the split is
+ 	 * complete. The ptl also protects against concurrent faults due to
+ 	 * making the pmd not-present.
+ 	 */
 -	set_pmd_at(mm, address, pmd, pmd_mknotpresent(*pmd));
 -	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
++	pmdp_invalidate(vma, address, pmd);
+ 	pmd_populate(mm, pmd, pgtable);
+ 	ret =3D 1;
+=20
+ unlock:
  	spin_unlock(&mm->page_table_lock);
 =20
  	return ret;
@@@ -2280,23 -2300,30 +2346,21 @@@ static int khugepaged_has_work(void
  static int khugepaged_wait_event(void)
  {
  	return !list_empty(&khugepaged_scan.mm_head) ||
 -		!khugepaged_enabled();
 +		kthread_should_stop();
  }
 =20
 -static void khugepaged_do_scan(struct page **hpage)
 +static void khugepaged_do_scan(void)
  {
 +	struct page *hpage =3D NULL;
  	unsigned int progress =3D 0, pass_through_head =3D 0;
- 	unsigned int pages =3D khugepaged_pages_to_scan;
+ 	unsigned int pages =3D ACCESS_ONCE(khugepaged_pages_to_scan);
 +	bool wait =3D true;
 =20
- 	barrier(); /* write khugepaged_pages_to_scan to local stack */
-=20
  	while (progress < pages) {
 -		cond_resched();
 -
 -#ifndef CONFIG_NUMA
 -		if (!*hpage) {
 -			*hpage =3D alloc_hugepage(khugepaged_defrag());
 -			if (unlikely(!*hpage)) {
 -				count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 -				break;
 -			}
 -			count_vm_event(THP_COLLAPSE_ALLOC);
 -		}
 -#else
 -		if (IS_ERR(*hpage))
 +		if (!khugepaged_prealloc_page(&hpage, &wait))
  			break;
 -#endif
 +
 +		cond_resched();
 =20
  		if (unlikely(kthread_should_stop() || freezing(current)))
  			break;

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Oct_2012_12_00_41_+1100_F.gQOPAC.X0AuRjy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQfLG5AAoJEECxmPOUX5FEOsoP/0jPky4tDq8lC0NyTw7AwxJs
YHQXY1QjztuDObAFcUyEFHD4CX/otuxpGo9fU0VIUwrsK/OCRvq6nGVaIVtRxwqG
XwudtPzKnRJorwyg0IVQYthyiFeLhi3waQsHWpQxcW7q6BsjU/J11ac2uJLqpofZ
sS7PnyKJHP0Q7tU6Y65/Yp8ls8kZufpJSKdrChq7CZsKJ7kqvp/ukaOlnT2jvFZV
B8skNWf5V4AyUvHiRDb9fYLr2QdKQmzMX+6n2OAC9JJKmUQXjfP+G7yKUtaDtsh/
DTFm4kSpE/CAymI2rpo6/YpARxfoQDCPtcQdWsSM+mD4CEAn5YaVBh/iJtEPH0/s
Sx3+y6XCfbf+RTzDdMLEm9Z4z5vZblZ3Yp/KNhLgfRj+DnuPXxEsnNcSPkrdrWt2
IgsYUw0b0D7GYCXZgVaVkfCJIRPl+Imr6NF+9O3ZQoP5vGHYuOe6hpv7KUILfyZm
QKC73dgfOZQbiiXqU5LlVahpVsQDa9MtIHm3F1qJ+TuI9ro2oUFJwKCQpd0QETuH
z2BvGIATvfdCF8Y+8pFtF9sFtYkqEUsgGq2p69oBFqyeY7yC6n3Mm38JI1Oqcfsp
AurLQD2QSGzOG3SPFEOGVA8Lv9+mhKiP9EX6ge5HDqcXvWO8dCO6pXM0i/vuySyW
4UbDzd2CN2PwsM7UsrxT
=NOoJ
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Oct_2012_12_00_41_+1100_F.gQOPAC.X0AuRjy--
