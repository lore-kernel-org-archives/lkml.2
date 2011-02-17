Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1BQBzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:55:47 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44803 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab1BQBzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:55:46 -0500
X-AuditID: b753bd60-a46baba000004916-75-4d5c801e024a
X-AuditID: b753bd60-a46baba000004916-75-4d5c801e024a
Message-ID: <4D5C8019.70301@hitachi.com>
Date: Thu, 17 Feb 2011 10:55:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Will Newton <will.newton@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Will Simoneau <simoneau@ele.uri.edu>,
        David Miller <davem@davemloft.net>, hpa@zytor.com,
        matt@console-pimps.org, peterz@infradead.org, jbaron@redhat.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <4D59B891.8010300@zytor.com> <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com> <20110215211123.GA3094@ele.uri.edu> <20110215.132702.39199169.davem@davemloft.net> <20110215215604.GA3177@ele.uri.edu> <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com> <1297858734.23343.138.camel@gandalf.stny.rr.com> <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com> <BLU0-SMTP80F56386E7E060A3B2020B96D20@phx.gbl>
In-Reply-To: <BLU0-SMTP80F56386E7E060A3B2020B96D20@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/16 22:24), Mathieu Desnoyers wrote:
> * Will Newton (will.newton@gmail.com) wrote:
>> On Wed, Feb 16, 2011 at 12:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> On Wed, 2011-02-16 at 10:15 +0000, Will Newton wrote:
>>>
>>>>> That's some really crippled hardware... it does seem like *any* loads
>>>>> from *any* address updated by an sc would have to be done with ll as
>>>>> well, else they may load stale values. One could work this into
>>>>> atomic_read(), but surely there are other places that are problems.
>>>>
>>>> I think it's actually ok, atomics have arch implemented accessors, as
>>>> do spinlocks and atomic bitops. Those are the only place we do sc so
>>>> we can make sure we always ll or invalidate manually.
>>>
>>> I'm curious, how is cmpxchg() implemented on this architecture? As there
>>> are several places in the kernel that uses this on regular variables
>>> without any "accessor" functions.
>>
>> We can invalidate the cache manually. The current cpu will see the new
>> value (post-cache invalidate) and the other cpus will see either the
>> old value or the new value depending on whether they read before or
>> after the invalidate, which is racy but I don't think it is
>> problematic. Unless I'm missing something...
> 
> Assuming the invalidate is specific to a cache-line, I'm concerned about
> the failure of a scenario like the following:
> 
> initially:
> foo = 0
> bar = 0
> 
> CPU A                            CPU B
> 
> xchg(&foo, 1);
>   ll foo
>   sc foo
> 
>   -> interrupt
> 
>   if (foo == 1)
>     xchg(&bar, 1);
>       ll bar
>       sc bar
>       invalidate bar
> 
>                                  lbar = bar;
>                                  smp_mb()
>                                  lfoo = foo;
>                                  BUG_ON(lbar == 1 && lfoo == 0);
>   invalidate foo
> 
> It should be valid to expect that every time "bar" read by CPU B is 1,
> then "foo" is always worth 1. However, in this case, the lack of
> invalidate on foo is keeping the cacheline from reaching CPU B. There
> seems to be a problem with interrupts/NMIs coming right between sc and
> invalidate, as Ingo pointed out.

Hmm, I think that is miss-coding ll/sc.
If I understand correctly, usually cache invalidation should be done
right before storing value, as MSI protocol does.
(or, sc should atomically invalidate the cache line)

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
