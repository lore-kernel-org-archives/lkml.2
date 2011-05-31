Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab1EaP44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:56:56 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:57136 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405Ab1EaP4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=sLzDmVINxWZs9av/0ltckLtS+WGkmLe1oxK8xsrHWXWVh4ky0pLdtys+KPuAulfq8r
         25iwpNnLV+RCXgqeVJ0z5kElrLWYi27d9HlfKm0eElUDJShVNIBBvqYN7OluhEE9OsYV
         HSzNBt++2SCcM1FfLKwkl4N5NOLOrROuYSn/E=
MIME-Version: 1.0
In-Reply-To: <20110531154012.GB30353@elte.hu>
References: <cover.1306851090.git.luto@mit.edu> <75a00aee647302e22c86a5c5fac0478b9776481a.1306851090.git.luto@mit.edu>
 <20110531154012.GB30353@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 31 May 2011 11:56:30 -0400
X-Google-Sender-Auth: KgdRadlrhUcqZg2-9hBuCqa0zMg
Message-ID: <BANLkTimGAtCPuvwvKfD6TLcabVzqKZhfGg@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 11:40 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@MIT.EDU> wrote:
>
>> This is not a security feature.  It's to prevent the int 0xcc
>> sequence from becoming ABI.
>
> Hm, what kind of ABI reliance could be built on it?

See:

http://lkml.kernel.org/r/<BANLkTi=zxA3xzc0pR14rqwaOUXUAyF__MQ%40mail.gmail.com>

I was surprised, too.

>
>> +static void __init mangle_vsyscall_movb(void *mapping,
>> +                                     unsigned long movb_addr, u8 initial)
>> +{
>> +     u8 *imm8;
>> +     BUG_ON(movb_addr >= 4095);
>
> Please put newlines after local variable definitions.

Yep.

>
>>  static int __init vsyscall_init(void)
>>  {
>> +     extern char __vsyscall_0;
>
> Please don't put extern definitions in the middle of a .c file - if
> then it should be in a .h file. (even if only a single function uses
> it)

I thought the convention (and existing practice in vsyscall_64.c) was
that if the extern reference is to a magic linker symbol then it goes
in the function that uses it.  But I can find it a header file.

>
>> +     /*
>> +      * Randomize the magic al values for int 0xcc invocation.  This
>> +      * isn't really a security feature; it's to make sure that
>> +      * dynamic binary instrumentation tools don't start to think
>> +      * that the int 0xcc magic incantation is ABI.
>> +      */
>> +     vsyscall_nr_offset = get_random_int() % 3;
>> +     vsyscall_page = pfn_to_page(__pa_symbol(&__vsyscall_0) >> PAGE_SHIFT);
>> +     mapping = kmap_atomic(vsyscall_page);
>> +     /* It's easier to hardcode the addresses -- they're ABI. */
>> +     mangle_vsyscall_movb(mapping, 0, 0xcc);
>
> what about filling it with zeroes?

Fill what with zeroes?  I'm just patching one byte here.

>
>> +#ifndef CONFIG_UNSAFE_VSYSCALLS
>> +     mangle_vsyscall_movb(mapping, 1024, 0xce);
>> +#endif
>> +     mangle_vsyscall_movb(mapping, 2048, 0xf0);
>
> Dunno, this all looks rather ugly.

Agreed.  Better ideas are welcome.

We could scrap int 0xcc entirely and emulate on page fault, but that
is slower and has other problems (like breaking anything that thinks
it can look at a call target in a binary and dereference that
address).

Here's a possibly dumb/evil idea:

Put real syscalls in the vsyscall page but mark the page NX.  Then
emulate the vsyscalls on the PF_INSTR fault when userspace jumps to
the correct address but send SIGSEGV for the wrong address.

Down side: it's even more complexity for the same silly case.

--Andy

>
> Thanks,
>
>        Ingo
>
