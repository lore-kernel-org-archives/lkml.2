Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1FMEyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 00:54:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45644 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1FMEyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 00:54:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WsShENFPK3hEMUwRAH9IrIHxWh3gOlaL8h2rFKzkoOxdfdI/SGor80wzTe3U65ZG8v
         ytuQHGUvG6wqqx3rU9Ngrrx2KFBSB4zoA4LM0UKxz1R57IMYKu6jwDc8pKtp5L22vlkt
         Yzgi7llc3ziOHL3CsriSbQnwDZqt5CIH7MKgQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTimv6F8NsH0Lg7q6gi1-oiBv8nUrSA@mail.gmail.com>
References: <1307777464.25182.3.camel@localhost.localdomain>
	<BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com>
	<BANLkTi=yEo9fcXW8SqUCtSOag7Mn_+Ni9Q@mail.gmail.com>
	<BANLkTimv6F8NsH0Lg7q6gi1-oiBv8nUrSA@mail.gmail.com>
Date: Mon, 13 Jun 2011 10:54:04 +0600
Message-ID: <BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 8:52 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Sun, Jun 12, 2011 at 1:12 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>> On Sat, Jun 11, 2011 at 5:01 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>> On Sat, Jun 11, 2011 at 3:31 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>>>> Due to commit 5cec93c216db77 (x86-64: Emulate legacy vsyscalls), we get the following warning:
>>>>
>>>>   arch/x86/kernel/vsyscall_64.c: In function ‘do_emulate_vsyscall’:
>>>>   arch/x86/kernel/vsyscall_64.c:111:7: warning: ‘ret’ may be used uninitialized in this function
>>>
>>> What's the code path that uses ret without initializing it?
>>>
>> In case of, vsyscall_nr is default it might gets uninitialized. And
>> current code already treats it as a bug.
>>
>>>> -       if (ret == -EFAULT) {
>>>> +       if (ret == -EFAULT || ret == -EINVAL) {
>>>>                /*
>>>>                 * Bad news -- userspace fed a bad pointer to a vsyscall.
>>>>                 *
>>>
>>> EINVAL doesn't seem like grounds to fault.  (I'm not sure how to get
>>> EINVAL from time, gettimeofday, or getcpu, but in case there is, we
>>> should return it back to userspace.)
>>>
>> If ret = EINVAL, then it means vsyscall_nr doesn't any of
>> gettimeofday, time or getcpu. So, I grounds it into fault. In case of
>> gettimeofday, EINVAL may gets return. But, maybe not in case of time
>> or getcpu. So, maybe we need to check EINVAL in case of gettimeofday
>> and maybe should separate EINVAL and EFAULT.
>
> I think there are three separate issues here:
>
> 1. Can ret be used uninitialized?  I say no, even as seen by the
> compiler.  If vsyscall_nr is 0, 1, or 2, then ret is initialized.  If
> vsyscall_nr is 3, then the BUG gets hit.  BUG is defined as some
> assembly magic followed by unreachable(), and the compiler is supposed
> to know that code after unreachable() is qunreachable.  So how can ret
> be used uninitialized?
>
I don't have much knowledge of advance assembly, so I really don't
understand that part - how BUG handles this. If it really makes sure
that, it will handle it properly then I think you can drop this patch.

> What version of gcc do you have?  gcc (GCC) 4.6.0 20110530 (Red Hat
> 4.6.0-9) does not produce this warning.
>
Currently, I'm replying from outside my home. I'll let you know when
I'm back home.

> 2. Is the BUG correct?  I say yes.  vsyscall_nr can only be 0, 1, 2,
> or 3 (see the function that generates it), and the only way that 3
> could happen is if regs->ip == 0xffffffffff600c02.  That can't happen
> because the instruction at ...601 is int3.
>
Ok, thanks for explaining. What will  regs->ax will have if it hits BUG?

> 3. Should the test for EFAULT be changed to EINVAL?  I can't see why.
> We need to preserve userspace ABI, and userspace expects vsyscalls
> that fail for reasons other than a fault to return an error, not
> segfault the caller.
>
Right. I think, we need to check for both EFAULT and EINVAL rather
than changing test for EFAULT to EINVAL. Since both of them can
happen, maybe it will help preserve userspace ABI properly.

> Note that regs->as *is* the return value, so we're not ignoring errors.
>
Yes, right. This was the worrying factor, what will regs->ax have. We
shouldn't allow anything else other than return value or EINVAL.

Thanks,
Rakib

> --Andy
>
