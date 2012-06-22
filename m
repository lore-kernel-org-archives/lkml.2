Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab2FVFCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:02:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58492 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab2FVFCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:02:08 -0400
Date: Fri, 22 Jun 2012 15:01:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20120622150146.73806542cc4bac1beb317fe0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Jun_2012_15_01_46_+1000_eqtgGADHG0OEflqq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Jun_2012_15_01_46_+1000_eqtgGADHG0OEflqq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in mm/mempolicy.c
between commit c4c0e9e544a0 ("mm, mempolicy: fix mbind() to do
synchronous migration") from Linus' tree and various commits from the tip
tree.

The latter rewrote bits of this file, so I used it and effectively
reapplied the former patch (see below).  I hope it came out right.

The diff of this file from the tip tree version looks like this (the
second hunk comes from the slab tree):

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2218157..aeb58da 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1146,7 +1146,7 @@ long mpol_do_mbind(unsigned long start, unsigned long=
 len,
 		else {
 			nr_failed =3D migrate_pages(&pagelist, new_vma_page,
 					(unsigned long)vma,
-					false, true);
+					false, MIGRATE_SYNC);
 		}
 	}
=20
@@ -1702,8 +1702,14 @@ static struct zonelist *policy_zonelist(gfp_t gfp, s=
truct mempolicy *policy,
  * task can change it's policy.  The system default policy requires no
  * such protection.
  */
-unsigned slab_node(struct mempolicy *policy)
+unsigned slab_node(void)
 {
+	struct mempolicy *policy;
+
+	if (in_interrupt())
+		return numa_node_id();
+
+	policy =3D current->mempolicy;
 	if (!policy || policy->flags & MPOL_F_LOCAL)
 		return numa_node_id();
=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/mempolicy.c
index bd92431,2218157..0000000
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@@ -1097,6 -1085,81 +1085,81 @@@ static struct page *new_vma_page(struc
  }
  #endif
 =20
+ long mpol_do_mbind(unsigned long start, unsigned long len,
+ 		struct mempolicy *new, unsigned long mode,
+ 		nodemask_t *nmask, unsigned long flags)
+ {
+ 	struct mm_struct *mm =3D current->mm;
+ 	struct vm_area_struct *vma;
+ 	int err, nr_failed =3D 0;
+ 	unsigned long end;
+ 	LIST_HEAD(pagelist);
+=20
+ 	len =3D (len + PAGE_SIZE - 1) & PAGE_MASK;
+ 	end =3D start + len;
+=20
+ 	if (end < start) {
+ 		err =3D -EINVAL;
+ 		goto mpol_out;
+ 	}
+=20
+ 	if (end =3D=3D start) {
+ 		err =3D 0;
+ 		goto mpol_out;
+ 	}
+=20
+ 	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) {
+ 		err =3D migrate_prep();
+ 		if (err)
+ 			goto mpol_out;
+ 	}
+=20
+ 	if (mode !=3D MPOL_NOOP) {
+ 		NODEMASK_SCRATCH(scratch);
+ 		err =3D -ENOMEM;
+ 		if (scratch) {
+ 			task_lock(current);
+ 			err =3D mpol_set_nodemask(new, nmask, scratch);
+ 			task_unlock(current);
+ 		}
+ 		NODEMASK_SCRATCH_FREE(scratch);
+ 		if (err)
+ 			goto mpol_out;
+ 	}
+=20
+ 	vma =3D check_range(mm, start, end, nmask,
+ 			  flags | MPOL_MF_INVERT, &pagelist);
+=20
+ 	err =3D PTR_ERR(vma);	/* maybe ... */
+ 	if (IS_ERR(vma))
+ 		goto mpol_out_putback;
+=20
+ 	if (mode !=3D MPOL_NOOP) {
+ 		err =3D mbind_range(mm, start, end, new);
+ 		if (err)
+ 			goto mpol_out_putback;
+ 	}
+=20
+ 	if (!list_empty(&pagelist)) {
+ 		if (flags & MPOL_MF_LAZY)
+ 			nr_failed =3D migrate_pages_unmap_only(&pagelist);
+ 		else {
+ 			nr_failed =3D migrate_pages(&pagelist, new_vma_page,
+ 					(unsigned long)vma,
 -					false, true);
++					false, MIGRATE_SYNC);
+ 		}
+ 	}
+=20
+ 	if (nr_failed && (flags & MPOL_MF_STRICT))
+ 		err =3D -EIO;
+=20
+ mpol_out_putback:
+ 	putback_lru_pages(&pagelist);
+=20
+ mpol_out:
+ 	return err;
+ }
+=20
  static long do_mbind(unsigned long start, unsigned long len,
  		     unsigned short mode, unsigned short mode_flags,
  		     nodemask_t *nmask, unsigned long flags)

--Signature=_Fri__22_Jun_2012_15_01_46_+1000_eqtgGADHG0OEflqq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4/w6AAoJEECxmPOUX5FEVz4P/AuIUsQiu1jqC+rHIt38sM2A
bUcfvP41iHX81ElhAfsd75OVo/eqm9y/n3m6x0V63D1cA53hL4des8yOd+CpIQD2
q+1a9IXFUBTKLlzNjVMbTVpLdUGPeResJmJNXqzNJw/bQxv2H84IyugrHp7VQkNP
Op3W4NMvj6Z1E5EAINrcfo+JZ/UmZVejmQ2/g/NIEMpgL9dgrGILThdrKFQzlUDB
yD3rbpP7ItnaawZn6JwULoFnT1senv4AUi5QnlWaMPEJMCj8XSnvPMXk8yF2A7F+
pjWvs5mazwGat57SjyGuD6z9m9262V8l1WoF+Chuv8tUNpbEWQQ/GtjgJcjZl30I
X4lvQlckbCp5Ii/omlLsl7G0xuAmHxuilNhXJ7wvWoTrcS3NcEGNv7quUF1cvgBS
Uop4JwApZT0RxyoGfSdJt2FkvLm3WiAbHgU00lAwzY5iWMX+Gg/J0mNsdzIwUskj
nHc2OwBIp3HbvvzNsGG5CDyKn0YCXVj9H7pmvmwy4OpbOWWo+j13pk4+8y4I8dSq
GtP/aedDRR1dLeeqfSeG38icelXFOpKCa0eFaAm6Sy0ihGN5t4BmQIYX9CkfxFHv
6c/nQGCj18OmXluDfoeNRnnp54iu+q6H7dLGbN3jKsTDb9oPNc2l964gjkJiVeFq
p7fBPQNmY4ua0rX5f09s
=ZtXe
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Jun_2012_15_01_46_+1000_eqtgGADHG0OEflqq--
