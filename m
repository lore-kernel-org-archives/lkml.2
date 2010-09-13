Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0IMKpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:45:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:46439 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0IMKpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:45:46 -0400
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
In-Reply-To: <1284371756.2275.108.camel@laptop>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <20100912061452.GA3383@elte.hu>
	 <1284276098.9111.24.camel@marge.simson.net>
	 <20100912181626.GB32327@Krystal>
	 <1284351183.7321.36.camel@marge.simson.net>
	 <20100913064153.GB14728@elte.hu>
	 <1284361716.25120.19.camel@marge.simson.net>
	 <1284366936.2275.27.camel@laptop>
	 <1284369373.14710.11.camel@marge.simson.net>
	 <1284370660.2275.86.camel@laptop>
	 <1284371457.14888.9.camel@marge.simson.net>
	 <1284371756.2275.108.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 12:45:28 +0200
Message-ID: <1284374728.2275.159.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 11:55 +0200, Peter Zijlstra wrote:
> +/*
> + * Earliest Eligible Virtual Deadline First
> + *
> + * In order to provide latency guarantees for different request sizes
> + * EEVDF selects the best runnable task from two criteria:
> + *
> + *  1) the task must be eligible (must be owed service)
> + *
> + *  2) from those tasks that meet 1), we select the one
> + *     with the earliest virtual deadline.
> + *
> + * We can do this in O(log n) time due to an augmented RB-tree. The
> + * tree keeps the entries sorted on service, but also functions as a
> + * heap based on the deadline by keeping:
> + *
> + *  se->min_deadline = min(se->deadline, se->{left,right}->min_deadline)
> + *
> + * Which allows an EDF like search on (sub)trees.
> + */ 

I just realized, this doesn't do what we wanted.. the virtual deadline
stuff is handy when you've got tasks with different QoS, but we don't
have that, they're all the same due to our task model.

What we want is real deadlines, the patch provides the infrastructure,
let me frob something for that.
