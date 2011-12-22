Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1LVIlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:41:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63828 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab1LVIlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:41:14 -0500
Message-ID: <4EF2EDA7.4010004@cn.fujitsu.com>
Date: Thu, 22 Dec 2011 16:43:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cgroup: move a check to parse_cgroupfs_options()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 16:40:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-22 16:40:26,
	Serialize complete at 2011-12-22 16:40:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always check the validity of mount options in parse_cgroupfs_options().

No functional change.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4936d88..bdb7994 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1218,7 +1218,6 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 	    (opts->subsys_bits & mask))
 		return -EINVAL;
 
-
 	/* Can't specify "none" and some subsystems */
 	if (opts->subsys_bits && opts->none)
 		return -EINVAL;
@@ -1231,6 +1230,13 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 		return -EINVAL;
 
 	/*
+	 * This can happen only when none of the subsystems is enabled
+	 * in the system.
+	 */
+	if (!opts->subsys_bits && !opts->none)
+		return -EINVAL;
+
+	/*
 	 * Grab references on all the modules we'll need, so the subsystems
 	 * don't dance around before rebind_subsystems attaches them. This may
 	 * take duplicate reference counts on a subsystem that's already used,
@@ -1401,9 +1407,6 @@ static struct cgroupfs_root *cgroup_root_from_opts(struct cgroup_sb_opts *opts)
 {
 	struct cgroupfs_root *root;
 
-	if (!opts->subsys_bits && !opts->none)
-		return NULL;
-
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
 	if (!root)
 		return ERR_PTR(-ENOMEM);
@@ -1442,10 +1445,6 @@ static int cgroup_set_super(struct super_block *sb, void *data)
 	int ret;
 	struct cgroup_sb_opts *opts = data;
 
-	/* If we don't have a new root, we can't set up a new sb */
-	if (!opts->new_root)
-		return -EINVAL;
-
 	BUG_ON(!opts->subsys_bits && !opts->none);
 
 	ret = set_anon_super(sb, NULL);
-- 
1.7.3.1
