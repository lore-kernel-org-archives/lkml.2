Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab2KFJXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:23:11 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:60182 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2KFJXG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 6 Nov 2012 04:23:06 -0500
Message-Id: <5098E50402000078000A698C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 06 Nov 2012 09:23:00 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
        "Rusty Russell" <rusty@rustcorp.com.au>
Cc: "Arjan van de Ven" <arjan@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when
 the compiler supports it
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com>
 <20121105142944.7b16e6a4.akpm@linux-foundation.org>
 <877gpz5wi4.fsf@rustcorp.com.au>
In-Reply-To: <877gpz5wi4.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.11.12 at 02:51, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
>> On Fri, 02 Nov 2012 14:47:40 +0000
>> "Jan Beulich" <JBeulich@suse.com> wrote:
>>
>>> This makes the resulting diagnostics quite a bit more useful.
>>
>> So asserts Jan, but to confirm it I would need to download, configure,
>> build and install a different gcc version, which sounds rather a hassle.
>>
>> So, please show us an exmple of these diagnostics in the changelog.
>>
>>> --- 3.7-rc3/include/linux/bug.h
>>> +++ 3.7-rc3-static-assert/include/linux/bug.h
>>> @@ -27,8 +27,15 @@ struct pt_regs;
>>>     result (of value 0 and type size_t), so the expression can be used
>>>     e.g. in a structure initializer (or where-ever else comma expressions
>>>     aren't permitted). */
>>> +#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6)
>>
>> This sort of logic is normally performed via the
>> include/linux/compiler*.h system.  And
>>
>> 	grep __GNUC include/linux/*.h
>>
>> indicates that we've been pretty successful.  Can we do that here too?
>>
>> (eg: suppose the Intel compiler supports _Static_assert?)
> 
> Yeah, there are a lot of goodies here:
> 
> _Static_assert:
>         We could define __ASSERT_STRUCT_FIELD(e) for this:
>         #define BUILD_BUG_ON_ZERO(e) \
>                 sizeof(struct { __ASSERT_STRUCT_FIELD(e); })

I considered something like this too, but it wouldn't work well: The
diagnostic issued from a failed _Static_assert() would preferably
refer to the original source expression, not an already macro
expanded variant of it. That, however, precludes passing it
through multiple levels of macro expansion. Which would leave
passing e and #e to __ASSERT_STRUCT_FIELD(), but that's again
ugly as it opens the door for someone adding a use where the two
arguments don't match up.

> __COUNTER__:
>         Used to make a unique id.  Let's define __UNIQUE_ID(prefix) for
>         this (using __COUNTER__ or __LINE__). 4.3 and above.

The fallback to __LINE__ is not necessarily correct in all cases,
namely when deep macro expansions result in two instances used
on the same source line, or a use in a header matches line number
wise a second use in another header or the source file.

I considered to option of a fallback (and hence an abstraction in
compiler*.h) when doing this, but I didn't want to do something
that would break in perhaps vary obscure ways.

> __compiletime_error():
>         I blame Arjan for this.  It disappears if not implemented, which
>         is just lazy.  BUILD_BUG_ON() does this right, and he didn't fix
>         that at the time :(

Again, the name of the macro made me not use it, as the obvious
fallback is a link time error. The only thing I would be agreeable to
is something like __buildtime_error().

> I'd say we have three patches here, really:
> 
> 1) Add __ASSERT_STRUCT_FIELD(e) to compiler.h
> 2) Add __UNIQUE_ID().
> 3) Use them (I can think of at least one other place for __UNIQUE_ID()).
> 
> Jan, do you want the glory?  :) If not, I'll respin.

Depending on the answers to the above (i.e. how much of it
actually would need re-doing and re-testing), it may take me
some time to get to this, but beyond that I'm fine with trying
to improve this to everyone's satisfaction.

Jan

