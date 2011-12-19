Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1LSNk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:40:26 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:24400 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1LSNkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:40:21 -0500
From: Nelson Elhage <nelhage@nelhage.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Nelson Elhage <nelhage@nelhage.com>
Subject: [PATCH 2/3] perf: builtin-record: Provide advice if mmap'ing fails with EPERM.
Date: Mon, 19 Dec 2011 08:39:31 -0500
Message-Id: <1324301972-22740-3-git-send-email-nelhage@nelhage.com>
X-Mailer: git-send-email 1.7.4.41.g50b8f
In-Reply-To: <1324301972-22740-1-git-send-email-nelhage@nelhage.com>
References: <1324301972-22740-1-git-send-email-nelhage@nelhage.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4EEF3EA8.002D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This failure is most likely due to running up against the
kernel.perf_event_mlock_kb sysctl, so we can tell the user what to do
to fix the issue.

Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
---
 tools/perf/builtin-record.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6ab58cc..45b23c1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -358,8 +358,15 @@ try_again:
 		exit(-1);
 	}
 
-	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0)
+	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0) {
+		if (errno == EPERM)
+			die("Permission error mapping pages.\n"
+			    "Consider increasing "
+			    "/proc/sys/kernel/perf_event_mlock_kb,\n"
+			    "or try again with a smaller value of -m/--mmap_pages.\n"
+			    "(current value: %d)\n", mmap_pages);
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
+	}
 
 	if (file_new)
 		session->evlist = evlist;
-- 
1.7.4.41.g50b8f

