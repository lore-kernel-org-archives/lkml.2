Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab2LMA3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:29:46 -0500
Received: from nm26.access.bullet.mail.mud.yahoo.com ([66.94.237.91]:39984
	"EHLO nm26.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793Ab2LMA3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:29:45 -0500
X-Yahoo-Newman-Id: 411790.39423.bm@smtp108.sbc.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: BM3s8xYVM1mknpATImoZna4O9weTyQmlhpWxLAx7Fq4Gkj7
 RsTANNQBVeYVreaBkpXc0_mWbifvwz1gCQxHJlsgBUJyJm0ampWV8CY0voRv
 47FMTvidBIcc.6jpfL25gthSyNGsh_KJ60PGIBHcDR3cB3ISXM126DIfgSth
 vSAjrsEvPSzcM5wiAw6qc36auLGDDf.U42H7n7.Tphm.6bA289KzY2pE3ZRR
 D8BNo__3GghYk2t7AU6cQQghjazini0SH6nuRdNPWu4dyM49J__l7da2amx.
 8mMmfypis8ISo5O0ZRZv.CKY1sy8KcMeabLDg2y.SpVKM3sAVy1IAiJ2nApi
 GtBLV3Nbvu_RiAGQqv0vnZiIEq0nAr81arhyPVhuaj.9lbN78UBywB4Tze0s
 AwbBtDkzEqqFqIseCO0YeVt5u00KQo1hvy85sWbxtuEqSOoJSZ8Gp3bhYoqo
 8f_v6a6BRvjVFVKcjfc2gp7jn0NOPnhI3u4XTUUDoTebD6g940DR286pkZX5
 EkB4D
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50C9217B.1010801@att.net>
Date: Wed, 12 Dec 2012 18:29:47 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121128 Thunderbird/10.0.11
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jan Beulich <JBeulich@suse.com>, david.daney@cavium.com,
        kosaki.motohiro@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when the
 compiler supports it
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com> <20121105142944.7b16e6a4.akpm@linux-foundation.org> <877gpz5wi4.fsf@rustcorp.com.au> <5098E50402000078000A698C@nat28.tlf.novell.com> <87ehk6443a.fsf@rustcorp.com.au> <509A245202000078000A6E8F@nat28.tlf.novell.com> <87zk2t2dzp.fsf@rustcorp.com.au>
In-Reply-To: <87zk2t2dzp.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow, it's really easy to miss parallel development on the same issue.  
Sorry for my late response to this thread.  I started another thread 
addressing these issues (as well as a few others) back in September 
(https://lkml.org/lkml/2012/9/28/1136).  I've finally gotten ACKs from 
maintainers with v6 of the patches (here 
https://lkml.org/lkml/2012/11/20/621) and I'm just waiting for 3.8-rc1 
to re-submit them.  I actually submitted these patches back in June as 
part of a larger patch set, but broke it apart in September (I had way 
to many changes for one patch set)


On 11/07/2012 05:24 PM, Rusty Russell wrote:
> Jan Beulich<JBeulich@suse.com>  writes:
>>>>> On 07.11.12 at 02:03, Rusty Russell<rusty@rustcorp.com.au>  wrote:
>>>>> __COUNTER__:
>>>>>          Used to make a unique id.  Let's define __UNIQUE_ID(prefix) for
>>>>>          this (using __COUNTER__ or __LINE__). 4.3 and above.
>>>> The fallback to __LINE__ is not necessarily correct in all cases,
>>>> namely when deep macro expansions result in two instances used
>>>> on the same source line, or a use in a header matches line number
>>>> wise a second use in another header or the source file.
>>>>
>>>> I considered to option of a fallback (and hence an abstraction in
>>>> compiler*.h) when doing this, but I didn't want to do something
>>>> that would break in perhaps vary obscure ways.
>>> I was thinking of my own code in moduleparam.h, but elfnote.h does the
>>> same trick.  In both cases, it'll simply fail compile if we fallback and
>>> __LINE__ isn't unique.
>>>
>>> So again, I don't think we're going to see many uses, and no existing
>>> use will bite us.
>> That's exactly the point - we can't know (because there's no
>> guarantee there aren't - or won't be by the time it might get
>> merged - any two conflicting uses of BUILD_BUG_ON...().
> Conflicting BUILD_BUG_ON() is completely harmless: two identical
> undefines are OK.  The other cases cause a compile error, and one which
> is trivial to fix, and I'm happy to fix it if it does.
>
> I've never seen a construction in the kernel which would silently break
> if __UNIQUE_ID() isn't actually unique.  That makes sense, because you
> if the symbol wasn't exposed you wouldn't need a __UNIQUE_ID.  And if
> it's exposed, the compiler will give an error on multiple definition.
>
> (Obviously you can't have non-static __UNIQUE_ID() because it's only
> ever unique across a single gcc compile).
I was considering __COUNTER__, but in the end, others felt that the 
inconsistency could cause problems later.  However, with the 
__compiletime_error function attribute, the result will only be that the 
actual error message emitted will be incorrect, since the first error 
attribute assigned to the extern function will be used.  Thus, compiling 
this code:

{extern void func(void) __attribute__((error("hello")));}
{extern void func(void) __attribute__((error("goodbye"))); func();}

would result in an error with the message "hello".

>>>> #define __build_bug_on_failed(n) __build_bug_on_##n##_failed
>>>> #define _BUILD_BUG_ON(n, condition)				\
>>>> 	do {							\
>>>> 		extern void __compiletime_error(#condition)	\
>>>> 		__build_bug_on_failed(n)(void);			\
>>>> 		if (condition) __build_bug_on_failed(n)();	\
>>>> 	} while(0)
>> Actually, I just noticed that __linktime_error() really is a compile
>> time error when gcc supports __attribute__(__error__()), so
>> probably using that one instead of __compiletime_error() here
>> would be the cleaner approach.
>>
>> The one thing puzzling me here is that __linktime_error() gets
>> defined even if __CHECKER__ isn't defined, while
>> __compiletime_error() doesn't - an apparent inconsistency
>> between 746a2a838deec3ef86ef6b7c3edd4207b9a351aa
>> (Kosaki?) and 1399ff86f2a2bbacbbe68fa00c5f8c752b344723
>> (David?), with apparently the latter being too lax, as it only
>> introduced a use inside a !__CHECKER__ section.
> Yes, __linktime_error() makes no sense, since it's identical to
> __compiletime_error().  It's also a terrible name.  Let's kill it.
Definitely.  My patch set kills that sucker too.
>
> I hadn't noticed BUILD_BUG.  We should fix that as discussed here, and
> simply make BUILD_BUG_ON() call it.
>
>>> Subject: __UNIQUE_ID()
>>>
>>> Jan Beulich points out __COUNTER__ (gcc 4.3 and above), so let's use
>>> that to create unique ids.  This is better than __LINE__ which we use
>>> today, so provide a wrapper.
>>>
>>> Signed-off-by: Rusty Russell<rusty@rustcorp.com.au>
>> Acked-by: Jan Beulich<jbeulich@suse.com>
> Thanks,
> Rusty.
https://lkml.org/lkml/2012/9/28/1136
