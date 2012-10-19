Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab2JSVQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:16:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188Ab2JSVQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:16:39 -0400
Message-Id: <20121019211626.583893413@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Fri, 19 Oct 2012 17:16:27 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, Jiri Slaby <jslaby@suse.cz>,
        cgroups@vger.kernel.org
Subject: [PATCH 1/3] device_cgroup: rename deny_all to behavior
References: <20121019211626.219447423@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=deny_all.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was done in a v2 patch but v1 ended up being committed. The variable name
is less confusing and stores the default behavior when no matching exception
exists.


Cc: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>

---
 security/device_cgroup.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- github.orig/security/device_cgroup.c	2012-10-19 16:35:37.936804289 -0400
+++ github/security/device_cgroup.c	2012-10-19 16:35:46.366102913 -0400
@@ -42,7 +42,10 @@ struct dev_exception_item {
 struct dev_cgroup {
 	struct cgroup_subsys_state css;
 	struct list_head exceptions;
-	bool deny_all;
+	enum {
+		DEVCG_DEFAULT_ALLOW,
+		DEVCG_DEFAULT_DENY,
+	} behavior;
 };
 
 static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
@@ -182,13 +185,13 @@ static struct cgroup_subsys_state *devcg
 	parent_cgroup = cgroup->parent;
 
 	if (parent_cgroup == NULL)
-		dev_cgroup->deny_all = false;
+		dev_cgroup->behavior = DEVCG_DEFAULT_ALLOW;
 	else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
 		mutex_lock(&devcgroup_mutex);
 		ret = dev_exceptions_copy(&dev_cgroup->exceptions,
 					  &parent_dev_cgroup->exceptions);
-		dev_cgroup->deny_all = parent_dev_cgroup->deny_all;
+		dev_cgroup->behavior = parent_dev_cgroup->behavior;
 		mutex_unlock(&devcgroup_mutex);
 		if (ret) {
 			kfree(dev_cgroup);
@@ -260,7 +263,7 @@ static int devcgroup_seq_read(struct cgr
 	 * - List the exceptions in case the default policy is to deny
 	 * This way, the file remains as a "whitelist of devices"
 	 */
-	if (devcgroup->deny_all == false) {
+	if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
 		set_access(acc, ACC_MASK);
 		set_majmin(maj, ~0);
 		set_majmin(min, ~0);
@@ -314,12 +317,12 @@ 		if (ex->minor != ~0 && ex->minor != re
 	 * In two cases we'll consider this new exception valid:
 	 * - the dev cgroup has its default policy to allow + exception list:
 	 *   the new exception should *not* match any of the exceptions
-	 *   (!deny_all, !match)
+	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
 	 * - the dev cgroup has its default policy to deny + exception list:
 	 *   the new exception *should* match the exceptions
-	 *   (deny_all, match)
+	 *   (behavior == DEVCG_DEFAULT_DENY, match)
 	 */
-	if (dev_cgroup->deny_all == match)
+	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
 		return 1;
 	return 0;
 }
@@ -375,11 +378,11 @@ 	memset(&ex, 0, sizeof(ex));
 			if (!parent_has_perm(devcgroup, &ex))
 				return -EPERM;
 			dev_exception_clean(devcgroup);
-			devcgroup->deny_all = false;
+			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
 			break;
 		case DEVCG_DENY:
 			dev_exception_clean(devcgroup);
-			devcgroup->deny_all = true;
+			devcgroup->behavior = DEVCG_DEFAULT_DENY;
 			break;
 		default:
 			return -EINVAL;
@@ -452,7 +455,7 @@ 		case '\0':
 		 * an matching exception instead. And be silent about it: we
 		 * don't want to break compatibility
 		 */
-		if (devcgroup->deny_all == false) {
+		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
 			dev_exception_rm(devcgroup, &ex);
 			return 0;
 		}
@@ -463,7 +466,7 @@ 			return 0;
 		 * an matching exception instead. And be silent about it: we
 		 * don't want to break compatibility
 		 */
-		if (devcgroup->deny_all == true) {
+		if (devcgroup->behavior == DEVCG_DEFAULT_DENY) {
 			dev_exception_rm(devcgroup, &ex);
 			return 0;
 		}

