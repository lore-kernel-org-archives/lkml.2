Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0LGLYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:24:33 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57743 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab0LGLYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:24:31 -0500
Date: Tue, 7 Dec 2010 11:24:14 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: vmscan: tracepoint: Account for scanned pages
	similarly for both ftrace and vmstat
Message-ID: <20101207112414.GB5422@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When correlating ftrace results with /proc/vmstat, I noticed that the
reporting scripts value for "pages scanned" differed significantly. Both
values were "right" depending on how you look at it.

The difference is due to vmstat only counting scanning of the inactive list
towards pages scanned. The analysis script for the tracepoint counts active
and inactive list yielding a far higher value than vmstat.  The resulting
scanning/reclaim ratio looks much worse.  The tracepoint is ok but this
patch updates the reporting script so that the report values for scanned
are similar to vmstat.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 .../trace/postprocess/trace-vmscan-postprocess.pl  |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl b/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
index b3e73dd..12cecc8 100644
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
+++ b/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -373,9 +373,18 @@ EVENT_PROCESS:
 				print "         $regex_lru_isolate/o\n";
 				next;
 			}
+			my $isolate_mode = $1;
 			my $nr_scanned = $4;
 			my $nr_contig_dirty = $7;
-			$perprocesspid{$process_pid}->{HIGH_NR_SCANNED} += $nr_scanned;
+
+			# To closer match vmstat scanning statistics, only count isolate_both
+			# and isolate_inactive as scanning. isolate_active is rotation
+			# isolate_inactive == 0
+			# isolate_active   == 1
+			# isolate_both     == 2
+			if ($isolate_mode != 1) {
+				$perprocesspid{$process_pid}->{HIGH_NR_SCANNED} += $nr_scanned;
+			}
 			$perprocesspid{$process_pid}->{HIGH_NR_CONTIG_DIRTY} += $nr_contig_dirty;
 		} elsif ($tracepoint eq "mm_vmscan_lru_shrink_inactive") {
 			$details = $5;
