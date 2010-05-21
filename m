Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab0EUQ6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:58:46 -0400
Received: from kroah.org ([198.145.64.141]:39137 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934257Ab0EUQy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/38] sysfs: Implement sysfs_delete_link
Date: Fri, 21 May 2010 09:53:53 -0700
Message-Id: <1274460848-11377-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

When removing a symlink sysfs_remove_link does not provide
enough information to figure out which tagged directory the symlink
falls in.  So I need sysfs_delete_link which is passed the target
of the symlink to delete.

sysfs_rename_link is updated to call sysfs_delete_link instead
of sysfs_remove_link as we have all of the information necessary
and the callers are interesting.

Both of these functions now have enough information to find a symlink
in a tagged directory.  The only restriction is that they must be called
before the target kobject is renamed or deleted.  If they are called
later I loose track of which tag the target kobject was marked with
and can no longer find the old symlink to remove it.

This patch was split from an earlier patch.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>
Signed-off-by: Daniel Lezcano <dlezcano@fr.ibm.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/symlink.c    |   20 ++++++++++++++++++++
 include/linux/sysfs.h |    8 ++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index b6ebdaa..f71246b 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -109,6 +109,26 @@ int sysfs_create_link_nowarn(struct kobject *kobj, struct kobject *target,
 }
 
 /**
+ *	sysfs_delete_link - remove symlink in object's directory.
+ *	@kobj:	object we're acting for.
+ *	@targ:	object we're pointing to.
+ *	@name:	name of the symlink to remove.
+ *
+ *	Unlike sysfs_remove_link sysfs_delete_link has enough information
+ *	to successfully delete symlinks in tagged directories.
+ */
+void sysfs_delete_link(struct kobject *kobj, struct kobject *targ,
+			const char *name)
+{
+	const void *ns = NULL;
+	spin_lock(&sysfs_assoc_lock);
+	if (targ->sd)
+		ns = targ->sd->s_ns;
+	spin_unlock(&sysfs_assoc_lock);
+	sysfs_hash_and_remove(kobj->sd, ns, name);
+}
+
+/**
  *	sysfs_remove_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
  *	@name:	name of the symlink to remove.
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 1885d21..976c466 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -155,6 +155,9 @@ void sysfs_remove_link(struct kobject *kobj, const char *name);
 int sysfs_rename_link(struct kobject *kobj, struct kobject *target,
 			const char *old_name, const char *new_name);
 
+void sysfs_delete_link(struct kobject *dir, struct kobject *targ,
+			const char *name);
+
 int __must_check sysfs_create_group(struct kobject *kobj,
 				    const struct attribute_group *grp);
 int sysfs_update_group(struct kobject *kobj,
@@ -269,6 +272,11 @@ static inline int sysfs_rename_link(struct kobject *k, struct kobject *t,
 	return 0;
 }
 
+static inline void sysfs_delete_link(struct kobject *k, struct kobject *t,
+				     const char *name)
+{
+}
+
 static inline int sysfs_create_group(struct kobject *kobj,
 				     const struct attribute_group *grp)
 {
-- 
1.7.0.3

