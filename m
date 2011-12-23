Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab1LWHvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 02:51:49 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:64455 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1LWHvr convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Fri, 23 Dec 2011 02:51:47 -0500
Message-Id: <4EF441580200007800069B38@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 23 Dec 2011 07:52:40 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Arnaud Lacombe" <lacombar@gmail.com>
Cc: <akpm@linux-foundation.org>, "Michal Marek" <mmarek@suse.cz>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] consolidate WARN_...ONCE() static variables
References: <4EF3609D0200007800069A30@nat28.tlf.novell.com>
 <CACqU3MWahjXy3q6AqDARCfPx5r3WF+uoHXZA6mkkpNKDjWcSMA@mail.gmail.com>
In-Reply-To: <CACqU3MWahjXy3q6AqDARCfPx5r3WF+uoHXZA6mkkpNKDjWcSMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.12.11 at 18:13, Arnaud Lacombe <lacombar@gmail.com> wrote:
> On Thu, Dec 22, 2011 at 10:53 AM, Jan Beulich <JBeulich@suse.com> wrote:
>> Due to the alignment of following variables, these typically consume
>> more than just the single byte that 'bool' requires, and as there are
>> a few hundred instances, the cache pollution (not so much the waste of
>> memory) sums op. Put these variables into their own section, outside
>> of half way frequently used memory range.
>>
> how does this relates to kbuild exactly ? I see you did not even CC'ed LKML.

In touching include/asm-generic/vmlinux.lds.h (and not touching
anything outside include/asm-generic/).

And I wasn't aware that any subsystem change needs to go to lkml too;
adding that list now.

> btw, it might be interesting to have numbers backing this change :)

Sort of difficult, as this (obviously) varies by configuration. But as
stated, it's generally a few hundred instances. Additionally, I find it
odd that any small and obvious (at least I view is as such, and it
should have been coded this way from the beginning) improvement
is being asked to be backed by precise numbers.

The one thing I wasn't sure about was whether this shouldn't be done
in a more abstract way, to allow use in other places as well. But such
abstraction can certainly be added incrementally.

Jan

>> --- 3.2-rc6/include/asm-generic/bug.h
>> +++ 3.2-rc6-warn-once-flag-cold/include/asm-generic/bug.h
>> @@ -134,7 +134,7 @@ extern void warn_slowpath_null(const cha
>>  #endif
>>
>>  #define WARN_ON_ONCE(condition)        ({                              \
>> -       static bool __warned;                                   \
>> +       static bool __section(.data.unlikely) __warned;         \
>>        int __ret_warn_once = !!(condition);                    \
>>                                                                \
>>        if (unlikely(__ret_warn_once))                          \
>> @@ -144,7 +144,7 @@ extern void warn_slowpath_null(const cha
>>  })
>>
>>  #define WARN_ONCE(condition, format...)        ({                      \
>> -       static bool __warned;                                   \
>> +       static bool __section(.data.unlikely) __warned;         \
>>        int __ret_warn_once = !!(condition);                    \
>>                                                                \
>>        if (unlikely(__ret_warn_once))                          \
>> @@ -154,7 +154,7 @@ extern void warn_slowpath_null(const cha
>>  })
>>
>>  #define WARN_TAINT_ONCE(condition, taint, format...)   ({      \
>> -       static bool __warned;                                   \
>> +       static bool __section(.data.unlikely) __warned;         \
>>        int __ret_warn_once = !!(condition);                    \
>>                                                                \
>>        if (unlikely(__ret_warn_once))                          \
>> --- 3.2-rc6/include/asm-generic/vmlinux.lds.h
>> +++ 3.2-rc6-warn-once-flag-cold/include/asm-generic/vmlinux.lds.h
>> @@ -167,6 +167,7 @@
>>        CPU_KEEP(exit.data)                                             \
>>        MEM_KEEP(init.data)                                             \
>>        MEM_KEEP(exit.data)                                             \
>> +       *(.data.unlikely)                                               \
>>        STRUCT_ALIGN();                                                 \
>>        *(__tracepoints)                                                \
>>        /* implement dynamic printk debug */                            \
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
>> the body of a message to majordomo@vger.kernel.org 
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html 



