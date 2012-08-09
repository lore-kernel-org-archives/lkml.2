Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab2HITRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:17:12 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:51866 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759300Ab2HITRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:17:09 -0400
Message-Id: <20120809190415.269834380@muttley.lan.cathedral>
User-Agent: quilt/0.60-1
Date: Thu, 09 Aug 2012 15:04:16 -0400
From: aris@ruivo.org
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND 2/4] device_cgroup: introduce dev_whitelist_clean()
References: <20120809190414.773462171@muttley.lan.cathedral>
Content-Disposition: inline; filename=introduce_whitelist_clean.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function cleans all the items in a whitelist and will be used by the next
patches.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

Index: github/security/device_cgroup.c
===================================================================
--- github.orig/security/device_cgroup.c	2012-07-24 17:16:00.085156162 -0400
+++ github/security/device_cgroup.c	2012-07-24 17:58:42.984081909 -0400
@@ -154,6 +154,22 @@
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
@@ -200,13 +216,9 @@
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
 

