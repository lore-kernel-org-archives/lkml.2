Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2I0G5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:57:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57489 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab2I0G5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:57:11 -0400
Date: Thu, 27 Sep 2012 16:57:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120927165707.3baaa7f083da9f157a09c653@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Sep_2012_16_57_07_+1000_klRVFTiG39yZuYlk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Sep_2012_16_57_07_+1000_klRVFTiG39yZuYlk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/mempolicy.c between commit 4d58c795f691 ("mm/mpol: Check for misplaced
page") from the tip tree and commit "mempolicy: fix refcount leak in
mpol_set_shared_policy()" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/mempolicy.c
index a0eec0e,1763418..0000000
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@@ -2174,82 -2157,12 +2174,88 @@@ mpol_shared_policy_lookup(struct shared
  	return pol;
  }
 =20
 +/**
 + * mpol_misplaced - check whether current page node is valid in policy
 + *
 + * @page   - page to be checked
 + * @vma    - vm area where page mapped
 + * @addr   - virtual address where page mapped
 + *
 + * Lookup current policy node id for vma,addr and "compare to" page's
 + * node id.
 + *
 + * Returns:
 + *	-1	- not misplaced, page is in the right node
 + *	node	- node id where the page should be
 + *
 + * Policy determination "mimics" alloc_page_vma().
 + * Called from fault path where we know the vma and faulting address.
 + */
 +int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigne=
d long addr)
 +{
 +	struct mempolicy *pol;
 +	struct zone *zone;
 +	int curnid =3D page_to_nid(page);
 +	unsigned long pgoff;
 +	int polnid =3D -1;
 +	int ret =3D -1;
 +
 +	BUG_ON(!vma);
 +
 +	pol =3D get_vma_policy(current, vma, addr);
 +	if (!(pol->flags & MPOL_F_MOF))
 +		goto out;
 +
 +	switch (pol->mode) {
 +	case MPOL_INTERLEAVE:
 +		BUG_ON(addr >=3D vma->vm_end);
 +		BUG_ON(addr < vma->vm_start);
 +
 +		pgoff =3D vma->vm_pgoff;
 +		pgoff +=3D (addr - vma->vm_start) >> PAGE_SHIFT;
 +		polnid =3D offset_il_node(pol, vma, pgoff);
 +		break;
 +
 +	case MPOL_PREFERRED:
 +		if (pol->flags & MPOL_F_LOCAL)
 +			polnid =3D numa_node_id();
 +		else
 +			polnid =3D pol->v.preferred_node;
 +		break;
 +
 +	case MPOL_BIND:
 +		/*
 +		 * allows binding to multiple nodes.
 +		 * use current page if in policy nodemask,
 +		 * else select nearest allowed node, if any.
 +		 * If no allowed nodes, use current [!misplaced].
 +		 */
 +		if (node_isset(curnid, pol->v.nodes))
 +			goto out;
 +		(void)first_zones_zonelist(
 +				node_zonelist(numa_node_id(), GFP_HIGHUSER),
 +				gfp_zone(GFP_HIGHUSER),
 +				&pol->v.nodes, &zone);
 +		polnid =3D zone->node;
 +		break;
 +
 +	default:
 +		BUG();
 +	}
 +	if (curnid !=3D polnid)
 +		ret =3D polnid;
 +out:
 +	mpol_cond_put(pol);
 +
 +	return ret;
 +}
 +
+ static void sp_free(struct sp_node *n)
+ {
+ 	mpol_put(n->policy);
+ 	kmem_cache_free(sn_cache, n);
+ }
+=20
  static void sp_delete(struct shared_policy *sp, struct sp_node *n)
  {
  	pr_debug("deleting %lx-l%lx\n", n->start, n->end);

--Signature=_Thu__27_Sep_2012_16_57_07_+1000_klRVFTiG39yZuYlk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQY/jDAAoJEECxmPOUX5FEmq4P/if8m78p8QfnFsIPdq5c6hHX
02TQVj0ppr1QCv9oq8Hz492UZYAakoBBRXdzpNsPSccn8lK7niSNqjQ3OotBESvz
pMap7rXzBIFnT/XpynBELnyBt4m1FRPYZG/FDZJ7hEnpQlWpQE2svFX0u8VlYsbu
hOgOl/+NtgZjPHquaPej1pyaE9PYQnqJJITiFZ/38zwMm8bSoNKmFyJakp7vmFBL
ediB/vcbd1Wtk5BL3jzhqhs9YoSY/mgMozI4tSSOq+qPBE4KHvOwNiJH3osegRb/
sRNJZbYLgLC7H+zFfyEwAbuFedwy7nK8RdBPAeCdWrMNFqXiOsZzYTlkqd1lGEbn
IJqigdfmVhpC5tLE5AJYEAFgTn6jVcVbnGQ0CQKZaWkS5FWsbCMphF/uNT+1OqGA
z5cOgMcRPIY2X+zMSjnFMsSqlhg9mpFqgOaByet9Zx+VrxWHmx03BEuAiWh8xrQW
A3pC7AoJn66IdHTO+krywc+kJZ9jeu6+ooY7TSNhAmtIXqLUf4mfyvMa96VHrd/e
ECjmZVFx+bw9pIbNb9ztgt5bmaEkFLVBfWGW6MnLaKgInQpYVrpqyJrDpQ5uPl5b
YI8AHuFeRPNszHzsD7g0vMyBFYnSONONn7d2d0CdlmUD4xNo8kX/ZCnsQewYsK1w
w1d/9++x9WG6kgePxhRJ
=Lerw
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Sep_2012_16_57_07_+1000_klRVFTiG39yZuYlk--
