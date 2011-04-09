Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab1DILO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 07:14:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50484 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab1DILO6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 07:14:58 -0400
Subject: Re: Subject: [PATCH] sched: fixed erroneous all_pinned logic.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ken Chen <kenchen@google.com>
Cc: Vladimir Davydov <VDavydov@parallels.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTi=ernzNawaR5tJZEsV_QVnfxqXmsQ@mail.gmail.com>
References: <20110408002420.3F3A912217F@elm.corp.google.com>
	 <870910A1-62AF-412F-A989-1FA57B715E35@parallels.com>
	 <1302263357.9086.138.camel@twins>
	 <BANLkTi=ernzNawaR5tJZEsV_QVnfxqXmsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 09 Apr 2011 13:14:43 +0200
Message-ID: <1302347683.9086.1247.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 12:20 -0700, Ken Chen wrote:
> sched: fixed erroneous all_pinned logic.
> 
> The scheduler load balancer has specific code to deal with cases of
> unbalanced system due to lots of unmovable tasks (for example because
> of hard CPU affinity). In those situation, it exclude the busiest CPU
> that has pinned tasks for load balance consideration such that it can
> perform second 2nd load balance pass on the rest of the system.  This
> all works as designed if there is only one cgroup in the system.
> 
> However, when we have multiple cgroups, this logic has false positive
> and triggers multiple load balance passes despite there are actually
> no pinned tasks at all.
> 
> The reason it has false positive is that the all pinned logic is deep
> in the lowest function of can_migrate_task() and is too low level.
> load_balance_fair() iterate each task group and calls balance_tasks()
> to migrate target load.  Along the way, balance_tasks() will also set
> a all_pinned variable.  Given that task-groups are iterated, this
> all_pinned variable is essentially the status of last group in the
> scanning process.  Task group can have number of reasons that no load
> being migrated, none due to cpu affinity.  However, this status bit
> is being propagated back up to the higher level load_balance(), which
> incorrectly think that no tasks were moved.  It kick off the all pinned
> logic and start multiple passes attempt to move load onto puller CPU.
> 
> Moved the all_pinned aggregation up at the iterator level. This ensures
> that the status is aggregated over all task-groups, not just last one
> in the list.
> 
> Signed-off-by: Ken Chen <kenchen@google.com> 

Thanks Ken!
