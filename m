Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1GULBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 07:01:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44561 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1GULBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 07:01:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 21 Jul 2011 19:54:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] memcg: prevent from reclaiming if there are per-cpu
 cached charges
Message-Id: <20110721195411.f4fa9f91.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <0ed59a22cc84037d6e42b258981c75e3a6063899.1311241300.git.mhocko@suse.cz>
References: <cover.1311241300.git.mhocko@suse.cz>
	<0ed59a22cc84037d6e42b258981c75e3a6063899.1311241300.git.mhocko@suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 10:28:10 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> If we fail to charge an allocation for a cgroup we usually have to fall
> back into direct reclaim (mem_cgroup_hierarchical_reclaim).
> The charging code, however, currently doesn't care about per-cpu charge
> caches which might have up to (nr_cpus - 1) * CHARGE_BATCH pre charged
> pages (the current cache is already drained, otherwise we wouldn't get
> to mem_cgroup_do_charge).
> That can be quite a lot on boxes with big amounts of CPUs so we can end
> up reclaiming even though there are charges that could be used. This
> will typically happen in a multi-threaded applications pined to many CPUs
> which allocates memory heavily.
> 

Do you have example and score, numbers on your test ?

> Currently we are draining caches during reclaim
> (mem_cgroup_hierarchical_reclaim) but this can be already late as we
> could have already reclaimed from other groups in the hierarchy.
> 
> The solution for this would be to synchronously drain charges early when
> we fail to charge and retry the charge once more.
> I think it still makes sense to keep async draining in the reclaim path
> as it is used from other code paths as well (e.g. limit resize). It will
> not do any work if we drained previously anyway.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

I don't like this solution, at all.

Assume 2 cpu SMP, (a special case), and 2 applications running under
a memcg.

 - one is running in SCHED_FIFO.
 - another is running into mem_cgroup_do_charge() and call drain_all_stock_sync().

Then, the application stops until SCHED_FIFO application release the cpu.

In general, I don't think waiting for schedule_work() against multiple cpus
is not quicker than short memory reclaim. Adding flush_work() here means
that a context switch is requred before calling direct reclaim. That's bad.
(At leaset, please check __GFP_NOWAIT.)


Please find another way, I think calling synchronous drain here is overkill.
There are not important file caches in the most case and reclaim is quick.
(And async draining runs.)

How about automatically adjusting CHARGE_BATCH and make it small when the
system is near to limit ? or flushing ->stock periodically ?


Thanks,
-Kame

