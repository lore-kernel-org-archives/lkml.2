Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab0JORaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:30:18 -0400
Received: from canuck.infradead.org ([134.117.69.58]:40100 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab0JORaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:30:17 -0400
Subject: Re: [PATCH] perf_events: fix transaction recovery in
 group_sched_in()
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com
In-Reply-To: <4cb86b4c.41e9d80a.44e9.3e19@mx.google.com>
References: <4cb86b4c.41e9d80a.44e9.3e19@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 19:29:57 +0200
Message-ID: <1287163797.1998.107.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 16:54 +0200, Stephane Eranian wrote:
> The group_sched_in() function uses a transactional approach to schedule
> a group of events. In a group, either all events can be scheduled or
> none are. To schedule each event in, the function calls event_sched_in().
> In case of error, event_sched_out() is called on each event in the group.
> 
> The problem is that event_sched_out() does not completely cancel the
> effects of event_sched_in(). Furthermore event_sched_out() changes the
> state of the event as if it had run which is not true is this particular
> case.
> 
> Those inconsistencies impact time tracking fields and may lead to events
> in a group not all reporting the same time_enabled and time_running values.
> This is demonstrated with the example below:
> 
> $ task -eunhalted_core_cycles,baclears,baclears -e unhalted_core_cycles,baclears,baclears sleep 5
> 1946101 unhalted_core_cycles (32.85% scaling, ena=829181, run=556827)
>   11423 baclears (32.85% scaling, ena=829181, run=556827)
>    7671 baclears (0.00% scaling, ena=556827, run=556827)
> 
> 2250443 unhalted_core_cycles (57.83% scaling, ena=962822, run=405995)
>   11705 baclears (57.83% scaling, ena=962822, run=405995)
>   11705 baclears (57.83% scaling, ena=962822, run=405995)
> 
> Notice that in the first group, the last baclears event does not
> report the same timings as its siblings.
> 
> This issue comes from the fact that tstamp_stopped is updated
> by event_sched_out() as if the event had actually run.
> 
> To solve the issue, we must ensure that, in case of error, there is
> no change in the event state whatsoever. That means timings must
> remain as they were when entering group_sched_in().
> 
> To do this we defer updating tstamp_running until we know the
> transaction succeeded. Therefore, we have split event_sched_in()
> in two parts separating the update to tstamp_running.
> 
> Similarly, in case of error, we do not want to update tstamp_stopped.
> Therefore, we have split event_sched_out() in two parts separating
> the update to tstamp_stopped. 
> 
> With this patch, we now get the following output:
> 
> $ task -eunhalted_core_cycles,baclears,baclears -e unhalted_core_cycles,baclears,baclears sleep 5
> 2492050 unhalted_core_cycles (71.75% scaling, ena=1093330, run=308841)
>   11243 baclears (71.75% scaling, ena=1093330, run=308841)
>   11243 baclears (71.75% scaling, ena=1093330, run=308841)
> 
> 1852746 unhalted_core_cycles (0.00% scaling, ena=784489, run=784489)
>    9253 baclears (0.00% scaling, ena=784489, run=784489)
>    9253 baclears (0.00% scaling, ena=784489, run=784489)
> 
> Note that the uneven timing between groups is a side effect of
> the process spending most of its time sleeping, i.e., not enough
> event rotations (but that's a separate issue).
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Yes, makes sense.. I'm a bit hesitant to slap a -stable tag on it due to
its size,.. Ingo, Paulus?


