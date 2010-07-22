Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874Ab0GVS0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:26:48 -0400
Received: from kroah.org ([198.145.64.141]:51709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759865Ab0GVS0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:26:42 -0400
Date: Thu, 22 Jul 2010 11:26:38 -0700
From: Greg KH <gregkh@suse.de>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
Message-ID: <20100722182638.GA12712@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We really shouldn't be asking userspace to create new root filesystems.
So follow along with all of the other in-kernel filesystems, and provide
a mount point in sysfs.

For cgroupfs, this should be in /sys/fs/cgroup/  This change provides
that mount point when the cgroup filesystem is registered in the kernel.

Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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
@@ -3871,9 +3873,18 @@ int __init cgroup_init(void)
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
 
