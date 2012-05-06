Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2EFScT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 14:32:19 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59781 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754005Ab2EFScS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 14:32:18 -0400
Date: Sun, 6 May 2012 15:32:12 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf top: Fix a race in callchain handling
Message-ID: <20120506183212.GB2485@infradead.org>
References: <1336231388-12347-1-git-send-email-namhyung@gmail.com>
 <1336242167.2463.138.camel@laptop>
 <20120505235319.GB2150@infradead.org>
 <1336271107.1534.12.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336271107.1534.12.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, May 06, 2012 at 11:25:07AM +0900, Namhyung Kim escreveu:
> 2012-05-05 (토), 20:53 -0300, Arnaldo Carvalho de Melo:
> > I'm looking how to get that fixed with Peter concerns addressed.
> > 
> 
> I guess it's gonna be a non-trivial job. As far as I can see, the hists
> code can handle up to two concurrent threads regardless of the callchain
> cursor problem. And also guess that other areas of libperf also doesn't
> support the true concurrency, right?

Right, but making it even less concurrent is something we should avoid
8-)

How about this one instead? At least we would be able to, concurrently,
process multiple, unrelated hists:


diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 9f6d630..c5cde92 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -397,8 +397,8 @@ static bool hists__collapse_insert_entry(struct hists *hists,
 			iter->period += he->period;
 			iter->nr_events += he->nr_events;
 			if (symbol_conf.use_callchain) {
-				callchain_cursor_reset(&hists->callchain_cursor);
-				callchain_merge(&hists->callchain_cursor, iter->callchain,
+				callchain_cursor_reset(&hists->callchain_collapse_cursor);
+				callchain_merge(&hists->callchain_collapse_cursor, iter->callchain,
 						he->callchain);
 			}
 			hist_entry__free(he);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index cfc64e2..e04c80b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -69,6 +69,7 @@ struct hists {
 	u16			col_len[HISTC_NR_COLS];
 	/* Best would be to reuse the session callchain cursor */
 	struct callchain_cursor	callchain_cursor;
+	struct callchain_cursor	callchain_collapse_cursor;
 };
 
 struct hist_entry *__hists__add_entry(struct hists *self,
