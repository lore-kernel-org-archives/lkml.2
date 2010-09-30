Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab0I3KQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 06:16:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51972 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab0I3KQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 06:16:48 -0400
From: "Kirill A. Shutsemov" <kirill@shutemov.name>
To: linux-mm@kvack.org
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [BUGFIX][PATCH v2] memcg: fix thresholds with use_hierarchy == 1
Date: Thu, 30 Sep 2010 13:16:32 +0300
Message-Id: <1285841792-23664-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill A. Shutemov <kirill@shutemov.name>

We need to check parent's thresholds if parent has use_hierarchy == 1 to
be sure that parent's threshold events will be triggered even if parent
itself is not active (no MEM_CGROUP_EVENTS).

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 mm/memcontrol.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3eed583..df40eaf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3587,9 +3587,13 @@ unlock:
 
 static void mem_cgroup_threshold(struct mem_cgroup *memcg)
 {
-	__mem_cgroup_threshold(memcg, false);
-	if (do_swap_account)
-		__mem_cgroup_threshold(memcg, true);
+	while (memcg) {
+		__mem_cgroup_threshold(memcg, false);
+		if (do_swap_account)
+			__mem_cgroup_threshold(memcg, true);
+
+		memcg =  parent_mem_cgroup(memcg);
+	}
 }
 
 static int compare_thresholds(const void *a, const void *b)
-- 
1.7.2.3

