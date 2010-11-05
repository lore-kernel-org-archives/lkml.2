Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab0KERGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:06:31 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60964 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0KERGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:06:30 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Ma Ling <ling.ma@intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] perf bench: add --prefault option for causing page faults before benchmark
Date: Sat,  6 Nov 2010 02:06:25 +0900
Message-Id: <1288976785-15857-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds --prefault option to perf bench mem memcpy.
If user specify this option to perf bench mem memcpy, overhead of
page faults will be removed from the score of memcpy().

Example of usage:
| % ./perf bench mem memcpy -l 500MB
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes from 0x7fc036749010 to 0x7fc055b4a010 ...
|
|      628.526821 MB/Sec
| mitake@X201i:~/linux/.../tools/perf% ./perf bench mem memcpy -l 500MB --prefault
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes from 0x7ff1b45e2010 to 0x7ff1d39e3010 ...
|
|        4.849256 GB/Sec

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ma Ling <ling.ma@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 tools/perf/bench/mem-memcpy.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 38dae74..be31ddb 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -23,8 +23,9 @@
 
 static const char	*length_str	= "1MB";
 static const char	*routine	= "default";
-static bool		use_clock	= false;
+static bool		use_clock;
 static int		clock_fd;
+static bool		prefault;
 
 static const struct option options[] = {
 	OPT_STRING('l', "length", &length_str, "1MB",
@@ -34,6 +35,8 @@ static const struct option options[] = {
 		    "Specify routine to copy"),
 	OPT_BOOLEAN('c', "clock", &use_clock,
 		    "Use CPU clock for measuring"),
+	OPT_BOOLEAN('p', "prefault", &prefault,
+		    "Cause page faults before memcpy()"),
 	OPT_END()
 };
 
@@ -139,6 +142,10 @@ int bench_mem_memcpy(int argc, const char **argv,
 		       length_str, src, dst);
 	}
 
+
+	if (prefault)
+		routines[i].fn(dst, src, length);
+
 	if (use_clock) {
 		init_clock();
 		clock_start = get_clock();
-- 
1.7.1.1

