Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2LLByY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 20:54:24 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33278 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2LLByX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 20:54:23 -0500
MIME-Version: 1.0
In-Reply-To: <1355258415.30831.2.camel@wall-e>
References: <1355242260-28762-1-git-send-email-stefani@seibold.net>
 <CALCETrWDkA8Xkp==okP8xERRSM8tcryRDr_+2RYcSK=vSQV9kQ@mail.gmail.com> <1355258415.30831.2.camel@wall-e>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Dec 2012 17:29:44 -0800
Message-ID: <CALCETrU6KporkvG8Pgx9jS3P_tPT5yDQE=tSktnn1RwDip-yTg@mail.gmail.com>
Subject: Re: [PATCH] Add VDSO time function support for x86 32-bit kernel
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, aarcange@redhat.com,
        john.stultz@linaro.org, Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc: Jeremy Fitzhardinge -- you wrote some of this]

On Tue, Dec 11, 2012 at 12:40 PM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Dienstag, den 11.12.2012, 11:37 -0800 schrieb Andy Lutomirski:
>> On Tue, Dec 11, 2012 at 8:11 AM,  <stefani@seibold.net> wrote:
>> > --- a/arch/x86/vdso/vclock_gettime.c
>> > +++ b/arch/x86/vdso/vclock_gettime.c
>> > @@ -59,14 +59,23 @@ notrace static cycle_t vread_tsc(void)
>> >
>> >  static notrace cycle_t vread_hpet(void)
>> >  {
>> > +#ifdef CONFIG_X86_64
>> >         return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
>> > +#else
>> > +       return readl(VVAR(vsyscall_hpet) + HPET_COUNTER);
>> > +#endif
>> >  }
>>
>> Is 0xf0 not equal to HPET_COUNTER?
>>
>
> Yes, but HPET_COUNTER is more readable.

Sorry -- read it backwards.  Can you change the 64-bit one as well?

>
>> >
>> >  notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
>> >  {
>> >         long ret;
>> > +#ifdef CONFIG_X86_64
>> >         asm("syscall" : "=a" (ret) :
>> >             "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
>> > +#else
>> > +       asm("int $0x80" : "=a" (ret) :
>> > +           "a" (__NR_clock_gettime), "b" (clock), "c" (ts) : "memory");
>> > +#endif
>> >         return ret;
>> >  }
>>
>> __kernel_vsyscall is probably much faster if you can figure out how to
>> call it from here :)
>>
>
> Yes i know. Thats one of my problems, because i cannot call
> __kernel_vsyscall directly due the relocation. Any idea?

What actually goes wrong?  I think that if calling __kernel_vsyscall
like a normal symbol doesn't work then it's a bug in the relocation.

What's the point of this relocation?  It appears thoroughly useless in
the !compat case.

--Andy
