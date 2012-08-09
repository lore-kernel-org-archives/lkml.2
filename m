Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab2HITRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:17:05 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:51854 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759300Ab2HITRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:17:03 -0400
Message-Id: <20120809190415.021701086@muttley.lan.cathedral>
User-Agent: quilt/0.60-1
Date: Thu, 09 Aug 2012 15:04:15 -0400
From: aris@ruivo.org
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND 1/4] device_cgroup: add "deny_all" in dev_cgroup structure
References: <20120809190414.773462171@muttley.lan.cathedral>
Content-Disposition: inline; filename=deny_all.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

deny_all will determine if the default policy is to deny all device access
unless for the ones in the exception list.

This variable will be used in the next patches to convert device_cgroup
internally into a default policy + rules.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: github/security/device_cgroup.c
===================================================================
--- github.orig/security/device_cgroup.c	2012-07-24 17:15:58.277108951 -0400
+++ github/security/device_cgroup.c	2012-07-24 17:16:00.085156162 -0400
@@ -42,6 +42,7 @@
 struct dev_cgroup {
 	struct cgroup_subsys_state css;
 	struct list_head whitelist;
+	bool deny_all;
 };
 
 static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
@@ -178,12 +179,14 @@
 		wh->minor = wh->major = ~0;
 		wh->type = DEV_ALL;
 		wh->access = ACC_MASK;
+		dev_cgroup->deny_all = false;
 		list_add(&wh->list, &dev_cgroup->whitelist);
 	} else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
 		mutex_lock(&devcgroup_mutex);
 		ret = dev_whitelist_copy(&dev_cgroup->whitelist,
 				&parent_dev_cgroup->whitelist);
+		dev_cgroup->deny_all = parent_dev_cgroup->deny_all;
 		mutex_unlock(&devcgroup_mutex);
 		if (ret) {
 			kfree(dev_cgroup);
@@ -409,9 +412,11 @@
 	case DEVCG_ALLOW:
 		if (!parent_has_perm(devcgroup, &wh))
 			return -EPERM;
+		devcgroup->deny_all = false;
 		return dev_whitelist_add(devcgroup, &wh);
 	case DEVCG_DENY:
 		dev_whitelist_rm(devcgroup, &wh);
+		devcgroup->deny_all = true;
 		break;
 	default:
 		return -EINVAL;

