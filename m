Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967026Ab0GSV6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:58:53 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:62427 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966979Ab0GSV6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:58:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19524.51858.992299.119315@pilspetsen.it.uu.se>
Date: Mon, 19 Jul 2010 23:58:42 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] math-emu: correct test for downshifting fraction in _FP_FROM_INT()
Cc: sparclinux@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-sh@vger.kernel.org,
        linuxppc-dev@ozlabs.org
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel's math-emu code contains a macro _FP_FROM_INT() which is
used to convert an integer to a raw normalized floating-point value.
It does this basically in three steps:

1. Compute the exponent from the number of leading zero bits.
2. Downshift large fractions to put the MSB in the right position
   for normalized fractions.
3. Upshift small fractions to put the MSB in the right position.

There is an boundary error in step 2, causing a fraction with its
MSB exactly one bit above the normalized MSB position to not be
downshifted.  This results in a non-normalized raw float, which when
packed becomes a massively inaccurate representation for that input.

The impact of this depends on a number of arch-specific factors,
but it is known to have broken emulation of FXTOD instructions
on UltraSPARC III, which was originally reported as GCC bug 44631
<http://gcc.gnu.org/bugzilla/show_bug.cgi?id=44631>.

Any arch which uses math-emu to emulate conversions from integers to
same-size floats may be affected.

The fix is simple: the exponent comparison used to determine if the
fraction should be downshifted must be "<=" not "<".

I'm sending a kernel module to test this as a reply to this message.
There are also SPARC user-space test cases in the GCC bug entry.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 include/math-emu/op-common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -rupN linux-2.6.35-rc5/include/math-emu/op-common.h linux-2.6.35-rc5.mathemu-FP_FROM_INT-fraction-downshift-condition/include/math-emu/op-common.h
--- linux-2.6.35-rc5/include/math-emu/op-common.h	2010-05-17 19:51:32.000000000 +0200
+++ linux-2.6.35-rc5.mathemu-FP_FROM_INT-fraction-downshift-condition/include/math-emu/op-common.h	2010-07-18 22:33:46.000000000 +0200
@@ -799,7 +799,7 @@ do {									\
 		X##_e -= (_FP_W_TYPE_SIZE - rsize);			\
 	X##_e = rsize - X##_e - 1;					\
 									\
-	if (_FP_FRACBITS_##fs < rsize && _FP_WFRACBITS_##fs < X##_e)	\
+	if (_FP_FRACBITS_##fs < rsize && _FP_WFRACBITS_##fs <= X##_e)	\
 	  __FP_FRAC_SRS_1(ur_, (X##_e - _FP_WFRACBITS_##fs + 1), rsize);\
 	_FP_FRAC_DISASSEMBLE_##wc(X, ur_, rsize);			\
 	if ((_FP_WFRACBITS_##fs - X##_e - 1) > 0)			\
