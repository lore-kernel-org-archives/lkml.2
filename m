Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab1HJQS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:18:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:48181 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1HJQS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:18:27 -0400
Subject: Re: [PATCH 3/5] writeback: dirty rate control
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 10 Aug 2011 18:17:55 +0200
In-Reply-To: <20110810110709.GA27604@localhost>
References: <20110806084447.388624428@intel.com>
	 <20110806094526.878435971@intel.com> <1312901852.1083.26.camel@twins>
	 <20110810110709.GA27604@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312993075.23660.40.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about something like the below, it still needs some more work, but
its more or less complete in that is now explains both controls in one
story. The actual update bit is still missing.

---

balance_dirty_pages() needs to throttle tasks dirtying pages such that
the total amount of dirty pages stays below the specified dirty limit in
order to avoid memory deadlocks. Furthermore we desire fairness in that
tasks get throttled proportionally to the amount of pages they dirty.

IOW we want to throttle tasks such that we match the dirty rate to the
writeout bandwidth, this yields a stable amount of dirty pages:

	ratelimit = writeout_bandwidth

The fairness requirements gives us:

	task_ratelimit = write_bandwidth / N

> : When started N dd, we would like to throttle each dd at
> : 
> :          balanced_rate == write_bw / N                                  (1)
> : 
> : We don't know N beforehand, but still can estimate balanced_rate
> : within 200ms.
> : 
> : Start by throttling each dd task at rate
> : 
> :         task_ratelimit = task_ratelimit_0                               (2)
> :                          (any non-zero initial value is OK)
> : 
> : After 200ms, we got
> : 
> :         dirty_rate = # of pages dirtied by all dd's / 200ms
> :         write_bw   = # of pages written to the disk / 200ms
> : 
> : For the aggressive dd dirtiers, the equality holds
> : 
> :         dirty_rate == N * task_rate
> :                    == N * task_ratelimit
> :                    == N * task_ratelimit_0                              (3)
> : Or
> :         task_ratelimit_0 = dirty_rate / N                               (4)
> :                           
> : So the balanced throttle bandwidth can be estimated by
> :                           
> :         balanced_rate = task_ratelimit_0 * (write_bw / dirty_rate)      (5)
> :                           
> : Because with (4) and (5) we can get the desired equality (1):
> :                           
> :         balanced_rate == (dirty_rate / N) * (write_bw / dirty_rate)
> :                       == write_bw / N

Then using the balance_rate we can compute task pause times like:

	task_pause = task->nr_dirtied / task_ratelimit

[ however all that still misses the primary feedback of:

   task_ratelimit_(i+1) = task_ratelimit_i * (write_bw / dirty_rate)

  there's still some confusion in the above due to task_ratelimit and
  balanced_rate.
]

However, while the above gives us means of matching the dirty rate to
the writeout bandwidth, it at best provides us with a stable dirty page
count (assuming a static system). In order to control the dirty page
count such that it is high enough to provide performance, but does not
exceed the specified limit we need another control.

> So if the dirty pages are ABOVE the setpoints, we throttle each task
> a bit more HEAVY than balanced_rate, so that the dirty pages are
> created less fast than they are cleaned, thus DROP to the setpoints
> (and the reverse). With that positional adjustment, the formula is
> transformed from
> 
>         task_ratelimit = balanced_rate
> 
> to
> 
>         task_ratelimit = balanced_rate * pos_ratio

> In terms of the negative feedback control theory, the
> bdi_position_ratio() function (control lines) can be expressed as
> 
> 1) f(setpoint) = 1.0
> 2) df/dt < 0
> 
> 3) optionally, abs(df/dt) should be large on large errors (= dirty -
>    setpoint) in order to cancel the errors fast, and be smaller when
>    dirty pages get closer to the setpoints in order to avoid overshooting.


