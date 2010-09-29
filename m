Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0I2M1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:27:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33477 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0I2M1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:27:46 -0400
From: "Kirill A. Shutsemov" <kirill@shutemov.name>
To: linux-mm@kvack.org
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [BUGFIX][PATCH] memcg: fix thresholds with use_hierarchy == 1
Date: Wed, 29 Sep 2010 15:27:25 +0300
Message-Id: <1285763245-19408-1-git-send-email-kirill@shutemov.name>
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
 mm/memcontrol.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3eed583..196f710 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3587,9 +3587,20 @@ unlock:
 
 static void mem_cgroup_threshold(struct mem_cgroup *memcg)
 {
-	__mem_cgroup_threshold(memcg, false);
-	if (do_swap_account)
-		__mem_cgroup_threshold(memcg, true);
+	struct cgroup *parent;
+
+	while (1) {
+		__mem_cgroup_threshold(memcg, false);
+		if (do_swap_account)
+			__mem_cgroup_threshold(memcg, true);
+
+		parent = memcg->css.cgroup->parent;
+		if (!parent)
+			break;
+		memcg = mem_cgroup_from_cont(parent);
+		if (!memcg->use_hierarchy)
+			break;
+	}
 }
 
 static int compare_thresholds(const void *a, const void *b)
-- 
1.7.2.3

