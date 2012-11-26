Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2KZJw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:52:59 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41295 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2KZJw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:52:58 -0500
Message-ID: <50B33BEF.4050304@linux.vnet.ibm.com>
Date: Mon, 26 Nov 2012 17:52:47 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>
Subject: [RFC] could we remove some work to reduce the overhead of cgroup?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12112609-7014-0000-0000-00000241A390
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Folks

I'm trying to find the place where we could reduce the overhead
of cgroup, especially when there is only root_task_group
(thanks for Peter's suggestion).

I found that no place is using the load info of root_task_group
and root cfs_rq currently, could we do some thing like below
to reduce the overhead?



diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2cebc81..67cf709 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1515,6 +1515,13 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
        u64 now = cfs_rq_clock_task(cfs_rq) >> 20;
        u64 decays;
 
+       /*
+        * do not work on root cfs_rq and task group, since no one need their
+        * load info.
+        */
+       if (cfs_rq->tg && cfs_rq->tg == &root_task_group)
+               return;
+
        decays = now - cfs_rq->last_decay;
        if (!decays && !force_update)
                return;



There are other places we could save works if we stop calculate
the load info of root_task_group and root cfs_rq, like the update
work of blocked_load_avg, runnable_load_avg and tg_load_contrib.

Those info are used to calculate the load of cfs_rq, so we could
use that load when we calculate the parent cfs_rq's load sum, but
since root task group has no parent, those info should be useless.

Please let me know if you think this is wrong or you have better
idea on where we can reduce the overhead of cgroup.


Regards,
Michael Wang

