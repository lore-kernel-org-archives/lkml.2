Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795Ab2KZRhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:37:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47917 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933681Ab2KZRLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Blum <bblum@andrew.cmu.edu>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Tejun Heo <tj@kernel.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 189/270] cgroup: notify_on_release may not be triggered in some cases
Date: Mon, 26 Nov 2012 14:57:59 -0200
Message-Id: <1353949160-26803-190-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

commit 1f5320d5972aa50d3e8d2b227b636b370e608359 upstream.

notify_on_release must be triggered when the last process in a cgroup is
move to another. But if the first(and only) process in a cgroup is moved to
another, notify_on_release is not triggered.

	# mkdir /cgroup/cpu/SRC
	# mkdir /cgroup/cpu/DST
	#
	# echo 1 >/cgroup/cpu/SRC/notify_on_release
	# echo 1 >/cgroup/cpu/DST/notify_on_release
	#
	# sleep 300 &
	[1] 8629
	#
	# echo 8629 >/cgroup/cpu/SRC/tasks
	# echo 8629 >/cgroup/cpu/DST/tasks
	-> notify_on_release for /SRC must be triggered at this point,
	   but it isn't.

This is because put_css_set() is called before setting CGRP_RELEASABLE
in cgroup_task_migrate(), and is a regression introduce by the
commit:74a1166d(cgroups: make procs file writable), which was merged
into v3.0.

Cc: Ben Blum <bblum@andrew.cmu.edu>
Acked-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/cgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 15462a0..63c9596 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1927,9 +1927,8 @@ static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
 	 * trading it for newcg is protected by cgroup_mutex, we're safe to drop
 	 * it here; it will be freed under RCU.
 	 */
-	put_css_set(oldcg);
-
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
+	put_css_set(oldcg);
 }
 
 /**
-- 
1.7.9.5

