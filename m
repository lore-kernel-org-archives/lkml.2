Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab0GNJpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:45:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36528 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab0GNJpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BbFER1+oZCJqYFLzD9m4QUKJraXRzFvNhXcJj3H6EYQbkYw4jFDiY5LzDvfXL2HICB
         X9glD8LpSZEpsY1ZVB8PFf/cJcM2dpqs+6/VezlTf4O+rwe6fNQ2v+OhcfFeGsLMVxVd
         NiPotLKh/NKDP+JxyNGBJbpJ62SncJMQ2S+bc=
From: Changli Gao <xiaosuo@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Jike Song" <albcamus@gmail.com>, linux-kernel@vger.kernel.org,
        Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH v2] drivers: code cleanups
Date: Wed, 14 Jul 2010 17:42:56 +0800
Message-Id: <1279100576-8680-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers: code cleanups

the first three goto clauses caused kfree(NULL), and the error code returned
by kset->uevent_ops->uevent() wasn't passed to the caller of show_uevent().
This patch also eliminates the unnecessary initializations of env and count.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 drivers/base/core.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 38bbbd0..76cd4f0 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -274,9 +274,8 @@ static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
 {
 	struct kobject *top_kobj;
 	struct kset *kset;
-	struct kobj_uevent_env *env = NULL;
+	struct kobj_uevent_env *env;
 	int i;
-	size_t count = 0;
 	int retval;
 
 	/* search the kset, the device belongs to */
@@ -284,16 +283,16 @@ static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
 	while (!top_kobj->kset && top_kobj->parent)
 		top_kobj = top_kobj->parent;
 	if (!top_kobj->kset)
-		goto out;
+		return 0;
 
 	kset = top_kobj->kset;
 	if (!kset->uevent_ops || !kset->uevent_ops->uevent)
-		goto out;
+		return 0;
 
 	/* respect filter */
 	if (kset->uevent_ops && kset->uevent_ops->filter)
 		if (!kset->uevent_ops->filter(kset, &dev->kobj))
-			goto out;
+			return 0;
 
 	env = kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
 	if (!env)
@@ -306,10 +305,10 @@ static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
 
 	/* copy keys to file */
 	for (i = 0; i < env->envp_idx; i++)
-		count += sprintf(&buf[count], "%s\n", env->envp[i]);
+		retval += sprintf(&buf[retval], "%s\n", env->envp[i]);
 out:
 	kfree(env);
-	return count;
+	return retval;
 }
 
 static ssize_t store_uevent(struct device *dev, struct device_attribute *attr,
