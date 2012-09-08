Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2IHOhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 10:37:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45109 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2IHOhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 10:37:41 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 05/12] perf diff: Refactor stdio ui data columns output
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
	<1346946426-13496-6-git-send-email-jolsa@redhat.com>
	<878vcmczjt.fsf@sejong.aot.lge.com>
	<20120908123514.GA3408@krava.brq.redhat.com>
	<20120908125059.GG20401@ghostprotocols.net>
Date: Sat, 08 Sep 2012 23:37:31 +0900
In-Reply-To: <20120908125059.GG20401@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Sat, 8 Sep 2012 05:50:59 -0700")
Message-ID: <871uica8d0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sat, 8 Sep 2012 05:50:59 -0700, Arnaldo Carvalho de Melo wrote:
> Em Sat, Sep 08, 2012 at 02:35:14PM +0200, Jiri Olsa escreveu:
>> On Fri, Sep 07, 2012 at 11:55:02AM +0900, Namhyung Kim wrote:
>> > Hi, Jiri
>> > 
>> > On Thu,  6 Sep 2012 17:46:59 +0200, Jiri Olsa wrote:
>> > > Currently for any of the data columns (like Overhead/Period..) in
>> > > stdio ui, there's separate code to print header/dots/value scattered
>> > > along the display code path.
>> > >
>> > > Adding hists_stdio_column struct to centralize all info needed
>> > > to print column header/dots/value.
>> > >
>> > > This change eases up addition for new columns, which is now mostly
>> > > matter only of adding new hists_stdio_column struct.
>> > 
>> > As you may know, I submitted a similar patchset few days ago for the
>> > same reason and it handles TUI/GTK cases as well.  I'm waiting for
>> > reviews.
>> 
>> ok, I'll rebase this to acme/tmp.perf/hpp
>
> well, you can, but that one is buggy and you will not be able to test
> 'perf diff' at all...

I posted the fix right before, and you will also need patch below for
fixing broken "baseline" output.


>From 8f2d9010979e244c6565f3a9134e7bfa61936e38 Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Sat, 8 Sep 2012 23:28:59 +0900
Subject: [PATCH] perf hist: Fix perf diff baseline output

When perf diff is running, the overhead field should print old hist
entry's period as a baseline.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 16dc486d02be..326f4e9e6911 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -21,6 +21,18 @@ static int hpp__width_overhead(struct perf_hpp *hpp __used)
 static int hpp__color_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = 100.0 * he->period / hpp->total_period;
+
+	if (hpp->ptr) {
+		struct hists *old_hists = hpp->ptr;
+		u64 total_period = old_hists->stats.total_period;
+		u64 base_period = he->pair ? he->pair->period : 0;
+
+		if (total_period)
+			percent = 100.0 * base_period / total_period;
+		else
+			percent = 0.0;
+	}
+
 	return percent_color_snprintf(hpp->buf, hpp->size, "  %5.2f%%", percent);
 }
 
@@ -29,6 +41,17 @@ static int hpp__entry_overhead(struct perf_hpp *hpp, struct hist_entry *he)
 	double percent = 100.0 * he->period / hpp->total_period;
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : "  %5.2f%%";
 
+	if (hpp->ptr) {
+		struct hists *old_hists = hpp->ptr;
+		u64 total_period = old_hists->stats.total_period;
+		u64 base_period = he->pair ? he->pair->period : 0;
+
+		if (total_period)
+			percent = 100.0 * base_period / total_period;
+		else
+			percent = 0.0;
+	}
+
 	return scnprintf(hpp->buf, hpp->size, fmt, percent);
 }
 
-- 
1.7.9.2

