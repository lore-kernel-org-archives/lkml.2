Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab2KESCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:02:22 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42505 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab2KESCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:02:18 -0500
Date: Mon, 5 Nov 2012 10:02:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC] cgroup: deprecate clone_children
Message-ID: <20121105180213.GB19354@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-2-git-send-email-tj@kernel.org>
 <5097C23B.3040808@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5097C23B.3040808@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clone_children makes cgroup invoke ->post_clone() callback if it
exists and sets CGRP_CLONE_CHILDREN.  ->post_clone(), while being
named generically, is only supposed to copy configuration from its
parent.

This is an entirely convenience feature which is only used by cpuset
to alter its configuration propagation.  As the mount option and
cgroupfs knobs are cgroup-wide and different controllers differ in
their configuration propagations, it's awkward to use for multiple
controllers especially if they're co-mounted.  At this point, we can't
use this flag for any other controller anyway as it would implicitly
change the behavior.

As this is unnecessary feature with very limited use and awkward in
co-mounted use cases, let's try to deprecate it.  Whine on the mount
option and accesses to cgroupfs knobs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
Glauber, I think this is more befitting change for .post_clone().  If
people aren't depending on this, I'd much prefer to just remove it.

Thanks.

 kernel/cgroup.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1162,6 +1162,8 @@ static int parse_cgroupfs_options(char *
 			continue;
 		}
 		if (!strcmp(token, "clone_children")) {
+			pr_warning("cgroup: mount option clone_children is deprecated (pid=%d comm=%s)\n",
+				   task_tgid_nr(current), current->comm);
 			opts->clone_children = true;
 			continue;
 		}
@@ -3837,6 +3839,9 @@ fail:
 static u64 cgroup_clone_children_read(struct cgroup *cgrp,
 				    struct cftype *cft)
 {
+	printk_ratelimited(KERN_WARNING "cgroup: clone_children is deprecated (pid=%d comm=%s)\n",
+			   task_tgid_nr(current), current->comm);
+
 	return clone_children(cgrp);
 }
 
@@ -3844,6 +3849,9 @@ static int cgroup_clone_children_write(s
 				     struct cftype *cft,
 				     u64 val)
 {
+	printk_ratelimited(KERN_WARNING "cgroup: clone_children is deprecated (pid=%d comm=%s)\n",
+			   task_tgid_nr(current), current->comm);
+
 	if (val)
 		set_bit(CGRP_CLONE_CHILDREN, &cgrp->flags);
 	else
