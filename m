Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2KGRPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:15:17 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64837 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2KGRPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:15:14 -0500
Date: Wed, 7 Nov 2012 09:15:08 -0800
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 1/9 v2] cgroup: add cgroup_subsys->post_create()
Message-ID: <20121107171508.GF2660@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351931915-1701-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there's no way for a controller to find out whether a new
cgroup finished all ->create() allocatinos successfully and is
considered "live" by cgroup.

This becomes a problem later when we add generic descendants walking
to cgroup which can be used by controllers as controllers don't have a
synchronization point where it can synchronize against new cgroups
appearing in such walks.

This patch adds ->post_create().  It's called after all ->create()
succeeded and the cgroup is linked into the generic cgroup hierarchy.
This plays the counterpart of ->pre_destroy().

When used in combination with the to-be-added generic descendant
iterators, ->post_create() can be used to implement reliable state
inheritance.  It will be explained with the descendant iterators.

v2: Added a paragraph about its future use w/ descendant iterators per
    Michal.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>
---
If you can explain it better, please be my guest.

Thanks.

 include/linux/cgroup.h |    1 +
 kernel/cgroup.c        |   12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -438,6 +438,7 @@ int cgroup_taskset_size(struct cgroup_ta
 
 struct cgroup_subsys {
 	struct cgroup_subsys_state *(*create)(struct cgroup *cgrp);
+	void (*post_create)(struct cgroup *cgrp);
 	void (*pre_destroy)(struct cgroup *cgrp);
 	void (*destroy)(struct cgroup *cgrp);
 	int (*can_attach)(struct cgroup *cgrp, struct cgroup_taskset *tset);
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4060,10 +4060,15 @@ static long cgroup_create(struct cgroup
 	if (err < 0)
 		goto err_remove;
 
-	/* each css holds a ref to the cgroup's dentry */
-	for_each_subsys(root, ss)
+	for_each_subsys(root, ss) {
+		/* each css holds a ref to the cgroup's dentry */
 		dget(dentry);
 
+		/* creation succeeded, notify subsystems */
+		if (ss->post_create)
+			ss->post_create(cgrp);
+	}
+
 	/* The cgroup directory was pre-locked for us */
 	BUG_ON(!mutex_is_locked(&cgrp->dentry->d_inode->i_mutex));
 
@@ -4281,6 +4286,9 @@ static void __init cgroup_init_subsys(st
 
 	ss->active = 1;
 
+	if (ss->post_create)
+		ss->post_create(&ss->root->top_cgroup);
+
 	/* this function shouldn't be used with modular subsystems, since they
 	 * need to register a subsys_id, among other things */
 	BUG_ON(ss->module);
