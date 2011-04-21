Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab1DUQw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:52:59 -0400
Received: from smtpa1.mediabeam.com ([194.25.41.13]:64325 "EHLO
	smtpa1.mediabeam.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab1DUQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:52:58 -0400
X-Greylist: delayed 14266 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Apr 2011 12:52:58 EDT
Date: Thu, 21 Apr 2011 14:55:10 +0200
From: Thomas Giesel <skoe@directbox.com>
To: linux-kernel@vger.kernel.org
Subject: rt scheduler may calculate wrong rt_time
Message-ID: <20110421145510.28cb7b78@skoe.de>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Friends of the scheduler,

I found that the current (well, at least 2.6.38) scheduler calculates a
wrong rt_time for realtime tasks in certain situations.

Example scenario:
- HZ = 1000, rt_runtime = 95 ms, rt_period = 100 ms (similar with other
  setups, but that's what I did)
- a high priority rt task (A) gets packets from Ethernet about every 10
  ms
- a low priority rt task (B) unfortunately runs for a longer time
  (here: endlessly :)
- no other tasks running (i.e. about 5 ms idle left per period)

When the runtime of the realtime tasks is exceeded (e.g. by (B)), they
are throttled. During this time idle is scheduled. When in idle,
tick_nohz_stop_sched_tick() will stop the scheduler tick, which causes
update_rq_clock() _not_ to be called for a while. When a realtime task
is woken up during this time (e.g. (A) by network traffic),
update_rq_clock() is called from enqueue_task(). The task is not picked
yet, because it is still throttled. After a while
sched_rt_period_timer() unthrottles the realtime tasks and cpu_idle
will call schedule().

schedule() picks (A) which has been woken up a while ago.
_pick_next_task_rt() sets exec_start to rq->clock_task. But this has
been updated last time when the task was woken up, which could have
been up to 5 ms ago in my example. So exec_start contains a time
_before_ the task was actually started. As a result of this, rt_time is
calculated too large which makes the rt tasks being throttled even
earlier in the next period. This error may even increase from interval
to interval, because the throttle-window (initially 5 ms) also
increases.

IMHO the best place to update clock_task would be to call a function
from tick_nohz_restart_sched_tick(). But currently I don't see a
suitable interface to the scheduler to do this. Currently I call
update_rq_clock(rq) just before put_prev_task() in schedule(). This
solves the issue and causes rt_runtime to be kept quite accurately.
(Well, same result would be to remove "if (...)" in put_prev_task())

What do you think is the best way to solve this issue?

Thomas

