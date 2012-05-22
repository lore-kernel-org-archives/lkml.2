Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab2EVLBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 07:01:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42936 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140Ab2EVLBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 07:01:38 -0400
Message-ID: <1337684482.9698.14.camel@twins>
Subject: Re: [RFC][BUG] Revert "sched, perf: Use a single callback into the
 scheduler"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, eranian@google.com
Date: Tue, 22 May 2012 13:01:22 +0200
In-Reply-To: <20120521080626.GA3591@m.brq.redhat.com>
References: <20120521080626.GA3591@m.brq.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 10:06 +0200, Jiri Olsa wrote:
> hi,
> Arnaldo an I were hunting why test__PERF_RECORD stop work recently.
> It seems that following commit is the culprit:
> 
> sched, perf: Use a single callback into the scheduler
> commit cb04ff9ac424d0e689d9b612e9f73cb443ab4b7e
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Tue May 8 18:56:04 2012 +0200
> 
> the reason seems to be following:
> 
>   - before commit this change was introduced, the process switch worked
>     like this (wrt to perf event schedule):
> 
>     schedule (prev, next)
>       - schedule out all perf events for prev
>       - switch to next
>       - schedule in all perf events for current (next)
> 
>   - after the commit, the process switch looks like:
> 
>     schedule (prev, next)
>       - schedule out all perf events for prev
>       - schedule in all perf events for (next)
>       - switch to next
> 
> The problem is, that after we schedule perf events in, the pmu is
> enabled and we can receive events even before we make the switch
> to next - so "current" still being prev process (event SAMPLE data
> are filled based on the value of the "current" process).
> 
> Thats exactly what we see for test__PERF_RECORD test. We receive
> SAMPLES with PID of the process that our tracee is scheduled from.
> Most of the time it's parent, sometimes idle (0).
> 
> I tried to keep the current code and add a new hook from finish_task_switch
> to enable related PMUs for task.. but I'm getting following warning:
> 
> WARNING: at arch/x86/kernel/cpu/perf_event.c:1054 x86_pmu_start+0x133/0x140()
> 
> which I haven't figured out yet... also I'm not sure if thats even
> right thing to do ;)
> 
> thoughts? 

Bah!, yeah I guess reverting is the right thing for now. Sad though.

So by having the two hooks we have a black-spot between them where we
receive no events at all, this black-spot covers the hand-over of
current and we thus don't receive the 'wrong' events.

I rather liked we could do away with both that black-spot and clean up
the code a little, but apparently people rely on it.


