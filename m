Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2KLRIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:08:42 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:51933 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2KLRIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:08:39 -0500
Date: Mon, 12 Nov 2012 14:08:33 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/12] perf tools: Keep group information
Message-ID: <20121112170833.GE18978@ghostprotocols.net>
References: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
 <1352479414-2324-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352479414-2324-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Nov 10, 2012 at 01:43:23AM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Add a few of group-related field in struct perf_{evlist,evsel} so that
> the group information in a evlist can be known easily.  It only counts
> groups which have more than 1 members since leader-only groups are
> treated as non-group events.

We don't need to add a group_idx, we can get it using evsel->idx -
evsel->leader->idx, interdiff of this patch to what I think is
equivalent:

diff -u b/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
--- b/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -111,18 +111,16 @@
 void __perf_evlist__set_leader(struct list_head *list)
 {
 	struct perf_evsel *evsel, *leader;
-	int count = 0;
 
 	leader = list_entry(list->next, struct perf_evsel, node);
+	evsel = list_entry(list->prev, struct perf_evsel, node);
 	leader->leader = NULL;
+	leader->nr_members = evsel->idx - leader->idx + 1;
 
 	list_for_each_entry(evsel, list, node) {
-		if (evsel != leader) {
+		if (evsel != leader)
 			evsel->leader = leader;
-			evsel->group_idx = count++;
-		}
 	}
-	leader->nr_members = count;
 }
 
 void perf_evlist__set_leader(struct perf_evlist *evlist)
diff -u b/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
--- b/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -72,12 +72,9 @@
 	bool 			needs_swap;
 	/* parse modifier helper */
 	int			exclude_GH;
+	int			nr_members;
 	struct perf_evsel	*leader;
 	char			*group_name;
-	union {
-		int		nr_members;
-		int		group_idx;
-	};
 };
 
 struct cpu_map;
@@ -237,2 +234,11 @@
 }
+
+static inline int perf_evsel__group_idx(struct perf_evsel *evsel)
+{
+	if (perf_evsel__is_group_leader(evsel)
+		return 0;
+
+	return evsel->idx - evsel->leader->idx;
+}
+
 #endif /* __PERF_EVSEL_H */
