Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1GDJAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 05:00:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47148 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab1GDJAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 05:00:10 -0400
MIME-Version: 1.0
In-Reply-To: <CADZ9YHg6MBqi-2DkuYkKBbyJi2E-q_2+gpt8Os4DuVt5an+7uQ@mail.gmail.com>
References: <1309545711.4303.2.camel@localhost.localdomain>
	<1309600260.10073.3.camel@twins>
	<CADZ9YHhmctoO+AZfjDYNHXJ6VO3VSDPHgYOhdoW9oROFrBgBnQ@mail.gmail.com>
	<1309620931.3282.4.camel@twins>
	<CADZ9YHg6MBqi-2DkuYkKBbyJi2E-q_2+gpt8Os4DuVt5an+7uQ@mail.gmail.com>
Date: Mon, 4 Jul 2011 15:00:09 +0600
Message-ID: <CADZ9YHjjxa+h8QKPm9pGqv3w75omO2sCpDJmDFhwNapo45Z3Ag@mail.gmail.com>
Subject: Re: [PATCH] sched: Check nr_running before calling pick_next_task in schedule().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 3, 2011 at 2:07 PM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Sat, Jul 2, 2011 at 9:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Sat, 2011-07-02 at 20:26 +0600, Rakib Mullick wrote:
>>> Well, yes - branching seems definitely have some side effects.
>>
>> It adds the cost of the test as well as a possible branch mis-predict.
>>
>>> Thinking from UP's perspective, it will only hit slow path -- going
>>> into idle.
>>
>> Uhm, no, every time the machine is busy and does a schedule between
>> tasks you still get to do that extra nr_running test and branch.
>>
> Ok, for now I'm putting branch aside. I don't think checking
> nr_running isn't extra, it should be norm. Cause, if this rq has no
> nr_running it calls idle_balance, at that point due to idle_balance -
> we might have moved task from other rq if idle_balance is successful.
> But, idle_balance might not be successful that's why I was thinking
> about checking nr_running is necessary, in that case we don't need to
> call pick_next_task cause - we don't have any task.
>
>>>  In that case, that likely branch will just fail. And on an
>>> UP system that slow path -- going into idle -- is the only way, taking
>>> the fast path (trying picking a task) isn't the right thing, isn't
>>> it?
>>
>> I'm not at all sure I even understand what you're trying to say. I
>> really don't understand what's the problem with going the long way with
>> picking the idle task, the machine is idle, it doesn't have anything
>> useful to do, who cares.
>>
> Well, yes the machine is idle. I got your point that you're
> emphasizing that CPU is idle even if we take long path it doesn't
> matter. But, when we've two ways, one is going through pick_next_task
> other is calling idle_class straight I think calling idle_class is
> better. Actually that's how I think (and certainly it differs from
> yours). Note that, in pick_next_task there is branch, which checks
> likely(nr_running==cfs->nr_running) - chances for hitting this branch
> will increase - cause in case of !nr_running, pick_next_task won't be
> called. It will reduce pick_next_task's calling overhead.
>
I made a mistake here, pick_next_task is inlined so function calling
overhead isn't a problem.


> Thanks,
> Rakib
>
