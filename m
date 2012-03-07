Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab2CGFFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:05:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48820 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2CGFFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:05:38 -0500
Date: Wed, 7 Mar 2012 16:05:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the cgroup tree with the block tree
Message-Id: <20120307160516.53086e588a8246edd87c41fc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__7_Mar_2012_16_05_16_+1100_T59mLzJHFwpnTOgo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Mar_2012_16_05_16_+1100_T59mLzJHFwpnTOgo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the cgroup tree got a conflict in
block/blk-cgroup.c between commit 7ee9c5620504 ("blkcg: let blkio_group
point to blkio_cgroup directly") from the block tree and commit
761b3ef50e1c ("cgroup: remove cgroup_subsys argument from callbacks")
from the cgroup tree.

I fixed it up (I hope - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc block/blk-cgroup.c
index ee962f3,1359d63..0000000
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@@ -33,16 -28,10 +33,13 @@@ static LIST_HEAD(all_q_list)
  struct blkio_cgroup blkio_root_cgroup =3D { .weight =3D 2*BLKIO_WEIGHT_DE=
FAULT };
  EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 =20
 +static struct blkio_policy_type *blkio_policy[BLKIO_NR_POLICIES];
 +
- static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
- 						  struct cgroup *);
- static int blkiocg_can_attach(struct cgroup_subsys *, struct cgroup *,
- 			      struct cgroup_taskset *);
- static void blkiocg_attach(struct cgroup_subsys *, struct cgroup *,
- 			   struct cgroup_taskset *);
- static int blkiocg_pre_destroy(struct cgroup_subsys *, struct cgroup *);
- static void blkiocg_destroy(struct cgroup_subsys *, struct cgroup *);
+ static struct cgroup_subsys_state *blkiocg_create(struct cgroup *);
+ static int blkiocg_can_attach(struct cgroup *, struct cgroup_taskset *);
+ static void blkiocg_attach(struct cgroup *, struct cgroup_taskset *);
++static int blkiocg_pre_destroy(struct cgroup *);
+ static void blkiocg_destroy(struct cgroup *);
  static int blkiocg_populate(struct cgroup_subsys *, struct cgroup *);
 =20
  /* for encoding cft->private value on file */
@@@ -1571,48 -1545,52 +1568,46 @@@ static int blkiocg_populate(struct cgro
  				ARRAY_SIZE(blkio_files));
  }
 =20
 -static void blkiocg_destroy(struct cgroup *cgroup)
 +/**
 + * blkiocg_pre_destroy - cgroup pre_destroy callback
-  * @subsys: cgroup subsys
 + * @cgroup: cgroup of interest
 + *
 + * This function is called when @cgroup is about to go away and responsib=
le
 + * for shooting down all blkgs associated with @cgroup.  blkgs should be
 + * removed while holding both q and blkcg locks.  As blkcg lock is nested
 + * inside q lock, this function performs reverse double lock dancing.
 + *
 + * This is the blkcg counterpart of ioc_release_fn().
 + */
