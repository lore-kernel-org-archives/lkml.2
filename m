Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab2JJCvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 22:51:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58352 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2JJCvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 22:51:09 -0400
Date: Wed, 10 Oct 2012 13:51:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20121010135105.b45d6f8cc5b6b627446f993c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Oct_2012_13_51_05_+1100_L0o7Eeiu_fGCilVA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Oct_2012_13_51_05_+1100_L0o7Eeiu_fGCilVA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in mm/mempolicy.c
between commit 63f74ca21f1f ("mempolicy: fix refcount leak in
mpol_set_shared_policy()") from Linus' tree and commit 4d58c795f691
("mm/mpol: Check for misplaced page") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/mempolicy.c
index 0b78fb9,3360a8d..0000000
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@@ -2170,12 -2168,116 +2203,122 @@@ mpol_shared_policy_lookup(struct shared
  	return pol;
  }
 =20
 +static void sp_free(struct sp_node *n)
 +{
 +	mpol_put(n->policy);
 +	kmem_cache_free(sn_cache, n);
 +}
 +
+ /**
+  * mpol_misplaced - check whether current page node is valid in policy
+  *
+  * @page   - page to be checked
+  * @vma    - vm area where page mapped
+  * @addr   - virtual address where page mapped
+  * @multi  - use multi-stage node binding
+  *
+  * Lookup current policy node id for vma,addr and "compare to" page's
+  * node id.
+  *
+  * Returns:
+  *	-1	- not misplaced, page is in the right node
+  *	node	- node id where the page should be
+  *
+  * Policy determination "mimics" alloc_page_vma().
+  * Called from fault path where we know the vma and faulting address.
+  */
+ int mpol_misplaced(struct page *page, struct vm_area_struct *vma,
+ 		   unsigned long addr, int multi)
+ {
+ 	struct mempolicy *pol;
+ 	struct zone *zone;
+ 	int curnid =3D page_to_nid(page);
+ 	unsigned long pgoff;
+ 	int polnid =3D -1;
+ 	int ret =3D -1;
+=20
+ 	BUG_ON(!vma);
+=20
+ 	pol =3D get_vma_policy(current, vma, addr);
+ 	if (!(pol->flags & MPOL_F_MOF))
+ 		goto out;
+=20
+ 	switch (pol->mode) {
+ 	case MPOL_INTERLEAVE:
+ 		BUG_ON(addr >=3D vma->vm_end);
+ 		BUG_ON(addr < vma->vm_start);
+=20
+ 		pgoff =3D vma->vm_pgoff;
+ 		pgoff +=3D (addr - vma->vm_start) >> PAGE_SHIFT;
+ 		polnid =3D offset_il_node(pol, vma, pgoff);
+ 		break;
+=20
+ 	case MPOL_PREFERRED:
+ 		if (pol->flags & MPOL_F_LOCAL)
+ 			polnid =3D numa_node_id();
+ 		else
+ 			polnid =3D pol->v.preferred_node;
+ 		break;
+=20
+ 	case MPOL_BIND:
+ 		/*
+ 		 * allows binding to multiple nodes.
+ 		 * use current page if in policy nodemask,
+ 		 * else select nearest allowed node, if any.
+ 		 * If no allowed nodes, use current [!misplaced].
+ 		 */
+ 		if (node_isset(curnid, pol->v.nodes))
+ 			goto out;
+ 		(void)first_zones_zonelist(
+ 				node_zonelist(numa_node_id(), GFP_HIGHUSER),
+ 				gfp_zone(GFP_HIGHUSER),
+ 				&pol->v.nodes, &zone);
+ 		polnid =3D zone->node;
+ 		break;
+=20
+ 	default:
+ 		BUG();
+ 	}
+=20
+ 	/*
+ 	 * Multi-stage node selection is used in conjunction with a periodic
+ 	 * migration fault to build a temporal task<->page relation. By
+ 	 * using a two-stage filter we remove short/unlikely relations.
+ 	 *
+ 	 * Using P(p) ~ n_p / n_t as per frequentist probability, we can
+ 	 * equate a task's usage of a particular page (n_p) per total usage
+ 	 * of this page (n_t) (in a given time-span) to a probability.
+ 	 *
+ 	 * Our periodic faults will then sample this probability and getting
+ 	 * the same result twice in a row, given these samples are fully
+ 	 * independent, is then given by P(n)^2, provided our sample period
+ 	 * is sufficiently short compared to the usage pattern.
+ 	 *
+ 	 * This quadric squishes small probabilities, making it less likely
+ 	 * we act on an unlikely task<->page relation.
+ 	 *
+ 	 * NOTE: effectively we're using task-home-node<->page-node relations
+ 	 * since those are the only thing we can affect.
+ 	 *
+ 	 * NOTE: we're using task-home-node as opposed to the current node
+ 	 * the task might be running on, since the task-home-node is the
+ 	 * long-term node of this task, further reducing noise. Also see
+ 	 * task_tick_numa().
+ 	 */
+ 	if (multi && (pol->flags & MPOL_F_HOME)) {
+ 		int last_nid =3D page_xchg_last_nid(page, polnid);
+ 		if (last_nid !=3D polnid)
+ 			goto out;
+ 	}
+=20
+ 	if (curnid !=3D polnid)
+ 		ret =3D polnid;
+ out:
+ 	mpol_cond_put(pol);
+=20
+ 	return ret;
+ }
+=20
  static void sp_delete(struct shared_policy *sp, struct sp_node *n)
  {
  	pr_debug("deleting %lx-l%lx\n", n->start, n->end);

--Signature=_Wed__10_Oct_2012_13_51_05_+1100_L0o7Eeiu_fGCilVA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQdOKZAAoJEECxmPOUX5FEVgcP/2L/4k7f6BT+HHM5X+axvxOp
DBukhp10N5h6Dyj99inK2RdPZ8+1yiQfOudlSOmP4StCq9+mDDm6W6RX/6/s24Af
M7ISc6dwrgMESSu93T7cLRs1GiuCe/2QpOcE8v2VguPFO6wqPghVD3M6PCJpevzx
bqlrpvU9j1aiSLm5irvNyXn9NN20q+eyGW1kMGgDtY5OzJK1PPxsyoFjSha8vaX4
RGOK4VO+IP9xvh3+EwVZlEiWeJxxOToRaqt4koq89kwnWKJHH9VtNrDlqWLeEsSC
2PrUB7qGjidMppWOhR6CnFnnX8oqzNHDbMNuX7WiObcx4Qnbk/FIJf59/VczRLXg
nB+JzocSg6GwrMWYN1CVOOxcooyjoM8H4Y0+jcVun+os+WFeUi+HGaEY5snfhOir
J+gcRldqYYVR49VLEsf9wAHTdt6nn0PC4c/V/u87uuwOYgdin2fBLqKrks8m3hTU
q9dGf7uFRj/tdzackIWKCbYu4Nb4IPH0afZaZrQtMJKKCZhANFLFT/nLr59CgKMU
1LJ5nl7OZJ8m7JGnIaP9dgNf2Y+PkbAocwHugi2I3NJ+A+47gzRTZamiLF0sQjgk
DH5nH83RaEWBvjd/XungEmh/ToI+5AWUKQUKX4AUkAo+H84SCtR/mum4fE/RpVtK
njzGlXGtj2atiYjoN+u8
=wTgY
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Oct_2012_13_51_05_+1100_L0o7Eeiu_fGCilVA--
