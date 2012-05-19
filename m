Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab2ESUhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 16:37:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50150 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab2ESUhh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 16:37:37 -0400
MIME-Version: 1.0
In-Reply-To: <1337433062.7075.9.camel@Abyss>
References: <1337229266-15798-1-git-send-email-ccross@android.com>
	<1337331395.573.3.camel@twins>
	<CAMbhsRQYeM8b167HVge11kVtniWKEukN+xGMvcMDf5+UOOc8_w@mail.gmail.com>
	<1337366237.573.106.camel@twins>
	<CAMbhsRRnweLW_J+aBUsSbBh_Rp-PzVFap1FaRV1t9G0o9fZZAw@mail.gmail.com>
	<1337433062.7075.9.camel@Abyss>
Date: Sat, 19 May 2012 13:37:36 -0700
X-Google-Sender-Auth: HDXTisHM_ZEWM5MaMPW-op7K7V4
Message-ID: <CAMbhsRQYgOQA7NB-mdMDi8GxtTaZDQhED2J2X9YmyiYjAzXx4w@mail.gmail.com>
Subject: Re: [PATCH] sched/rt: fix SCHED_RR across cgroups
From: Colin Cross <ccross@android.com>
To: Dario Faggioli <raistlin@linux.it>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2012 at 6:11 AM, Dario Faggioli <raistlin@linux.it> wrote:
> On Fri, 2012-05-18 at 17:13 -0700, Colin Cross wrote:
>> Even with this patch, scheduling of SCHED_RR tasks in cgroups is a
>> little odd.  Each cgroup is treated as a schedulable entity alongside
>> the tasks in the same parent cgroup, and then the tasks inside the
>> child cgroup round robin through the child cgroup's time slices.  So
>> in the setup:
>> root_cgroup
>>    task 1
>>    cgroup
>>       task 2
>>       task 3
>>
>> The RR will be:
>> task 1, cgroup(task 2), task 1, cgroup(task 3), ...
>>
>> task 1 will run twice as often, for a full RR_TIMESLICE each time, as
>> tasks 2 and 3.
>>
> That looks right to me...
>
>> Is that the way SCHED_RR is intended to interact with cgroups?
>>
> I would say it is. That's what you get because of putting task1 and
> cgroup at the same level in the "hierarchy". I'm curious, what kind of
> behaviour were you expecting?

That behavior matches exactly with scheduling of normal tasks and
cgroups with default cpu.shares, but doesn't match too well with what
I can see of the posix SCHED_RR description, which suggests all the
SCHED_RR threads go into a single queue.  I was just curious if the
behavior my patch restored was correct, since it can't be adjusted by
tweaking any parameters like cpu.shares.

> Of course, the actual schedule also depends on the real-time priority of
> the various tasks (groups don't have a priority, they inherit it from
> their tasks, or at least it was like this when I used to work with
> it :-P), but I guess you're putting all the tasks in the same queue
> (i.e., same rt-prio), is it that the case?

Yes.
