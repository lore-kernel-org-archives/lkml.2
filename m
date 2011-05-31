Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab1EaSJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 14:09:13 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:60506 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab1EaSJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 14:09:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=x3s+sjyIdd47borwLkIvtGUTqxWklR/d2nCkMQdksTlJ8qUmhB6WsO5o3iKCvWgrmq
         TwhCPpwImPO58pxC5KtD6l6L6Z6PXgkPpp87r73BYHFNE/pIJ4seb/spaFGzAijDu5xB
         krhEdoC2qjWPu5eXh2ZEnEu4SG+3PkW7EyhTc=
MIME-Version: 1.0
In-Reply-To: <20110531164227.GA15651@elte.hu>
References: <cover.1306851090.git.luto@mit.edu> <75a00aee647302e22c86a5c5fac0478b9776481a.1306851090.git.luto@mit.edu>
 <20110531154012.GB30353@elte.hu> <BANLkTimGAtCPuvwvKfD6TLcabVzqKZhfGg@mail.gmail.com>
 <20110531164227.GA15651@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 31 May 2011 14:08:50 -0400
X-Google-Sender-Auth: SczrOhVK4RF9J8JkgHQVdff4W-k
Message-ID: <BANLkTimfWtBE1dNdv7YSmOBus_0LA9GBWw@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] x86-64: Randomize int 0xcc magic al values at boot
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 12:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> >>  static int __init vsyscall_init(void)
>> >>  {
>> >> +     extern char __vsyscall_0;
>> >
>> > Please don't put extern definitions in the middle of a .c file - if
>> > then it should be in a .h file. (even if only a single function uses
>> > it)
>>
>> I thought the convention (and existing practice in vsyscall_64.c)
>> was that if the extern reference is to a magic linker symbol then
>> it goes in the function that uses it.  But I can find it a header
>> file.
>
> i'd suggest collecting them into a vsyscall header. The problem with
> externs in .c is that the moment two .c files start using it there's
> the danger of type divergence.
>
>> >> +     /*
>> >> +      * Randomize the magic al values for int 0xcc invocation.  This
>> >> +      * isn't really a security feature; it's to make sure that
>> >> +      * dynamic binary instrumentation tools don't start to think
>> >> +      * that the int 0xcc magic incantation is ABI.
>> >> +      */
>> >> +     vsyscall_nr_offset = get_random_int() % 3;
>> >> +     vsyscall_page = pfn_to_page(__pa_symbol(&__vsyscall_0) >> PAGE_SHIFT);
>> >> +     mapping = kmap_atomic(vsyscall_page);
>> >> +     /* It's easier to hardcode the addresses -- they're ABI. */
>> >> +     mangle_vsyscall_movb(mapping, 0, 0xcc);
>> >
>> > what about filling it with zeroes?
>>
>> Fill what with zeroes?  I'm just patching one byte here.
>
> Sigh, i suck at reading comprehension today!
>
>> >> +#ifndef CONFIG_UNSAFE_VSYSCALLS
>> >> +     mangle_vsyscall_movb(mapping, 1024, 0xce);
>> >> +#endif
>> >> +     mangle_vsyscall_movb(mapping, 2048, 0xf0);
>> >
>> > Dunno, this all looks rather ugly.
>>
>> Agreed.  Better ideas are welcome.
>
> None at the moment except "don't randomize it and see where the chips
> may fall". I'd rather live with a somewhat sticky default-off compat
> Kconfig switch than some permanently ugly randomization to make the
> transition to no-vsyscall faster.
>
> It's not like we'll be able to remove the vsyscall altogether from
> the kernel - the best we can hope for is to be able to flip the
> default - there's binaries out there today that rely on it and
> binaries are sticky - a few months ago i saw someone test-running
> 1995 binaries ;-)
>
> Btw., we could also make the vsyscall page vanish *runtime*, via a
> sysctl. That way distros only need to update their /etc/sysctl.conf.
>
>> We could scrap int 0xcc entirely and emulate on page fault, but
>> that is slower and has other problems (like breaking anything that
>> thinks it can look at a call target in a binary and dereference
>> that address).
>>
>> Here's a possibly dumb/evil idea:
>>
>> Put real syscalls in the vsyscall page but mark the page NX.  Then
>> emulate the vsyscalls on the PF_INSTR fault when userspace jumps to
>> the correct address but send SIGSEGV for the wrong address.
>>
>> Down side: it's even more complexity for the same silly case.
>
> heh, you are good at coming up with sick ideas! ;-)
>
> I don't think we want to add another branch to #PF, but could we turn
> this into #GP or perhaps an illegal instruction fault?

I'm not seeing one right now.  But #PF can be done without any
fast-path impact by checking for a vsyscall after the normal
page-fault logic gives up.  That takes about 400ns on my machine, I
think.

>
> Should be benchmarked:
>
>  - The advantage of INT 0xCC is that it's completely isolated: it
>   does not slow down anything else.

220ns or so.

>
>  - doing this through #GP might be significantly slower cycle-wise.
>   Do we know by how much?

Not sure how to do it.  I imagine that #UD is almost the same as int cc, though.

>
> The advantage would be that we would not waste an extra vector, it
> would be smaller, plus it would be rather simple to make it all a
> runtime toggle via a sysctl.

I think this is all moot right now, though -- whatever we do has to
keep time() fast for awhile, and I think that means that we need a
real (even if illegal) instruction in gettimeofday.

So let's just drop the randomization patch and hope that the "int 0xcc
in user code (exploit attempt? legacy instrumented code?)" is enough
to keep people from doing dumb things.

--Andy
