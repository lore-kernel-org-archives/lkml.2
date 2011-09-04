Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab1IDBPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 21:15:52 -0400
Received: from shutemov.name ([188.40.19.243]:33846 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab1IDBPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 21:15:51 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] memcg: drain all stocks for the cgroup before read usage
Date: Sun,  4 Sep 2011 04:15:33 +0300
Message-Id: <1315098933-29464-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

Currently, mem_cgroup_usage() for non-root cgroup returns usage
including stocks.

Let's drain all socks before read resource counter value. It makes
memory{,.memcg}.usage_in_bytes and memory.stat consistent.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 mm/memcontrol.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ebd1e86..e091022 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3943,6 +3943,7 @@ static inline u64 mem_cgroup_usage(struct mem_cgroup *mem, bool swap)
 	u64 val;
 
 	if (!mem_cgroup_is_root(mem)) {
+		drain_all_stock_sync(mem);
 		if (!swap)
 			return res_counter_read_u64(&mem->res, RES_USAGE);
 		else
-- 
1.7.5.4

