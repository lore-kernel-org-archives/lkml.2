Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2GRUJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 16:09:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48714 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab2GRUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 16:09:00 -0400
MIME-Version: 1.0
In-Reply-To: <CABqD9hZSRTF3nZu2J0mahrPQpB+7KMDFy=iv5=J2B+vswpLpVg@mail.gmail.com>
References: <cover.1342566495.git.luto@amacapital.net> <912c85ae09ccb083110ae451d4f59260ae65296f.1342566495.git.luto@amacapital.net>
 <CABqD9hbKws1FRQBh3ctCCcYd5Jd=J5pW2a+ApFKso5s5ajqqFw@mail.gmail.com> <CABqD9hZSRTF3nZu2J0mahrPQpB+7KMDFy=iv5=J2B+vswpLpVg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Jul 2012 13:08:39 -0700
Message-ID: <CALCETrUt7kgC4oGxdi2QghaqLWQ-pDV1f3wmt-WLbo2xgd1Mrw@mail.gmail.com>
Subject: Re: [PATCH 3.5 2/2] seccomp: Future-proof against silly tracers
To: Will Drewry <wad@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 11:35 AM, Will Drewry <wad@chromium.org> wrote:
> On Tue, Jul 17, 2012 at 9:13 PM, Will Drewry <wad@chromium.org> wrote:
>> On Tue, Jul 17, 2012 at 6:19 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> Currently, if a tracer changes a syscall nr to __NR_future_enosys,
>>> behavior will differ between kernels that know about
>>> __NR_future_enosys (and return -ENOSYS) and older kernels (which
>>> return the value from pt_regs).  This is silly; we should just
>>> return -ENOSYS.
>>>
>>> This is unlikely to ever happen on x86 because the return value in
>>> pt_regs starts out as -ENOSYS, but a silly tracer can change that.
>>>
>>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>>> Cc: Will Drewry <wad@chromium.org>
>>> ---
>>>  arch/x86/include/asm/syscall.h |   11 +++++++++++
>>>  kernel/seccomp.c               |   15 +++++++++++++++
>>>  2 files changed, 26 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
>>> index 1ace47b..8191e057 100644
>>> --- a/arch/x86/include/asm/syscall.h
>>> +++ b/arch/x86/include/asm/syscall.h
>>
>> Since this is used in an arch-wide location, the prototype and comment
>> should be in asm-generic/syscall.h too.
>>
>>> @@ -70,6 +70,17 @@ static inline void syscall_set_return_value(struct task_struct *task,
>>>         regs->ax = (long) error ?: val;
>>>  }
>>>
>>> +static inline bool syscall_is_nr_future(struct task_struct *task,
>>> +                                       struct pt_regs *regs)
>>> +{
>>> +#ifdef CONFIG_IA32_EMULATION
>>> +       if (task_thread_info(task)->status & TS_COMPAT)
>>> +               return syscall_get_nr(task, regs) > __NR_ia32_syscall_max;
>>> +#endif
>>> +
>>> +       return syscall_get_nr(task, regs) > __NR_syscall_max;
>>
>> I'm not sure how easy this will be to implement on some of the arches
>> where this data isn't bubbled up.  It'd be good if some non-x86 arch
>> maintainers chimed in (since x86 is easy and already works as expected
>> :).
>>
>
> Since x86 always returns -ENOSYS with an invalid syscall and only x86
> supports seccomp filter in 3.5, I'd propose pushing this off for 3.6+
> to get more feedback from the relevant parties.  Not doing it now
> doesn't expose any users of 3.5 to any sort of changing ABI.

It's (barely) visible.  See VSYS.trace_changenr_high here:

https://github.com/amluto/seccomp

>
> (Otherwise, it seems fine but may make adding new arches slightly more
> onerous, but I suspect ftrace needs this sort of info too as it
> spreads to other arches!)

Are there any arches for which the return value isn't its own
register?  If so, this is necessary.

Agreed, though: let's wait for 3.6.

-- 
Andy Lutomirski
AMA Capital Management, LLC
