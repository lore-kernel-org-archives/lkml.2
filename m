Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967041Ab0GSWMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 18:12:13 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:63739 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966620Ab0GSWMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 18:12:08 -0400
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n9mytknlZR"
Content-Transfer-Encoding: 7bit
Message-ID: <19524.52658.716540.932975@pilspetsen.it.uu.se>
Date: Tue, 20 Jul 2010 00:12:02 +0200
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


--n9mytknlZR
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

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

And here's the test module.

To illustrate the bug it uses math-emu to convert a series of
single-bit power-of-two ints to corresponding floats and back,
and prints the intermediate representations and the differences
between the original values and the final ones.  These ints all
have exact float representations so there should be no differences.

But for 0x08000000 the conversion goes wrong.  The test case
then converts a few more numbers near this one and up to the next
power-of-two which did convert Ok.

With an unpatched kernel you get the following kernel messages
after insmod:

mathemu_test: init
test_itof: 0x40000000 -> 0x4e800000 -> 0x40000000, diff 0
test_itof: 0x20000000 -> 0x4e000000 -> 0x20000000, diff 0
test_itof: 0x10000000 -> 0x4d800000 -> 0x10000000, diff 0
test_itof: 0x08000000 -> 0x4d800000 -> 0x10000000, diff 134217728
test_itof: 0x04000000 -> 0x4c800000 -> 0x04000000, diff 0
test_itof: 0x02000000 -> 0x4c000000 -> 0x02000000, diff 0
test_itof: 0x01000000 -> 0x4b800000 -> 0x01000000, diff 0
test_itof: 0x00800000 -> 0x4b000000 -> 0x00800000, diff 0
test_itof: 0x0f000000 -> 0x4de00000 -> 0x1c000000, diff 218103808
test_itof: 0x0e000000 -> 0x4dc00000 -> 0x18000000, diff 167772160
test_itof: 0x0d000000 -> 0x4da00000 -> 0x14000000, diff 117440512
test_itof: 0x0c000000 -> 0x4d800000 -> 0x10000000, diff 67108864
test_itof: 0x0b000000 -> 0x4de00000 -> 0x1c000000, diff 285212672
test_itof: 0x0a000000 -> 0x4dc00000 -> 0x18000000, diff 234881024
test_itof: 0x09000000 -> 0x4da00000 -> 0x14000000, diff 184549376
test_itof: 0x08000000 -> 0x4d800000 -> 0x10000000, diff 134217728
test_itof: 0x07000000 -> 0x4ce00000 -> 0x07000000, diff 0

With the patch applied, you instead get this:

mathemu_test: init
test_itof: 0x40000000 -> 0x4e800000 -> 0x40000000, diff 0
test_itof: 0x20000000 -> 0x4e000000 -> 0x20000000, diff 0
test_itof: 0x10000000 -> 0x4d800000 -> 0x10000000, diff 0
test_itof: 0x08000000 -> 0x4d000000 -> 0x08000000, diff 0
test_itof: 0x04000000 -> 0x4c800000 -> 0x04000000, diff 0
test_itof: 0x02000000 -> 0x4c000000 -> 0x02000000, diff 0
test_itof: 0x01000000 -> 0x4b800000 -> 0x01000000, diff 0
test_itof: 0x00800000 -> 0x4b000000 -> 0x00800000, diff 0
test_itof: 0x0f000000 -> 0x4d700000 -> 0x0f000000, diff 0
test_itof: 0x0e000000 -> 0x4d600000 -> 0x0e000000, diff 0
test_itof: 0x0d000000 -> 0x4d500000 -> 0x0d000000, diff 0
test_itof: 0x0c000000 -> 0x4d400000 -> 0x0c000000, diff 0
test_itof: 0x0b000000 -> 0x4d300000 -> 0x0b000000, diff 0
test_itof: 0x0a000000 -> 0x4d200000 -> 0x0a000000, diff 0
test_itof: 0x09000000 -> 0x4d100000 -> 0x09000000, diff 0
test_itof: 0x08000000 -> 0x4d000000 -> 0x08000000, diff 0
test_itof: 0x07000000 -> 0x4ce00000 -> 0x07000000, diff 0

Unfortunately it seems difficult to write a generic module
which uses math-emu:
- <math-emu/soft-fp.h> includes <asm/sfp-machine.h>,
  but only a handful of archs have it
- <asm/sfp-machine.h> isn't always self-contained and may depend
  on various $arch-specific declarations being present

The given test module works on sparc64 and ppc64, where it uses
the kernel's sfp-machine.h, and on x86 where it uses a stub
sfp-machine.h supplied by itself.  I tried to cross-compile it
for alpha, but that failed due to its sfp-machine.h not being
self-contained.  I didn't try sh or s390.

/Mikael


--n9mytknlZR
Content-Type: application/octet-stream
Content-Description: math-emu test module
Content-Disposition: attachment;
	filename="mathemu_test.tar.gz"
Content-Transfer-Encoding: base64

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
KAAA
--n9mytknlZR--
