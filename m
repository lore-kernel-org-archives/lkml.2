Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0JRJoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:44:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53573 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab0JRJoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:44:17 -0400
Date: Mon, 18 Oct 2010 10:44:04 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v2.6.36-rc7] memory_hotplug: drop spurious calls to
	flush_scheduled_work()
Message-ID: <20101018094403.GW30667@csn.ul.ie>
References: <4CB8725B.9010200@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4CB8725B.9010200@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 05:25:15PM +0200, Tejun Heo wrote:
> lru_add_drain_all() uses schedule_on_each_cpu() which is synchronous.
> There is no reason to call flush_scheduled_work() after
> lru_add_drain_all().  Drop the spurious calls.
> 

This looks correct.

Acked-by: Mel Gorman <mel@csn.ul.ie>

I suspect this call to flush_scheduled_work() existed because it is easy
to interpret the documentation of schedule_on_each_cpu to mean it is an
asynchronous call.  Maybe something like the following?

==== CUT HERE ====
workqueue: Clarify that schedule_on_each_cpu is synchronous

The documentation for schedule_on_each_cpu() states that it calls a function
on each online CPU from keventd. This can easily be interpreted as an
asyncronous call because the description does not mention that flush_work
is called. Clarify that it is synchronous.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 kernel/workqueue.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f77afd9..07cba1e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2592,13 +2592,15 @@ int schedule_delayed_work_on(int cpu,
 EXPORT_SYMBOL(schedule_delayed_work_on);
 
 /**
- * schedule_on_each_cpu - call a function on each online CPU from keventd
+ * schedule_on_each_cpu - Call a function on each online CPU via keventd and wait for completion
  * @func: the function to call
  *
+ * schedule_on_each_cpu executes a given callback function on each CPU via keventd
+ * and blocks until each callback has completed. schedule_on_each_cpu() is very
+ * slow.
+ *
  * Returns zero on success.
  * Returns -ve errno on failure.
- *
- * schedule_on_each_cpu() is very slow.
  */
 int schedule_on_each_cpu(work_func_t func)
 {
