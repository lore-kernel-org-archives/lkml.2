Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025Ab1EBODe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:03:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:32379 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156Ab1EBODc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:03:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,303,1301900400"; 
   d="scan'208";a="428890522"
Date: Mon, 2 May 2011 22:02:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Dave Chinner <david@fromorbit.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH] getdelays: show average CPU/IO/SWAP/RECLAIM delays
Message-ID: <20110502140257.GA12780@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I find it very handy to show the average delays in milliseconds.

Example output (on 100 concurrent dd reading sparse files):

CPU             count     real total  virtual total    delay total  delay average
                  986     3223509952     3207643301    38863410579         39.415ms
IO              count    delay total  delay average
                    0              0              0ms
SWAP            count    delay total  delay average
                    0              0              0ms
RECLAIM         count    delay total  delay average
                 1059     5131834899              4ms
dd: read=0, write=0, cancelled_write=0

CC: Mel Gorman <mel@linux.vnet.ibm.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/accounting/getdelays.c |   33 +++++++++++++++----------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- linux-next.orig/Documentation/accounting/getdelays.c	2011-05-02 11:33:44.000000000 +0800
+++ linux-next/Documentation/accounting/getdelays.c	2011-05-02 21:36:45.000000000 +0800
@@ -191,30 +191,37 @@ static int get_family_id(int sd)
 	return id;
 }
 
+#define average_ms(t, c) (t / 1000000ULL / (c ? c : 1))
+
 static void print_delayacct(struct taskstats *t)
 {
-	printf("\n\nCPU   %15s%15s%15s%15s\n"
-	       "      %15llu%15llu%15llu%15llu\n"
-	       "IO    %15s%15s\n"
-	       "      %15llu%15llu\n"
-	       "SWAP  %15s%15s\n"
-	       "      %15llu%15llu\n"
-	       "RECLAIM  %12s%15s\n"
-	       "      %15llu%15llu\n",
-	       "count", "real total", "virtual total", "delay total",
+	printf("\n\nCPU   %15s%15s%15s%15s%15s\n"
+	       "      %15llu%15llu%15llu%15llu%15.3fms\n"
+	       "IO    %15s%15s%15s\n"
+	       "      %15llu%15llu%15llums\n"
+	       "SWAP  %15s%15s%15s\n"
+	       "      %15llu%15llu%15llums\n"
+	       "RECLAIM  %12s%15s%15s\n"
+	       "      %15llu%15llu%15llums\n",
+	       "count", "real total", "virtual total",
+	       "delay total", "delay average",
 	       (unsigned long long)t->cpu_count,
 	       (unsigned long long)t->cpu_run_real_total,
 	       (unsigned long long)t->cpu_run_virtual_total,
 	       (unsigned long long)t->cpu_delay_total,
-	       "count", "delay total",
+	       average_ms((double)t->cpu_delay_total, t->cpu_count),
+	       "count", "delay total", "delay average",
 	       (unsigned long long)t->blkio_count,
 	       (unsigned long long)t->blkio_delay_total,
-	       "count", "delay total",
+	       average_ms(t->blkio_delay_total, t->blkio_count),
+	       "count", "delay total", "delay average",
 	       (unsigned long long)t->swapin_count,
 	       (unsigned long long)t->swapin_delay_total,
-	       "count", "delay total",
+	       average_ms(t->swapin_delay_total, t->swapin_count),
+	       "count", "delay total", "delay average",
 	       (unsigned long long)t->freepages_count,
-	       (unsigned long long)t->freepages_delay_total);
+	       (unsigned long long)t->freepages_delay_total,
+	       average_ms(t->freepages_delay_total, t->freepages_count));
 }
 
 static void task_context_switch_counts(struct taskstats *t)
