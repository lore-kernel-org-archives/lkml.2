Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab2BVFIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 00:08:55 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47293 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab2BVFIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 00:08:53 -0500
Date: Wed, 22 Feb 2012 16:08:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@intel.com>, Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120222160836.5cb6ee57527e62c180607a8a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Feb_2012_16_08_36_+1100_AvQ_fX2Xv_eIqn0H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Feb_2012_16_08_36_+1100_AvQ_fX2Xv_eIqn0H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from arch/x86/include/asm/suspend_64.h:10:0,
                 from arch/x86/include/asm/suspend.h:4,
                 from arch/x86/kernel/asm-offsets.c:18:
arch/x86/include/asm/i387.h: In function '__thread_clear_has_fpu':
arch/x86/include/asm/i387.h:300:2: error: implicit declaration of function =
'percpu_write' [-Werror=3Dimplicit-function-declaration]
arch/x86/include/asm/i387.h: In function 'fpu_lazy_restore':
arch/x86/include/asm/i387.h:354:2: error: implicit declaration of function =
'percpu_read_stable' [-Werror=3Dimplicit-function-declaration]
arch/x86/include/asm/i387.h:354:13: warning: comparison between pointer and=
 integer [enabled by default]

Caused by commits "percpu: remove percpu_xxx() functions" and "x86:
change percpu_read_stable() to this_cpu_read_stable()" from the akpm tree
interacting with commit 7e16838d94b5 ("i387: support lazy restore of FPU
state") from Linus' tree.

I applied the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 22 Feb 2012 16:00:44 +1100
Subject: [PATCH] percpu: fixup for added percpu_xxx calls in i387.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/include/asm/i387.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 2479049..df1cadd 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -297,14 +297,14 @@ static inline int __thread_has_fpu(struct task_struct=
 *tsk)
 static inline void __thread_clear_has_fpu(struct task_struct *tsk)
 {
 	tsk->thread.fpu.has_fpu =3D 0;
-	percpu_write(fpu_owner_task, NULL);
+	__this_cpu_write(fpu_owner_task, NULL);
 }
=20
 /* Must be paired with a 'clts' before! */
 static inline void __thread_set_has_fpu(struct task_struct *tsk)
 {
 	tsk->thread.fpu.has_fpu =3D 1;
-	percpu_write(fpu_owner_task, tsk);
+	__this_cpu_write(fpu_owner_task, tsk);
 }
=20
 /*
@@ -351,7 +351,7 @@ typedef struct { int preload; } fpu_switch_t;
  */
 static inline int fpu_lazy_restore(struct task_struct *new, unsigned int c=
pu)
 {
-	return new =3D=3D percpu_read_stable(fpu_owner_task) &&
+	return new =3D=3D this_cpu_read_stable(fpu_owner_task) &&
 		cpu =3D=3D new->thread.fpu.last_cpu;
 }
=20
@@ -473,7 +473,7 @@ static inline void kernel_fpu_begin(void)
 		__thread_clear_has_fpu(me);
 		/* We do 'stts()' in kernel_fpu_end() */
 	} else {
-		percpu_write(fpu_owner_task, NULL);
+		__this_cpu_write(fpu_owner_task, NULL);
 		clts();
 	}
 }
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__22_Feb_2012_16_08_36_+1100_AvQ_fX2Xv_eIqn0H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPRHhUAAoJEECxmPOUX5FEPlMP/jJ8+Jt1JIEPkkswpnpHa5PF
mhML3ZJUuMrf1FBzStnW+xqJoOtSEy+bf9UyaeU0iH4OgZeJxIc5trnD0g9Cfkgk
WCwGWc8CH3B7KK10AGE3pGRgiCvkkAr8/7kBblJN6DYGgY1uCroJ0PqiCVZl/JOo
EXzN8peBx8kVZJy/4Jfp+OAyi0cts1Rej2qBu0q9JB5P7uGOjUA33uFl0J9fIHLS
SLyNINH07ZQWm6SG4mPjNOLoo2abJPyZP4JlyECF+51TApsrXyf6FbmQO4Vy2L7J
LRwTxDNywFdoUZR3lk+H/CQtRKh3BJfOexE4EWQDvZF7wpyX7vthAsbp8p4lc82o
0BQECweHaZtYIDnZb2SKQXCt40JgTg85OS6wNnQ00LFgqc27YxcDsYdUCQ7alcQa
Yl6b8oINJuAN0jIshiFdAWs8WBFxAVk7olSrccFK4Ex2lnobQUc+Hs4TMQC85N7+
MZmVkRxNS7ctVsPlhZNwxdPmAoMTyf2zl6XNlaZa8LOhVy2/dPGabWsZbGIqNxaC
tSlh653gH0l6Jx055beDwlPNV0D0FaO0YLXcbt/6v9jyF7OILqEWco/q0uHFSZ37
V+BjwSXvxxG8WG/sM/4KKm8zC2m0CSo70dE/6KsZy7hJzuBTLSoVjxRcxEzPPGmE
NDBUufSqnVKncDcJwtpX
=MSOQ
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Feb_2012_16_08_36_+1100_AvQ_fX2Xv_eIqn0H--
