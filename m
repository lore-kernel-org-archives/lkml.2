Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2KHAB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 19:01:27 -0500
Received: from ozlabs.org ([203.10.76.45]:51563 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab2KHABW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 19:01:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Beulich <JBeulich@suse.com>, david.daney@cavium.com,
        kosaki.motohiro@jp.fujitsu.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when the compiler supports it
In-Reply-To: <509A245202000078000A6E8F@nat28.tlf.novell.com>
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com> <20121105142944.7b16e6a4.akpm@linux-foundation.org> <877gpz5wi4.fsf@rustcorp.com.au> <5098E50402000078000A698C@nat28.tlf.novell.com> <87ehk6443a.fsf@rustcorp.com.au> <509A245202000078000A6E8F@nat28.tlf.novell.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 08 Nov 2012 09:54:26 +1030
Message-ID: <87zk2t2dzp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich <JBeulich@suse.com> writes:
>>>> On 07.11.12 at 02:03, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>> __COUNTER__:
>>>>         Used to make a unique id.  Let's define __UNIQUE_ID(prefix) for
>>>>         this (using __COUNTER__ or __LINE__). 4.3 and above.
>>>
>>> The fallback to __LINE__ is not necessarily correct in all cases,
>>> namely when deep macro expansions result in two instances used
>>> on the same source line, or a use in a header matches line number
>>> wise a second use in another header or the source file.
>>>
>>> I considered to option of a fallback (and hence an abstraction in
>>> compiler*.h) when doing this, but I didn't want to do something
>>> that would break in perhaps vary obscure ways.
>> 
>> I was thinking of my own code in moduleparam.h, but elfnote.h does the
>> same trick.  In both cases, it'll simply fail compile if we fallback and
>> __LINE__ isn't unique.
>> 
>> So again, I don't think we're going to see many uses, and no existing
>> use will bite us.
>
> That's exactly the point - we can't know (because there's no
> guarantee there aren't - or won't be by the time it might get
> merged - any two conflicting uses of BUILD_BUG_ON...().

Conflicting BUILD_BUG_ON() is completely harmless: two identical
undefines are OK.  The other cases cause a compile error, and one which
is trivial to fix, and I'm happy to fix it if it does.

I've never seen a construction in the kernel which would silently break
if __UNIQUE_ID() isn't actually unique.  That makes sense, because you
if the symbol wasn't exposed you wouldn't need a __UNIQUE_ID.  And if
it's exposed, the compiler will give an error on multiple definition.

(Obviously you can't have non-static __UNIQUE_ID() because it's only
ever unique across a single gcc compile).
>>> #define __build_bug_on_failed(n) __build_bug_on_##n##_failed
>>> #define _BUILD_BUG_ON(n, condition)				\
>>> 	do {							\
>>> 		extern void __compiletime_error(#condition)	\
>>> 		__build_bug_on_failed(n)(void);			\
>>> 		if (condition) __build_bug_on_failed(n)();	\
>>> 	} while(0)
>
> Actually, I just noticed that __linktime_error() really is a compile
> time error when gcc supports __attribute__(__error__()), so
> probably using that one instead of __compiletime_error() here
> would be the cleaner approach.
>
> The one thing puzzling me here is that __linktime_error() gets
> defined even if __CHECKER__ isn't defined, while
> __compiletime_error() doesn't - an apparent inconsistency
> between 746a2a838deec3ef86ef6b7c3edd4207b9a351aa
> (Kosaki?) and 1399ff86f2a2bbacbbe68fa00c5f8c752b344723
> (David?), with apparently the latter being too lax, as it only
> introduced a use inside a !__CHECKER__ section.

Yes, __linktime_error() makes no sense, since it's identical to
__compiletime_error().  It's also a terrible name.  Let's kill it.

I hadn't noticed BUILD_BUG.  We should fix that as discussed here, and
simply make BUILD_BUG_ON() call it.

>> Subject: __UNIQUE_ID()
>> 
>> Jan Beulich points out __COUNTER__ (gcc 4.3 and above), so let's use
>> that to create unique ids.  This is better than __LINE__ which we use
>> today, so provide a wrapper.
>> 
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Acked-by: Jan Beulich <jbeulich@suse.com>

Thanks,
Rusty.
