Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab0DOH3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:29:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58145 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348Ab0DOH3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:14 -0400
Subject: Re: [RFC][PATCH 09/11] sched: first draft of deadline inheritance.
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
In-Reply-To: <1267385165.13676.99.camel@Palantir>
References: <1267383976.13676.79.camel@Palantir>
	 <1267385165.13676.99.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 10:25:00 +0200
Message-ID: <1271233500.32749.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-28 at 20:26 +0100, Raistlin wrote:
> Therefore, as of now, this patch:
>  - implements priority inheritance for -deadline tasks, according to
>    what described above;
>  - to make this possible without rewriting outstanding chunks of
>    code of both -deadline scheduling and existing PI, the task's
>    relative deadline is stored in the prio field of the task_struct.
>    This is done in such a way that:
>     * prio is always < 0 for -deadline tasks,
>     * p1->prio < p2->prio still means p1 has higher priority than
>       p2, i.e., in our case, p1 has smaller relative deadline.
>  - the point above means that, since prio is of int type, a relative
>    deadline has to be smaller than INT_MAX. This is about 2sec,
>    which is a something (we think! :-)) we can afford, at least
>    for now.

Right, except that this makes the plist stuff O(INT_MAX) [ or rather
O(nr_dl_tasks) ].

But I guess it serves for testing.

I think it would be relatively straight forward to modify the existing
PI chain code to work using an RB-tree instead of the plist stuff.

An RB-tree would also make the whole ->prio mess much easier to solve,
we could simply make a more complex comparison function, like:

int rt_mutex_prio_less(struct task_struct *left, struct task_struct *right)
{
	if (left->prio < right->prio)
		return 1;

	if (left->prio == right->prio && left->prio == -1) {
		if (left->deadline < right->deadline)
			return 1;
	}

	return 0;
}

Which uses the static prio -1 to represent all deadline tasks.

>  - disables bandwidth throttling for tasks while they are deadline
>    boosted. It also tries to make them pay back for runtime overrun
>    and deadline misses in this phase, but it's only "local", in the
>    sense that instances farther than the one right next to the
>    overrun are not going to be direcly affected.
> 
Yeah, good enough to start with ;-)

