Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2H0Ho5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:44:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:49807 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab2H0HoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:44:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,318,1344236400"; 
   d="scan'208";a="138220478"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 3/3] perf tools: Fix a misuse of for_each_set_bit() in session.c
Date: Mon, 27 Aug 2012 15:38:27 +0800
Message-Id: <1346053107-11946-4-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
References: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In regs_dump__printf() it use for_each_set_bit() for bit ops by
casting a (u64 *) to a (unsigned long *), this works for 64 bits
machine, but will fail on 32 bits ones.

Fix it by using the raw bit comparing method.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 tools/perf/util/session.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f7bb7ae..afcea6c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -904,11 +904,10 @@ static void regs_dump__printf(u64 mask, u64 *regs)
 {
 	unsigned rid, i = 0;
 
-	for_each_set_bit(rid, (unsigned long *) &mask, sizeof(mask) * 8) {
-		u64 val = regs[i++];
-
-		printf(".... %-5s 0x%" PRIx64 "\n",
-		       perf_reg_name(rid), val);
+	for (rid = 0; rid < 64; rid++) {
+		if (mask & (1 << rid))
+			printf(".... %-5s 0x%" PRIx64 "\n",
+				perf_reg_name(rid), regs[i++]);
 	}
 }
 
-- 
1.7.1

