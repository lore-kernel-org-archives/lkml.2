Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab0ILKld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 06:41:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49965 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab0ILKlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 06:41:32 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <20100911195708.GA9273@Krystal>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <20100911195708.GA9273@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 12 Sep 2010 12:41:12 +0200
Message-ID: <1284288072.2251.91.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 15:57 -0400, Mathieu Desnoyers wrote:
> The interesting part is in the range from 4 to 8 tasks. I diminish the scheduler
> granularity as the number of tasks increases rather than increasing latency.
> This leads to more scheduler preemptions than usual, but only in the 4-8 running
> tasks range. 

I really don't get it.. that's exactly what it does from the 1..3 range
too, if you want to extend that, simply set a lower min_gran, it will
update nr_latency and you get it from 1..(latency/min_gran) range.

And you didn't touch sched_proc_update_handler(), which recomputes
sched_nr_latency when you change sched_latency or sched_min_gran.

So the current stuff is:

  period := max(latency, min_gran * nr_running)

or, conversely:

  gran := max(min_gran, latency / nr_running)

Which seems to be exactly what you want, no? Its doing that!

Except that in the one place we used 'gran' directly we avoided the
division and used the minimal value: min_gran in all cases, which is a
trade-of favouring latency.


