Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1BDQrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 11:47:37 -0500
Received: from complete.lackof.org ([198.49.126.79]:40506 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab1BDQrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 11:47:36 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Feb 2011 11:47:36 EST
From: dann.frazier@canonical.com
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, dann frazier <dann.frazier@canonical.com>
Subject: [PATCH] [ocfs2] Use a kobject instead of a kset
Date: Fri,  4 Feb 2011 09:40:27 -0700
Message-Id: <1296837627-7416-1-git-send-email-dann.frazier@canonical.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: dann frazier <dann.frazier@canonical.com>

We currently allocate a kset and add attributes to its internal kobject.
However, Documentation/kobject.txt says only the kset code should manipulate
this internal object, and we can get the same results by just creating our
own kobject and avoiding a kset altogether.

Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 fs/ocfs2/stackglue.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index 39abf89..7098101 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -607,29 +607,29 @@ static struct attribute_group ocfs2_attr_group = {
 	.attrs = ocfs2_attrs,
 };
 
-static struct kset *ocfs2_kset;
+static struct kobject *ocfs2_kobj;
 
 static void ocfs2_sysfs_exit(void)
 {
-	kset_unregister(ocfs2_kset);
+	kobject_put(ocfs2_kobj);
 }
 
 static int ocfs2_sysfs_init(void)
 {
 	int ret;
 
-	ocfs2_kset = kset_create_and_add("ocfs2", NULL, fs_kobj);
-	if (!ocfs2_kset)
+	ocfs2_kobj = kobject_create_and_add("ocfs2", fs_kobj);
+	if (!ocfs2_kobj)
 		return -ENOMEM;
 
-	ret = sysfs_create_group(&ocfs2_kset->kobj, &ocfs2_attr_group);
+	ret = sysfs_create_group(ocfs2_kobj, &ocfs2_attr_group);
 	if (ret)
 		goto error;
 
 	return 0;
 
 error:
-	kset_unregister(ocfs2_kset);
+	kobject_put(ocfs2_kobj);
 	return ret;
 }
 
-- 
1.7.2.3

