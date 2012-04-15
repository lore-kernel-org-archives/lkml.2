Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2DOIgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 04:36:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35544 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab2DOIgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 04:36:45 -0400
Date: Sun, 15 Apr 2012 01:34:48 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-6782206b5dfece4c51f587b3ca1540a4027f87dd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1334233262-5679-3-git-send-email-jolsa@redhat.com>
References: <1334233262-5679-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session:
  Skip event correctly for unknown id/machine
Git-Commit-ID: 6782206b5dfece4c51f587b3ca1540a4027f87dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 15 Apr 2012 01:34:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6782206b5dfece4c51f587b3ca1540a4027f87dd
Gitweb:     http://git.kernel.org/tip/6782206b5dfece4c51f587b3ca1540a4027f87dd
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 12 Apr 2012 14:21:01 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 12 Apr 2012 12:14:50 -0300

perf session: Skip event correctly for unknown id/machine

In case the perf_session__process_event function fails, we estimate the
next event offset.

This is not necessary for sample event failing on unknown ID or machine.
In such case we know proper size of the event, so we dont need to guess.
Also failure statistics are updated correctly so we don't miss any
information.

Forcing perf_session__process_event to return 0 in case of unknown ID or
machine.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1334233262-5679-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 00923cd..1efd3be 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -876,11 +876,11 @@ static int perf_session_deliver_event(struct perf_session *session,
 		dump_sample(session, event, sample);
 		if (evsel == NULL) {
 			++session->hists.stats.nr_unknown_id;
-			return -1;
+			return 0;
 		}
 		if (machine == NULL) {
 			++session->hists.stats.nr_unprocessable_samples;
-			return -1;
+			return 0;
 		}
 		return tool->sample(tool, event, sample, evsel, machine);
 	case PERF_RECORD_MMAP:
