Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0KINsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:48:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36705 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0KINsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:48:18 -0500
Date: Tue, 9 Nov 2010 14:48:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Michael Matz <matz@suse.de>
Cc: Dave Korn <dave.korn.cygwin@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Richard Guenther <richard.guenther@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>, Jim <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101109134816.GB29433@basil.fritz.box>
References: <4CD538CA.8010901@xs4all.nl>
 <87wroostw3.fsf@basil.nowhere.org>
 <m2hbfsu57i.fsf@igel.home>
 <87k4kospnd.fsf@basil.nowhere.org>
 <AANLkTikG6kBxSrO7EZ5_nZqTKqo8Rjm2stoEGVJWxanz@mail.gmail.com>
 <877hgorrj1.fsf@basil.nowhere.org>
 <4CD843DC.10106@gmail.com>
 <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1011091352460.29956@wotan.suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My speculation is, that the asm is not removed but rather that regs.eax 
> isn't reloaded after the asm because the memory clobber doesn't clobber 
> automatic variables.

Yes that makes sense. I wasn't able to verify it so far though.

Maybe the original poster could try the obvious patch 
instead of the volatile change.


i8k: tell gcc that regs gets clobbered
    
Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 3bc0eef..f3bbf73 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -142,7 +142,7 @@ static int i8k_smm(struct smm_regs *regs)
 		"lahf\n\t"
 		"shrl $8,%%eax\n\t"
 		"andl $1,%%eax\n"
-		:"=a"(rc)
+		:"=a"(rc), "=m" (*regs)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
@@ -167,7 +167,7 @@ static int i8k_smm(struct smm_regs *regs)
 	    "movl %%edx,0(%%eax)\n\t"
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
-	    "andl $1,%%eax\n":"=a"(rc)
+	    "andl $1,%%eax\n":"=a"(rc), "=m" (*regs)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif

-Andi
