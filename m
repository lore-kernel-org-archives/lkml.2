Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2KMQ0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:26:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37374 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2KMQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:26:32 -0500
Date: Tue, 13 Nov 2012 08:26:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup fixes for v3.7-rc5
Message-ID: <20121113162627.GB18227@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the following branch to receive fixes for v3.7-rc5.
It contains two fix patches for device_cgroup.  One fixes a regression
introduced earlier in 3.7 cycle where device_cgroup could try to
dereference the NULL parent of the root cgroup.  The other one is RCU
usage fix.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.7-fixes

Thanks.
---
Aristeu Rozanski (1):
      device_cgroup: fix unchecked cgroup parent usage

Tejun Heo (1):
      device_cgroup: fix RCU usage

 security/device_cgroup.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 842c254..b08d20c 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -164,8 +164,8 @@ static void dev_exception_clean(struct dev_cgroup *dev_cgroup)
 	struct dev_exception_item *ex, *tmp;
 
 	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
-		list_del(&ex->list);
-		kfree(ex);
+		list_del_rcu(&ex->list);
+		kfree_rcu(ex, rcu);
 	}
 }
 
@@ -298,7 +298,7 @@ static int may_access(struct dev_cgroup *dev_cgroup,
 	struct dev_exception_item *ex;
 	bool match = false;
 
-	list_for_each_entry(ex, &dev_cgroup->exceptions, list) {
+	list_for_each_entry_rcu(ex, &dev_cgroup->exceptions, list) {
 		if ((refex->type & DEV_BLOCK) && !(ex->type & DEV_BLOCK))
 			continue;
 		if ((refex->type & DEV_CHAR) && !(ex->type & DEV_CHAR))
@@ -352,6 +352,8 @@ static int parent_has_perm(struct dev_cgroup *childcg,
  */
 static inline int may_allow_all(struct dev_cgroup *parent)
 {
+	if (!parent)
+		return 1;
 	return parent->behavior == DEVCG_DEFAULT_ALLOW;
 }
 
@@ -376,11 +378,14 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 	int count, rc;
 	struct dev_exception_item ex;
 	struct cgroup *p = devcgroup->css.cgroup;
-	struct dev_cgroup *parent = cgroup_to_devcgroup(p->parent);
+	struct dev_cgroup *parent = NULL;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (p->parent)
+		parent = cgroup_to_devcgroup(p->parent);
+
 	memset(&ex, 0, sizeof(ex));
 	b = buffer;
 
@@ -391,11 +396,14 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 			if (!may_allow_all(parent))
 				return -EPERM;
 			dev_exception_clean(devcgroup);
+			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+			if (!parent)
+				break;
+
 			rc = dev_exceptions_copy(&devcgroup->exceptions,
 						 &parent->exceptions);
 			if (rc)
 				return rc;
-			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
 			break;
 		case DEVCG_DENY:
 			dev_exception_clean(devcgroup);

