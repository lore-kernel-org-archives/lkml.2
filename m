Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab0JVSZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:25:49 -0400
Received: from kroah.org ([198.145.64.141]:37842 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758983Ab0JVSZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Robin Holt <holt@sgi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/31] kobject: Introduce kset_find_obj_hinted.
Date: Fri, 22 Oct 2010 11:25:09 -0700
Message-Id: <1287771916-15016-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>

One call chain getting to kset_find_obj is:
  link_mem_sections()
    find_mem_section()
      kset_find_obj()

This is done during boot.  The memory sections were added in a linearly
increasing order and link_mem_sections tends to utilize them in that
same linear order.

Introduce a kset_find_obj_hinted which is passed the result of the
previous kset_find_obj which it uses for a quick "is the next object
our desired object" check before falling back to the old behavior.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Robert P. J. Day <rpjday@crashcourse.ca>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    2 ++
 lib/kobject.c           |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 7950a37..8f6d121 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -191,6 +191,8 @@ static inline struct kobj_type *get_ktype(struct kobject *kobj)
 }
 
 extern struct kobject *kset_find_obj(struct kset *, const char *);
+extern struct kobject *kset_find_obj_hinted(struct kset *, const char *,
+						struct kobject *);
 
 /* The global /sys/kernel/ kobject for people to chain off of */
 extern struct kobject *kernel_kobj;
diff --git a/lib/kobject.c b/lib/kobject.c
index f07c572..82dc34c 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -746,17 +746,56 @@ void kset_unregister(struct kset *k)
  */
 struct kobject *kset_find_obj(struct kset *kset, const char *name)
 {
+	return kset_find_obj_hinted(kset, name, NULL);
+}
+
+/**
+ * kset_find_obj_hinted - search for object in kset given a predecessor hint.
+ * @kset: kset we're looking in.
+ * @name: object's name.
+ * @hint: hint to possible object's predecessor.
+ *
+ * Check the hint's next object and if it is a match return it directly,
+ * otherwise, fall back to the behavior of kset_find_obj().  Either way
+ * a reference for the returned object is held and the reference on the
+ * hinted object is released.
+ */
+struct kobject *kset_find_obj_hinted(struct kset *kset, const char *name,
+				     struct kobject *hint)
+{
 	struct kobject *k;
 	struct kobject *ret = NULL;
 
 	spin_lock(&kset->list_lock);
+
+	if (!hint)
+		goto slow_search;
+
+	/* end of list detection */
+	if (hint->entry.next == kset->list.next)
+		goto slow_search;
+
+	k = container_of(hint->entry.next, struct kobject, entry);
+	if (!kobject_name(k) || strcmp(kobject_name(k), name))
+		goto slow_search;
+
+	ret = kobject_get(k);
+	goto unlock_exit;
+
+slow_search:
 	list_for_each_entry(k, &kset->list, entry) {
 		if (kobject_name(k) && !strcmp(kobject_name(k), name)) {
 			ret = kobject_get(k);
 			break;
 		}
 	}
+
+unlock_exit:
 	spin_unlock(&kset->list_lock);
+
+	if (hint)
+		kobject_put(hint);
+
 	return ret;
 }
 
-- 
1.7.2