- static int blkiocg_pre_destroy(struct cgroup_subsys *subsys,
- 			       struct cgroup *cgroup)
++static int blkiocg_pre_destroy(struct cgroup *cgroup)
  {
  	struct blkio_cgroup *blkcg =3D cgroup_to_blkio_cgroup(cgroup);
 -	unsigned long flags;
 -	struct blkio_group *blkg;
 -	void *key;
 -	struct blkio_policy_type *blkiop;
 -	struct blkio_policy_node *pn, *pntmp;
 =20
 -	rcu_read_lock();
 -	do {
 -		spin_lock_irqsave(&blkcg->lock, flags);
 +	spin_lock_irq(&blkcg->lock);
 =20
 -		if (hlist_empty(&blkcg->blkg_list)) {
 -			spin_unlock_irqrestore(&blkcg->lock, flags);
 -			break;
 +	while (!hlist_empty(&blkcg->blkg_list)) {
 +		struct blkio_group *blkg =3D hlist_entry(blkcg->blkg_list.first,
 +						struct blkio_group, blkcg_node);
 +		struct request_queue *q =3D blkg->q;
 +
 +		if (spin_trylock(q->queue_lock)) {
 +			blkg_destroy(blkg);
 +			spin_unlock(q->queue_lock);
 +		} else {
 +			spin_unlock_irq(&blkcg->lock);
 +			cpu_relax();
 +			spin_lock(&blkcg->lock);
  		}
 +	}
 =20
 -		blkg =3D hlist_entry(blkcg->blkg_list.first, struct blkio_group,
 -					blkcg_node);
 -		key =3D rcu_dereference(blkg->key);
 -		__blkiocg_del_blkio_group(blkg);
 -
 -		spin_unlock_irqrestore(&blkcg->lock, flags);
 -
 -		/*
 -		 * This blkio_group is being unlinked as associated cgroup is
 -		 * going away. Let all the IO controlling policies know about
 -		 * this event.
 -		 */
 -		spin_lock(&blkio_list_lock);
 -		list_for_each_entry(blkiop, &blkio_list, list) {
 -			if (blkiop->plid !=3D blkg->plid)
 -				continue;
 -			blkiop->ops.blkio_unlink_group_fn(key, blkg);
 -		}
 -		spin_unlock(&blkio_list_lock);
 -	} while (1);
 +	spin_unlock_irq(&blkcg->lock);
 +	return 0;
 +}
 =20
- static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *=
cgroup)
 -	list_for_each_entry_safe(pn, pntmp, &blkcg->policy_list, node) {
 -		blkio_policy_delete_node(pn);
 -		kfree(pn);
 -	}
++static void blkiocg_destroy(struct cgroup *cgroup)
 +{
 +	struct blkio_cgroup *blkcg =3D cgroup_to_blkio_cgroup(cgroup);
 =20
 -	free_css_id(&blkio_subsys, &blkcg->css);
 -	rcu_read_unlock();
  	if (blkcg !=3D &blkio_root_cgroup)
  		kfree(blkcg);
  }

--Signature=_Wed__7_Mar_2012_16_05_16_+1100_T59mLzJHFwpnTOgo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPVuyMAAoJEECxmPOUX5FE4HsP/2njCLg/Fri8jOEI2ZrdxHKz
3gkWO29AcZ+Ti2pH3Vm2JHWaKlRZ8uPg3Lf53RIqHUAdjHzZJUiLw2Gge3kq/pg0
rXCXwzcg6DEQlfpUBLwFiVVNzPQAV5X0FyR/fW3KApTAu++oBUybySqFPX19JU2Y
c7v/ZN1FFiRpc8f+SsJeXdVuAwkqynL2iYDjzVHaet54XOs2Nalv1YfBIySD5gJe
/eSz2pQ8D6E0JtSJ1JtBxWlxVe2c0otIjndp1g/odf0rrkkVrkyfYYp76a4nRUh2
JjImBqq3lEDPPKN8rrpmO+bULz4q+jTXgnSjECXSfhcH/FdkFXQ5Cdr6WnKySkoI
96/lujmpF6xtfaOD+QS0Gp9pjRZrTqi9Asy9enVZdGSnqYNSrMoAP48ywWGUv7Q6
gQguPDuqEejxWpHIZzSFenm6S0qeCFuCihjk3wgs+WvKL0pdTFRLJVoZj7gN/SYx
LNVdt9LJXfxFpVzr0mQLFJOhFm01qP3T5Om9WXDw3pdEQ4n61Fcf+6MmlwpSf8q1
mUn8XMBw8170XAE2i+5utx4YQAb3zsxsCCKIsFuT06p6zsk5c/pU8ABYwJLZRKIP
pZf1pVqAyBA2Ogj5b//cblA5aUzi0K2xFJe3fCbqr4HVQuzpvk95R3YmSln89jha
iNd1mlYqRS372aNjvvc8
=IXnN
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Mar_2012_16_05_16_+1100_T59mLzJHFwpnTOgo--
