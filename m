Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0KOLSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:18:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284Ab0KOLSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:18:09 -0500
Date: Mon, 15 Nov 2010 12:16:42 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org,
        Jim Bos <jim876@xs4all.nl>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <4CD843DC.10106@gmail.com>
 <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
 <20101109134816.GB29433@basil.fritz.box>
 <m3lj52txaq.fsf@redhat.com>
 <4CD97A3D.1040602@xs4all.nl>
 <m31v6nmmr3.fsf@jhcloos.com>
 <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
 <20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
 <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
 <20101115105446.GD7269@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115105446.GD7269@basil.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 11:54:46AM +0100, Andi Kleen wrote:
> > And for this the starting point should be what has been requested,
> > i.e. preprocessed source + gcc options + gcc version and some hints what
> > actually misbehaves (with the , "+m" (*regs) change reverted)
> > in gcc bugzilla.  Only with that we can actually look at what has been
> > happening, see whether it is the tree optimizations or RTL and which one
> > makes a difference.
> > If I've missed a PR about this I apologize. 
> 
> I tried to file one, but I can't reproduce it currently
> (I don't have hardware, so have to rely on code reading and the 32bit
> code looks correct to me even without the additional +m)
> 
> The preprocessed source is at
> http://halobates.de/tmp/i8k.i
> 
> Options I used:
> 
>  -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -fno-delete-null-pointer-checks -O2 -m32 -msoft-float -mregparm=3 -freg-struct-return -mpreferred-stack-boundary=2 -march=i686 -mtune=pentium3 -mtune=generic -maccumulate-outgoing-args -Wa,-mtune=generic32 -ffreestanding -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -Wframe-larger-than=2048 -fno-stack-protector -fno-omit-frame-pointer -fno-optimize-sibling-calls -pg -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack

Indeed, with this and 4.5.2 20101111 (prerelease) from SVN as well as
gcc-4.5.1-5.fc14:

...
        movl    %eax, -16(%ebp) # regs, %sfp
        movl    (%eax), %eax    # regs_2(D)->eax,
        movl    %eax, -20(%ebp) #, %sfp
        movl    -16(%ebp), %eax # %sfp,
#APP
# 149 "/home/lsrc/git/linux-work2/drivers/char/i8k.c" 1
...
#NO_APP
        testl   %eax, %eax      #
        movl    $-22, %edx      #, D.18378
        movl    %eax, -24(%ebp) #, %sfp
        je      .L7     #,
.L2:
        movl    -12(%ebp), %ebx #,
        movl    %edx, %eax      # D.18378,
        movl    -8(%ebp), %esi  #,
        movl    -4(%ebp), %edi  #,
        movl    %ebp, %esp      #,
        popl    %ebp    #
        ret
        .p2align 4,,7
        .p2align 3
.L7:
        movl    -16(%ebp), %eax # %sfp,
        movl    (%eax), %ecx    # regs_2(D)->eax, D.18371
        cmpw    $-1, %cx        #, D.18371
        je      .L2     #,
        cmpl    %ecx, -20(%ebp) # D.18371, %sfp
        cmovne  -24(%ebp), %edx # %sfp,, D.18378
        jmp     .L2     #
        .size   i8k_smm, .-i8k_smm

I don't see any problems on the assembly level.  i8k_smm is
not inlined in this case and checks all 3 conditions.

Guess we need somebody who actually reported the problem, state what
gcc was actually used and post preprocessed source, gcc options
from his case.

	Jakub
