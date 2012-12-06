Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946067Ab2LFQvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:51:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424218Ab2LFQvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:51:48 -0500
Date: Thu, 6 Dec 2012 17:51:36 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/5] perf diff: Use internal rb tree for compute resort
Message-ID: <20121206165136.GA27199@krava.brq.redhat.com>
References: <1354806581-5316-1-git-send-email-namhyung@kernel.org>
 <1354806581-5316-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354806581-5316-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 12:09:40AM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> There's no reason to run hists_compute_resort() using output tree.
> Convert it to use internal tree so that it can remove unnecessary
> _output_resort.

I have another patch in queue ommiting dummy entries to display
number in the compute column, so we don't have confusing 'sorted'
outputs like:

[jolsa@krava perf]$ ./perf diff -c+delta
# Event 'cycles:u'
#
# Baseline    Delta  Shared Object                      Symbol
# ........  .......  .............  ..........................
#
    17.92%  -17.92%  libc-2.15.so   [.] _IO_link_in           
            +77.54%  libc-2.15.so   [.] __fprintf_chk         
    15.64%  -15.64%  libc-2.15.so   [.] _dl_addr              
     0.08%   +0.61%  ld-2.15.so     [.] _start                
    12.16%  -12.16%  ld-2.15.so     [.] dl_main               
    15.39%  -15.39%  ld-2.15.so     [.] _dl_check_map_versions
    38.81%  -17.04%  [kernel.kallsyms]  [k] page_fault            

just in case anyone actualy tries and wonders ;)


We need following change as well, because output resort does
also col width recalc. Please add it if you respin, or I can
send it later.

other than that:

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

---
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index f66968e..6f56f78 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -425,12 +425,15 @@ static void hists__compute_resort(struct hists *hists)
 	hists->entries = RB_ROOT;
 	next = rb_first(root);
 
+	hists__reset_col_len(hists);
+
 	while (next != NULL) {
 		struct hist_entry *he;
 
 		he = rb_entry(next, struct hist_entry, rb_node_in);
 		next = rb_next(&he->rb_node_in);
 
+		hists__calc_col_len(hists, he);
 		insert_hist_entry_by_compute(&hists->entries, he, compute);
 	}
 }
