Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab1FGXi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:38:56 -0400
Received: from r00tworld.com ([212.85.137.150]:51263 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab1FGXiz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:38:55 -0400
From: pageexec@freemail.hu
To: Brian Gerst <brgerst@gmail.com>
Date: Wed, 08 Jun 2011 01:32:38 +0200
MIME-Version: 1.0
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Reply-to: pageexec@freemail.hu
CC: Andrew Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Message-ID: <4DEEB516.4681.19EE05CD@pageexec.freemail.hu>
In-reply-to: <BANLkTim4sN-bymGPPDU_f9V3FYCWP=PhNA@mail.gmail.com>
References: <cover.1307292171.git.luto@mit.edu>, <4DECDD14.5845.12BA3C18@pageexec.freemail.hu>, <BANLkTim4sN-bymGPPDU_f9V3FYCWP=PhNA@mail.gmail.com>
X-mailer: Pegasus Mail for Windows (4.61)
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 08 Jun 2011 01:33:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Jun 2011 at 10:07, Brian Gerst wrote:

> > do you know what that mucking looks like? ;) prepare for the most complex code
> > you've ever seen (it's in __bad_area_nosemaphore):
> >
> >  779 #ifdef CONFIG_X86_64
> >  780 »·······if (mm && (error_code & PF_INSTR) && mm->context.vdso) {
> >  781 »·······»·······if (regs->ip == (unsigned long)vgettimeofday) {
> >  782 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, gettimeofday);
> >  783 »·······»·······»·······return;
> >  784 »·······»·······} else if (regs->ip == (unsigned long)vtime) {
> >  785 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, clock_gettime);
> >  786 »·······»·······»·······return;
> >  787 »·······»·······} else if (regs->ip == (unsigned long)vgetcpu) {
> >  788 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, getcpu);
> >  789 »·······»·······»·······return;
> >  790 »·······»·······}
> >  791 »·······}
> >  792 #endif
> 
> I like this approach, however since we're already in the kernel it
> makes sense just to run the normal syscall instead of redirecting to
> the vdso.

it's not that simple as the page fault occurs not at the actual syscall
insn but at the first insn of the given vsyscall function, so you'd have
to emulate it carefully to be able to return back the original caller in
userland.

