Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab2KGIFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:05:32 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:60917 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2KGIFa convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Wed, 7 Nov 2012 03:05:30 -0500
Message-Id: <509A245202000078000A6E8F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 07 Nov 2012 08:05:21 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <david.daney@cavium.com>, <kosaki.motohiro@jp.fujitsu.com>,
        "Rusty Russell" <rusty@rustcorp.com.au>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when
 the compiler supports it
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com>
 <20121105142944.7b16e6a4.akpm@linux-foundation.org>
 <877gpz5wi4.fsf@rustcorp.com.au>
 <5098E50402000078000A698C@nat28.tlf.novell.com>
 <87ehk6443a.fsf@rustcorp.com.au>
In-Reply-To: <87ehk6443a.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 07.11.12 at 02:03, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Jan Beulich <JBeulich@suse.com> writes:
>>>>> On 06.11.12 at 02:51, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> Yeah, there are a lot of goodies here:
>>> 
>>> _Static_assert:
>>>         We could define __ASSERT_STRUCT_FIELD(e) for this:
>>>         #define BUILD_BUG_ON_ZERO(e) \
>>>                 sizeof(struct { __ASSERT_STRUCT_FIELD(e); })
>>
>> I considered something like this too, but it wouldn't work well: The
>> diagnostic issued from a failed _Static_assert() would preferably
>> refer to the original source expression, not an already macro
>> expanded variant of it. That, however, precludes passing it
>> through multiple levels of macro expansion. Which would leave
>> passing e and #e to __ASSERT_STRUCT_FIELD(), but that's again
>> ugly as it opens the door for someone adding a use where the two
>> arguments don't match up.
> 
> Good point, but this is going to be pretty damn obscure.  In fact, I
> don't think it'll see more than the use here.

Okay, so I'll go with something like that then.

>>> __COUNTER__:
>>>         Used to make a unique id.  Let's define __UNIQUE_ID(prefix) for
>>>         this (using __COUNTER__ or __LINE__). 4.3 and above.
>>
>> The fallback to __LINE__ is not necessarily correct in all cases,
>> namely when deep macro expansions result in two instances used
>> on the same source line, or a use in a header matches line number
>> wise a second use in another header or the source file.
>>
>> I considered to option of a fallback (and hence an abstraction in
>> compiler*.h) when doing this, but I didn't want to do something
>> that would break in perhaps vary obscure ways.
> 
> I was thinking of my own code in moduleparam.h, but elfnote.h does the
> same trick.  In both cases, it'll simply fail compile if we fallback and
> __LINE__ isn't unique.
> 
> So again, I don't think we're going to see many uses, and no existing
> use will bite us.

That's exactly the point - we can't know (because there's no
guarantee there aren't - or won't be by the time it might get
merged - any two conflicting uses of BUILD_BUG_ON...().

>>> __compiletime_error():
>>>         I blame Arjan for this.  It disappears if not implemented, which
>>>         is just lazy.  BUILD_BUG_ON() does this right, and he didn't fix
>>>         that at the time :(
>>
>> Again, the name of the macro made me not use it, as the obvious
>> fallback is a link time error. The only thing I would be agreeable to
>> is something like __buildtime_error().
> 
> Yes, it's awkward to use.  Your own usage here is the only correct way
> to do it, AFAICT:
> 
>> #define __build_bug_on_failed(n) __build_bug_on_##n##_failed
>> #define _BUILD_BUG_ON(n, condition)				\
>> 	do {							\
>> 		extern void __compiletime_error(#condition)	\
>> 		__build_bug_on_failed(n)(void);			\
>> 		if (condition) __build_bug_on_failed(n)();	\
>> 	} while(0)

Actually, I just noticed that __linktime_error() really is a compile
time error when gcc supports __attribute__(__error__()), so
probably using that one instead of __compiletime_error() here
would be the cleaner approach.

The one thing puzzling me here is that __linktime_error() gets
defined even if __CHECKER__ isn't defined, while
__compiletime_error() doesn't - an apparent inconsistency
between 746a2a838deec3ef86ef6b7c3edd4207b9a351aa
(Kosaki?) and 1399ff86f2a2bbacbbe68fa00c5f8c752b344723
(David?), with apparently the latter being too lax, as it only
introduced a use inside a !__CHECKER__ section.

>> #define BUILD_BUG_ON(condition...) _BUILD_BUG_ON(__COUNTER__, ##condition)
> 
> The ... is overkill here: sure it's general, but we don't allow that
> currently, nor in the other BUILD_BUG_ON() definitions.

This may be a leftover from previous failed attempts; I don't
see a reason why it should stay.

> So I think this becomes:
> 
> #define _BUILD_BUG_ON(undefname, condition)                                    \
>         do {                                                                   \
>                 extern void __compiletime_error(#condition) undefname(void);   \
>                 if (condition) undefname();                                    \
>         } while(0)
> #define BUILD_BUG_ON(condition) \
>         _BUILD_BUG_ON(__UNIQUE_ID(__build_bug_fail), (condition))

Yes, subject to the fallback issue.

> Subject: __UNIQUE_ID()
> 
> Jan Beulich points out __COUNTER__ (gcc 4.3 and above), so let's use
> that to create unique ids.  This is better than __LINE__ which we use
> today, so provide a wrapper.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Jan Beulich <jbeulich@suse.com>

> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index 412bc6c..8908821 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -31,6 +31,8 @@
>  
>  #define __linktime_error(message) __attribute__((__error__(message)))
>  
> +#define __UNIQUE_ID(prefix) __PASTE(prefix, __PASTE(__, __COUNTER__))
> +
>  #if __GNUC_MINOR__ >= 5
>  /*
>   * Mark a position in code as unreachable.  This can be used to
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index f430e41..c55ae87 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -42,6 +42,10 @@ extern void __chk_io_ptr(const volatile void __iomem *);
>  # define __rcu
>  #endif
>  
> +/* Indirect macros required for expanded argument pasting, eg. __LINE__. */
> +#define ___PASTE(a,b) a##b
> +#define __PASTE(a,b) ___PASTE(a,b)
> +
>  #ifdef __KERNEL__
>  
>  #ifdef __GNUC__
> @@ -164,6 +168,11 @@ void ftrace_likely_update(struct ftrace_branch_data *f, 
> int val, int expect);
>      (typeof(ptr)) (__ptr + (off)); })
>  #endif
>  
> +/* Not-quite-unique ID. */
> +#ifndef __UNIQUE_ID
> +# define __UNIQUE_ID(prefix) __PASTE(__PASTE(prefix, __), __LINE__)
> +#endif
> +
>  #endif /* __KERNEL__ */
>  
>  #endif /* __ASSEMBLY__ */


