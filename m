Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2JOAc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 20:32:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33201 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2JOAc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 20:32:27 -0400
Date: Mon, 15 Oct 2012 11:32:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20121015113214.e52b7d9da7a88d762d73be97@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__15_Oct_2012_11_32_14_+1100_i6FIAABmqVyr=xkU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Oct_2012_11_32_14_+1100_i6FIAABmqVyr=xkU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
include/linux/mempolicy.h between commit 607ca46e97a1 ("UAPI: (Scripted)
Disintegrate include/linux") from Linus' tree and commits 6f98f92971e9
("mm/mpol: Make MPOL_LOCAL a real policy"), 84e3a981648d ("mm/mpol: Add
MPOL_MF_LAZY ..."), 0719b9688bfe ("mm/mpol: Add MPOL_MF_NOOP"),
4d58c795f691 ("mm/mpol: Check for misplaced page") and fa74ef9e42df
("sched/numa: Implement per task memory placement for 'big' processes")
from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

I also added this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 15 Oct 2012 11:14:21 +1100
Subject: [PATCH] mm/pol: fixups for UAPI include files split

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/uapi/linux/mempolicy.h |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 23e62e0..0c774c6 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -20,6 +20,8 @@ enum {
 	MPOL_PREFERRED,
 	MPOL_BIND,
 	MPOL_INTERLEAVE,
+	MPOL_LOCAL,
+	MPOL_NOOP,		/* retain existing policy for range */
 	MPOL_MAX,	/* always last member of enum */
 };
=20
@@ -47,9 +49,16 @@ enum mpol_rebind_step {
=20
 /* Flags for mbind */
 #define MPOL_MF_STRICT	(1<<0)	/* Verify existing pages in the mapping */
-#define MPOL_MF_MOVE	(1<<1)	/* Move pages owned by this process to conform=
 to mapping */
-#define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to mapping */
-#define MPOL_MF_INTERNAL (1<<3)	/* Internal flags start here */
+#define MPOL_MF_MOVE	 (1<<1)	/* Move pages owned by this process to conform
+				   to policy */
+#define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to policy */
+#define MPOL_MF_LAZY	 (1<<3)	/* Modifies '_MOVE:  lazy migrate on fault */
+#define MPOL_MF_INTERNAL (1<<4)	/* Internal flags start here */
+
+#define MPOL_MF_VALID	(MPOL_MF_STRICT   | 	\
+			 MPOL_MF_MOVE     | 	\
+			 MPOL_MF_MOVE_ALL |	\
+			 MPOL_MF_LAZY)
=20
 /*
  * Internal flags that share the struct mempolicy flags word with
@@ -59,6 +68,7 @@ enum mpol_rebind_step {
 #define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
 #define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
 #define MPOL_F_REBINDING (1 << 2)	/* identify policies in rebinding */
-
+#define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
+#define MPOL_F_HOME	(1 << 4) /* this is the home-node policy */
=20
 #endif /* _UAPI_LINUX_MEMPOLICY_H */
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mempolicy.h
index e5ccb9d,67c9734..0000000
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@@ -2,10 -7,72 +2,9 @@@
   * NUMA memory policies for Linux.
   * Copyright 2003,2004 Andi Kleen SuSE Labs
   */
 -
 -/*
 - * Both the MPOL_* mempolicy mode and the MPOL_F_* optional mode flags are
 - * passed by the user to either set_mempolicy() or mbind() in an 'int' ac=
tual.
 - * The MPOL_MODE_FLAGS macro determines the legal set of optional mode fl=
ags.
 - */
 -
 -/* Policies */
 -enum {
 -	MPOL_DEFAULT,
 -	MPOL_PREFERRED,
 -	MPOL_BIND,
 -	MPOL_INTERLEAVE,
 -	MPOL_LOCAL,
 -	MPOL_NOOP,		/* retain existing policy for range */
 -	MPOL_MAX,	/* always last member of enum */
 -};
 -
 -enum mpol_rebind_step {
 -	MPOL_REBIND_ONCE,	/* do rebind work at once(not by two step) */
 -	MPOL_REBIND_STEP1,	/* first step(set all the newly nodes) */
 -	MPOL_REBIND_STEP2,	/* second step(clean all the disallowed nodes)*/
 -	MPOL_REBIND_NSTEP,
 -};
 -
 -/* Flags for set_mempolicy */
 -#define MPOL_F_STATIC_NODES	(1 << 15)
 -#define MPOL_F_RELATIVE_NODES	(1 << 14)
 -
 -/*
 - * MPOL_MODE_FLAGS is the union of all possible optional mode flags passe=
d to
 - * either set_mempolicy() or mbind().
 - */
 -#define MPOL_MODE_FLAGS	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
 -
 -/* Flags for get_mempolicy */
 -#define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
 -#define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
 -#define MPOL_F_MEMS_ALLOWED (1<<2) /* return allowed memories */
 -
 -/* Flags for mbind */
 -#define MPOL_MF_STRICT	(1<<0)	/* Verify existing pages in the mapping */
 -#define MPOL_MF_MOVE	 (1<<1)	/* Move pages owned by this process to confo=
rm
 -				   to policy */
 -#define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to policy */
 -#define MPOL_MF_LAZY	 (1<<3)	/* Modifies '_MOVE:  lazy migrate on fault */
 -#define MPOL_MF_INTERNAL (1<<4)	/* Internal flags start here */
 -
 -#define MPOL_MF_VALID	(MPOL_MF_STRICT   | 	\
 -			 MPOL_MF_MOVE     | 	\
 -			 MPOL_MF_MOVE_ALL |	\
 -			 MPOL_MF_LAZY)
 -
 -/*
 - * Internal flags that share the struct mempolicy flags word with
 - * "mode flags".  These flags are allocated from bit 0 up, as they
 - * are never OR'ed into the mode in mempolicy API arguments.
 - */
 -#define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
 -#define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
 -#define MPOL_F_REBINDING (1 << 2)	/* identify policies in rebinding */
 -#define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
 -#define MPOL_F_HOME	(1 << 4) /* this is the home-node policy */
 -
 -#ifdef __KERNEL__
 +#ifndef _LINUX_MEMPOLICY_H
 +#define _LINUX_MEMPOLICY_H 1
 =20
-=20
  #include <linux/mmzone.h>
  #include <linux/slab.h>
  #include <linux/rbtree.h>
@@@ -323,5 -393,13 +326,11 @@@ static inline int mpol_to_str(char *buf
  	return 0;
  }
 =20
+ static inline int mpol_misplaced(struct page *page, struct vm_area_struct=
 *vma,
+ 				 unsigned long address)
+ {
+ 	return -1; /* no node preference */
+ }
+=20
  #endif /* CONFIG_NUMA */
 -#endif /* __KERNEL__ */
 -
  #endif

--Signature=_Mon__15_Oct_2012_11_32_14_+1100_i6FIAABmqVyr=xkU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQe1mOAAoJEECxmPOUX5FECe0QAJS7DZJaYJJQJBI1KAQZ4JeI
vxheCM0WAr4jBjvJ2vDIa/SHTITEsxDfPzdBtKuleTMTWWc9OZ24icMxjGPrQT67
laupwob4Q5knNTruzgbcBvq+B3najuET06HhMhOQK+xGX79wX9eufXNHIvxhsnP/
dELV+eHOqcbB4KXwvWBYbytrCjB6sH4Jv9hQAfVh609ROOvgzljdM9Y4LegwpjcB
iQQRXDouV7U2iYAzlrL6S0Gmo59aIt8M1NMuPwUlayQMMC4RsiG+CJkpwOPlJ4Ft
L3/0iWqV7bY/p0rFSPOpi3+XHvCZAYJiqDYfu/ARj4PBxs4omgEks7iKGs45MGZO
aUIFvpbCKPJETKljnLBsYeUMYzXo7CNgwcGGkndxsDOLQOzS5lapuKCgUNWLhJmV
yNWCPgSe3P8TGlFRROhR5NMKLz5FgdN9cHPjXXLaDWMa6He37n1jUCBrecYwjxbC
SCf2fLBkd4+z5iOZw9hGcnNomZYtJTuHYzNLiFN/fFS9gIYBt0XGllKoDjZI1qpT
tqYUOIwsMDJQx7rA12lxACs16dacXdPy6kRyj6E7kqxsPxz1kApmq2qHZi7GHDSH
gHdCzqLqRgGjFdcRbmlfH3hYHn8fBERstQDecacGAsrJhRcn0sspryudjhEjAbqa
DhSGuQDUGokOR6FX/DS1
=AH1Q
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Oct_2012_11_32_14_+1100_i6FIAABmqVyr=xkU--
