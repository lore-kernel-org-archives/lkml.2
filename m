Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab1FDDEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 23:04:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55036 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1FDDES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 23:04:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v3enLNy14gDPpmV7foWMaN5ILNVvSnh9zl8nGT5YEcpoJnabcoIOIzbYiD4k4Ci5u5
         Gx01I4O57a4ot3ZKC63A==
MIME-Version: 1.0
In-Reply-To: <58c0ab81-5c63-4d41-957b-df02e15aeba5@default>
References: <87hb87lsb0.fsf@gmail.com>
	<58c0ab81-5c63-4d41-957b-df02e15aeba5@default>
Date: Fri, 3 Jun 2011 20:04:14 -0700
Message-ID: <BANLkTiko0AUtGYqXcYxv1KpUKY8t+tvqf1bczSN-qa9uSWtPTg@mail.gmail.com>
Subject: Re: [RFC] "mustnotsleep"
From: Hugh Dickins <hughd@google.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Luis Henriques <luis.henrix@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 5:00 PM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
>> From: Luis Henriques [mailto:luis.henrix@gmail.com]
>> Subject: Re: [RFC] "mustnotsleep"
>>
>> Dan Magenheimer <dan.magenheimer@oracle.com> writes:
>>
>> > In development of RAMster, I have frequently been bitten
>> > by indirect use of existing kernel subsystems that
>> > unexpectedly sleep.  As such, I have hacked the
>> > following "debug" code fragments for use where I need to
>> > ensure that doesn't happen.
>> >
>> > DEFINE_PER_CPU(int, mustnotsleep_count);
>> >
>> > void mustnotsleep_start(void)
>> > {
>> >     int cpu = smp_processor_id();
>> >     per_cpu(mustnotsleep_count, cpu)++;
>> > }
>> >
>> > void mustnotsleep_done(void)
>> > {
>> >     int cpu = smp_processor_id();
>> >     per_cpu(mustnotsleep_count, cpu)--;
>> > }
>> >
>> > and in schedule.c in schedule():
>> >
>> > if (per_cpu(mustnotsleep_count))
>> >     panic("scheduler called in mustnotsleep code");
>> >
>> > This has enabled me to start identifying code that
>> > is causing me problems.  (I know this is a horrible
>> > hack, but that's OK right now.)
>>
>> I'm pretty sure I'm missing something here but... what if you just use
>> CONFIG_DEBUG_PREEMPT?  Isn't that good enough?
>
> Thanks for the reply Luis.
>
> Looking at the code enabled by CONFIG_DEBUG_PREEMPT,
> I don't think it does what I'm looking for.  I need
> to ensure that no code called inside the boundaries
> of mustnotsleep_start/done ever calls the scheduler,
> e.g. cond_resched is never called etc.

Luis is surely on the right lines, but maybe CONFIG_DEBUG_PREEMPT was
not the crucial option.

You should be building with CONFIG_PREEMPT and
CONFIG_DEBUG_SPINLOCK_SLEEP for best testing, and it would be good to
throw in CONFIG_DEBUG_PREEMPT too.

You need to preempt_disable() instead of mustnotsleep_start(), and
preempt_enable() instead of mustnotsleep_done().  You cannot even
safely use their smp_processor_id() without disabling preemption -
otherwise that task might on a different cpu by the time you get to
use the cpu it told you.  It's essential to disable preemption if you
cannot bear to be rescheduled.

Then, if I've read the ifdefs correctly (please verify),
cond_resched() will include a __might_sleep() to report "BUG: sleeping
function called from invalid context..." from cond_resched() and other
useful places.

But please don't disable preemption unnecessarily, nor for very long:
it's better to remain preemptible wherever possible.

Hugh
