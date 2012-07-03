Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab2GCB6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:58:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42723 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab2GCB6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:58:47 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-67-4ff251d40883
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH v2] perf target: Ignore return value of strerror_r() explicitly
Date: Tue,  3 Jul 2012 10:54:12 +0900
Message-Id: <1341280452-18919-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since glibc 2.16 added warn_unused_result (wur) attribute
to the function, we should check it or ignore it explicitly.

Also resets @buf not to access to garbages for an invalid
(negative) @errnum.

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/target.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 1064d5b148ad..c3a38918e8b6 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -110,8 +110,11 @@ int perf_target__strerror(struct perf_target *target, int errnum,
 	int idx;
 	const char *msg;
 
+	memset(buf, 0, buflen);
+
 	if (errnum >= 0) {
-		strerror_r(errnum, buf, buflen);
+		/* make glibc (>= 2.16) happy */
+		(void)strerror_r(errnum, buf, buflen);
 		return 0;
 	}
 
-- 
1.7.10.2

