Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1KPJYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:24:22 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:46862 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754530Ab1KPJYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:24:21 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/i0yB3PsDih6S5nGgKRBcOV5viq0/7Xh7+4trOUD
	5x98cCTmtg4FU1
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 10:24:15 +0100
Message-ID: <1321435455.5072.64.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 17:14 -0800, Suresh Siddha wrote:

> How about this patch which is more self explanatory?

Actually, after further testing/reading, it looks to me like both of
these patches have a problem.  They'll never select SMT siblings (so a
skip SIBLING should accomplish the same).

This patch didn't select an idle core either though, where Peter's did.

Tested by pinning a hog to cores 1-3, then starting up an unpinned
tbench pair.  Peter's patch didn't do the BadThing (as in bad for
TCP_RR/tbench) in that case, but should have.

> +		sg = sd->groups;
> +		do {
> +			if (!cpumask_intersects(sched_group_cpus(sg),
> +						tsk_cpus_allowed(p)))
> +				goto next;
>  
> +			for_each_cpu(i, sched_group_cpus(sg)) {
> +				if (!idle_cpu(i))
> +					goto next;

Say target is CPU0.  Groups are 0,4 1,5 2,6 3,7.  0-3 are first CPUs
encountered in MC groups, all were busy.  At SIBLING level, the only
group is 0,4.  First encountered CPU of sole group is busy target, so
we're done.. so we return busy target.

> +			target = cpumask_first_and(sched_group_cpus(sg),
> +					tsk_cpus_allowed(p));

At SIBLING, group = 0,4 = 0x5, 0x5 & 0xff = 1 = target.

	-Mike

