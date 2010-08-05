Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965Ab0HEWbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:31:53 -0400
Received: from kroah.org ([198.145.64.141]:37805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760807Ab0HEWZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:25:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 21/28] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
Date: Thu,  5 Aug 2010 15:24:11 -0700
Message-Id: <1281047058-23716-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>

We really shouldn't be asking userspace to create new root filesystems.
So follow along with all of the other in-kernel filesystems, and provide
a mount point in sysfs.

For cgroupfs, this should be in /sys/fs/cgroup/  This change provides
that mount point when the cgroup filesystem is registered in the kernel.

Acked-by: Paul Menage <menage@google.com>
Acked-by: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/cgroup.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a8ce099..d83cab0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1623,6 +1623,8 @@ static struct file_system_type cgroup_fs_type = {
 	.kill_sb = cgroup_kill_sb,
 };
 
+static struct kobject *cgroup_kobj;
+
 static inline struct cgroup *__d_cgrp(struct dentry *dentry)
 {
 	return dentry->d_fsdata;
@@ -3894,9 +3896,18 @@ int __init cgroup_init(void)
 	hhead = css_set_hash(init_css_set.subsys);
 	hlist_add_head(&init_css_set.hlist, hhead);
 	BUG_ON(!init_root_id(&rootnode));
+
+	cgroup_kobj = kobject_create_and_add("cgroup", fs_kobj);
+	if (!cgroup_kobj) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	err = register_filesystem(&cgroup_fs_type);
-	if (err < 0)
+	if (err < 0) {
+		kobject_put(cgroup_kobj);
 		goto out;
+	}
 
 	proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations);
 
-- 
1.7.2

