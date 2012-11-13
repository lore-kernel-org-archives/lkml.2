Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab2KMDEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:04:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65334 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab2KMDC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:02:27 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/17] cgroup: lock cgroup_mutex in cgroup_init_subsys()
Date: Mon, 12 Nov 2012 19:01:36 -0800
Message-Id: <1352775704-9023-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352775704-9023-1-git-send-email-tj@kernel.org>
References: <1352775704-9023-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make cgroup_init_subsys() grab cgroup_mutex while initializing a
subsystem so that all helpers and callbacks are called under the
context they expect.  This isn't strictly necessary as
cgroup_init_subsys() doesn't race with anybody but will allow adding
lockdep assertions.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6df17cb..76f1a01 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4317,6 +4317,8 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 
 	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
 
+	mutex_lock(&cgroup_mutex);
+
 	/* init base cftset */
 	cgroup_init_cftsets(ss);
 
@@ -4346,6 +4348,8 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss)
 	if (ss->post_create)
 		ss->post_create(dummytop);
 
+	mutex_unlock(&cgroup_mutex);
+
 	/* this function shouldn't be used with modular subsystems, since they
 	 * need to register a subsys_id, among other things */
 	BUG_ON(ss->module);
-- 
1.7.11.7

