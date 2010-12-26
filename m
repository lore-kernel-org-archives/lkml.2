Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab0LZAGF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 19:06:05 -0500
Received: from smtp-out.google.com ([74.125.121.67]:25046 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0LZAGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 19:06:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=daU9RzGBXq3SuVFaqyZ0P7eg/CKUMykgbXsUq68OZiMrfGX590KoofBjTdUDKLGh66
         5tSEZi92AF6ZfUHAxmjg==
MIME-Version: 1.0
In-Reply-To: <1293263418.6896.54.camel@marge.simson.net>
References: <1293236813-31550-1-git-send-email-venki@google.com>
	<1293263418.6896.54.camel@marge.simson.net>
Date: Sat, 25 Dec 2010 16:05:58 -0800
Message-ID: <AANLkTintN2e-NHB=USQ4RSi1LMrC8TxB7BB0MNpPscSB@mail.gmail.com>
Subject: Re: [PATCH] sched: Buggy comparison in check_preempt_tick
From: Venkatesh Pallipadi <venki@google.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Ranjit Manomohan <ranjitm@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 11:50 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Fri, 2010-12-24 at 16:26 -0800, Venkatesh Pallipadi wrote:
>> A preempt comparison line in check_preempt_tick has two bugs.
>> * It compares signed and unsigned quantities, which breaks when signed
>>   quantity happens to be negative
>
> Oops, that's a bug.
>
>> * It compares runtime and vruntime, which breaks when there are niced tasks
>
> This imho isn't.
>
> vruntimes advance at different rates for differently weighted tasks, so
> they're already weighted, as is ideal_runtime.
>
> For wakeup preemption we use wakeup_gran() as the weighted ruler to
> limit spread.  This test just uses a different weighted ruler for the
> same purpose at tick time, one already computed.
>
> If you're a heavily niced task, you were very likely booted before you
> got this far.  If you haven't run for considerable wall time, you won't
> get further, you keep on running.  You only get booted if giving you a
> full wall slice will spread vruntimes too much, for which you'll pay if
> you keep running, and leftmost will pay now if we don't boot you.
>

May be I am all confused.
- se->vruntime update in __update_curr() is based on
delta_exec_weighted ( i.e., calc_delta_fair(delta_exec, curr) with
delta_exec being wall clock time.
- We have earlier in check_preempt_tick(), ideal_runtime getting
compared with delta exec, which is wall clock time
- delta in check_preempt_tick is se->vruntime difference, which should
be the weighted time and comparing that with ideal_runtime (which is
compared with wall clock earlier) seems wrong.

This is debug output with trace_printk outside this if statement and
if based on (s64)ideal_runtime.
Task 17807 is nice 0 task and task 6363 is nice -2.
Ideal slice for Task 17807 is 8168151
Ideal slice for Task 6363 is 15798460
<...>-17807 [002] 15851.352247: task_tick_fair: delta 3538447 rt
8168151 vrt 10200199
<...>-17807 [002] 15851.353246: task_tick_fair: delta 4799848 rt
8168151 vrt 10200199
<...>-17807 [002] 15851.354245: task_tick_fair: delta 6036141 rt
8168151 vrt 10200199
<...>-17807 [002] 15851.355244: task_tick_fair: delta 7297361 rt
8168151 vrt 10200199
<...>-17807 [002] 15851.356244: task_tick_fair: delta 8546469 rt
8168151 vrt 10200199

Here delta is increasing faster than wall time due to relative lower
nice value of this task and we are comparing this delta with
ideal_slice, which is wall clock time and hence we preempt this task
earlier. No?

Thanks,
Venki
