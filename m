Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2ISWoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 18:44:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52508 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2ISWoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 18:44:05 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, lizefan@huawei.com
Cc: peterz@infradead.org, glommer@parallels.com, mhocko@suse.cz,
        kay.sievers@vrfy.org, mzxreary@0pointer.de, davej@redhat.com,
        ben@decadent.org.uk, pjt@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] cgroup: implement CFTYPE_NO_PREFIX
Date: Wed, 19 Sep 2012 15:43:43 -0700
Message-Id: <1348094625-4471-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1348094625-4471-1-git-send-email-tj@kernel.org>
References: <1348094625-4471-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cgroup files are created, cgroup core automatically prepends the
name of the subsystem as prefix.  This patch adds CFTYPE_NO_PREFIX
which disables the automatic prefix.

This will be used to deprecate cpuacct which will make cpu create and
serve the cpuacct files.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Glauber Costa <glommer@parallels.com>
---
 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 68e8df7..7d6a298 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -283,6 +283,7 @@ struct cgroup_map_cb {
 /* cftype->flags */
 #define CFTYPE_ONLY_ON_ROOT	(1U << 0)	/* only create on root cg */
 #define CFTYPE_NOT_ON_ROOT	(1U << 1)	/* don't create onp root cg */
+#define CFTYPE_NO_PREFIX	(1U << 2)	/* skip subsys prefix */
 
 #define MAX_CFTYPE_NAME		64
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b7d9606..08edb52 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2687,7 +2687,8 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cgroup_subsys *subsys,
 	if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgrp->parent)
 		return 0;
 
-	if (subsys && !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
+	if (subsys && !(cft->flags & CFTYPE_NO_PREFIX) &&
+	    !test_bit(ROOT_NOPREFIX, &cgrp->root->flags)) {
 		strcpy(name, subsys->name);
 		strcat(name, ".");
 	}
-- 
1.7.7.3

