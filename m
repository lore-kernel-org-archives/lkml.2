Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab0IKS6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 14:58:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48770 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0IKS6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 14:58:06 -0400
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
In-Reply-To: <20100911174003.051303123@efficios.com>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 11 Sep 2010 20:57:50 +0200
Message-ID: <1284231470.2251.52.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-11 at 13:37 -0400, Mathieu Desnoyers wrote:

Its not at all clear what or why you're doing what exactly.

What we used to have is:

  period -- time in which each task gets scheduled once

This period was adaptive in that we had an ideal period
(sysctl_sched_latency), but since keeping to this means that each task
gets latency/nr_running time. This is undesired in that it means busy
systems will over-schedule due to tiny slices. Hence we also had a
minimum slice (sysctl_sched_min_granularity).

This yields:

  period := max(sched_latency, nr_running * sched_min_granularity)

[ where we introduce the intermediate: 
	nr_latency := sched_latency / sched_min_granularity
  in order to avoid the multiplication where possible ]

Now you introduce a separate preemption measure, sched_gran as:

		  sched_std_granularity; nr_running <= 8
  sched_gran := {
		  max(sched_min_granularity, sched_latency / nr_running)

Which doesn't make any sense at all, because it will either be larger or
as large as the current sched_min_granularity.

And you break the above definition of period by replacing nr_latency by
8.

Not at all charmed, this look like random changes without conceptual
integrity.
