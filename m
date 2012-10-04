Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab2JDRTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:19:55 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:55291 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2JDRTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:19:54 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com C90C38214B
Date: Thu, 4 Oct 2012 19:19:47 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC 1/3] sched: introduce distinct per-cpu load average
Message-ID: <20121004171947.GA2088@thinkpad>
References: <1349305512-3428-1-git-send-email-andrea@betterlinux.com>
 <1349305512-3428-2-git-send-email-andrea@betterlinux.com>
 <1349341186.4438.1.camel@twins>
 <20121004094349.GA2163@thinkpad>
 <1349352728.4438.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349352728.4438.23.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 02:12:08PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-10-04 at 11:43 +0200, Andrea Righi wrote:
> > 
> > Right, the update must be atomic to have a coherent nr_uninterruptible
> > value. And AFAICS the only way to account a coherent
> > nr_uninterruptible
> > value per-cpu is to go with atomic ops... mmh... I'll think more on
> > this. 
> 
> You could stick it in the cpu controller instead of cpuset, add a
> per-cpu nr_uninterruptible counter to struct task_group and update it
> from the enqueue/dequeue paths. Those already are per-cgroup (through
> cfs_rq, which has a tg pointer).
> 
> That would also give you better semantics since it would really be the
> load of the tasks of the cgroup, not whatever happened to run on a
> particular cpu regardless of groups. Then again, it might be 'fun' to
> get the hierarchical semantics right :-)
> 
> OTOH it would also make calculating the load-avg O(nr_cgroups) and since
> we do this from the tick and people are known to create a shitload (on
> the order of 1e3 and upwards) of those this might not actually be a very
> good idea.

That would be an interesting path to explore, even if my concern goes to
the large hosting companies that want to create like a cpu cgroup for
each user. In this case we may have big scalability issues.  Maintaining
all the required stats per-cpu seems a more scalable solution to me
(except probably for the large SMP systems case...).

I wonder if it is worth to define rq->nr_uninterruptible as a pointer to
percpu data rather than converting it to an atomic var... but this would
be even worst for the large SMP systems. Especially for those that are
not interested in the loadavg feature.

> 
> Also, your patch 2 relies on the load avg function to be additive yet
> your completely fail to mention this and state whether this is so or
> not.

Correct, I'll report a more detailed description in the next version.

> 
> Furthermore, please look at PER_CPU() and friends as alternatives to
> [NR_CPUS] arrays.

Will do.

Thanks again for your suggestions.

-Andrea
