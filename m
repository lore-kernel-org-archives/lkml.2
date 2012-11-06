Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab2KFCKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 21:10:43 -0500
Received: from ozlabs.org ([203.10.76.45]:33371 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933442Ab2KFCKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 21:10:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Beulich <JBeulich@suse.com>
Cc: linux-kernel@vger.kernel.org, "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when the compiler supports it
In-Reply-To: <20121105142944.7b16e6a4.akpm@linux-foundation.org>
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com> <20121105142944.7b16e6a4.akpm@linux-foundation.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 06 Nov 2012 12:21:47 +1030
Message-ID: <877gpz5wi4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 02 Nov 2012 14:47:40 +0000
> "Jan Beulich" <JBeulich@suse.com> wrote:
>
>> This makes the resulting diagnostics quite a bit more useful.
>
> So asserts Jan, but to confirm it I would need to download, configure,
> build and install a different gcc version, which sounds rather a hassle.
>
> So, please show us an exmple of these diagnostics in the changelog.
>
>> --- 3.7-rc3/include/linux/bug.h
>> +++ 3.7-rc3-static-assert/include/linux/bug.h
>> @@ -27,8 +27,15 @@ struct pt_regs;
>>     result (of value 0 and type size_t), so the expression can be used
>>     e.g. in a structure initializer (or where-ever else comma expressions
>>     aren't permitted). */
>> +#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6)
>
> This sort of logic is normally performed via the
> include/linux/compiler*.h system.  And
>
> 	grep __GNUC include/linux/*.h
>
> indicates that we've been pretty successful.  Can we do that here too?
>
> (eg: suppose the Intel compiler supports _Static_assert?)

Yeah, there are a lot of goodies here:

_Static_assert:
        We could define __ASSERT_STRUCT_FIELD(e) for this:
        #define BUILD_BUG_ON_ZERO(e) \
                sizeof(struct { __ASSERT_STRUCT_FIELD(e); })

__COUNTER__:
        Used to make a unique id.  Let's define __UNIQUE_ID(prefix) for
        this (using __COUNTER__ or __LINE__). 4.3 and above.

__compiletime_error():
        I blame Arjan for this.  It disappears if not implemented, which
        is just lazy.  BUILD_BUG_ON() does this right, and he didn't fix
        that at the time :(

I'd say we have three patches here, really:

1) Add __ASSERT_STRUCT_FIELD(e) to compiler.h
2) Add __UNIQUE_ID().
3) Use them (I can think of at least one other place for __UNIQUE_ID()).

Jan, do you want the glory?  :) If not, I'll respin.

Thanks,
Rusty.

