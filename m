Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab0EDLX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 07:23:28 -0400
Received: from ozlabs.org ([203.10.76.45]:35558 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0EDLX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 07:23:27 -0400
Date: Tue, 4 May 2010 21:19:15 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Fix performance issue with perf report
Message-ID: <20100504111915.GB14636@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On a large machine we spend a lot of time in perf_header__find_attr when
running perf report. 

If we are parsing a file without PERF_SAMPLE_ID then for each sample we call
perf_header__find_attr and loop through all counter IDs, never finding a match.
As the machine gets larger there are more per cpu counters and we spend an
awful lot of time in there.

The patch below initialises each sample id to -1ULL and checks for this in
perf_header__find_attr. We may need to do something more intelligent eventually
(eg a hash lookup from counter id to attr) but this at least fixes the most
common usage of perf report.

Signed-off-by: Anton Blanchard <anton@samba.org>
--

Index: linux.trees.git/tools/perf/util/event.c
===================================================================
--- linux.trees.git.orig/tools/perf/util/event.c	2010-05-03 20:20:54.000000000 +1000
+++ linux.trees.git/tools/perf/util/event.c	2010-05-04 21:15:20.000000000 +1000
@@ -713,6 +713,7 @@ int event__parse_sample(event_t *event, 
 		array++;
 	}
 
+	data->id = -1ULL;
 	if (type & PERF_SAMPLE_ID) {
 		data->id = *array;
 		array++;
Index: linux.trees.git/tools/perf/util/header.c
===================================================================
--- linux.trees.git.orig/tools/perf/util/header.c	2010-05-03 20:20:54.000000000 +1000
+++ linux.trees.git/tools/perf/util/header.c	2010-05-04 21:15:20.000000000 +1000
@@ -923,6 +923,14 @@ perf_header__find_attr(u64 id, struct pe
 {
 	int i;
 
+	/*
+	 * We set id to -1 if the data file doesn't contain sample
+	 * ids. Check for this and avoid walking through the entire
+	 * list of ids which may be large.
+	 */
+	if (id == -1ULL)
+		return NULL;
+
 	for (i = 0; i < header->attrs; i++) {
 		struct perf_header_attr *attr = header->attr[i];
 		int j;
