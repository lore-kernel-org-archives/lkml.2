Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1BGNtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 08:49:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab1BGNtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 08:49:40 -0500
Subject: Re: [PATCH] sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <1296854731-25039-1-git-send-email-venki@google.com>
References: <1296852688-1665-1-git-send-email-venki@google.com>
	 <1296854731-25039-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 14:50:42 +0100
Message-ID: <1297086642.13327.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-04 at 13:25 -0800, Venkatesh Pallipadi wrote:
> Consider a system with { [ (A B) (C D) ] [ (E F) (G H) ] },
> () denoting SMT siblings, [] cores on same socket and {} system wide
> Further, A, C and D are idle, B is busy and one of EFGH has excess load.
> 
> With sd_idle logic, a check in rebalance_domains() converts tick
> based load balance requests from CPU A to busy load balance for core
> and above domains (lower rate of balance and higher load_idx).

the if (load_balance())
	idle = CPU_NOT_IDLE;
bit, right?

> With first_idle_cpu logic, when CPU C or D tries to balance across domains
> the logic finds CPU A as first idle CPU in the group and nominates CPU A to
> idle balance across sockets.

Right..

> But, sd_idle above would not allow CPU A to do cross socket idle balance
> as CPU A switches its higher level balancing to busy balance.

Because it fails the sd->flags & SD_SHARE_CPUPOWER test at the beginning
of load_balance() and hence sd_idle will remain 0, right?

I'm just not quite sure how we then end up returning !0 for
load_balance(), both branches returning -1 seem conditional on
SD_SHARE_CPUPOWER but the [ (A B) (C D) ], domain doesn't have that set.

> So, this can result is no cross socket balancing for extended periods.

Which is bad

> The fix here adds additional check to detect sd_idle logic in
> first_idle_cpu code path. We will now nominate (in order or preference):
> * First fully idle CPU
> * First semi-idle CPU
> * First CPU
> 
> Note that this solution works fine for 2 SMT siblings case and won't be
> perfect in picking proper semi-idle in case of more than 2 SMT threads.

All these SMT exceptions make my head hurt, can't we clean that up
instead of making them worse?

Why is SMT treaded differently from say a shared cache? In both cases we
want to spread the load as wide as possible to provide as much of the
resources to the few runnable tasks.

