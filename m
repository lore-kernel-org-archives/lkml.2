Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab0G3TRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:17:43 -0400
Received: from kroah.org ([198.145.64.141]:46225 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab0G3RRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:17:53 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:01 2010
Message-Id: <20100730171501.121605338@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikael Pettersson <mikpe@it.uu.se>,
        "David S. Miller" <davem@davemloft.net>
Subject: [016/165] math-emu: correct test for downshifting fraction in _FP_FROM_INT()
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikael Pettersson <mikpe@it.uu.se>

commit f8324e20f8289dffc646d64366332e05eaacab25 upstream.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/math-emu/op-common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/math-emu/op-common.h
+++ b/include/math-emu/op-common.h
@@ -799,7 +799,7 @@ do {									\
 		X##_e -= (_FP_W_TYPE_SIZE - rsize);			\
 	X##_e = rsize - X##_e - 1;					\
 									\
-	if (_FP_FRACBITS_##fs < rsize && _FP_WFRACBITS_##fs < X##_e)	\
+	if (_FP_FRACBITS_##fs < rsize && _FP_WFRACBITS_##fs <= X##_e)	\
 	  __FP_FRAC_SRS_1(ur_, (X##_e - _FP_WFRACBITS_##fs + 1), rsize);\
 	_FP_FRAC_DISASSEMBLE_##wc(X, ur_, rsize);			\
 	if ((_FP_WFRACBITS_##fs - X##_e - 1) > 0)			\


