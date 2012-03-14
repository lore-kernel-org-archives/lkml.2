Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031133Ab2CNVwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:52:36 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52389 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031118Ab2CNVwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:52:33 -0400
Date: Wed, 14 Mar 2012 14:52:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Lennart Poettering <mzxreary@0pointer.de>
Subject: [PATCH] cgroup: deprecate remount option changes and "name=" mount
 option
Message-ID: <20120314215228.GI7349@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following features.

* Rebinding subsys by remount: Never reached useful state - only works
  on empty hierarchies.

* release_agent update by remount: release_agent itself will be
  replaced with conventional fsnotify notification.

* "name=" mount option: This has been broken for years before Li fixed
  it recently.  It has very marginal usefulness (plain bind mount can
  mostly replace it) and is quite unusual.  Take the chance and mark
  for deprecation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
---
If you want these to survive, now is the time to scream. :)

Thanks.

 Documentation/feature-removal-schedule.txt |   12 ++++++++++++
 kernel/cgroup.c                            |   10 ++++++++++
 2 files changed, 22 insertions(+)

Index: work/Documentation/feature-removal-schedule.txt
===================================================================
--- work.orig/Documentation/feature-removal-schedule.txt
+++ work/Documentation/feature-removal-schedule.txt
@@ -510,3 +510,15 @@ Why:	The pci_scan_bus_parented() interfa
 	convert to using pci_scan_root_bus() so they can supply a list of
 	bus resources when the bus is created.
 Who:	Bjorn Helgaas <bhelgaas@google.com>
+
+----------------------------
+
+What:	cgroup option updates via remount, and "name=" mount option
+When:	March 2013
+Why:	Remount currently allows changing bound subsystems and
+	release_agent.  Rebinding is hardly useful as it only works
+	when the hierarchy is empty and release_agent itself should be
+	replaced with conventional fsnotify.  "name=" option allows
+	mounting existing hierarchy by its name, which isn't useful
+	and has been broken for years without anyone noticing.
+Who:	Tejun Heo <tj@kernel.org>
Index: work/kernel/cgroup.c
===================================================================
--- work.orig/kernel/cgroup.c
+++ work/kernel/cgroup.c
@@ -1146,6 +1146,11 @@ static int parse_cgroupfs_options(char *
 		}
 		if (!strncmp(token, "name=", 5)) {
 			const char *name = token + 5;
+
+			/* See feature-removal-schedule.txt */
+			pr_warning("cgroup: name= option is deprecated (pid=%d comm=%s name=%s)\n",
+				   task_tgid_nr(current), current->comm, name);
+
 			/* Can't specify an empty name */
 			if (!strlen(name))
 				return -EINVAL;
@@ -1294,6 +1299,11 @@ static int cgroup_remount(struct super_b
 	if (ret)
 		goto out_unlock;
 
+	/* See feature-removal-schedule.txt */
+	if (opts.subsys_bits != root->actual_subsys_bits || opts.release_agent)
+		pr_warning("cgroup: option changes via remount are deprecated (pid=%d comm=%s)\n",
+			   task_tgid_nr(current), current->comm);
+
 	/* Don't allow flags or name to change at remount */
 	if (opts.flags != root->flags ||
 	    (opts.name && strcmp(opts.name, root->name))) {
