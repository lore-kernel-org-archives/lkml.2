Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab1CMMfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 08:35:33 -0400
Received: from science.horizon.com ([71.41.210.146]:51067 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754534Ab1CMMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 08:35:31 -0400
Date: 13 Mar 2011 08:35:29 -0400
Message-ID: <20110313123529.30919.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: Functionality collision: round_jiffies & set_timer_slack
Cc: arjan@infradead.org, linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two separate implementations of the same idea in the kernel
timer code.  That is, to try to cluster scheduled timeouts to reduce
the number of processor wakeups.

The kernel timer has the concept of "slack"; the amount by which the timer
trigger time can be rounded up.  This can be configured, but defaults to 1/256
of the relative expiration time.

The kernel looks for the time in (expires, expires+slack) with the
largest number of trailing zero bits.  (kernel/timer.c:apply_slack()).


The work queue code (which is a customer of the timer code) has a variety of
round_jiffies functions, which try to round timeouts to the next or nearest
even second.  There is a 3*smp_processor_id() jiffy offset to avoid
lock contention in the work handling.

One versio is round_jiffies_relative, which has a problem with
incrementing jiffies.  The code rounds the relative timeout based on
the current jiffies, then later adds a potentially different jiffies
value when scheduling the timer.  Unfortunately, fixing this is a major
API change.


The big problem is that these two mechanisms try to do basically the
same thing.  This is at best unnecessary duplication, and at worst they
fight; the timer code's rounding tends to round away the work queue's
3-jiffy offset.

If it were up to me, I'd:
- Generalize the "slack = -1" special case to allow general negative
  slack numbers to mean slack = (expires - now) >> -slack.  (With slack
  defaulting to -8 for compatibility.)
- Add the processor ID dithering (maybe not the exact same algorithm;
  installing a bit-reversed processor ID in the "all-zero" low-order
  bits might work better) to the timer core code.
- Overhaul the schedule_delayed_work() API to take rounding parameters
  that are converted to timer slack parameters, rather than a separate
  round_jiffies_relative function.
- Have a look at all the other uses of round_jiffies to see how they can
  be eliminated.

But fixing the many scattered uses of round_jiffies in the kernel is a
bit intimidating for me.  I'm sending this e-mail in case it inspires
someone else to either do it or suggest a revised API and encourage me
to do the revision.

It's not deaperately urgent issue, but I was getting confused and unhappy
trying to read the code and figured it needed some light shined on it.
