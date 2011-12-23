Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab1LWV41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:56:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:50727 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab1LWVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:53:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Nelson Elhage <nelhage@nelhage.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/15] perf: builtin-record: Document and check that mmap_pages must be a power of two.
Date: Fri, 23 Dec 2011 19:53:10 -0200
Message-Id: <1324677198-5191-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324677198-5191-1-git-send-email-acme@infradead.org>
References: <1324677198-5191-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@nelhage.com>

Now that we automatically point users at it, let's provide them some
guidance so that they hopefully don't just get mysterious EINVAL's
from the kernel.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1324301972-22740-4-git-send-email-nelhage@nelhage.com
Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
[ committer note: Made it work after 50a682c ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt |    2 +-
 tools/perf/builtin-record.c              |    3 +++
 tools/perf/util/evlist.c                 |    2 ++
 tools/perf/util/util.h                   |   11 +++++++++++
 4 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 5a520f8..2937f7e 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -89,7 +89,7 @@ OPTIONS
 
 -m::
 --mmap-pages=::
-	Number of mmap data pages.
+	Number of mmap data pages. Must be a power of two.
 
 -g::
 --call-graph::
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 56bb447..e873ae2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -279,6 +279,9 @@ try_again:
 			    "/proc/sys/kernel/perf_event_mlock_kb,\n"
 			    "or try again with a smaller value of -m/--mmap_pages.\n"
 			    "(current value: %d)\n", opts->mmap_pages);
+		else if (!is_power_of_2(opts->mmap_pages))
+			die("--mmap_pages/-m value must be a power of two.");
+
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 	}
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 963d63d..fa18370 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -563,6 +563,8 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
         /* 512 kiB: default amount of unprivileged mlocked memory */
         if (pages == UINT_MAX)
                 pages = (512 * 1024) / page_size;
+	else if (!is_power_of_2(pages))
+		return -EINVAL;
 
 	mask = pages * page_size - 1;
 
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 0128906..37be34d 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -245,4 +245,15 @@ int readn(int fd, void *buf, size_t size);
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
+/*
+ *  Determine whether some value is a power of two, where zero is
+ * *not* considered a power of two.
+ */
+
+static inline __attribute__((const))
+bool is_power_of_2(unsigned long n)
+{
+	return (n != 0 && ((n & (n - 1)) == 0));
+}
+
 #endif
-- 
1.7.8.rc0.35.gee6df

