Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0GZTSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 15:18:21 -0400
Received: from kroah.org ([198.145.64.141]:59070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab0GZTST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 15:18:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] sysfs: Don't allow the creation of symlinks we can't remove
Date: Mon, 26 Jul 2010 12:18:15 -0700
Message-Id: <1280171897-13157-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100726190905.GC12683@kroah.com>
References: <20100726190905.GC12683@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Recently my tagged sysfs support revealed a flaw in the device core
that a few rare drivers are running into such that we don't always put
network devices in a class subdirectory named net/.

Since we are not creating the class directory the network devices wind
up in a non-tagged directory, but the symlinks to the network devices
from /sys/class/net are in a tagged directory.  All of which works
until we go to remove or rename the symlink.  When we remove or rename
a symlink we look in the namespace of the target of the symlink.
Since the target of the symlink is in a non-tagged sysfs directory we
don't have a namespace to look in, and we fail to remove the symlink.

Detect this problem up front and simply don't create symlinks we won't
be able to remove later.  This prevents symlink leakage and fails in
a much clearer and more understandable way.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/symlink.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index f71246b..44bca5f 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -28,6 +28,7 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 	struct sysfs_dirent *target_sd = NULL;
 	struct sysfs_dirent *sd = NULL;
 	struct sysfs_addrm_cxt acxt;
+	enum kobj_ns_type ns_type;
 	int error;
 
 	BUG_ON(!name);
@@ -58,16 +59,28 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 	if (!sd)
 		goto out_put;
 
-	if (sysfs_ns_type(parent_sd))
+	ns_type = sysfs_ns_type(parent_sd);
+	if (ns_type)
 		sd->s_ns = target->ktype->namespace(target);
 	sd->s_symlink.target_sd = target_sd;
 	target_sd = NULL;	/* reference is now owned by the symlink */
 
 	sysfs_addrm_start(&acxt, parent_sd);
-	if (warn)
-		error = sysfs_add_one(&acxt, sd);
-	else
-		error = __sysfs_add_one(&acxt, sd);
+	/* Symlinks must be between directories with the same ns_type */
+	if (ns_type == sysfs_ns_type(sd->s_symlink.target_sd->s_parent)) {
+		if (warn)
+			error = sysfs_add_one(&acxt, sd);
+		else
+			error = __sysfs_add_one(&acxt, sd);
+	} else {
+		error = -EINVAL;
+		WARN(1, KERN_WARNING
+			"sysfs: symlink across ns_types %s/%s -> %s/%s\n",
+			parent_sd->s_name,
+			sd->s_name,
+			sd->s_symlink.target_sd->s_parent->s_name,
+			sd->s_symlink.target_sd->s_name);
+	}
 	sysfs_addrm_finish(&acxt);
 
 	if (error)
-- 
1.7.2

