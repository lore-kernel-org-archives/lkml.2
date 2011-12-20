Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab1LTGKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 01:10:10 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:54780 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1LTGKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 01:10:09 -0500
Date: Tue, 20 Dec 2011 17:10:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: linux-next: manual merge of the cgroup tree with the block tree
Message-Id: <20111220171000.e38cee0ea6b9bafc2851ad4b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_17_10_00_+1100_.ZvkFtMcCGAKD/D2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_17_10_00_+1100_.ZvkFtMcCGAKD/D2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the cgroup tree got a conflict in
block/blk-cgroup.c between commit 6e736be7f282 ("block: make ioc get/put
interface more conventional and fix race on alloction") from the block
tree and commit bb9d97b6dffa ("cgroup: don't use subsys->can_attach_task
() or ->attach_task()") from the cgroup tree.

I guessed about fixing it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc block/blk-cgroup.c
index 2788693,b8c143d..0000000
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@@ -1641,15 -1648,18 +1648,19 @@@ static int blkiocg_can_attach(struct cg
  	return ret;
  }
 =20
- static void blkiocg_attach_task(struct cgroup *cgrp, struct task_struct *=
tsk)
+ static void blkiocg_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
+ 			   struct cgroup_taskset *tset)
  {
+ 	struct task_struct *task;
  	struct io_context *ioc;
 =20
- 	/* we don't lose anything even if ioc allocation fails */
- 	ioc =3D get_task_io_context(tsk, GFP_ATOMIC, NUMA_NO_NODE);
- 	if (ioc) {
- 		ioc_cgroup_changed(ioc);
- 		put_io_context(ioc, NULL);
+ 	cgroup_taskset_for_each(task, cgrp, tset) {
 -		task_lock(task);
 -		ioc =3D task->io_context;
 -		if (ioc)
 -			ioc->cgroup_changed =3D 1;
 -		task_unlock(task);
++		/* we don't lose anything even if ioc allocation fails */
++		ioc =3D get_task_io_context(task, GFP_ATOMIC, NUMA_NO_NODE);
++		if (ioc) {
++			ioc_cgroup_changed(ioc);
++			put_io_context(ioc, NULL);
++		}
  	}
  }
 =20

--Signature=_Tue__20_Dec_2011_17_10_00_+1100_.ZvkFtMcCGAKD/D2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8Ca4AAoJEECxmPOUX5FEg34P/R2cF/IrUyyk9YNpEDzj543a
JXsw3mTT1TTwfT8GSkl2uoZ8q9pqFPPrB8N5vRvIbffavIJUMQvK3qKZpHIrDVv6
ecQDh/hpIH2pzOd056f1tY9WKTAgPLCloMEpjUa8rs4m0beesVEMYeUxseZ5+MVg
8oHjpOLeS0ClJ5Q4+YUtHGlX3yieLs4GEF5Y9HOMxzm3Flozxtk5O5eoVn6UGtk2
PHsOVldI6ZBsuAtIQmHB+p5PBhc8Pk3BP99c5/d7oS/EXvTFq3mBQ4ucuUyFmalR
dKAXIIhjEvXXvvOu9qYHX3Fz/9pbBnOZQ8iAjO4Ychu/vDbfnr0JynhUtZiNndes
y+8bv+2GPsQ8167DeFb6jc7Ksxa0QsuDy9bU8GDTiLMXCDhi1eFUdyHztrxBFKRY
can5qehQcRDpOiypOH90c5i+8SlJpLULzMO4t1nrgnz/BiTDJatEc3+tfxVMPedx
8ZyOn7UxDW2GYQKzCTSQ4vPrgqOu4QkMfbmQoJCJPfioZyx2QwNpCFKjXEXzCyYF
w44i+Y23bX626bxdjds0hED4n8rP4445UVllXjVvub20fGUZgWiA2DZMC4+8CCOo
zsvJ60Ftmc+TWb/VCnkplv2KQ0QepfHrQJGnfXcz8hHSXFn7Kc8GrtIvh3Zy8LKA
YwcOAQJw4d+nEgwABMNd
=T1LV
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_17_10_00_+1100_.ZvkFtMcCGAKD/D2--
