Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2BQJr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:47:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38623 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2BQJr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:47:58 -0500
Date: Fri, 17 Feb 2012 01:47:05 -0800
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
Message-ID: <tip-0c095715b388d19d7a0b7e8eaceeceb018f5b3d1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jasowang@redhat.com, joerg.roedel@amd.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, joerg.roedel@amd.com,
        jasowang@redhat.com, a.p.zijlstra@chello.nl, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328893505-4115-2-git-send-email-joerg.roedel@amd.com>
References: <1328893505-4115-2-git-send-email-joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Don'
 t process samples with no valid machine object
Git-Commit-ID: 0c095715b388d19d7a0b7e8eaceeceb018f5b3d1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:47:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c095715b388d19d7a0b7e8eaceeceb018f5b3d1
Gitweb:     http://git.kernel.org/tip/0c095715b388d19d7a0b7e8eaceeceb018f5b3d1
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Fri, 10 Feb 2012 18:05:04 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 22:55:58 -0200

perf top: Don't process samples with no valid machine object

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
