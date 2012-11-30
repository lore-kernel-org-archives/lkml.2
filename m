Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031409Ab2K3RuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:50:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61901 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1031395Ab2K3RuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:50:10 -0500
X-IronPort-AV: E=Sophos;i="4.83,348,1352044800"; 
   d="scan'208";a="6309117"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: cgroups@vger.kernel.org
Cc: tj@kernel.org, lizefan@huawei.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 1/2] cgroup: use cgroup_addrm_files in cgroup_clear_directory
Date: Sat, 1 Dec 2012 00:21:28 +0800
Message-Id: <1354292489-18434-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/01 00:21:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/01 00:21:49,
	Serialize complete at 2012/12/01 00:21:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_rm_file only remove the first file. after remount,
the cgroup subsystem will be unloaded with it's files left.

use cgroup_addrm_files to remove all files of subsystem.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 kernel/cgroup.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f24f724..e5233b7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -970,6 +970,8 @@ static int cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 	return -ENOENT;
 }
 
+static int cgroup_addrm_files(struct cgroup *cgrp, struct cgroup_subsys *subsys,
+			      struct cftype cfts[], bool is_add);
 /**
  * cgroup_clear_directory - selective removal of base and subsystem files
  * @dir: directory containing the files
@@ -987,7 +989,7 @@ static void cgroup_clear_directory(struct dentry *dir, bool base_files,
 		if (!test_bit(ss->subsys_id, &subsys_mask))
 			continue;
 		list_for_each_entry(set, &ss->cftsets, node)
-			cgroup_rm_file(cgrp, set->cfts);
+			cgroup_addrm_files(cgrp, NULL, set->cfts, false);
 	}
 	if (base_files) {
 		while (!list_empty(&cgrp->files))
-- 
1.7.7.6

