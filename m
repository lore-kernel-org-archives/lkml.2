Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2KEIqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:46:19 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:37613 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab2KEIqR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 5 Nov 2012 03:46:17 -0500
Message-Id: <50978AE402000078000A64A3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 05 Nov 2012 08:46:12 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when
 the compiler supports it
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com>
 <87pq3syeow.fsf@rustcorp.com.au>
In-Reply-To: <87pq3syeow.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.11.12 at 03:19, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Jan Beulich <JBeulich@suse.com> writes:
>> @@ -54,6 +61,15 @@ struct pt_regs;
>>   */
>>  #ifndef __OPTIMIZE__
>>  #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
>> +#elif __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 3)
>> +#define __build_bug_on_failed(n) __build_bug_on_##n##_failed
>> +#define _BUILD_BUG_ON(n, condition)				\
>> +	do {							\
>> +		extern void __compiletime_error(#condition)	\
>> +		__build_bug_on_failed(n)(void);			\
>> +		if (condition) __build_bug_on_failed(n)();	\
>> +	} while(0)
>> +#define BUILD_BUG_ON(condition...) _BUILD_BUG_ON(__COUNTER__, ##condition)
>>  #else
>>  extern int __build_bug_on_failed;
>>  #define BUILD_BUG_ON(condition)					\
> 
> Why does this depend on gcc version?  Looks like residue from an attempt
> to use _Static_assert here?

That was the original hope, yes, but didn't work because of
certain uses BUILD_BUG_ON() in inline functions. Hence the
next best solution was to use __compiletime_error(), which
still gives a better diagnostic than what we have so far, but is
- see include/linux/compiler-gcc4.h - available only with gcc 4.3
and newer (simply using the construct even when expanding to
nothing - in include/linux/compile.h - wouldn't have the intended
effect of producing a compiler diagnostic at all, it would get
deferred to link time in _all_ cases, even if the compiler can tell
it's a constant).

Jan

