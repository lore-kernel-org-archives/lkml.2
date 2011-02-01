Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab1BAASN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:18:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48691 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1BAASM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:18:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Feb 2011 09:12:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [PATCH] memcg: fix event counting breakage by recent THP update
Message-Id: <20110201091208.b2088800.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks to Johannes for catching this.
And sorry for my patch, I'd like to consinder some debug check..
=
Changes in commit e401f1761c0b01966e36e41e2c385d455a7b44ee
adds nr_pages to support multiple page size in memory_cgroup_charge_statistics.

But counting the number of event nees abs(nr_pages) for increasing
counters. This patch fixes event counting.

Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: mmotm-0125/mm/memcontrol.c
===================================================================
--- mmotm-0125.orig/mm/memcontrol.c
+++ mmotm-0125/mm/memcontrol.c
@@ -612,8 +612,10 @@ static void mem_cgroup_charge_statistics
 	/* pagein of a big page is an event. So, ignore page size */
 	if (nr_pages > 0)
 		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGIN_COUNT]);
-	else
+	else {
 		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_PGPGOUT_COUNT]);
+		nr_pages = -nr_pages; /* for event */
+	}
 
 	__this_cpu_add(mem->stat->count[MEM_CGROUP_EVENTS], nr_pages);
 

