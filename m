Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2ILGJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:09:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:63320 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab2ILGJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:09:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,408,1344236400"; 
   d="scan'208";a="220900965"
From: Andi Kleen <andi@firstfloor.org>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Stop perf stat -p when profiled process exits
Date: Tue, 11 Sep 2012 23:09:04 -0700
Message-Id: <1347430144-26758-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When counting a process with perf stat -p check if the process died
and exit collection if yes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-stat.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 861f0ae..1313bb5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -536,7 +536,14 @@ static int run_perf_stat(int argc __used, const char **argv)
 		if (WIFSIGNALED(status))
 			psignal(WTERMSIG(status), argv[0]);
 	} else {
-		while(!done) sleep(1);
+		char piddir[40];
+		snprintf(piddir, sizeof piddir, "/proc/%d", atoi(target.pid));
+
+		while(!done) {
+			sleep(1);
+			if (target.pid && access(piddir, X_OK) < 0 && errno == ENOENT)
+				break;
+		}
 	}
 
 	t1 = rdclock();
-- 
1.7.7.6

