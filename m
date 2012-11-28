Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab2K1Nx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:53:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab2K1Nxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:53:52 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 09/14] perf diff: Update perf diff documentation for multiple data comparison
Date: Wed, 28 Nov 2012 14:52:44 +0100
Message-Id: <1354110769-2998-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating perf diff documentation to include multiple perf data
files comparison.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-diff.txt | 73 +++++++++++++++++++++++++++++-----
 1 file changed, 64 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 194f37d..ab5b79e 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -3,17 +3,17 @@ perf-diff(1)
 
 NAME
 ----
-perf-diff - Read two perf.data files and display the differential profile
+perf-diff - Read perf.data files and display the differential profile
 
 SYNOPSIS
 --------
 [verse]
-'perf diff' [oldfile] [newfile]
+'perf diff' [baseline file] [data file1] [[data file2] ... ]
 
 DESCRIPTION
 -----------
-This command displays the performance difference amongst two perf.data files
-captured via perf record.
+This command displays the performance difference amongst two or more perf.data
+files captured via perf record.
 
 If no parameters are passed it will assume perf.data.old and perf.data.
 
@@ -91,6 +91,59 @@ OPTIONS
 --formula::
         Show formula for given computation.
 
+COMPARISON
+----------
+The comparison is governed by the baseline file. The baseline perf.data
+file is iterated for samples. All other perf.data files specified on
+the command line are searched for the baseline sample pair. If the pair
+is found, specified computation is made and result is displayed.
+
+All samples from non-baseline perf.data files, that do not match any
+baseline entry, are displayed with empty space within baseline column
+and possible computation results (delta) in their related column.
+
+Example files samples:
+- file A with samples f1, f2, f3, f4,    f6
+- file B with samples     f2,     f4, f5
+- file C with samples f1, f2,         f5
+
+Example output:
+  x - computation takes place for pair
+  b - baseline sample percentage
+
+- perf diff A B C
+
+  baseline/A compute/B compute/C  samples
+  ---------------------------------------
+  b                    x          f1
+  b          x         x          f2
+  b                               f3
+  b          x                    f4
+  b                               f6
+             x         x          f5
+
+- perf diff B A C
+
+  baseline/B compute/A compute/C  samples
+  ---------------------------------------
+  b          x         x          f2
+  b          x                    f4
+  b                    x          f5
+             x         x          f1
+             x                    f3
+             x                    f6
+
+- perf diff C B A
+
+  baseline/C compute/B compute/A  samples
+  ---------------------------------------
+  b                    x          f1
+  b          x         x          f2
+  b          x                    f5
+                       x          f3
+             x         x          f4
+                       x          f6
+
 COMPARISON METHODS
 ------------------
 delta
@@ -100,7 +153,7 @@ If specified the 'Delta' column is displayed with value 'd' computed as:
   d = A->period_percent - B->period_percent
 
 with:
-  - A/B being matching hist entry from first/second file specified
+  - A/B being matching hist entry from data/baseline file specified
     (or perf.data/perf.data.old) respectively.
 
   - period_percent being the % of the hist entry period value within
@@ -113,24 +166,26 @@ If specified the 'Ratio' column is displayed with value 'r' computed as:
   r = A->period / B->period
 
 with:
-  - A/B being matching hist entry from first/second file specified
+  - A/B being matching hist entry from data/baseline file specified
     (or perf.data/perf.data.old) respectively.
 
   - period being the hist entry period value
 
-wdiff
-~~~~~
+wdiff:WEIGHT-B,WEIGHT-A
+~~~~~~~~~~~~~~~~~~~~~~~
 If specified the 'Weighted diff' column is displayed with value 'd' computed as:
 
    d = B->period * WEIGHT-A - A->period * WEIGHT-B
 
-  - A/B being matching hist entry from first/second file specified
+  - A/B being matching hist entry from data/baseline file specified
     (or perf.data/perf.data.old) respectively.
 
   - period being the hist entry period value
 
   - WEIGHT-A/WEIGHT-B being user suplied weights in the the '-c' option
     behind ':' separator like '-c wdiff:1,2'.
+    - WIEGHT-A being the weight of the data file
+    - WIEGHT-B being the weight of the baseline data file
 
 SEE ALSO
 --------
-- 
1.7.11.7

