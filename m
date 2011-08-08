Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1HHPxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:53:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40587 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab1HHPxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:53:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jovi Zhang <bookjovi@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf probe: Fix coredump introduced by probe module option
Date: Mon,  8 Aug 2011 12:52:53 -0300
Message-Id: <1312818776-19530-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1312818776-19530-1-git-send-email-acme@infradead.org>
References: <1312818776-19530-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

perf will coredump if the user doesn't give the "-m" option in probe
command, this patch fixes it.

[root@localhost perf]# ./perf probe --add='PROBE'
Segmentation fault (core dumped)

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1311602888-2389-1-git-send-email-bookjovi@gmail.com
Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b82d54f..1c7bfa5 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1820,11 +1820,15 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 		ret = -ENOMEM;
 		goto error;
 	}
-	tev->point.module = strdup(module);
-	if (tev->point.module == NULL) {
-		ret = -ENOMEM;
-		goto error;
+
+	if (module) {
+		tev->point.module = strdup(module);
+		if (tev->point.module == NULL) {
+			ret = -ENOMEM;
+			goto error;
+		}
 	}
+
 	tev->point.offset = pev->point.offset;
 	tev->point.retprobe = pev->point.retprobe;
 	tev->nargs = pev->nargs;
-- 
1.6.2.5

