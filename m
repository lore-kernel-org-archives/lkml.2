Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab2IBFqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 01:46:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42914 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2IBFqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 01:46:34 -0400
Date: Sat, 1 Sep 2012 22:43:35 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Colin Cross <ccross@android.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH/RFC 0/4] Deferrable timers support for timerfd API
Message-ID: <20120902054335.GA12741@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch set implements a userland-side API for generic deferrable
timers, per linux/timer.h:

 * A deferrable timer will work normally when the system is busy, but
 * will not cause a CPU to come out of idle just to service it; instead,
 * the timer will be serviced when the CPU eventually wakes up with a
 * subsequent non-deferrable timer.

These timers are crucial for power saving, i.e. periodic tasks that want
to work in background when the system is under use, but don't want to
cause wakeups themselves.

The deferred timers are somewhat orthogonal to high-res external timers,
since the deferred timer is tied to the system load, not just to some
external decrementer source.

So, currently, the implementation has a HZ precision, and the maximum
interval is jiffies resolution (i.e. with HZ=1000, on 32 bit that would
be around max 49 days).  Of course we can implement longer timeouts by
rearming the timer, although it probably  wouldn't make much sense in
real world, so we keep it simple and just return E2BIG if we don't like
the interval.

Note that the code is still using time calculation that is done by the
hrtimer routines, so we pretty much reuse everything except for the
timer events themselves (i.e. we use calculation results of
hrtimer_forward_now() and hrtimer_expires_remaining(), but never start
the hrtimer). So the code path is pretty much the same for both hrtimers
and deferrable timers.

We will use the timers to periodically read /proc/vmstat without
forcibly waking up the system; but let's see, maybe there are other use
cases that might be interesting for PM folks.

Thanks!

Anton.

--
 fs/timerfd.c            | 87 +++++++++++++++++++++++++++++++++++++++++++------
 include/linux/jiffies.h |  3 ++
 include/linux/ktime.h   |  3 +-
 include/linux/timerfd.h |  4 ++-
 kernel/time.c           | 23 +++++++++++++
 5 files changed, 108 insertions(+), 12 deletions(-)
