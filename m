Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab2IKX5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:57:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:42269 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2IKXxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:53:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/18] perf test: Remove die() calls
Date: Tue, 11 Sep 2012 20:52:53 -0300
Message-Id: <1347407590-30960-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347407590-30960-1-git-send-email-acme@infradead.org>
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just use pr_err() + return -1 and let the other tests run as well and
then the perf's main() exit doing whatever it needs.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-n5ahw26e94klmde9cz6rxsdf@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index cf33e50..6ae102e 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1023,14 +1023,16 @@ static int __test__rdpmc(void)
 
 	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
 	if (fd < 0) {
-		die("Error: sys_perf_event_open() syscall returned "
-		    "with %d (%s)\n", fd, strerror(errno));
+		pr_debug("Error: sys_perf_event_open() syscall returned "
+			 "with %d (%s)\n", fd, strerror(errno));
+		return -1;
 	}
 
 	addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
 	if (addr == (void *)(-1)) {
-		die("Error: mmap() syscall returned "
-		    "with (%s)\n", strerror(errno));
+		pr_debug("Error: mmap() syscall returned with (%s)\n",
+			 strerror(errno));
+		goto out_close;
 	}
 
 	for (n = 0; n < 6; n++) {
@@ -1051,9 +1053,9 @@ static int __test__rdpmc(void)
 	}
 
 	munmap(addr, page_size);
-	close(fd);
-
 	pr_debug("   ");
+out_close:
+	close(fd);
 
 	if (!delta_sum)
 		return -1;
-- 
1.7.9.2.358.g22243

