Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab2FDOak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:30:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56322 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754968Ab2FDOaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:30:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX191E9ZLkBV15wJbNxpnWxWUxZcH4lfwS+2CM41jOr
	B3Z9JiaHgeNYJd
Message-ID: <1338820234.7356.250.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
From: Mike Galbraith <efault@gmx.de>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 04 Jun 2012 16:30:34 +0200
In-Reply-To: <20120604130740.GC25126@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
	 <1338801907.7356.163.camel@marge.simpson.net>
	 <1338810796.28282.32.camel@twins>
	 <1338814063.7356.192.camel@marge.simpson.net>
	 <20120604130740.GC25126@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 18:37 +0530, Srivatsa Vaddagiri wrote: 
> * Mike Galbraith <efault@gmx.de> [2012-06-04 14:47:43]:
> 
> > You need a good reason to run RT, and being able to starve others to
> > death ain't it, so I don't see a good reason to care about the 95% case
> > enough to fiddle with load balancing to accommodate the oddball case.
> 
> While starvation of SCHED_OTHER task was an extreme case, the point
> remains that SCHED_OTHER tasks are better served by moving them away
> from cpus running rt tasks that are partially cpu intensive. While the
> current code has the nuts and bolts to recognize this situation
> (scale_rt_power), it fails to effect SCHED_OTHER task movement because of how
> one cpu from a sched_group is designated to pull tasks on behalf of its
> siblings and that chosen balance_cpu may not be in the task's cpus_allowed mask
> (but the task can run on one or more of its sibling cpus).

Yeah, this is true, it is a latency source and a fairness violation.
Slow path balance consideration does make some sense to me.

But, if you have an RT requirement, you can't afford to mix unknown
entities, nor over-commit etc.  A realtime application will assign all
resources, so the load balancer becomes essentially unemployed.  No?
Non critical worker-bees may be allowed to bounce around in say a
cpuset, but none of the CPUs which do critical work will ever be
over-committed, else application just lost the war.  In that regard,
twiddling the load balancer to accommodate strange sounding case still
seems wrong to me.

-Mike

