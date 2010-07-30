Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044Ab0G3R4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:56:44 -0400
Received: from kroah.org ([198.145.64.141]:58554 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759974Ab0G3Rzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:46 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:41 2010
Message-Id: <20100730175141.715008212@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Shi <alex.shi@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [089/205] sched: Fix over-scheduling bug
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex,Shi <alex.shi@intel.com>

commit 3c93717cfa51316e4dbb471e7c0f9d243359d5f8 upstream.

Commit e70971591 ("sched: Optimize unused cgroup configuration") introduced
an imbalanced scheduling bug.

If we do not use CGROUP, function update_h_load won't update h_load. When the
system has a large number of tasks far more than logical CPU number, the
incorrect cfs_rq[cpu]->h_load value will cause load_balance() to pull too
many tasks to the local CPU from the busiest CPU. So the busiest CPU keeps
going in a round robin. That will hurt performance.

The issue was found originally by a scientific calculation workload that
developed by Yanmin. With that commit, the workload performance drops
about 40%.

 CPU  before    after

 00   : 2       : 7
 01   : 1       : 7
 02   : 11      : 6
 03   : 12      : 7
 04   : 6       : 6
 05   : 11      : 7
 06   : 10      : 6
 07   : 12      : 7
 08   : 11      : 6
 09   : 12      : 6
 10   : 1       : 6
 11   : 1       : 6
 12   : 6       : 6
 13   : 2       : 6
 14   : 2       : 6
 15   : 1       : 6

Reviewed-by: Yanmin zhang <yanmin.zhang@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1276754893.9452.5442.camel@debian>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1675,9 +1675,6 @@ static void update_shares(struct sched_d
 
 static void update_h_load(long cpu)
 {
-	if (root_task_group_empty())
-		return;
-
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 }
 


