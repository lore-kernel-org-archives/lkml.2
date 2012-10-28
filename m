Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab2J1X21 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:28:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42172 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756934Ab2J1X2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:23 -0400
Message-Id: <20121028231553.071436947@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:28 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ben Blum <bblum@andrew.cmu.edu>, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>
Subject: [ 052/105] cgroup: notify_on_release may not be triggered in some cases
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/cgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1803,9 +1803,8 @@ static int cgroup_task_migrate(struct cg
 	 * trading it for newcg is protected by cgroup_mutex, we're safe to drop
 	 * it here; it will be freed under RCU.
 	 */
-	put_css_set(oldcg);
-
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
+	put_css_set(oldcg);
 	return 0;
 }
 


