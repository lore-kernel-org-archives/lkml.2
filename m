Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1L2UvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 15:51:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39574 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab1L2UvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 15:51:09 -0500
Date: Thu, 29 Dec 2011 12:50:47 -0800
From: tip-bot for Nelson Elhage <nelhage@nelhage.com>
Message-ID: <tip-41d0d933494ce10eb77758a1168b08e317c42e8e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        nelhage@nelhage.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        nelhage@nelhage.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1324301972-22740-4-git-send-email-nelhage@nelhage.com>
References: <1324301972-22740-4-git-send-email-nelhage@nelhage.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: builtin-record:
  Document and check that mmap_pages must be a power of two.
Git-Commit-ID: 41d0d933494ce10eb77758a1168b08e317c42e8e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Dec 2011 12:50:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41d0d933494ce10eb77758a1168b08e317c42e8e
Gitweb:     http://git.kernel.org/tip/41d0d933494ce10eb77758a1168b08e317c42e8e
Author:     Nelson Elhage <nelhage@nelhage.com>
AuthorDate: Mon, 19 Dec 2011 08:39:32 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 23 Dec 2011 16:53:58 -0200

perf: builtin-record: Document and check that mmap_pages must be a power of two.

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
