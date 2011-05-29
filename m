Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab1E2Tta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:49:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45536 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab1E2Tt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:49:29 -0400
Date: Sun, 29 May 2011 21:49:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86-64: Replace vsyscall gettimeofday fallback with
 int 0xcc
Message-ID: <20110529194922.GC13539@elte.hu>
References: <cover.1306517576.git.luto@mit.edu>
 <452208dbdf79d4c821d701d5973621bf7546419a.1306517576.git.luto@mit.edu>
 <20110529191055.GC9835@elte.hu>
 <BANLkTin=nCdEjA3Fgj6jH5TrSryit8K_XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin=nCdEjA3Fgj6jH5TrSryit8K_XQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Lutomirski <luto@mit.edu> wrote:

> > Ok, i suspect you marked it 0xCC because that's the INT3 instruction
> > - not very useful for exploits?
> 
> Exactly.
> 
> The comments in irq_vectors.h make it sound like vectors 0x81..0xed 
> are used for device interrupts but AFAICT it's only 0x20..0x39 that 
> are used, so the precise choice of vector doesn't matter that much.

No, we use almost all of the vector space for device interrupts. Why 
do you think only 0x20..0x39 is used?

> > A not-so-nit: i'd not limit this message to unhandled signals 
> > alone. An attacker could install a SIGSEGV handler, send a 
> > SIGSEGV and attempt the exploit right then - he'll get a free 
> > attempt with no logging performed, right?.
> 
> I think if an exploit can call sigaction, then we've already lost. 

Yes, indeed. In theory an app could be catching SIGSEGV and we could 
have an exploit there. But that's pretty theoretical ...

> But I can still make the change.

If you did it to not repeat the message then i think the 
printk_ratelimit() is more than enough. force_sig() will be able to 
sort out repeat signals just fine.

> >> +     local_irq_disable();
> >> +     return;
> >> +}
> >
> > Nit: no need for a 'return;' at the end of a void function.
> 
> :)
> 
> That pointless "return" statement was to hide the fact that the
> local_irq_enable wasn't correctly matched.

indeed. I noticed the do_exit() local_irq_enable() assymetry which is 
harmless (we never return), but missed the force_sig() one that isn't 
so harmless.

> I'm changing this code a fair bit in preparation for the extra 
> bonus patch to defang vsyscalls even more by trapping all of them.

ok.

Thanks,

	Ingo
