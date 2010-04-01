Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0DAMXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 08:23:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab0DAMXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 08:23:39 -0400
X-Authority-Analysis: v=1.1 cv=pKw63bS+wPQ6BxbjPFuXko/1Hb8f7lpGL8zfzHecwYY= c=1 sm=0 a=omkJG8e60WYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=X2x3t0y01wOpl9Y63JgA:9 a=f-01394kkQB35jjWydoA:7 a=uuMKMvaorRX5lP4NORG50EX0vbwA:4 a=PUjeQqilurYA:10 a=4yi0NgVIIXfUBa3X:21 a=8mGHoFi4abDBnLUq:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 7/7] ring-buffer: Add lost event count to end of sub
 buffer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100401061343.GA5207@nowhere>
References: <20100401031735.683626160@goodmis.org>
	 <20100401031820.590115556@goodmis.org>  <20100401061343.GA5207@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 01 Apr 2010 08:23:36 -0400
Message-ID: <1270124616.19685.8829.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 08:13 +0200, Frederic Weisbecker wrote:
> On Wed, Mar 31, 2010 at 11:17:42PM -0400, Steven Rostedt wrote:

> If you don't have enough room to put lost_events in the end of
> the buffer, you could keep as is cpu_buffer->last_overrun,
> so the next time you swap the reader page, the new delta
> will be added to the previous that you couldn't transmit.
> 
> That way you ensure the user always know when you lose events.

When is not the issue since we set the MISSING_EVENTS flag already. It's
how many were lost at that time that we do not store.

I actually found in most cases there is room, and trace-cmd can report
it. When there is no room, it just says events were dropped without
reporting the actual number.


This is what it shows when the number can be stored:

       trace-cmd-4980  [002] 32784.303699: lock_acquire:         0xffff88003ebf0e08 &(&sbi->s_rsv_window_lock)->rlock
       trace-cmd-4980  [002] 32784.303700: lock_release:         0xffff88003ebf0e08 &(&sbi->s_rsv_window_lock)->rlock
CPU:1 [415 EVENTS DROPPED]
       trace-cmd-4981  [001] 32784.303701: lock_release:         0xffff88000c49d7d0 &ei->truncate_mutex
       trace-cmd-4981  [001] 32784.303704: lock_acquire:         0xffffffff816591e0 read rcu_read_lock
       trace-cmd-4980  [002] 32784.303705: lock_acquire:         0xffff88003c0719d8 &(&bgl->locks[i].lock)->rlock

This is what it shows when the number can not:

          <idle>-0     [002] 32784.304459: lock_acquire:         0xffffffff816591e0 read rcu_read_lock
          <idle>-0     [002] 32784.304464: lock_release:         0xffffffff816591e0 rcu_read_lock
CPU:1 [EVENTS DROPPED]
              ls-4984  [001] 32784.304471: lock_acquire:         0xffff88003f8b8018 &(&base->lock)->rlock
              ls-4984  [001] 32784.304471: lock_release:         0xffff88003f8b8018 &(&base->lock)->rlock
              ls-4984  [001] 32784.304471: softirq_exit:         vec=1 [action=TIMER]


The problem with storing it later is that there is no guarantee that it
will be stored later. How far should the output look for that number. By
delaying when to print it, the output would need to search for that
number.

What happens if events were lost again before we found the number? Do we
add them together? Then we wont know how many events were lost between
the two spots where the events were lost. That is, if 448 events were
lost but we could not store the number, and then 318 events were lost,
and now we can store the number, do we add them together and report 766
events lost?

The end of the report still gives the total number lost, as it has
always done. Now I'm trying to report where they are lost.

Also note, in practice, the majority of the time we can record the
number:

  $ trace-cmd report | grep EVENTS
CPU:1 [82 EVENTS DROPPED]
CPU:0 [79 EVENTS DROPPED]
CPU:2 [75 EVENTS DROPPED]
CPU:1 [86 EVENTS DROPPED]
CPU:0 [87 EVENTS DROPPED]
CPU:2 [EVENTS DROPPED]
CPU:0 [87 EVENTS DROPPED]
CPU:0 [79 EVENTS DROPPED]
CPU:1 [177 EVENTS DROPPED]
CPU:0 [78 EVENTS DROPPED]
CPU:0 [73 EVENTS DROPPED]
CPU:1 [163 EVENTS DROPPED]
CPU:2 [86 EVENTS DROPPED]
CPU:0 [75 EVENTS DROPPED]
CPU:2 [89 EVENTS DROPPED]
CPU:0 [EVENTS DROPPED]
CPU:0 [75 EVENTS DROPPED]
CPU:1 [EVENTS DROPPED]
CPU:2 [EVENTS DROPPED]
CPU:0 [77 EVENTS DROPPED]
CPU:0 [EVENTS DROPPED]
CPU:0 [78 EVENTS DROPPED]
CPU:1 [90 EVENTS DROPPED]
CPU:2 [86 EVENTS DROPPED]
CPU:1 [87 EVENTS DROPPED]
CPU:2 [84 EVENTS DROPPED]
CPU:2 [82 EVENTS DROPPED]
CPU:1 [90 EVENTS DROPPED]
CPU:1 [89 EVENTS DROPPED]
CPU:2 [EVENTS DROPPED]
CPU:0 [EVENTS DROPPED]
CPU:2 [164 EVENTS DROPPED]
CPU:1 [EVENTS DROPPED]
CPU:0 [79 EVENTS DROPPED]
CPU:0 [89 EVENTS DROPPED]


If we really want this number every time, then we need to add it to the
sub buffer header, and not hope there was room to store it.

-- Steve


