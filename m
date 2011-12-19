Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1LSNk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:40:28 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:24401 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab1LSNkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:40:21 -0500
From: Nelson Elhage <nelhage@nelhage.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Nelson Elhage <nelhage@nelhage.com>
Subject: [PATCH 3/3] perf: builtin-record: Document and check that mmap_pages must be a power of two.
Date: Mon, 19 Dec 2011 08:39:32 -0500
Message-Id: <1324301972-22740-4-git-send-email-nelhage@nelhage.com>
X-Mailer: git-send-email 1.7.4.41.g50b8f
In-Reply-To: <1324301972-22740-1-git-send-email-nelhage@nelhage.com>
References: <1324301972-22740-1-git-send-email-nelhage@nelhage.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4EEF3EA8.00D0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we automatically point users at it, let's provide them some
guidance so that they hopefully don't just get mysterious EINVAL's
from the kernel.

Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
---
 tools/perf/Documentation/perf-record.txt |    2 +-
 tools/perf/builtin-record.c              |    3 +++
 tools/perf/util/util.h                   |   11 +++++++++++
 3 files changed, 15 insertions(+), 1 deletions(-)

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
index 45b23c1..275c78d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -560,6 +560,9 @@ static int __cmd_record(int argc, const char **argv)
 	if (mmap_pages == UINT_MAX)
 		mmap_pages = (512 * 1024) / page_size;
 
+	if (!is_power_of_2(mmap_pages))
+		die("--mmap_pages/-m value must be a power of two.");
+
 	if (forks) {
 		child_pid = fork();
 		if (child_pid < 0) {
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
1.7.4.41.g50b8f

