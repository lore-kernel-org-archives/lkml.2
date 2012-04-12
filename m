Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701Ab2DLMVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 08:21:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137Ab2DLMVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 08:21:21 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/3] perf, tool: Skip event correctly for unknown id/machine
Date: Thu, 12 Apr 2012 14:21:01 +0200
Message-Id: <1334233262-5679-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334233262-5679-1-git-send-email-jolsa@redhat.com>
References: <1334233262-5679-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the perf_session__process_event function fails, we
estimate the next event offset.

This is not necessary for sample event failing on unknown ID
or machine. In such case we know proper size of the event,
so we dont need to guess. Also failure statistics are updated
correctly so we don't miss any information.

Forcing perf_session__process_event to return 0 in case of
unknown ID or machine.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/session.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9412e3b..9189751 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -868,11 +868,11 @@ static int perf_session_deliver_event(struct perf_session *session,
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
-- 
1.7.1

