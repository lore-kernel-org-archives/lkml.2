Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1FMRGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 13:06:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45628 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab1FMRGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=dQFykMkGZaSzFfFLJ5IEzBhZGM6m1a3eFpvjv+OpMwpb5NdBhECAO5NOOX0H1Gj4uq
         CNuJOXVOZzrXoV08sLpdPgXeZGYFteORoEqsqSZpezGO2yHJupNOZn4g2zR1lda3NYTY
         5OnwHNkhsGq245Y5i1SNLIx1/fGhiiTwLqGzo=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=2kw+8ijdPDNva11Ct9vr0p_uhmA@mail.gmail.com>
References: <1307777464.25182.3.camel@localhost.localdomain>
 <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com> <20110613092940.GB8282@elte.hu>
 <BANLkTi=eLODKcTfXb8Z1eAy4KnSE16icow@mail.gmail.com> <20110613141408.GA16126@elte.hu>
 <BANLkTimctV0Tp7PP0CaGvmxmxh=yw6dRvw@mail.gmail.com> <BANLkTi=2kw+8ijdPDNva11Ct9vr0p_uhmA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 13 Jun 2011 13:06:26 -0400
X-Google-Sender-Auth: zxZYSpuzigxOZRHjrKvEcngWajg
Message-ID: <BANLkTinn449JN_jAeO9M_AuZ1B2+7hgj4A@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 1:05 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Mon, Jun 13, 2011 at 8:18 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> On Mon, Jun 13, 2011 at 10:14 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> * Andrew Lutomirski <luto@mit.edu> wrote:
>>>
>>>> On Mon, Jun 13, 2011 at 5:29 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>> >
>>>> > * Andrew Lutomirski <luto@mit.edu> wrote:
>>>> >
>>>> >> On Sat, Jun 11, 2011 at 3:31 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>>>> >> > Due to commit 5cec93c216db77 (x86-64: Emulate legacy vsyscalls), we get the following warning:
>>>> >> >
>>>> >> >   arch/x86/kernel/vsyscall_64.c: In function ‘do_emulate_vsyscall’:
>>>> >> >   arch/x86/kernel/vsyscall_64.c:111:7: warning: ‘ret’ may be used uninitialized in this function
>>>> >>
>>>> >> What's the code path that uses ret without initializing it?
>>>> >
>>>> > If the code is correct but GCC got confused then please use the
>>>> > simplest possible patch to help GCC find its way around the code.
>>>>
>>>> The simplest patch is to mark ret as uninitialized_var.
>>>
>>> No - that primitive really sucks as it might hide *future* debug
>>> warnings and silently break code.
>>>
>>> The problem with uninitialized_var() is that such code:
>>>
>>>        int test(void)
>>>        {
>>>                int uninitialized_var(ret);
>>>
>>>                return ret;
>>>        }
>>>
>>> Builds without a single warning but it is very broken code.
>>>
>>> So if we use uninitialized_var() and the code is changed in the
>>> future to have the above broken sequence, we'll have a silent runtime
>>> failure ...
>>>
>>> So we try to avoid using uninitialized_var() in arch/x86/ and use
>>> explicit initialization instead.
>>>
>>> That way GCC that can see through the flow will optimize away the
>>> superfluous initialization - GCC versions that are older will
>>> generate one more instruction but that's OK.
>>
>> Fair enough.
>>
>> Unfortunately there doesn't seem to be an EKERNELBUG error code, and
>> initializing to EFAULT seems silly.  0 is probably harmless.
>>
>> I'll wait awhile longer for that GCC version, since there might be a
>> better fix.  In any case, it would be nice for the changelog entry to
>> say which version has a warning that's being worked around.
>>
> Well, I think I already posted the GCC version in this thread. Anyway,
> for you're convenience, here is my GCC version: gcc version 4.5.1
> 20100924 (Red Hat 4.5.1-4). I'm using Fedora Core 14.

Sorry -- I think I managed to read every email in the thread except
that one.  Will test tonight.

--Andy

>
>
> Thanks,
> Rakib
>
