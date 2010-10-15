Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab0JOP0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:26:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:39919 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab0JOP0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:26:20 -0400
Message-ID: <4CB8725B.9010200@kernel.org>
Date: Fri, 15 Oct 2010 17:25:15 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, Michal Hocko <mhocko@suse.cz>
Subject: [PATCH v2.6.36-rc7] memory_hotplug: drop spurious calls to flush_scheduled_work()
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 15:25:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lru_add_drain_all() uses schedule_on_each_cpu() which is synchronous.
There is no reason to call flush_scheduled_work() after
lru_add_drain_all().  Drop the spurious calls.

This is to prepare for the deprecation and removal of
flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/memory_hotplug.c |    2 --
 1 file changed, 2 deletions(-)

Index: work/mm/memory_hotplug.c
===================================================================
--- work.orig/mm/memory_hotplug.c
+++ work/mm/memory_hotplug.c
@@ -840,7 +840,6 @@ repeat:
 	ret = 0;
 	if (drain) {
 		lru_add_drain_all();
-		flush_scheduled_work();
 		cond_resched();
 		drain_all_pages();
 	}
@@ -862,7 +861,6 @@ repeat:
 	}
 	/* drain all zone's lru pagevec, this is asyncronous... */
 	lru_add_drain_all();
-	flush_scheduled_work();
 	yield();
 	/* drain pcp pages , this is synchrouns. */
 	drain_all_pages();
