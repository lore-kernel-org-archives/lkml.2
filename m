Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2LMAsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:48:11 -0500
Received: from nm7.access.bullet.mail.mud.yahoo.com ([66.94.237.208]:30799
	"EHLO nm7.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754815Ab2LMAsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:48:09 -0500
X-Yahoo-Newman-Id: 707341.16966.bm@smtp108.sbc.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: RTJrRKMVM1lVab999ZRbakeyjUiBqqDCWt2ucLRpT_OyXTt
 XPInvvrAMN2GWHc6uoNJm7sSrypG8puR4oZtd4cQiegSW0zYW8bMYzXZoBvD
 W4NoM2czzFCbrf7rSoE8ETNVi0JKuOQD1ywV0jT5TCCnvDvmNB8b.VrLuScQ
 QD4dAtVZYdYgClyFn9tSQ0SsCFpBxHQuwSOaCaknCc7s8ozvQzyyNl2aCana
 lPfT11HQK4kk9pkOAxFmPPMKYR3LEHIa3Sro8QYd0RaUu8u4oEHco1FGCSlD
 ShTdkcqfk3hymMJ5mRdeuGzvWmSkooviCbXsXm4kDz_N40yFlYQFD.kGMgae
 9O13A7ZS64jo.u0eHNgNHt8z7s1SrN3bKJqzSg58tEqn.j9MKqaFAFtlnM.s
 RO6QBRG6JYTMulbdeYRbcQx8572aRwvrFQAxx2Mk.ekU_1rfW5g--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50C925CC.1090801@att.net>
Date: Wed, 12 Dec 2012 18:48:12 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121128 Thunderbird/10.0.11
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when the
 compiler supports it
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com> <20121105142944.7b16e6a4.akpm@linux-foundation.org> <877gpz5wi4.fsf@rustcorp.com.au> <5098E50402000078000A698C@nat28.tlf.novell.com>
In-Reply-To: <5098E50402000078000A698C@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 03:23 AM, Jan Beulich wrote:
>> This sort of logic is normally performed via the
>> include/linux/compiler*.h system.  And
>>
>> 	grep __GNUC include/linux/*.h
>>
>> indicates that we've been pretty successful.  Can we do that here too?
>>
>> (eg: suppose the Intel compiler supports _Static_assert?)
>> Yeah, there are a lot of goodies here:
>>
>> _Static_assert:
>>          We could define __ASSERT_STRUCT_FIELD(e) for this:
>>          #define BUILD_BUG_ON_ZERO(e) \
>>                  sizeof(struct { __ASSERT_STRUCT_FIELD(e); })
> I considered something like this too, but it wouldn't work well: The
> diagnostic issued from a failed _Static_assert() would preferably
> refer to the original source expression, not an already macro
> expanded variant of it. That, however, precludes passing it
> through multiple levels of macro expansion. Which would leave
> passing e and #e to __ASSERT_STRUCT_FIELD(), but that's again
> ugly as it opens the door for someone adding a use where the two
> arguments don't match up.
I was under the assumption that _Static_assert doesn't exist unless you 
are using -std=c11 or -std=gnu11, but I admit I didn't look into it 
much. I'm very glad it was added to the standard. IMO, it would be 
better to use such a feature (presuming it behaves well) when it is 
available but, of course, we still need the best possible functionality 
when it isn't.

In either case, the new BUILD_BUG_ON macro simply stringifies the 
condition, so it will emit an error indicating the exact expression that 
failed. If you pass it a macro, macro expansion will not be performed 
prior to stringification.
>
>> __compiletime_error():
>>          I blame Arjan for this.  It disappears if not implemented, which
>>          is just lazy.  BUILD_BUG_ON() does this right, and he didn't fix
>>          that at the time :(
> Again, the name of the macro made me not use it, as the obvious
> fallback is a link time error. The only thing I would be agreeable to
> is something like __buildtime_error().

Yeah, I agree, since we speak more in terms of a "build" rather than 
compiling.  But I didn't mess with it in my patches.

>
>> I'd say we have three patches here, really:
>>
>> 1) Add __ASSERT_STRUCT_FIELD(e) to compiler.h
There are actually a number of reasons for having multiple mechanisms to 
break the build.  For instance, BUILD_BUG_ON_ZERO is used outside of 
function bodies, where a compound gcc expression ({expr; expr;}) isn't 
permitted.
>> 2) Add __UNIQUE_ID().
>> 3) Use them (I can think of at least one other place for __UNIQUE_ID()).
>>
>> Jan, do you want the glory?  :) If not, I'll respin.
> Depending on the answers to the above (i.e. how much of it
> actually would need re-doing and re-testing), it may take me
> some time to get to this, but beyond that I'm fine with trying
> to improve this to everyone's satisfaction.
Personally, I would rather we start a cpputil.h (or some such) to 
encapsulate all of our preprocessor kludgery, err, I mean wizardry.  
There must be 14 thousand paste macros in the kernel.  We could move 
stringify into it as well, but I suppose that's another issue.

Daniel
