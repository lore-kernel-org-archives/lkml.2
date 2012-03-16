Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab2CPRmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 13:42:16 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52832 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2CPRkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 13:40:00 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4 06/10] memcg: track resource index in cftype private
Date: Fri, 16 Mar 2012 23:09:26 +0530
Message-Id: <1331919570-2264-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12031617-4790-0000-0000-000001D401F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This helps in using same memcg callbacks for non reclaim resource
control files.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/memcontrol.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7a9ea94..d8b3513 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -358,9 +358,14 @@ enum charge_type {
 #define _MEM			(0)
 #define _MEMSWAP		(1)
 #define _OOM_TYPE		(2)
-#define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
-#define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
-#define MEMFILE_ATTR(val)	((val) & 0xffff)
+#define _MEMHUGETLB		(3)
+
+/*  0 ... val ...16.... x...24...idx...32*/
+#define __MEMFILE_PRIVATE(idx, x, val)	(((idx) << 24) | ((x) << 16) | (val))
+#define MEMFILE_PRIVATE(x, val)		__MEMFILE_PRIVATE(0, x, val)
+#define MEMFILE_TYPE(val)		(((val) >> 16) & 0xff)
+#define MEMFILE_IDX(val)		(((val) >> 24) & 0xff)
+#define MEMFILE_ATTR(val)		((val) & 0xffff)
 /* Used for OOM nofiier */
 #define OOM_CONTROL		(0)
 
@@ -3954,7 +3959,7 @@ static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	u64 val;
-	int type, name;
+	int type, name, idx;
 
 	type = MEMFILE_TYPE(cft->private);
 	name = MEMFILE_ATTR(cft->private);
@@ -3971,6 +3976,10 @@ static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 		else
 			val = res_counter_read_u64(&memcg->memsw, name);
 		break;
+	case _MEMHUGETLB:
+		idx = MEMFILE_IDX(cft->private);
+		val = res_counter_read_u64(&memcg->hugepage[idx], name);
+		break;
 	default:
 		BUG();
 		break;
@@ -4003,7 +4012,10 @@ static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 			break;
 		if (type == _MEM)
 			ret = mem_cgroup_resize_limit(memcg, val);
-		else
+		else if (type == _MEMHUGETLB) {
+			int idx = MEMFILE_IDX(cft->private);
+			ret = res_counter_set_limit(&memcg->hugepage[idx], val);
+		} else
 			ret = mem_cgroup_resize_memsw_limit(memcg, val);
 		break;
 	case RES_SOFT_LIMIT:
@@ -4067,7 +4079,10 @@ static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 	case RES_MAX_USAGE:
 		if (type == _MEM)
 			res_counter_reset_max(&memcg->res);
-		else
+		else if (type == _MEMHUGETLB) {
+			int idx = MEMFILE_IDX(event);
+			res_counter_reset_max(&memcg->hugepage[idx]);
+		} else
 			res_counter_reset_max(&memcg->memsw);
 		break;
 	case RES_FAILCNT:
-- 
1.7.9

