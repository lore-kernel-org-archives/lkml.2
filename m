Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0KOJM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:12:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51774 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0KOJMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:12:25 -0500
Date: Mon, 15 Nov 2010 10:12:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Michael Matz <matz@suse.de>, Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org,
        Jim Bos <jim876@xs4all.nl>
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115091219.GA7269@basil.fritz.box>
References: <AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
 <877hgorrj1.fsf@basil.nowhere.org>
 <4CD843DC.10106@gmail.com>
 <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
 <20101109134816.GB29433@basil.fritz.box>
 <m3lj52txaq.fsf@redhat.com>
 <4CD97A3D.1040602@xs4all.nl>
 <m31v6nmmr3.fsf@jhcloos.com>
 <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com>
 <20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115085605.GE2583@sunsite.ms.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That said, changing the inline asm to just clobber one less register
> would be completely sufficient to make it work well with all gccs out there,
> just push/pop one of the register around the whole body.  I doubt calling
> out SMM BIOS is actually so performance critical that one push and one pop
> would ruin it.  Of course x86_64 version can stay as is, there are enough
> registers left...

Yes traditionally clobbering all registers has been dangerous
and it clearly can be done inside the asm too.

Here's a untested patch to do some manual push/pops too. Could someone with
the hardware please test it? (running a 32bit kernel)

-Andi

---

i8k: Clobber less registers

gcc doesn't like inline assembler statements that clobber nearly
all registers. Save a few registers manually on i386 to avoid this
problem.

Fix suggested by Jakub Jelinek

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index f0863be..a2da38b 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -146,7 +146,10 @@ static int i8k_smm(struct smm_regs *regs)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
-	asm("pushl %%eax\n\t"
+	asm("pushl %%ebx\n\t"
+	    "pushl %%ecx\n\t"
+	    "pushl %%edx\n\t"
+	    "pushl %%eax\n\t"
 	    "movl 0(%%eax),%%edx\n\t"
 	    "push %%edx\n\t"
 	    "movl 4(%%eax),%%ebx\n\t"
@@ -167,10 +170,13 @@ static int i8k_smm(struct smm_regs *regs)
 	    "movl %%edx,0(%%eax)\n\t"
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
-	    "andl $1,%%eax\n"
+	    "andl $1,%%eax\n\t"
+	    "popl %%edx\n\t"
+	    "popl %%ecx\n\t"
+	    "popl %%ebx\n"
 	    :"=a"(rc), "+m" (*regs)
 	    :    "a"(regs)
-	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
+	    :    "%esi", "%edi", "memory");
 #endif
 	if (rc != 0 || (regs->eax & 0xffff) == 0xffff || regs->eax == eax)
 		return -EINVAL;


-- 
ak@linux.intel.com -- Speaking for myself only.
