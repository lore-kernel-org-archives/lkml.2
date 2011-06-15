Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1FOB7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:59:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49775 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab1FOB7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:59:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 15 Jun 2011 10:52:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: [BUGFIX][PATCH v2] memcg: avoid percpu cached charge draining at
 softlimit
Message-Id: <20110615105221.fa869a53.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110615104935.ccefc6b5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
	<20110613121648.3d28afcd.kamezawa.hiroyu@jp.fujitsu.com>
	<20110615104935.ccefc6b5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Michal Hokko's comment.

=
>From 5d1121e4e5425187a58025cb63be8e297a97f624 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 15 Jun 2011 10:44:29 +0900
Subject: [PATCH 6/6] memcg: avoid percpu cached charge draining at softlimit.

 We are not draining per cpu cached charges during soft limit reclaim
 because background reclaim doesn't care about charges. It tries to free
 some memory and charges will not give any.
 Cached charges might influence only selection of the biggest soft limit
 offender but as the call is done only after the selection has been
 already done it makes no change.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8fb29de..fa5c918 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1670,7 +1670,13 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
 			loop++;
-			if (loop >= 1)
+			/*
+			 * We are not draining per cpu cached charges during
+			 * soft limit reclaim  because global reclaim doesn't
+			 * care about charges. It tries to free some memory and
+			 * charges will not give any.
+			 */
+			if (!check_soft && loop >= 1)
 				drain_all_stock_async(root_mem);
 			if (loop >= 2) {
 				/*
-- 
1.7.4.1


