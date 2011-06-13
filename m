Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab1FMOSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:18:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57928 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1FMOSc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:18:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Xu90d9u7CF0t2s6Jb4c2iTts+KRTWfBp5oxMzVQxokaQtpzAOTkT41L8LYXBXSUJsT
         +PD7EA4aYD72WQLgGhb5xBfKPWc2XfFdpfnrejcH/sH0ABXTH/i1wklOiqsyGNeLuMBa
         yjIG3H8Oz07unFOFlsT4XUyq8/2eLpyk+2s88=
MIME-Version: 1.0
In-Reply-To: <20110613141408.GA16126@elte.hu>
References: <1307777464.25182.3.camel@localhost.localdomain>
 <BANLkTi=SQb6EL4+bdH2Q+iwaW9E3i+48Ew@mail.gmail.com> <20110613092940.GB8282@elte.hu>
 <BANLkTi=eLODKcTfXb8Z1eAy4KnSE16icow@mail.gmail.com> <20110613141408.GA16126@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 13 Jun 2011 10:18:12 -0400
X-Google-Sender-Auth: DtH_C_d1XBh4L8J3ZNEWgfKZcoU
Message-ID: <BANLkTimctV0Tp7PP0CaGvmxmxh=yw6dRvw@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
To: Ingo Molnar <mingo@elte.hu>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, hpa@zytor.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 10:14 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> On Mon, Jun 13, 2011 at 5:29 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Andrew Lutomirski <luto@mit.edu> wrote:
>> >
>> >> On Sat, Jun 11, 2011 at 3:31 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>> >> > Due to commit 5cec93c216db77 (x86-64: Emulate legacy vsyscalls), we get the following warning:
>> >> >
>> >> >   arch/x86/kernel/vsyscall_64.c: In function ‘do_emulate_vsyscall’:
>> >> >   arch/x86/kernel/vsyscall_64.c:111:7: warning: ‘ret’ may be used uninitialized in this function
>> >>
>> >> What's the code path that uses ret without initializing it?
>> >
>> > If the code is correct but GCC got confused then please use the
>> > simplest possible patch to help GCC find its way around the code.
>>
>> The simplest patch is to mark ret as uninitialized_var.
>
> No - that primitive really sucks as it might hide *future* debug
> warnings and silently break code.
>
> The problem with uninitialized_var() is that such code:
>
>        int test(void)
>        {
>                int uninitialized_var(ret);
>
>                return ret;
>        }
>
> Builds without a single warning but it is very broken code.
>
> So if we use uninitialized_var() and the code is changed in the
> future to have the above broken sequence, we'll have a silent runtime
> failure ...
>
> So we try to avoid using uninitialized_var() in arch/x86/ and use
> explicit initialization instead.
>
> That way GCC that can see through the flow will optimize away the
> superfluous initialization - GCC versions that are older will
> generate one more instruction but that's OK.

Fair enough.

Unfortunately there doesn't seem to be an EKERNELBUG error code, and
initializing to EFAULT seems silly.  0 is probably harmless.

I'll wait awhile longer for that GCC version, since there might be a
better fix.  In any case, it would be nice for the changelog entry to
say which version has a warning that's being worked around.

--Andy
