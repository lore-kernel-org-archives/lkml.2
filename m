Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2LJLyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:54:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59959 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2LJLyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:54:03 -0500
Date: Mon, 10 Dec 2012 12:53:57 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/49] Automatic NUMA Balancing v10
Message-ID: <20121210115357.GA8242@gmail.com>
References: <1354875832-9700-1-git-send-email-mgorman@suse.de>
 <20121207110113.GB21482@gmail.com>
 <20121209203630.GC1009@suse.de>
 <20121210113945.GA7550@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210113945.GA7550@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > reasons. As it turns out, a printk() bodge showed that 
> > nr_cpus_allowed == 80 set in sched_init_smp() while 
> > num_online_cpus() == 48. This effectively disabling 
> > numacore. If you had responded to the bug report, this would 
> > likely have been found last Wednesday.
> 
> Does changing it from num_online_cpus() to num_possible_cpus() 
> help? (Can send a patch if you want.)

I.e. something like the patch below.

Thanks,

	Ingo

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 503ec29..9d11a8a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2646,7 +2646,7 @@ static bool task_numa_candidate(struct task_struct *p)
 
 	/* Don't disturb hard-bound tasks: */
 	if (sched_feat(NUMA_EXCLUDE_AFFINE)) {
-		if (p->nr_cpus_allowed != num_online_cpus())
+		if (p->nr_cpus_allowed != num_possible_cpus())
 			return false;
 	}
 
