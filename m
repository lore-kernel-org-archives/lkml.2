Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0KILdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 06:33:53 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57815 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997Ab0KILdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 06:33:52 -0500
Date: Tue, 9 Nov 2010 11:33:37 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: page allocator: Adjust the per-cpu counter
	threshold when memory is low
Message-ID: <20101109113337.GI32723@csn.ul.ie>
References: <1288278816-32667-1-git-send-email-mel@csn.ul.ie> <1288278816-32667-2-git-send-email-mel@csn.ul.ie> <20101028150433.fe4f2d77.akpm@linux-foundation.org> <20101029101210.GG4896@csn.ul.ie> <20101029124002.356bd592.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101029124002.356bd592.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 12:40:02PM -0700, Andrew Morton wrote:
> > ...
> >
> > Follow-on patch?
> 
> Sometime, please.
> 

How does this look?

==== CUT HERE ====
mm: vmscan: Comment on why kswapd reduces the per-cpu vmstat threshold

While kswapd is awake, the per-cpu vmstat threshold is reduced to
reduce per-cpu drift to acceptable levels. Add a comment explaining
why.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7966110..ba39948 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2378,6 +2378,19 @@ static int kswapd(void *p)
 				 */
 				if (!sleeping_prematurely(pgdat, order, remaining)) {
 					trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
+
+					/*
+					 * vmstat counters are not perfectly
+					 * accurate and the estimated value
+					 * for counters such as NR_FREE_PAGES
+					 * can deviate from the true value by
+					 * nr_online_cpus * threshold. To
+					 * avoid the zone watermarks being
+					 * breached while under pressure, we
+					 * reduce the per-cpu vmstat threshold
+					 * while kswapd is awake and restore
+					 * them before going back to sleep.
+					 */
 					set_pgdat_percpu_threshold(pgdat,
 						calculate_normal_threshold);
 					schedule();
