Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1CIF16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 00:27:58 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33307 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1CIF15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 00:27:57 -0500
MIME-Version: 1.0
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 9 Mar 2011 00:22:11 -0500
Message-ID: <AANLkTi=PXwh7ZCT1hW=OgBSH_U5CXaDt7yj+dSjfstJU@mail.gmail.com>
Subject: powerpc/e500: binutils tests [Was: RFC: x86: kill binutils 2.16.x?]
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org,
        Kyle Moffett <kyle.d.moffett@boeing.com>,
        Kumar Gala <kumar.gala@freescale.com>, sebastian@breakpoint.cc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 23:39, Segher Boessenkool
<segher@kernel.crashing.org> wrote:
>> The problem is not with the kernel compile itself, but with the 2.12
>> "dssall" binutils test.  Basically, recent binutils treats e500 as
>> effectively a separate architecture that happens to share *most* of
>> the opcodes with regular PowerPC.  Any opcode which is not understood
>> by the e500 chip is either convert to an equivalent opcode which is
>> understood (IE: lwsync => sync), or failed with an error.  This means
>> that the kernel compile aborts early telling me to upgrade to a newer
>> version of binutils.
>
> $ echo dssall | powerpc-linux-as -many -me500
> $ powerpc-linux-objdump -d a.out | grep 0:
>   0:   7e 00 06 6c     dssall
> $ powerpc-linux-as --version | head -1
> GNU assembler (GNU Binutils) 2.21.51.20110309
>
> What version of binutils does not work?  (I also checked with
> -me500x2, -me500mc, -mspe, and various combinations.  lwsync
> is indeed converted to a regular sync (well, "msync") for e500
> and e500x2).

Hmm, something's fishy here.

Just going based on this changeset, the floating point and AltiVec
opcodes are *supposed* to generate hard errors:
  http://sourceware.org/ml/binutils-cvs/2010-06/msg00070.html

Oh... that patch only disables the opcodes if "-many" is not specified.

Aha! The native compiler on my Debian e500 boxes right now is hidden
behind a small wrapper script which removes "-many" and "-Wa,-many"
and generates errors for anything else that isn't "-me500".  My GCC
also excludes the "-many" option when calling the linker directly.

So I think this is only a "local" problem right now, actually, sorry
for the noise and confusion.  If I log into that system and run "echo
dssall | as", I get the expected hard error, and due to the wrapper
scripts in place I get the same error from "echo dssall | as -me500x2
-many"

Unfortunately I still need to have the assembler generate hard errors
when someone tries to natively compile code with AltiVec or
classic-FPU instructions, otherwise I have no way of detecting
unported software at build-time.

Would a patch to make the Altivec "dssall" test conditional on
CONFIG_ALTIVEC be acceptable?  That really is the only test that
causes the kernel compile to fail with the strict wrappers.

Cheers,
Kyle Moffett
