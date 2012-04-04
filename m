Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2DDDXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 23:23:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49196 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2DDDXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 23:23:45 -0400
Date: Wed, 4 Apr 2012 13:23:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@snapgear.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: linux-next: manual merge of the akpm tree with the m68knommu tree
Message-Id: <20120404132335.d8d55177a608396c9270dc74@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Apr_2012_13_23_35_+1000_OVtsOrOK=sT806Mj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Apr_2012_13_23_35_+1000_OVtsOrOK=sT806Mj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/m68k/kernel/signal_no.c between commit de6bd4f40385 ("m68k: merge
the MMU and non-MMU signal.c code") from the m68knommu tree and commit
"m68k: use set_current_blocked() and block_sigmask()" from the akpm tree.

The former merged this file into arch/m68k/kernel/signal.c, git applied
the changes for arch/m68k/kernel/signal_mm.c in the akpm tree commit
there.  The whole patch is now as below.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index 1747c70..c9f519f 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -230,12 +230,13 @@ static inline void push_cache(unsigned long vaddr)
 asmlinkage int
 sys_sigsuspend(int unused0, int unused1, old_sigset_t mask)
 {
-	mask &=3D _BLOCKABLE;
-	spin_lock_irq(&current->sighand->siglock);
+	sigset_t blocked;
+
 	current->saved_sigmask =3D current->blocked;
-	siginitset(&current->blocked, mask);
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+
+	mask &=3D _BLOCKABLE;
+	siginitset(&blocked, mask);
+	set_current_blocked(&blocked);
=20
 	current->state =3D TASK_INTERRUPTIBLE;
 	schedule();
@@ -804,8 +805,7 @@ asmlinkage int do_sigreturn(unsigned long __unused)
 		goto badframe;
=20
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	current->blocked =3D set;
-	recalc_sigpending();
+	set_current_blocked(&set);
=20
 	if (restore_sigcontext(regs, &frame->sc, frame + 1))
 		goto badframe;
@@ -830,8 +830,7 @@ asmlinkage int do_rt_sigreturn(unsigned long __unused)
 		goto badframe;
=20
 	sigdelsetmask(&set, ~_BLOCKABLE);
-	current->blocked =3D set;
-	recalc_sigpending();
+	set_current_blocked(&set);
=20
 	if (rt_restore_ucontext(regs, sw, &frame->uc))
 		goto badframe;
@@ -1150,10 +1149,7 @@ handle_signal(int sig, struct k_sigaction *ka, sigin=
fo_t *info,
 	if (err)
 		return;
=20
-	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&current->blocked,sig);
-	recalc_sigpending();
+	block_sigmask(ka, sig);
=20
 	if (test_thread_flag(TIF_DELAYED_TRACE)) {
 		regs->sr &=3D ~0x8000;

--Signature=_Wed__4_Apr_2012_13_23_35_+1000_OVtsOrOK=sT806Mj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPe763AAoJEECxmPOUX5FEY5YP/jFVciIcibIhPDjNSg7DRxHv
4ml4xJ3oRU2+8hell/vqsAp4ANVNImHAGcXxHNHYeyDEf/1oPXTPcg9MiBXb3UCI
Rwrtx/oUajZBULxJ7kdCUCa8DsVysQEgbxQAEFbg+MNvH0Gs+CnrXLmuGtFS2fU3
mRtueKxoIzMk+sC18j6mgnuIvtSrtf1zZ/r9Sq7VQcJ7EYveSguGZWyg0hr2SuGZ
jBzotBPbaYKd3flZHB4YywEVZKPPFL8uSrboQRZ39NALd3oLCMK537e2ChtrKiio
6GybHz9PTCRxhPOOML9ifHyTjX2INItES8A/Xe7VfQQfV8chWMb/uKyiMGavKGLo
29R1eWJv+03hr0WLHC796txmsv5jCY18m/0xcVDXqZe/q4+NqgxarcD6gVtaRLUE
Z/v7w69C1Om0VVd9xJ/fOxzEIYwXm92cTFHHz3JP/EPKh95FJvNDpgxpwmn6H7N+
mSoPojXyCMvflBzZDkNUV10a+iCnzHMaZp2KhS4yD2V134wdCXdMf8J1/oa/MQTv
M84OQsG49uZq2UxZ65Z4As9fsKFufv2HQaL/KnRlJZyWRAAVI9tPTEoT8ZMsxcSI
vRjd/vWzW8YBnDY1yVVzz7zbVjwE/dcXzwHgJKROKUiHHnmLWCpe6dwARb9UGNTw
VYN5fC7o0WKqJ4t7bS+s
=MDaP
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Apr_2012_13_23_35_+1000_OVtsOrOK=sT806Mj--
