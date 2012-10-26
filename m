Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab2JZAPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:15:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:53964 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab2JZAIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Li Zefan <lizefan@huawei.com>, Ben Blum <bblum@andrew.cmu.edu>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Tejun Heo <tj@kernel.org>
Subject: [ 50/85] cgroup: notify_on_release may not be triggered in some cases
Date: Thu, 25 Oct 2012 17:06:08 -0700
Message-Id: <20121026000036.149998987@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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

Acked-by: Li Zefan <lizefan@huawei.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1923,9 +1923,8 @@ static void cgroup_task_migrate(struct c
 	 * trading it for newcg is protected by cgroup_mutex, we're safe to drop
 	 * it here; it will be freed under RCU.
 	 */
-	put_css_set(oldcg);
-
 	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
+	put_css_set(oldcg);
 }
 
 /**


