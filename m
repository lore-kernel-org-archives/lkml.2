Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab2BNByG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:54:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:45737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078Ab2BNBxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:53:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/16] perf top: Don't process samples with no valid machine object
Date: Mon, 13 Feb 2012 23:52:45 -0200
Message-Id: <1329184375-27911-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1329184375-27911-1-git-send-email-acme@infradead.org>
References: <1329184375-27911-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The perf sample processing code relies on a valid machine object. Make
sure that this path is only entered when such a object exists.

A counter for samples where no machine object exits is also introduced
to give the user a message about these samples.

Reported-by: David Ahern <dsahern@gmail.com>
Reported-by: Jason Wang <jasowang@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328893505-4115-2-git-send-email-joerg.roedel@amd.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c  |    6 ++++++
 tools/perf/util/hist.h    |    1 +
 tools/perf/util/session.c |   10 ++++++++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 94d55cb..5a88c0d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -677,6 +677,12 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		return;
 	}
 
+	if (!machine) {
+		pr_err("%u unprocessable samples recorded.",
+		       top->session->hists.stats.nr_unprocessable_samples++);
+		return;
+	}
+
 	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		top->exact_samples++;
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 0d48613..48e5acd 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -32,6 +32,7 @@ struct events_stats {
 	u32 nr_unknown_events;
 	u32 nr_invalid_chains;
 	u32 nr_unknown_id;
+	u32 nr_unprocessable_samples;
 };
 
 enum hist_column {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 552c1c5..9f833cf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -796,6 +796,10 @@ static int perf_session_deliver_event(struct perf_session *session,
 			++session->hists.stats.nr_unknown_id;
 			return -1;
 		}
+		if (machine == NULL) {
+			++session->hists.stats.nr_unprocessable_samples;
+			return -1;
+		}
 		return tool->sample(tool, event, sample, evsel, machine);
 	case PERF_RECORD_MMAP:
 		return tool->mmap(tool, event, sample, machine);
@@ -964,6 +968,12 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
  			    session->hists.stats.nr_invalid_chains,
  			    session->hists.stats.nr_events[PERF_RECORD_SAMPLE]);
  	}
+
+	if (session->hists.stats.nr_unprocessable_samples != 0) {
+		ui__warning("%u unprocessable samples recorded.\n"
+			    "Do you have a KVM guest running and not using 'perf kvm'?\n",
+			    session->hists.stats.nr_unprocessable_samples);
+	}
 }
 
 #define session_done()	(*(volatile int *)(&session_done))
-- 
1.7.9.123.g65da0

