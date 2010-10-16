Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab0JPTrO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 15:47:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:51026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab0JPTrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 15:47:13 -0400
Subject: Re: [RFC tg_shares_up improvements - v1 00/12] [RFC tg_shares_up -
 v1 00/12] Reducing cost of tg->shares distribution
From: Peter Zijlstra <peterz@infradead.org>
To: pjt@google.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>
In-Reply-To: <20101016044349.830426011@google.com>
References: <20101016044349.830426011@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 16 Oct 2010 21:46:54 +0200
Message-ID: <1287258414.1998.133.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 21:43 -0700, pjt@google.com wrote:
> Hi all,
> 
> Peter previously posted a patchset that attempted to improve the problem of
> task_group share distribution.  This is something that has been a long-time
> pain point for group scheduling.  The existing algorithm considers
> distributions on a per-cpu-per-domain basis and carries a fairly high update
> overhead, especially on larger machines.
> 
> I was previously looking at improving this using Fenwick trees to allow a
> single sum without the exorbitant cost but then Peter's idea above was better :).
> 
> The kernel is that by monitoring the average contribution to load on a
> per-cpu-per-taskgroup basis we can distribute the weight for which we are
> expected to consume.
> 
> This set extends the original posting with a focus on increased fairness and
> reduced convergence (to true average) time.  In particular the case of large
> over-commit in the case of a distributed wake-up is a concern which is now
> fairly well addressed.
> 
> Obviously everything's experimental but it should be stable/fair.

I like what you've done with it, my only worry is 10/12 where you allow
for extra updates to the global state -- I think they should be fairly
limited in number, and I can see the need for the update if we get too
far out of whack, but it is something to look at while testing this
stuff.

> TODO:
> - Validate any RT interaction

I don't think there's anything to worry about there, the only
interaction which there is between this and the rt scheduling classes is
the initial sharing of the load-avg window, but you 'cure' that in 7/12.

(I think that sysctl wants a _us postfix someplace and we thus want some
NSEC_PER_USEC multiplication in there).

> - Continue collecting/analyzing performance and fairness data

Yes please ;-), I'll try and run this on some machines as well.

> - Should the shares period just be the sched_latency?

Interesting idea.. lets keep it a separate sysctl for now for easy
tuning, if things settle down and we're still good in that range we can
consider merging them.


