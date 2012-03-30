Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab2C3F0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 01:26:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62961 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2C3F0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 01:26:17 -0400
Date: Thu, 29 Mar 2012 22:26:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Mandeep Singh Baines <msb@chromium.org>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [GIT PULL] cgroup: urgent fix for 3.4-rc1 merge window
Message-ID: <20120330052612.GA13855@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

61d1d219c4 "cgroup: remove extra calls to find_existing_css_set" which
was part of the rc1 cgroup pull request made writes to cgroup "tasks"
file return uninitialized retval on success which can cause boot
failures with systemd.  The change stayed in linux-next for quite some
time but gcc interestingly failed to emit warning about using
uninitialized variable and the problem seems to materialize only for
certain build combinations (probably depends on register allocation).

It's just missing local variable initialization and the fix is trivial
& safe.  As the problem is critical when it materializes, I'm
fast-tracking it.  Also included is Li's email address change in
MAINTAINERS.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.4-fixes

Li Zefan (1):
      cgroup: update MAINTAINERS entry

Tejun Heo (1):
      cgroup: cgroup_attach_task() could return -errno after success

Thanks.
---
 MAINTAINERS     |    2 +-
 kernel/cgroup.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f9faade..3dbf4d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1940,7 +1940,7 @@ F:	drivers/connector/
 
 CONTROL GROUPS (CGROUPS)
 M:	Tejun Heo <tj@kernel.org>
-M:	Li Zefan <lizf@cn.fujitsu.com>
+M:	Li Zefan <lizefan@huawei.com>
 L:	containers@lists.linux-foundation.org
 L:	cgroups@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index f4ea4b6..ed64cca 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1883,7 +1883,7 @@ static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
  */
 int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
 {
-	int retval;
+	int retval = 0;
 	struct cgroup_subsys *ss, *failed_ss = NULL;
 	struct cgroup *oldcgrp;
 	struct cgroupfs_root *root = cgrp->root;

--
tejun
