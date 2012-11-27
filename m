Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab2K0UM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:12:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab2K0UMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:12:24 -0500
Message-Id: <20121127193502.817704289@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 27 Nov 2012 14:35:05 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>,
        cgroups@vger.kernel.org
Subject: [PATCH 4/5] device_cgroup: make may_access() stronger
References: <20121127193501.255267751@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=strengthen-may_access.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to revalidate local exceptions for the hierarchy change propagation,
make may_access() stronger.

Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

Index: github/security/device_cgroup.c
===================================================================
--- github.orig/security/device_cgroup.c	2012-11-26 17:28:04.399150628 -0500
+++ github/security/device_cgroup.c	2012-11-27 11:57:55.932996663 -0500
@@ -352,13 +352,14 @@
  *		won't have more privileges than its parent or to
  *		verify if a certain access is allowed.
  * @dev_cgroup: dev cgroup to be tested against
+ * @behavior: behavior of the exception
  * @refex: new exception
  */
 static int may_access(struct dev_cgroup *dev_cgroup,
 		      struct dev_exception_item *refex)
 {
 	struct dev_exception_item *ex;
-	bool match = false;
+	int match = 0;
 
 	rcu_lockdep_assert(rcu_read_lock_held() ||
 			   lockdep_is_held(&devcgroup_mutex),
@@ -375,22 +376,33 @@
 			continue;
 		if (refex->access & (~ex->access))
 			continue;
-		match = true;
+		match = 1;
 		break;
 	}
 
 	/*
-	 * In two cases we'll consider this new exception valid:
-	 * - the dev cgroup has its default policy to allow + exception list:
-	 *   the new exception should *not* match any of the exceptions
-	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
-	 * - the dev cgroup has its default policy to deny + exception list:
-	 *   the new exception *should* match the exceptions
-	 *   (behavior == DEVCG_DEFAULT_DENY, match)
+	 * The only three possibilities are:
+	 * devcg->behavior == ALLOW, rule behavior == ALLOW
+	 * devcg->behavior == ALLOW, rule behavior == DENY
+	 * devcg->behavior == DENY, rule behavior == DENY
+	 * the remaining
+	 * devcg->behavior == DENY, rule behavior == ALLOW
+	 * won't be possible by hierarchy
+	 *
+	 * Since we want to simplify the code, here're the possibilites to
+	 * make easier to understand:
+	 *
+	 * devcg behavior   rule behavior  match  result
+	 * allow            allow          1      0
+	 * allow            allow          0      1
+	 * allow            deny           1      0
+	 * allow            deny           0      1
+	 * deny             deny           1      1
+	 * deny             deny           0      0
 	 */
-	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
-		return 1;
-	return 0;
+	if (dev_cgroup->behavior == DEVCG_DEFAULT_ALLOW)
+		return !match;
+	return match;
 }
 
 /*

