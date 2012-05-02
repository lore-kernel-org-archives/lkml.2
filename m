Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab2EBT0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:26:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47296 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab2EBTZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:25:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/15] perf tools: Check more combinations of PID/TID, UID and CPU switches
Date: Wed,  2 May 2012 16:24:56 -0300
Message-Id: <1335986702-9408-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335986702-9408-1-git-send-email-acme@infradead.org>
References: <1335986702-9408-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There were some combinations of these switches that are not so
appropriate IMHO.

Since there are implicit priorities between them and they worked well
anyway, but it ends up opening useless duplicated events.

For example, 'perf stat -t <pid> -a' will open multiple events for the
thread instead of one.

Add explicit checks and warn user in perf_target__validate().

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335417327-11796-7-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/usage.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index 0a1a885..228f0a5 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -132,4 +132,18 @@ void perf_target__validate(struct perf_target *target)
 		sleep(1);
 		target->uid_str = NULL;
 	}
+
+	/* UID and CPU are mutually exclusive */
+	if (target->uid_str && target->cpu_list) {
+		ui__warning("UID switch overriding CPU\n");
+		sleep(1);
+		target->cpu_list = NULL;
+	}
+
+	/* PID/UID and SYSTEM are mutually exclusive */
+	if ((target->tid || target->uid_str) && target->system_wide) {
+		ui__warning("PID/TID/UID switch overriding CPU\n");
+		sleep(1);
+		target->system_wide = false;
+	}
 }
-- 
1.7.9.2.358.g22243

