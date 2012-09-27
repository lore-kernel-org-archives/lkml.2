Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab2I0HPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 03:15:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34319 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab2I0HPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 03:15:49 -0400
Date: Thu, 27 Sep 2012 17:15:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120927171545.79c597f3fa5f7d5f66a7e2ce@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Sep_2012_17_15_45_+1000_Cu.KDYiTw.nMLf6D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Sep_2012_17_15_45_+1000_Cu.KDYiTw.nMLf6D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/huge_memory.c between commit 93c9d633bd9e ("93c9d633bd9e") from the
tip tree and commit "thp: introduce pmdp_invalidate()" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/huge_memory.c
index 9267537,56f9443..0000000
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@@ -1384,55 -1312,59 +1384,54 @@@ static int __split_huge_page_map(struc
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
 -		pmdp_invalidate(vma, address, pmd);
 -		pmd_populate(mm, pmd, pgtable);
 -		ret =3D 1;
 +	prot =3D pmd_pgprot(*pmd);
 +	pgtable =3D pgtable_trans_huge_withdraw(mm);
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
- 	set_pmd_at(mm, address, pmd, pmd_mknotpresent(*pmd));
- 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
++	pmdp_invalidate(vma, address, pmd);
 +	pmd_populate(mm, pmd, pgtable);
 +	ret =3D 1;
 +
 +unlock:
  	spin_unlock(&mm->page_table_lock);
 =20
  	return ret;

--Signature=_Thu__27_Sep_2012_17_15_45_+1000_Cu.KDYiTw.nMLf6D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQY/0hAAoJEECxmPOUX5FEAZcQAI8u/7YY+HNw5hl0Z77xf2ri
cbKIZFc8zO6HSRHqzgkJa/YhHAjW9wh+F/zZU2Q0oYa8lVLAUGvRhZY4S2Mwr+vE
9eZw7WD7TtOtLsunaZ2ijMclS5drfw9XRVIAULFV0ieJxsDSTcLM8STEcbHjSdu1
tr9ANLJhmISjGkxxHAw0WFtemFi59J6em2KTQYhLdqzgGvTsw7HetDvc+Esr2R05
BlAr+IHi0c8HDfwHdeyTgBBM6U+Gvc3Ak5Q8eEHc53DewE1nucnTGYXmn+H7r1it
yizCLb57EFGufQST7VdhGPPAVYJQWFDNvBNu23VjSDYf7gDalw8RdAUjtAU0iM1S
jD6lkJhKeXebLXFoKWSNQADEYk83cu4wce9vVZpvN5nqaHEqiL/2yxmGqhuQadOR
Vtu7Ho67DPCeNBUFRNPVJDHF44YTRVX7DxEiTgTuCG1gsg8J9iz+w1/TMjSGv7oj
sm3CquG1V/70NXfxc3+wHKMcG742YP6KbIGiKSWG/R/njjZmxFisNSpTiZhDooww
FvRzt+Tx7uQBQZJYPm95YaDzPmZK4mLBCYaZC3VsSp4SVGCh0T7UAhfrEMWf5rfs
7zMCW6lwiYqfOXoAGPqdKzmUYoJU0ouA2OAV8sz3AhNtuV1SEvXF/GEt7dfE0Bpz
n4/zumsn6a2IHhK9prWL
=ujUu
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Sep_2012_17_15_45_+1000_Cu.KDYiTw.nMLf6D--
