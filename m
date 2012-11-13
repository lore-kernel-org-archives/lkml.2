Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab2KMDEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:04:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46691 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2KMDC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:02:29 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/17] cgroup: fix harmless bugs in cgroup_load_subsys() fail path and cgroup_unload_subsys()
Date: Mon, 12 Nov 2012 19:01:37 -0800
Message-Id: <1352775704-9023-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352775704-9023-1-git-send-email-tj@kernel.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* If idr init fails, cgroup_load_subsys() cleared dummytop->subsys[]
  before calilng ->destroy() making CSS inaccessible to the callback,
  and didn't unlink ss->sibling.  As no modular controller uses
  ->use_id, this doesn't cause any actual problems.

* cgroup_unload_subsys() was forgetting to free idr, call
  ->pre_destroy() and clear ->active.  As there currently is no
  modular controller which uses ->use_id, ->pre_destroy() or ->active,
  this doesn't cause any actual problems.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 76f1a01..c5368c0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4420,9 +4420,10 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	if (ss->use_id) {
 		int ret = cgroup_init_idr(ss, css);
 		if (ret) {
-			dummytop->subsys[ss->subsys_id] = NULL;
 			ss->destroy(dummytop);
+			dummytop->subsys[ss->subsys_id] = NULL;
 			subsys[ss->subsys_id] = NULL;
+			list_del_init(&ss->sibling);
 			mutex_unlock(&cgroup_mutex);
 			return ret;
 		}
@@ -4490,7 +4491,19 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	 */
 	BUG_ON(ss->root != &rootnode);
 
+	/* ->pre_destroy() should be called outside cgroup_mutex for now */
+	if (ss->pre_destroy)
+		ss->pre_destroy(dummytop);
+
 	mutex_lock(&cgroup_mutex);
+
+	ss->active = 0;
+
+	if (ss->use_id) {
+		idr_remove_all(&ss->idr);
+		idr_destroy(&ss->idr);
+	}
+
 	/* deassign the subsys_id */
 	subsys[ss->subsys_id] = NULL;
 
-- 
1.7.11.7

