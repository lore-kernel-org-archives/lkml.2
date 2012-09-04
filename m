Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2IDOej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757018Ab2IDOeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:34:36 -0400
Message-Id: <20120904143420.546524755@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 04 Sep 2012 10:34:21 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 2/6] device_cgroup: introduce dev_whitelist_clean()
References: <20120904143419.892872876@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=introduce_whitelist_clean.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function cleans all the items in a whitelist and will be used by the next
patches.

v2:
- no changes

Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: James Morris <jmorris@namei.org>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

Index: github/security/device_cgroup.c
===================================================================
--- github.orig/security/device_cgroup.c	2012-08-21 10:50:34.650810797 -0400
+++ github/security/device_cgroup.c	2012-08-21 10:50:37.526892088 -0400
@@ -157,6 +157,22 @@
 	}
 }
 
+/**
+ * dev_whitelist_clean - frees all entries of the whitelist
+ * @dev_cgroup: dev_cgroup with the whitelist to be cleaned
+ *
+ * called under devcgroup_mutex
+ */
+static void dev_whitelist_clean(struct dev_cgroup *dev_cgroup)
+{
+	struct dev_whitelist_item *wh, *tmp;
+
+	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
+		list_del(&wh->list);
+		kfree(wh);
+	}
+}
+
 /*
  * called from kernel/cgroup.c with cgroup_lock() held.
  */
@@ -203,13 +219,9 @@
 static void devcgroup_destroy(struct cgroup *cgroup)
 {
 	struct dev_cgroup *dev_cgroup;
-	struct dev_whitelist_item *wh, *tmp;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
-	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
-		list_del(&wh->list);
-		kfree(wh);
-	}
+	dev_whitelist_clean(dev_cgroup);
 	kfree(dev_cgroup);
 }
 

