Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2I0HKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:10:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38647 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2I0HKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:10:49 -0400
Date: Thu, 27 Sep 2012 17:10:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120927171046.315e74c236e28c40e37e1553@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Sep_2012_17_10_46_+1000_l6+4YBXJVR4l2fx6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Sep_2012_17_10_46_+1000_l6+4YBXJVR4l2fx6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/huge_memory.c between commit 93c9d633bd9e ("mm/thp: Preserve pgprot
across huge page split") from the tip tree and commit  ("thp: remove
assumptions on pgtable_t type") from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/huge_memory.c
index 6b176fe,a91bc3c..0000000
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@@ -1416,55 -1312,60 +1384,55 @@@ static int __split_huge_page_map(struc
  	spin_lock(&mm->page_table_lock);
  	pmd =3D page_check_address_pmd(page, mm, address,
  				     PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG);
 -	if (pmd) {
 -		pgtable =3D pgtable_trans_huge_withdraw(mm);
 -		pmd_populate(mm, &_pmd, pgtable);
 -
 -		for (i =3D 0, haddr =3D address; i < HPAGE_PMD_NR;
 -		     i++, haddr +=3D PAGE_SIZE) {
 -			pte_t *pte, entry;
 -			BUG_ON(PageCompound(page+i));
 -			entry =3D mk_pte(page + i, vma->vm_page_prot);
 -			entry =3D maybe_mkwrite(pte_mkdirty(entry), vma);
 -			if (!pmd_write(*pmd))
 -				entry =3D pte_wrprotect(entry);
 -			else
 -				BUG_ON(page_mapcount(page) !=3D 1);
 -			if (!pmd_young(*pmd))
 -				entry =3D pte_mkold(entry);
 -			pte =3D pte_offset_map(&_pmd, haddr);
 -			BUG_ON(!pte_none(*pte));
 -			set_pte_at(mm, haddr, pte, entry);
 -			pte_unmap(pte);
 -		}
 +	if (!pmd)
 +		goto unlock;
 =20
 -		smp_wmb(); /* make pte visible before pmd */
 -		/*
 -		 * Up to this point the pmd is present and huge and
 -		 * userland has the whole access to the hugepage
 -		 * during the split (which happens in place). If we
 -		 * overwrite the pmd with the not-huge version
 -		 * pointing to the pte here (which of course we could
 -		 * if all CPUs were bug free), userland could trigger
 -		 * a small page size TLB miss on the small sized TLB
 -		 * while the hugepage TLB entry is still established
 -		 * in the huge TLB. Some CPU doesn't like that. See
 -		 * http://support.amd.com/us/Processor_TechDocs/41322.pdf,
 -		 * Erratum 383 on page 93. Intel should be safe but is
 -		 * also warns that it's only safe if the permission
 -		 * and cache attributes of the two entries loaded in
 -		 * the two TLB is identical (which should be the case
 -		 * here). But it is generally safer to never allow
 -		 * small and huge TLB entries for the same virtual
 -		 * address to be loaded simultaneously. So instead of
 -		 * doing "pmd_populate(); flush_tlb_range();" we first
 -		 * mark the current pmd notpresent (atomically because
 -		 * here the pmd_trans_huge and pmd_trans_splitting
 -		 * must remain set at all times on the pmd until the
 -		 * split is complete for this pmd), then we flush the
 -		 * SMP TLB and finally we write the non-huge version
 -		 * of the pmd entry with pmd_populate.
 -		 */
 -		set_pmd_at(mm, address, pmd, pmd_mknotpresent(*pmd));
 -		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 -		pmd_populate(mm, pmd, pgtable);
 -		ret =3D 1;
 +	prot =3D pmd_pgprot(*pmd);
- 	pgtable =3D get_pmd_huge_pte(mm);
++	pgtable =3D pgtable_trans_huge_withdraw(mm);
 +	pmd_populate(mm, &_pmd, pgtable);
 +
 +	for (i =3D 0, haddr =3D address; i < HPAGE_PMD_NR; i++, haddr +=3D PAGE_=
SIZE) {
 +		pte_t *pte, entry;
 +
 +		BUG_ON(PageCompound(page+i));
 +		entry =3D mk_pte(page + i, prot);
 +		entry =3D pte_mkdirty(entry);
 +		if (!pmd_young(*pmd))
 +			entry =3D pte_mkold(entry);
 +		pte =3D pte_offset_map(&_pmd, haddr);
 +		BUG_ON(!pte_none(*pte));
 +		set_pte_at(mm, haddr, pte, entry);
 +		pte_unmap(pte);
  	}
 +
 +	smp_wmb(); /* make ptes visible before pmd, see __pte_alloc */
 +	/*
 +	 * Up to this point the pmd is present and huge.
 +	 *
 +	 * If we overwrite the pmd with the not-huge version, we could trigger
 +	 * a small page size TLB miss on the small sized TLB while the hugepage
 +	 * TLB entry is still established in the huge TLB.
 +	 *
 +	 * Some CPUs don't like that. See
 +	 * http://support.amd.com/us/Processor_TechDocs/41322.pdf, Erratum 383
 +	 * on page 93.
 +	 *
 +	 * Thus it is generally safer to never allow small and huge TLB entries
 +	 * for overlapping virtual addresses to be loaded. So we first mark the
 +	 * current pmd not present, then we flush the TLB and finally we write
 +	 * the non-huge version of the pmd entry with pmd_populate.
 +	 *
 +	 * The above needs to be done under the ptl because pmd_trans_huge and
 +	 * pmd_trans_splitting must remain set on the pmd until the split is
 +	 * complete. The ptl also protects against concurrent faults due to
 +	 * making the pmd not-present.
 +	 */
 +	set_pmd_at(mm, address, pmd, pmd_mknotpresent(*pmd));
 +	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 +	pmd_populate(mm, pmd, pgtable);
 +	ret =3D 1;
 +
 +unlock:
  	spin_unlock(&mm->page_table_lock);
 =20
  	return ret;

--Signature=_Thu__27_Sep_2012_17_10_46_+1000_l6+4YBXJVR4l2fx6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQY/v2AAoJEECxmPOUX5FEJeIP/j4Xk3I6vRwfIgRWTtZWjsP6
VcSEuZFf/VpD2+9HxJplopEoBegURd636WomzCGyw0z4RapUteVAjd8huawvBT2H
/53nB8qpGs+lPjoHuOwL30OHnKOAzqGARA+HSOC2+9VXkvOWAWUG/D1wFr5vN23v
GHoSLPDLD3HLzhnrmxqLvudQtQXSy9duKiYzYxMUzQCAgsVjPzdFou/XqkE7P0cZ
xsSDhMJT872ZQhJST2rrdNADOWiYVzZOUFAFZEKShxviw8RXcTk0l9+aMQixoWYY
qT0t1KkgDAm+/sTKVEbiyTInpV93yJxluAIiN1An2Pwm5pmHl06jnU77mTF6GI/H
dWFWlsL/r1UlEOQT8nHGrUtpAfMNv5QvW7cebBrOA5r3GNLXeUpJIZ1MtNPBAQiE
9/q/+EGFTo7QEVZk+LzfWgi0GXkqYr/QQ4Sn3PnTSQo4ru5NCWe/Z2hUUtNrpB8u
DNewVUd3eUhqykkP/+RJCLlb5P1a8m0bobFWpW4/zboJkH04XC86KGikA06JO7Xt
830U92J+4DAnjro0bpUjcP8fUGnMmttLBgMKCqU627Amge3vdEvuf+rxk6cbO7ui
uAASvW9VBC7F6TJYxAFzLvy+q655qy01rTykXLvbf4v/zOsTxa54D5JxRQrGN5yl
M0D/0THBXZfzsk6cFqZx
=Dgun
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Sep_2012_17_10_46_+1000_l6+4YBXJVR4l2fx6--
