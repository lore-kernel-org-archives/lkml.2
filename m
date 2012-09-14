Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab2INFuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:50:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2INFuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:50:19 -0400
Date: Thu, 13 Sep 2012 22:49:43 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-n5ahw26e94klmde9cz6rxsdf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Remove die() calls
Git-Commit-ID: 32c7f7383a096a4fc878fdda686c7725945e8a8f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 22:49:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32c7f7383a096a4fc878fdda686c7725945e8a8f
Gitweb:     http://git.kernel.org/tip/32c7f7383a096a4fc878fdda686c7725945e8a8f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 8 Sep 2012 22:53:06 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Sep 2012 11:39:02 -0300

perf test: Remove die() calls

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
 1 files changed, 8 insertions(+), 6 deletions(-)

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
