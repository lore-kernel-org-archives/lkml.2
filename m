Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab1FFOH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:07:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56661 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1FFOHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b+/7pUIiQlrtjMBqj/hNVwEhVGQxwAp7gzr5X2MfcxMnOsbWZrhOlDqcKWtzlgjQbE
         sGaKmrr3+4Jw4JwCY7GA0jTKqw2JjCBJMIiQxiZR6O5fYO6yoWwsda1BZeJtHS0qwaEO
         Mbfp1F+lhtnVzHae+0Nc47eWf4RZ29EkGO8Nk=
MIME-Version: 1.0
In-Reply-To: <4DECDD14.5845.12BA3C18@pageexec.freemail.hu>
References: <cover.1307292171.git.luto@mit.edu>
	<4DECC07A.8317.124A847C@pageexec.freemail.hu>
	<BANLkTi=viR9DaQu2hzX4THdpDqfOZq-cXw@mail.gmail.com>
	<4DECDD14.5845.12BA3C18@pageexec.freemail.hu>
Date: Mon, 6 Jun 2011 10:07:53 -0400
Message-ID: <BANLkTim4sN-bymGPPDU_f9V3FYCWP=PhNA@mail.gmail.com>
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
From: Brian Gerst <brgerst@gmail.com>
To: pageexec@freemail.hu
Cc: Andrew Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 9:58 AM,  <pageexec@freemail.hu> wrote:
> On 6 Jun 2011 at 8:43, Andrew Lutomirski wrote:
>
>> >> and it's less flexible
>> >
>> > why? as in, what kind of flexibility do you need that int xx can provide but a page
>> > fault cannot?
>>
>> The ability to make time() fast when configured that way.
>
> true, nx and fast time() at vsyscall addresses will never mix. but it's a temporary
> problem for anyone who cares, a trivial glibc patch fixes it.
>
>> >> and it could impact a fast path in the kernel.
>> >
>> > a page fault is never a fast path, after all the cpu has just taken an exception
>> > (vs. the syscall/sysenter style actually fast user->kernel transition) and is
>> > about to make page table changes (and possibly TLB flushes).
>>
>> Sure it is.  It's a path that's optimized carefully and needs to be as
>> fast as possible.  Just because it's annoyingly slow doesn't mean we
>> get to make it even slower.
>
> sorry, but stating that the pf handler is a fast path doesn't make it so ;).
> the typical pf is caused by userland to either fill in non-present pages
> or do c-o-w, a few well predicted conditional branches in those paths are
> simply not measurable (actually, those conditional branches would not be
> on those paths, at least they aren't in PaX). seriously, try it ;).
>
>> >> > another thing to consider for using the int xx redirection scheme (speaking
>> >> > of which, it should just be an int3):
>> >>
>> >> Why?  0xcd 0xcc traps no matter what offset you enter it at.
>> >
>> > but you're wasting/abusing an IDT entry for no real gain (and it's lots of code
>> > for such a little change). also placing sw interrupts among hw ones is what can
>> > result in (ab)use like this:
>>
>> I think it's less messy than mucking with the page fault handler.
>
> do you know what that mucking looks like? ;) prepare for the most complex code
> you've ever seen (it's in __bad_area_nosemaphore):
>
>  779 #ifdef CONFIG_X86_64
>  780 »·······if (mm && (error_code & PF_INSTR) && mm->context.vdso) {
>  781 »·······»·······if (regs->ip == (unsigned long)vgettimeofday) {
>  782 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, gettimeofday);
>  783 »·······»·······»·······return;
>  784 »·······»·······} else if (regs->ip == (unsigned long)vtime) {
>  785 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, clock_gettime);
>  786 »·······»·······»·······return;
>  787 »·······»·······} else if (regs->ip == (unsigned long)vgetcpu) {
>  788 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, getcpu);
>  789 »·······»·······»·······return;
>  790 »·······»·······}
>  791 »·······}
>  792 #endif

I like this approach, however since we're already in the kernel it
makes sense just to run the normal syscall instead of redirecting to
the vdso.

--
Brian Gerst
