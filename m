Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833Ab2ESANb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:13:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42999 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab2ESAN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:13:29 -0400
MIME-Version: 1.0
In-Reply-To: <1337366237.573.106.camel@twins>
References: <1337229266-15798-1-git-send-email-ccross@android.com>
	<1337331395.573.3.camel@twins>
	<CAMbhsRQYeM8b167HVge11kVtniWKEukN+xGMvcMDf5+UOOc8_w@mail.gmail.com>
	<1337366237.573.106.camel@twins>
Date: Fri, 18 May 2012 17:13:28 -0700
X-Google-Sender-Auth: uOGWZs086CfxE4CxBPzMHBzjEzg
Message-ID: <CAMbhsRRnweLW_J+aBUsSbBh_Rp-PzVFap1FaRV1t9G0o9fZZAw@mail.gmail.com>
Subject: Re: [PATCH] sched/rt: fix SCHED_RR across cgroups
From: Colin Cross <ccross@android.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:37 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2012-05-18 at 10:52 -0700, Colin Cross wrote:
>
>> > OK, fair enough.. one does wonder though, WTH is android doing with
>> > SCHED_RR?
>>
>> Nothing, I was just experimenting with how it interacted with cgroups
>> and the numbers didn't make sense.
>
> OK. Thanks anyway!

Even with this patch, scheduling of SCHED_RR tasks in cgroups is a
little odd.  Each cgroup is treated as a schedulable entity alongside
the tasks in the same parent cgroup, and then the tasks inside the
child cgroup round robin through the child cgroup's time slices.  So
in the setup:
root_cgroup
   task 1
   cgroup
      task 2
      task 3

The RR will be:
task 1, cgroup(task 2), task 1, cgroup(task 3), ...

task 1 will run twice as often, for a full RR_TIMESLICE each time, as
tasks 2 and 3.

Is that the way SCHED_RR is intended to interact with cgroups?
