Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab2BJRFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:05:20 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:48796
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757729Ab2BJRFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:05:19 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ6SSN-01-1NN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] perf-tool: Don't process samples with no valid machine object
Date: Fri, 10 Feb 2012 18:05:04 +0100
Message-ID: <1328893505-4115-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328893505-4115-1-git-send-email-joerg.roedel@amd.com>
References: <1328893505-4115-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf sample processing code relies on a valid machine
object. Make sure that this path is only entered when such a
object exists.

A counter for samples where no machine object exits is also
introduced to give the user a message about these samples.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 tools/perf/builtin-top.c  |    6 ++++++
 tools/perf/util/hist.h    |    1 +
 tools/perf/util/session.c |   10 ++++++++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index dd162aa..48e0090 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -668,6 +668,12 @@ static void perf_event__process_sample(struct perf_tool *tool,
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
index f55f0a8d..8d5641f 100644
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
index b5ca2558..a8d25d9 100644
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
1.7.5.4


