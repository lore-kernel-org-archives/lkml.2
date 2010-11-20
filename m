Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0KTHLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 02:11:48 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65463 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0KTHLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 02:11:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iu5b14Dw0W9GWXQJtEQ2NZAm/simJuz6AqDDxie8aIIgMNiHjhXGI+yydn7CoG/jOg
         3bftUw8oeaSxhRT4dQBL2f3hYctn0kQBzLbUh9QF7woCqyfCYoDtvhl0OOGVyzdO2fOF
         bLOIUprmEVCAjRlP+LnLVp/hJwNF7gyt8JkY0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	<AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>
	<AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>
	<AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com>
Date: Sat, 20 Nov 2010 15:11:45 +0800
Message-ID: <AANLkTiki3d3Ft3-XJwFg8DUzUYcz3xPoYTzLZokLf+dv@mail.gmail.com>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: huang ying <huang.ying.caritas@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 10:15 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Nov 19, 2010 at 6:04 PM, huang ying
> <huang.ying.caritas@gmail.com> wrote:
>>
>> We thought about 'printk' for hardware errors before, but it has some
>> issues too.
>>
>> 1) It mixes software errors and hardware errors. When Andi Kleen
>> maintained the Machine Check code, he found many users report the
>> hardware errors as software bug to software vendor instead of as
>> hardware error to hardware vendor. Having explicit hardware error
>> reporting interface may help these users.
>
> Bah. Many machine checks _were_ software errors. They were things like
> the BIOS not clearing some old pending state etc.

I think the BIOS error should be reported to hardware vendor instead
of software vendor. Do you think so?

> The confusion came not from printk, but simply from ambiguous errors.
> When is a machine check hardware-related? It's not at all always
> obvious.
>
> Sometimes machine checks are from uninitialized hardware state, where
> _software_ hasn't initialized it. Is it a hardware bug? No.

That could be possible.

>> 2) Hardware error reporting may flush other information in printk
>> buffer. Considering one pin of your ECC DIMM is broken, tons of 1 bit
>> corrected memory error will be reported. Although we can enforce some
>> kind of throttling, your printk buffer may be full of the hardware
>> error reporting eventually.
>
> Sure. That doesn't change the fact that finding the data is your
> /var/log/messages and your regular logging tools is still a lot more
> useful than having some random tool that is specialized and that most
> IT people won't know about. And that won't be good at doing network
> reporting etc etc.
>
> The thing is, hardware errors aren't that special. Sure, hardware
> people always think so. But to anybody else, a hardware error is "just
> another source of issues".
>
> Anybody who thinks that hardware errors are special and needs a
> special interface is missing that point totally.
>
> And I really do understand why people inside Intel would miss that
> point. To YOU guys the hardware errors you report are magical and
> special. But that's always true. To _everybody_, the errors _they_
> report is special. Like snowflakes, we're all unique. And we're all
> the same.

Yes. Hardware errors and software errors are just two types of errors.
Hardware errors are not so special. So I agree that we need to report
hardware error information with printk. Which is mainly human oriented
interface. We need a tool oriented interface too, to let user space
error daemon to do something like counting errors for hardware
components, offline/hot-remove the error components based on some
policy automatically, etc.

>> 3) We need some kind of user space hardware error daemon, which is
>> used to enforce some policy. For example, if the number of corrected
>> memory errors reported on one page exceeds the threshold, we can
>> offline the page to prevent some fatal error to occur in the future,
>> because fatal error may begin with corrected errors in reality. printk
>> is good for administrator, and may be not good enough for the hardware
>> error daemon.
>
> And by "we", who do you mean exactly? The fact is, "we" covers a lot
> of ground, and I don't think your statement is in the least true.
>
> Yes, IT people want to know. When they start seeing hardware errors,
> they'll start replacing the machine as soon as they can. Whether that
> replacement is then "in five minutes" or "four months from now" is up
> to their management, their replacement policy, and based on how
> critical that machine is.
>
> IT HAS NOTHING WHAT-SO-EVER TO DO WITH HOW OFTEN THE ERRORS HAPPEN.

Because some external cause like cosmic rays and electromagnetic
interference can cause hardware errors too. We need error counting to
distinguish between external caused hardware errors and real hardware
errors.

Usually, the hardware components reporting corrected hardware errors
can work for some while. But if the corrected errors reporting rate
goes high, the possibility for hardware to stop work (because of some
fatal error) goes high too. The error counting can help IT people to
know the urgency.

And user space error daemon can help IT people to do some recovery
operation automatically, for example, trigger the memory or CPU
offline/hot-remove based on policy set by IT people.

> And yes, Intel can do guidelines, but when you say there should be
> some "enforced policy" by some tool, you're simply just wrong.

Yes. The replacement policy should be determined by IT people. My
previous expression is confusing. We need to provide some mechanism in
user space error daemon to help IT people to do that automatically.
For example, we provide error counting for each hardware components,
and let IT people set the threshold.

So, do you agree that we need some tool oriented interface in addition
to printk?

Best Regards,
Huang Ying
