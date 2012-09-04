Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2IDOed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:34:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757018Ab2IDOea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:34:30 -0400
Message-Id: <20120904143420.234142640@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 04 Sep 2012 10:34:20 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 1/6] device_cgroup: add "behavior" in dev_cgroup structure
References: <20120904143419.892872876@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=deny_all.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

behavior will determine if the default policy is to deny all device access
unless for the ones in the exception list.

This variable will be used in the next patches to convert device_cgroup
internally into a default policy + rules.

v2:
- renamed deny_all to behavior

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: github/security/device_cgroup.c
===================================================================
--- github.orig/security/device_cgroup.c	2012-08-21 09:49:38.698415513 -0400
+++ github/security/device_cgroup.c	2012-08-21 10:50:34.650810797 -0400
@@ -42,6 +42,10 @@
 struct dev_cgroup {
 	struct cgroup_subsys_state css;
 	struct list_head whitelist;
+	enum {
+		DEVCG_DEFAULT_ALLOW,
+		DEVCG_DEFAULT_DENY,
+	} behavior;
 };
 
 static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
@@ -178,12 +182,14 @@
 		wh->minor = wh->major = ~0;
 		wh->type = DEV_ALL;
 		wh->access = ACC_MASK;
+		dev_cgroup->behavior = DEVCG_DEFAULT_ALLOW;
 		list_add(&wh->list, &dev_cgroup->whitelist);
 	} else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
 		mutex_lock(&devcgroup_mutex);
 		ret = dev_whitelist_copy(&dev_cgroup->whitelist,
 				&parent_dev_cgroup->whitelist);
+		dev_cgroup->behavior = parent_dev_cgroup->behavior;
 		mutex_unlock(&devcgroup_mutex);
 		if (ret) {
 			kfree(dev_cgroup);
@@ -409,9 +415,11 @@
 	case DEVCG_ALLOW:
 		if (!parent_has_perm(devcgroup, &wh))
 			return -EPERM;
+		devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
 		return dev_whitelist_add(devcgroup, &wh);
 	case DEVCG_DENY:
 		dev_whitelist_rm(devcgroup, &wh);
+		devcgroup->behavior = DEVCG_DEFAULT_DENY;
 		break;
 	default:
 		return -EINVAL;

