Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab1A2WUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 17:20:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:52218 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab1A2WUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 17:20:08 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/7] perf events: Account PERF_RECORD_LOST events in event__process
Date: Sat, 29 Jan 2011 20:19:14 -0200
Message-Id: <1296339559-20914-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1296339559-20914-1-git-send-email-acme@infradead.org>
References: <1296339559-20914-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Right now this function is only used by perf top, that uses PROT_READ
only, i.e. overwrite mode, so no PERF_RECORD_LOST events are generated,
but don't forget those events.

The patch that moved this out of perf top was made so that this routine
could be used by 'perf probe' in the uprobes patchset, so perhaps there
they need to check for LOST events and warn the user, as will be done in
the following patches that will switch 'perf top' to non overwrite mode
(mmap with PROT_READ|PROT_WRITE).

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index e4db8b8..b9d4ac8 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -646,6 +646,8 @@ int event__process(event_t *event, struct sample_data *sample,
 	case PERF_RECORD_EXIT:
 		event__process_task(event, sample, session);
 		break;
+	case PERF_RECORD_LOST:
+		event__process_lost(event, sample, session);
 	default:
 		break;
 	}
-- 
1.6.2.5

