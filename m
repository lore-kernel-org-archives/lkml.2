Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab2IMP66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:58:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:19881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758106Ab2IMP64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:58:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,417,1344236400"; 
   d="scan'208";a="192385276"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, dsahern@gmail.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Stop perf stat -p when profiled process exits v3
Date: Thu, 13 Sep 2012 08:58:51 -0700
Message-Id: <1347551931-7666-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When counting a process with perf stat -p check if the process died
and exit collection if yes.

v2: Add more checks, handle non -p again. Handle /proc not there.
v3: Handle multi pid case. Fix non /proc error path
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-stat.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 861f0ae..b5e7df2 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -536,7 +536,19 @@ static int run_perf_stat(int argc __used, const char **argv)
 		if (WIFSIGNALED(status))
 			psignal(WTERMSIG(status), argv[0]);
 	} else {
-		while(!done) sleep(1);
+		char piddir[40];
+		int check_proc = target.pid &&
+				 access("/proc", X_OK) == 0 &&
+				 !strchr(target.pid, ',');
+		if (check_proc)
+			snprintf(piddir, sizeof piddir, "/proc/%d", 
+				 atoi(target.pid));
+		while(!done) {
+			sleep(1);
+			if (check_proc && access(piddir, X_OK) < 0 && 
+			    errno == ENOENT)
+				break;
+		}
 	}
 
 	t1 = rdclock();
-- 
1.7.7.6

