Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2KGBfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:35:14 -0500
Received: from ozlabs.org ([203.10.76.45]:38803 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2KGBfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:35:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Beulich <JBeulich@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when the compiler supports it
In-Reply-To: <5098E50402000078000A698C@nat28.tlf.novell.com>
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com> <20121105142944.7b16e6a4.akpm@linux-foundation.org> <877gpz5wi4.fsf@rustcorp.com.au> <5098E50402000078000A698C@nat28.tlf.novell.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 07 Nov 2012 11:33:05 +1030
Message-ID: <87ehk6443a.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich <JBeulich@suse.com> writes:
>>>> On 06.11.12 at 02:51, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>>> On Fri, 02 Nov 2012 14:47:40 +0000
>>> "Jan Beulich" <JBeulich@suse.com> wrote:
>>>
>>>> This makes the resulting diagnostics quite a bit more useful.
>>>
>>> So asserts Jan, but to confirm it I would need to download, configure,
>>> build and install a different gcc version, which sounds rather a hassle.
>>>
>>> So, please show us an exmple of these diagnostics in the changelog.
>>>
>>>> --- 3.7-rc3/include/linux/bug.h
>>>> +++ 3.7-rc3-static-assert/include/linux/bug.h
>>>> @@ -27,8 +27,15 @@ struct pt_regs;
>>>>     result (of value 0 and type size_t), so the expression can be used
>>>>     e.g. in a structure initializer (or where-ever else comma expressions
>>>>     aren't permitted). */
>>>> +#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6)
>>>
>>> This sort of logic is normally performed via the
>>> include/linux/compiler*.h system.  And
>>>
>>> 	grep __GNUC include/linux/*.h
>>>
>>> indicates that we've been pretty successful.  Can we do that here too?
>>>
>>> (eg: suppose the Intel compiler supports _Static_assert?)
>> 
>> Yeah, there are a lot of goodies here:
>> 
>> _Static_assert:
>>         We could define __ASSERT_STRUCT_FIELD(e) for this:
>>         #define BUILD_BUG_ON_ZERO(e) \
>>                 sizeof(struct { __ASSERT_STRUCT_FIELD(e); })
>
> I considered something like this too, but it wouldn't work well: The
> diagnostic issued from a failed _Static_assert() would preferably
> refer to the original source expression, not an already macro
> expanded variant of it. That, however, precludes passing it
> through multiple levels of macro expansion. Which would leave
> passing e and #e to __ASSERT_STRUCT_FIELD(), but that's again
> ugly as it opens the door for someone adding a use where the two
> arguments don't match up.

Good point, but this is going to be pretty damn obscure.  In fact, I
don't think it'll see more than the use here.

>> __COUNTER__:
>>         Used to make a unique id.  Let's define __UNIQUE_ID(prefix) for
>>         this (using __COUNTER__ or __LINE__). 4.3 and above.
>
> The fallback to __LINE__ is not necessarily correct in all cases,
> namely when deep macro expansions result in two instances used
> on the same source line, or a use in a header matches line number
> wise a second use in another header or the source file.
>
> I considered to option of a fallback (and hence an abstraction in
> compiler*.h) when doing this, but I didn't want to do something
> that would break in perhaps vary obscure ways.

I was thinking of my own code in moduleparam.h, but elfnote.h does the
same trick.  In both cases, it'll simply fail compile if we fallback and
__LINE__ isn't unique.

So again, I don't think we're going to see many uses, and no existing
use will bite us.

>> __compiletime_error():
>>         I blame Arjan for this.  It disappears if not implemented, which
>>         is just lazy.  BUILD_BUG_ON() does this right, and he didn't fix
>>         that at the time :(
>
> Again, the name of the macro made me not use it, as the obvious
> fallback is a link time error. The only thing I would be agreeable to
> is something like __buildtime_error().

Yes, it's awkward to use.  Your own usage here is the only correct way
to do it, AFAICT:

> #define __build_bug_on_failed(n) __build_bug_on_##n##_failed
> #define _BUILD_BUG_ON(n, condition)				\
> 	do {							\
> 		extern void __compiletime_error(#condition)	\
> 		__build_bug_on_failed(n)(void);			\
> 		if (condition) __build_bug_on_failed(n)();	\
> 	} while(0)
> #define BUILD_BUG_ON(condition...) _BUILD_BUG_ON(__COUNTER__, ##condition)

The ... is overkill here: sure it's general, but we don't allow that
currently, nor in the other BUILD_BUG_ON() definitions.

So I think this becomes:

#define _BUILD_BUG_ON(undefname, condition)                                    \
        do {                                                                   \
                extern void __compiletime_error(#condition) undefname(void);   \
                if (condition) undefname();                                    \
        } while(0)
#define BUILD_BUG_ON(condition) \
        _BUILD_BUG_ON(__UNIQUE_ID(__build_bug_fail), (condition))

>> I'd say we have three patches here, really:
>> 
>> 1) Add __ASSERT_STRUCT_FIELD(e) to compiler.h
>> 2) Add __UNIQUE_ID().
>> 3) Use them (I can think of at least one other place for __UNIQUE_ID()).
>> 
>> Jan, do you want the glory?  :) If not, I'll respin.
>
> Depending on the answers to the above (i.e. how much of it
> actually would need re-doing and re-testing), it may take me
> some time to get to this, but beyond that I'm fine with trying
> to improve this to everyone's satisfaction.

Yeah, it is kind of a lot of work for a little bikeshed.  But putting
compiler tests in bug.h is pretty icky too.

Below is a __UNIQUE_ID() patch, which I'd like anyway to clean up
moduleparam.h.

Cheers,
Rusty.

Subject: __UNIQUE_ID()

Jan Beulich points out __COUNTER__ (gcc 4.3 and above), so let's use
that to create unique ids.  This is better than __LINE__ which we use
today, so provide a wrapper.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 412bc6c..8908821 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -31,6 +31,8 @@
 
 #define __linktime_error(message) __attribute__((__error__(message)))
 
+#define __UNIQUE_ID(prefix) __PASTE(prefix, __PASTE(__, __COUNTER__))
+
 #if __GNUC_MINOR__ >= 5
 /*
  * Mark a position in code as unreachable.  This can be used to
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index f430e41..c55ae87 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -42,6 +42,10 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __rcu
 #endif
 
+/* Indirect macros required for expanded argument pasting, eg. __LINE__. */
+#define ___PASTE(a,b) a##b
+#define __PASTE(a,b) ___PASTE(a,b)
+
 #ifdef __KERNEL__
 
 #ifdef __GNUC__
@@ -164,6 +168,11 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+/* Not-quite-unique ID. */
+#ifndef __UNIQUE_ID
+# define __UNIQUE_ID(prefix) __PASTE(__PASTE(prefix, __), __LINE__)
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
