Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1AKOvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:51:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:55543 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab1AKOvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:51:42 -0500
Date: Tue, 11 Jan 2011 12:51:34 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-perf-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf timechart broken
Message-ID: <20110111145134.GA11968@ghostprotocols.net>
References: <201101071104.37576.trenn@suse.de> <20110111013625.GE2570@nowhere> <201101110955.37560.trenn@suse.de> <20110111114951.GA8564@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111114951.GA8564@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 11, 2011 at 09:49:51AM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Jan 11, 2011 at 09:55:36AM +0100, Thomas Renninger escreveu:
> > On Tuesday 11 January 2011 02:36:28 Frederic Weisbecker wrote:
> > > It's too late for .37, but it's fine, we just need to add
> > > a "Cc: stable@kernel.org" tag in the patch for it to be
> > > backported.
> > I'll submit it to stable@ (it wasn't taken because
> > the patch which included the fix wasn't mainline yet and I
> > forgot to submit it for 2.6.37-rcX). 
>  
> > I can take care of that, but it would be great if someone could look
> > at the issue that perf timechart shows: "no trace data in the file" in
> > x86/tip which seems introduced by one of Arnaldo's latest commits.
> > Reverting some of his latest patches, solved it for me.
> 
> Looking at it now.

Can you try with this patch applied? We need a better way of specifying
ordering of __exit and __init routines :-\

- Arnaldo

commit 7116fe5e13ff978676d96bcea79ec1b8f87b2f9d
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Tue Jan 11 12:42:00 2011 -0200

    perf evsel: Fix order of event list deletion
    
    We need to defer calling perf_evsel_list__delete() till after atexit
    registered routines, because we need to traverse the events being
    recorded at that time at least on 'perf record'.
    
    This fixes the problem reported by Thomas Renninger where cmd_record
    called by cmd_timechart would not write the tracing data to the perf.data
    file header because the evsel_list at atexit (control+C on 'perf timechart
    record') time would be empty, being already deleted by run_builtin(),
    and thus 'perf timechart' when trying to process such perf.data file would
    die with:
    
    "no trace data in the file"

    Problem introduced in 70d544d.
    
    Reported-by: Thomas Renninger <trenn@suse.de>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Stephane Eranian <eranian@google.com>
    Cc: Thomas Renninger <trenn@suse.de>
    Cc: Tom Zanussi <tzanussi@gmail.com>
    LKML-Reference: <new-submission>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7069bd3..aa7ece3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -480,6 +480,7 @@ static void atexit_header(void)
 			process_buildids();
 		perf_header__write(&session->header, output, true);
 		perf_session__delete(session);
+		perf_evsel_list__delete();
 		symbol__exit();
 	}
 }
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c385a63..0ff11d9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -743,6 +743,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 out_free_fd:
 	list_for_each_entry(pos, &evsel_list, node)
 		perf_evsel__free_stat_priv(pos);
+	perf_evsel_list__delete();
 out:
 	thread_map__delete(threads);
 	threads = NULL;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6ce4042..4b995ee 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1490,6 +1490,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 out_free_fd:
 	list_for_each_entry(pos, &evsel_list, node)
 		perf_evsel__free_mmap(pos);
+	perf_evsel_list__delete();
 
 	return status;
 }
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 5b1ecd6..595d0f4 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -286,8 +286,6 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	status = p->fn(argc, argv, prefix);
 	exit_browser(status);
 
-	perf_evsel_list__delete();
-
 	if (status)
 		return status & 0xff;
 


