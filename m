Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab0GPKMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 06:12:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38599 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936053Ab0GPKMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 06:12:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Subject: [PATCH 0/7] memcg reclaim tracepoint
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100716191006.7369.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 16 Jul 2010 19:12:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, Mel Gorman added some vmscan tracepoint. but they can't
trace memcg. So, This patch series does.


following three patches are nit fix and cleanups.

  memcg: sc.nr_to_reclaim should be initialized
  memcg: mem_cgroup_shrink_node_zone() doesn't need sc.nodemask
  memcg: nid and zid can be calculated from zone

following four patches are tracepoint conversion and adding memcg tracepoints.

  vmscan:        convert direct reclaim tracepoint to DEFINE_EVENT
  memcg, vmscan: add memcg reclaim tracepoint
  vmscan:        convert mm_vmscan_lru_isolate to DEFINE_EVENT
  memcg, vmscan: add mm_vmscan_memcg_isolate tracepoint


diffstat
================
 include/linux/memcontrol.h    |    6 ++--
 include/linux/mmzone.h        |    5 +++
 include/linux/swap.h          |    3 +-
 include/trace/events/vmscan.h |   79 +++++++++++++++++++++++++++++++++++++++--
 mm/memcontrol.c               |   15 +++++---
 mm/vmscan.c                   |   35 ++++++++++++------
 6 files changed, 118 insertions(+), 25 deletions(-)


Sameple output is here.
=========================

              dd-1851  [001]   158.837763: mm_vmscan_memcg_reclaim_begin: order=0 may_writepage=1 gfp_flags=GFP_HIGHUSER_MOVABLE
              dd-1851  [001]   158.837783: mm_vmscan_memcg_isolate: isolate_mode=0 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
              dd-1851  [001]   158.837860: mm_vmscan_memcg_reclaim_end: nr_reclaimed=32
  (...)
              dd-1970  [000]   266.608235: mm_vmscan_wakeup_kswapd: nid=0 zid=1 order=0
              dd-1970  [000]   266.608239: mm_vmscan_wakeup_kswapd: nid=1 zid=1 order=0
              dd-1970  [000]   266.608248: mm_vmscan_wakeup_kswapd: nid=2 zid=1 order=0
         kswapd1-348   [001]   266.608254: mm_vmscan_kswapd_wake: nid=1 order=0
              dd-1970  [000]   266.608254: mm_vmscan_wakeup_kswapd: nid=3 zid=1 order=0
         kswapd3-350   [000]   266.608266: mm_vmscan_kswapd_wake: nid=3 order=0
  (...)
         kswapd0-347   [001]   267.328891: mm_vmscan_memcg_softlimit_reclaim_begin: order=0 may_writepage=1 gfp_flags=GFP_HIGHUSER_MOVABLE
         kswapd0-347   [001]   267.328897: mm_vmscan_memcg_isolate: isolate_mode=0 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
         kswapd0-347   [001]   267.328915: mm_vmscan_memcg_isolate: isolate_mode=0 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
         kswapd0-347   [001]   267.328989: mm_vmscan_memcg_softlimit_reclaim_end: nr_reclaimed=32
         kswapd0-347   [001]   267.329019: mm_vmscan_lru_isolate: isolate_mode=1 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
         kswapd0-347   [001]   267.330562: mm_vmscan_lru_isolate: isolate_mode=1 order=0 nr_requested=32 nr_scanned=32 nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
  (...)
         kswapd2-349   [001]   267.407081: mm_vmscan_kswapd_sleep: nid=2
         kswapd3-350   [001]   267.408077: mm_vmscan_kswapd_sleep: nid=3
         kswapd1-348   [000]   267.427858: mm_vmscan_kswapd_sleep: nid=1
         kswapd0-347   [001]   267.430064: mm_vmscan_kswapd_sleep: nid=0





