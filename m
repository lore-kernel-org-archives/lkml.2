Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab2JJCpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 22:45:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52519 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2JJCpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 22:45:41 -0400
Date: Wed, 10 Oct 2012 13:45:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20121010134527.a2c21165e0c7b1219d2b847c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Oct_2012_13_45_27_+1100_d3WSahWFB03iHElT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Oct_2012_13_45_27_+1100_d3WSahWFB03iHElT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
mm/huge_memory.c between commits d516904bd239 ("thp: merge page pre-alloc
in khugepaged_loop into khugepaged_do_scan"), e3ebcf643811 ("thp: remove
assumptions on pgtable_t type") and 46dcde735c9d ("thp: introduce
pmdp_invalidate()") from Linus' tree and commit 93c9d633bd9e ("mm/thp:
Preserve pgprot across huge page split") from the tip tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/huge_memory.c
index a863af2,5b9ab25..0000000
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@@ -1346,59 -1428,55 +1417,54 @@@ static int __split_huge_page_map(struc
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
@@@ -2279,23 -2300,30 +2345,21 @@@ static int khugepaged_has_work(void
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

--Signature=_Wed__10_Oct_2012_13_45_27_+1100_d3WSahWFB03iHElT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQdOFHAAoJEECxmPOUX5FEpJAP/0V/mRJhh8/U8VV07F+w6auI
6FuI+Ts2P0+qTkTDV3s3Obkbrt/v6c2wzqDaSOPxk9xT3wzFwkly8n0+h4O2IQja
66JYYT16Zm6F4hpU9J4cESmCJq0ktY5rHMI9Ep4PpAyfSb0FiR0/vy3hzuoAOhGN
gITXBHsLd0Yh6vetQ9HCya+UID7n4k9xuHVimGm//c1bL8z5SOU+X+xPo6ZQPNHW
pjaWKBTT/3icAHW3wL+nmSLpNCxPB/1wcjz9BKHBODrIS4urnoPAwZichpM+4qC/
xwz72yIUuM5hqKsd1urtIEpr6tAgPoeDCbWkpfhdBumYWFTgaUEzXrYMXgO2xvfE
KhOBeN9rISSShTNU02pefYA4DxKwYlf2e0xXwuBbYa66hglHWFFN9AgbFGzBur0R
15X1xOZmmJlY9rjuPedGnkMGaiYIpHA7nao44JjVuYq9wWRu3Asv7vWdbceC4/mS
1MAJvvXnwku4gZKIb1BZAzzxzaaDvt0eDqbzojpAWcSe14xT5DniPG0zPcG18fH9
jU3WWh1jm0pD24u/hqAhTYvZ02hpfGcw1K2h3k66h3Fv1VQtUX2yUi9Iz6nlSxD1
8CX0eNifgZo4HIAap0scHDh6GYZbl3pShOnQm522QVxlcwSsW9QEK/GDj34a85o8
llTeKKuGBnIhPsWmronL
=O2Zm
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Oct_2012_13_45_27_+1100_d3WSahWFB03iHElT--
