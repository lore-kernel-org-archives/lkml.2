Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0GTNf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 09:35:28 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:60201 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab0GTNf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 09:35:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19525.42521.198122.812309@pilspetsen.it.uu.se>
Date: Tue, 20 Jul 2010 15:35:21 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-sh@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] math-emu: correct test for downshifting fraction in _FP_FROM_INT()
In-Reply-To: <19524.51858.992299.119315@pilspetsen.it.uu.se>
References: <19524.51858.992299.119315@pilspetsen.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > The kernel's math-emu code contains a macro _FP_FROM_INT() which is
 > used to convert an integer to a raw normalized floating-point value.
 > It does this basically in three steps:
 > 
 > 1. Compute the exponent from the number of leading zero bits.
 > 2. Downshift large fractions to put the MSB in the right position
 >    for normalized fractions.
 > 3. Upshift small fractions to put the MSB in the right position.
 > 
 > There is an boundary error in step 2, causing a fraction with its
 > MSB exactly one bit above the normalized MSB position to not be
 > downshifted.  This results in a non-normalized raw float, which when
 > packed becomes a massively inaccurate representation for that input.
 > 
 > The impact of this depends on a number of arch-specific factors,
 > but it is known to have broken emulation of FXTOD instructions
 > on UltraSPARC III, which was originally reported as GCC bug 44631
 > <http://gcc.gnu.org/bugzilla/show_bug.cgi?id=44631>.
 > 
 > Any arch which uses math-emu to emulate conversions from integers to
 > same-size floats may be affected.
 > 
 > The fix is simple: the exponent comparison used to determine if the
 > fraction should be downshifted must be "<=" not "<".
 > 
 > I'm sending a kernel module to test this as a reply to this message.
 > There are also SPARC user-space test cases in the GCC bug entry.
 > 
 > Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>

I forgot to mention that this needs to be backported to older kernels,
so can the maintainer who picks this up please add

	Cc: stable@kernel.org

Thanks,

/Mikael

 > ---
 >  include/math-emu/op-common.h |    2 +-
 >  1 file changed, 1 insertion(+), 1 deletion(-)
 > 
 > diff -rupN linux-2.6.35-rc5/include/math-emu/op-common.h linux-2.6.35-rc5.mathemu-FP_FROM_INT-fraction-downshift-condition/include/math-emu/op-common.h
 > --- linux-2.6.35-rc5/include/math-emu/op-common.h	2010-05-17 19:51:32.000000000 +0200
 > +++ linux-2.6.35-rc5.mathemu-FP_FROM_INT-fraction-downshift-condition/include/math-emu/op-common.h	2010-07-18 22:33:46.000000000 +0200
 > @@ -799,7 +799,7 @@ do {									\
 >  		X##_e -= (_FP_W_TYPE_SIZE - rsize);			\
 >  	X##_e = rsize - X##_e - 1;					\
 >  									\
 > -	if (_FP_FRACBITS_##fs < rsize && _FP_WFRACBITS_##fs < X##_e)	\
 > +	if (_FP_FRACBITS_##fs < rsize && _FP_WFRACBITS_##fs <= X##_e)	\
 >  	  __FP_FRAC_SRS_1(ur_, (X##_e - _FP_WFRACBITS_##fs + 1), rsize);\
 >  	_FP_FRAC_DISASSEMBLE_##wc(X, ur_, rsize);			\
 >  	if ((_FP_WFRACBITS_##fs - X##_e - 1) > 0)			\
 > --
 > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html
 > Please read the FAQ at  http://www.tux.org/lkml/
 > 
