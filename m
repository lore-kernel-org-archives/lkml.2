Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2BYRjb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 12:39:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31938 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab2BYRja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 12:39:30 -0500
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=0XEKaFmjbKEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=COIMdTyV95FYDTYJnmsA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Z-VapH8XUjUJleW-EfcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120225173928.559517896@goodmis.org>
User-Agent: quilt/0.50-1
Date: Sat, 25 Feb 2012 12:35:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] x86: Fix the NMI nesting comments
References: <20120225173548.977089274@goodmis.org>
Content-Disposition: inline; filename=0002-x86-Fix-the-NMI-nesting-comments.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Some of the comments for the nesting NMI algorithm were stale and
had some references to some prototypes that were first tried.

I also updated the comments to be a little easier to understand
the flow of the code. It definitely needs the documentation.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e0eca00..2de3e45 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1624,11 +1624,12 @@ first_nmi:
 	 * | pt_regs                 |
 	 * +-------------------------+
 	 *
-	 * The saved RIP is used to fix up the copied RIP that a nested
-	 * NMI may zero out. The original stack frame and the temp storage
+	 * The saved stack frame is used to fix up the copied stack frame
+	 * that a nested NMI may change to make the interrupted NMI iret jump
+	 * to the repeat_nmi. The original stack frame and the temp storage
 	 * is also used by nested NMIs and can not be trusted on exit.
 	 */
-	/* Do not pop rdx, nested NMIs will corrupt it */
+	/* Do not pop rdx, nested NMIs will corrupt that part of the stack */
 	movq (%rsp), %rdx
 	CFI_RESTORE rdx
=20
@@ -1641,6 +1642,8 @@ first_nmi:
 	.endr
 	CFI_DEF_CFA_OFFSET SS+8-RIP
=20
+	/* Everything up to here is safe from nested NMIs */
+
 	/*
 	 * If there was a nested NMI, the first NMI's iret will return
 	 * here. But NMIs are still enabled and we can take another
@@ -1667,9 +1670,8 @@ end_repeat_nmi:
=20
 	/*
 	 * Everything below this point can be preempted by a nested
-	 * NMI if the first NMI took an exception. Repeated NMIs
-	 * caused by an exception and nested NMI will start here, and
-	 * can still be preempted by another NMI.
+	 * NMI if the first NMI took an exception and reset our iret stack
+	 * so that we repeat another NMI.
 	 */
 	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
 	subq $ORIG_RAX-R15, %rsp
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPSRzQAAoJEIy3vGnGbaoASdYP/A9i2kIGMNzg2cTCN+QpBtFD
MSBisOqp0qPfO+KHRgxP9mY/m/YyqX6WiFUDy3kS4JYTLd/Te41Y4jBG1bgjQn0m
l+sNeXNjahgzQIXQCExhcoSkNDzmrO6cVGnFX/+QR9IDRXh2H+jKNK16ENYF4mUu
tsRFVpMlf/6JvLFZ+ecyjzzY0Vh5zHbEJD7Jvuq0dl6NRNkxHb+g1dZWZS4PgrA9
+rsTVDSdmn1MCPQ7C0l1rMmDe4z+95lfsN23mv3LjCmnPHpCEtJ8a6pDJs8/GkaM
jda9krIkfKDkI8tS/O7sjd0DnGAZ3mcRWjKzH0AgGgCN/hPNNphWspgEuwWi76zR
/lOJw/Q+f7rG2qCykSpk4U0/tVJCc4N58Lowc3HpOly4nuLgqQFjtL6dpNjDcYQB
nehUpYVG/DMeY+HgkmY/bb0FlSekg4o1J4JMuilPVcgJUX+Siif8ZATvJlIey9PZ
MWTqQSqaM/2PO+Kc0ET2jXCP13ZW2e2MjePvVoDy2hhb3uyAHatcnlz5wm/oiFHp
hx//IgoeTGWldT+yfbJHmF1CLtZ1R1tmj5fWjc28PyFFsYAoOTlOAKJNIRGoTHCS
btjO/rvYRn6pITCRj2aYozkFj5w7IrdIJCqbF4PT961Cw9aQheQ/hhUDwbTmbt7S
pHMCcl6HMMVDS94hiIcy
=Hp1q
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
