Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab1LWVyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:54:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57958 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab1LWVxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:53:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Nelson Elhage <nelhage@nelhage.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/15] perf: builtin-record: Provide advice if mmap'ing fails with EPERM.
Date: Fri, 23 Dec 2011 19:53:09 -0200
Message-Id: <1324677198-5191-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324677198-5191-1-git-send-email-acme@infradead.org>
References: <1324677198-5191-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@nelhage.com>

This failure is most likely due to running up against the
kernel.perf_event_mlock_kb sysctl, so we can tell the user what to do to
fix the issue.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1324301972-22740-3-git-send-email-nelhage@nelhage.com
Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f8fd14f..56bb447 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -272,8 +272,15 @@ try_again:
 		exit(-1);
 	}
 
-	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0)
+	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
+		if (errno == EPERM)
+			die("Permission error mapping pages.\n"
+			    "Consider increasing "
+			    "/proc/sys/kernel/perf_event_mlock_kb,\n"
+			    "or try again with a smaller value of -m/--mmap_pages.\n"
+			    "(current value: %d)\n", opts->mmap_pages);
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
+	}
 
 	if (rec->file_new)
 		session->evlist = evlist;
-- 
1.7.8.rc0.35.gee6df

