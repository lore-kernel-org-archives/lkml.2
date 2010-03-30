Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0C3FxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 01:53:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:14206 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab0C3FxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 01:53:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,332,1267430400"; 
   d="scan'208";a="260119891"
Date: Tue, 30 Mar 2010 13:53:04 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: [PATCH]vmscan: handle underflow for get_scan_ratio
Message-ID: <20100330055304.GA2983@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 84b18490d1f1bc7ed5095c929f78bc002eb70f26 introduces a regression.
With it, our tmpfs test always oom. The test has a lot of rotated anon
pages and cause percent[0] zero. Actually the percent[0] is a very small
value, but our calculation round it to zero. The commit makes vmscan
completely skip anon pages and cause oops.
An option is if percent[x] is zero in get_scan_ratio(), forces it
to 1. See below patch.
But the offending commit still changes behavior. Without the commit, we scan
all pages if priority is zero, below patch doesn't fix this. Don't know if
It's required to fix this too.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 79c8098..d5cc34e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1604,6 +1604,18 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
 	/* Normalize to percentages */
 	percent[0] = 100 * ap / (ap + fp + 1);
 	percent[1] = 100 - percent[0];
+	/*
+	 * if percent[x] is small and rounded to 0, this case doesn't mean we
+	 * should skip scan. Give it at least 1% share.
+	 */
+	if (percent[0] == 0) {
+		percent[0] = 1;
+		percent[1] = 99;
+	}
+	if (percent[1] == 0) {
+		percent[0] = 99;
+		percent[1] = 1;
+	}
 }
 
 /*
