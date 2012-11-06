Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2KFEvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 23:51:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:35198 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2KFEvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 23:51:39 -0500
Date: Tue, 6 Nov 2012 15:51:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the akpm tree with the cgroup tree
Message-Id: <20121106155128.ae5ac335cce32d0398586701@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Nov_2012_15_51_28_+1100_tyC9y9N5Va+Mjonx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Nov_2012_15_51_28_+1100_tyC9y9N5Va+Mjonx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/memcontrol.c between commit ab5196c202c6 ("memcg: make
mem_cgroup_reparent_charges non failing") from the cgroup tree and commit
"memcg: allow a memcg with kmem charges to be destructed" from the akpm
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memcontrol.c
index 8f2b789,540bac5..0000000
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -3987,11 -4015,15 +3992,12 @@@ static void mem_cgroup_force_empty_list
   *
   * Caller is responsible for holding css reference on the memcg.
   */
 -static int mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 +static void mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
  {
 -	struct cgroup *cgrp =3D memcg->css.cgroup;
  	int node, zid;
+ 	u64 usage;
 =20
  	do {
 -		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
 -			return -EBUSY;
  		/* This is for making all *used* pages to be on LRU. */
  		lru_add_drain_all();
  		drain_all_stock_sync(memcg);
@@@ -4016,7 -4053,11 +4027,9 @@@
  		 * right after the check. RES_USAGE should be safe as we always
  		 * charge before adding to the LRU.
  		 */
- 	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0);
+ 		usage =3D res_counter_read_u64(&memcg->res, RES_USAGE) -
+ 			res_counter_read_u64(&memcg->kmem, RES_USAGE);
+ 	} while (usage > 0);
 -
 -	return 0;
  }
 =20
  /*

--Signature=_Tue__6_Nov_2012_15_51_28_+1100_tyC9y9N5Va+Mjonx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQmJdQAAoJEECxmPOUX5FEH5cP/i2edQE4wHovyv5QOgfpxtNW
ciR0y/746u7kQOeD6GLFVX73k+33E0I3l2EiPIWQ0bYAN8YU7WPE8PGdGbFZJTZX
6bH71vKUHtAnXbUDWa+pRpEai3feFGf0FCtYyGsb4hRJp+CLX1GWkz9i//GXusMR
a7d/aRH+JMNjgaYrKazExjE00Vsk0QwloM8/3x1lOxGz56xMemFtuRsc6m6OhkiT
7RIJazZhqrIwy8p0KgIkuD+nXOfAJbcL4hihb8jp1HrC1j0+nYBloovdH8WjrZD2
jWrUBA62nCx3RiYyNsM7ZTkAxo8NgYyZDWFA+AbEKy/WV9UOCTdJ9H5FeN45DVbr
lkUfMHoYR/QCJ8UD6TqwsUyOIeaB/BtQSbpX1muPzpb37rYe9jSfSvdZ5h4N3WtJ
+3I9DA+NnqIvdHWXysTh8wTtIKC01zJaGg7tPOkpVYqP4zhuVy7fBnD8JC83aV4D
I+W0DxESl4u/XgSLzv7J4C5w38UWQjPB5oNy/huoE9mXZ086yD9jh0dQuj1kT0AD
F5zjWoUgkY9roZo4F0MKe226arKbJ52huErLAR7JoDOnWjJmFcxul2rkG30nJh2V
myS/Q1ZBk4fidDdK/80VreXTDOHj70COmpRe7faB9OrrQf7AXLp8DJkOAstqNuQi
I95JsMG4jf6yvk3DQKwA
=Asrt
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Nov_2012_15_51_28_+1100_tyC9y9N5Va+Mjonx--
