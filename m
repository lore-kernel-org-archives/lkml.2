Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab1CHT5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:57:54 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47686 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab1CHT5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:57:50 -0500
MIME-Version: 1.0
In-Reply-To: <20110303083035.GB14854@elte.hu>
References: <4D6E8932.1010405@zytor.com> <alpine.LFD.2.00.1103022152420.2701@localhost6.localdomain6>
 <4D6EB07C.5040004@zytor.com> <alpine.LFD.2.00.1103022216180.2701@localhost6.localdomain6>
 <4D6ECBDB.6090307@zytor.com> <20110303083035.GB14854@elte.hu>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Tue, 8 Mar 2011 14:57:29 -0500
Message-ID: <AANLkTik4aTN8+Ob_GVwF17v6pDNGg2DEZJubBazs2e3L@mail.gmail.com>
Subject: Re: RFC: x86: kill binutils 2.16.x?
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Kumar Gala <kumar.gala@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 03:30, Ingo Molnar <mingo@elte.hu> wrote:
> This is how specific GAS functionality is tested in arch/powerpc:
>
>        @if ! /bin/echo dssall | $(AS) -many -o $(TOUT) >/dev/null 2>&1 ; then \
>                echo -n '*** ${VERSION}.${PATCHLEVEL} kernels no longer build ' ; \
>                echo 'correctly with old versions of binutils.' ; \
>                echo '*** Please upgrade your binutils to 2.12.1 or newer' ; \
>                false ; \
>        fi
>
> This would also be a 'constructive' (and safest) way of blacklisting binutils: we'd
> really only exclude binutils that is truly buggy.

Hrm... well... actually...

It's funny that you brought up this particular case.  While I agree
that it's good in general, it's causing problems for me building a
kernel using a recent e500 gcc/binutils (triplet
"powerpc-linux-gnuspe").

Specifically the e500 doesn't have a normal PowerPC FPU, it has a
custom FPU built using extended integer registers instead, and it
happens to borrow the AltiVec opcode range to do it.

When trying to port Debian to the platform we were getting SIGILL's
all over the place until binutils got updated to reject all of the
unsupported opcodes on this particular platform.  Now of course we get
build errors, but that's a lot easier to debug and fix. :-D

Basically, binutils no longer supports "-many" (because too many
opcodes conflict), and the test itself would fail anyways (because
"dssall" is not valid on "any" PowerPC).

So while I think that it is entirely reasonable to add a similar test
for buggy x86 binutils, I'm actually about to send a patch to remove
that particular check from the powerpc Makefile.  Since the "required"
binutils 2.12.1 was released in May 2002 (almost 9 years ago) it's
probably not even worth testing for anymore.

Cheers,
Kyle Moffett
