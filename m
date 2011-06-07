Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab1FGXtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:49:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50540 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab1FGXtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=jIfIM/+IbM3Qee0Xz6+BmzSiZ/nQ/dSqqZSTAqSHXAXPqvzT1GjhWvu7cNsY3q+qF8
         H44Jn0UXB8iI3sYFxLNHO80cVTAqLATudGalfBbAp63YbDB8oYqikDP+weKEO6Tc5599
         psMZkkBILrEBYa2fqjEvXUtRolci6G/7pK0tU=
MIME-Version: 1.0
In-Reply-To: <4DEEB516.4681.19EE05CD@pageexec.freemail.hu>
References: <cover.1307292171.git.luto@mit.edu> <4DECDD14.5845.12BA3C18@pageexec.freemail.hu>
 <BANLkTim4sN-bymGPPDU_f9V3FYCWP=PhNA@mail.gmail.com> <4DEEB516.4681.19EE05CD@pageexec.freemail.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 7 Jun 2011 19:49:02 -0400
X-Google-Sender-Auth: NlMtpFfFd3g9VaEhX1DCGMdvx4k
Message-ID: <BANLkTimy2AkWxPAOj3JTzXEDak_othZhZA@mail.gmail.com>
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
To: pageexec@freemail.hu
Cc: Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 7:32 PM,  <pageexec@freemail.hu> wrote:
>> > do you know what that mucking looks like? ;) prepare for the most complex code
>> > you've ever seen (it's in __bad_area_nosemaphore):
>> >
>> >  779 #ifdef CONFIG_X86_64
>> >  780 »·······if (mm && (error_code & PF_INSTR) && mm->context.vdso) {
>> >  781 »·······»·······if (regs->ip == (unsigned long)vgettimeofday) {
>> >  782 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, gettimeofday);
>> >  783 »·······»·······»·······return;
>> >  784 »·······»·······} else if (regs->ip == (unsigned long)vtime) {
>> >  785 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, clock_gettime);
>> >  786 »·······»·······»·······return;
>> >  787 »·······»·······} else if (regs->ip == (unsigned long)vgetcpu) {
>> >  788 »·······»·······»·······regs->ip = (unsigned long)VDSO64_SYMBOL(mm->context.vdso, getcpu);
>> >  789 »·······»·······»·······return;
>> >  790 »·······»·······}
>> >  791 »·······}
>> >  792 #endif
>>
>> I like this approach, however since we're already in the kernel it
>> makes sense just to run the normal syscall instead of redirecting to
>> the vdso.
>
> it's not that simple as the page fault occurs not at the actual syscall
> insn but at the first insn of the given vsyscall function, so you'd have
> to emulate it carefully to be able to return back the original caller in
> userland.
>
>

My patch (the version that's in tip/x86/vdso) more-or-less does that.
It's something like six lines of code, including error handling.

__bad_area_nosemaphore is not a fast path, and in fact I tried that
for the very first version of this code that I wrote.  My recollection
is that it's noticeably slower than int 0xcc because it has to go
through the whole VMA lookup.

If you want to submit a patch to switch from int 0xcc to
__bad_area_nosemaphore, be my guest :)  It will have almost no effect
on the complexity of the code, and, in fact, you'll probably get a net
deletion of lines because you can remove all the crud in vmlinux.lds.S
and some of the mapping code in vsyscall_64.c.

--Andy
