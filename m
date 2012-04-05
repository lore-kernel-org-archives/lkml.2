Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2DEHPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 03:15:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61718 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2DEHO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 03:14:59 -0400
Date: Thu, 5 Apr 2012 00:14:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [patch 2/2] cpu_cgroup: disallow attaching kthreadd
In-Reply-To: <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1204050014100.9466@chino.kir.corp.google.com>
References: <1333475906.7439.7.camel@marge.simpson.net> <alpine.DEB.2.00.1204040008040.5356@chino.kir.corp.google.com> <1333535915.7188.18.camel@marge.simpson.net> <alpine.DEB.2.00.1204040419450.23137@chino.kir.corp.google.com> <1333542649.7188.40.camel@marge.simpson.net>
 <alpine.DEB.2.00.1204041414220.26086@chino.kir.corp.google.com> <20120404230922.GC2173@dhcp-172-17-108-109.mtv.corp.google.com> <1333601231.7783.31.camel@marge.simpson.net> <alpine.DEB.2.00.1204042157530.31186@chino.kir.corp.google.com>
 <1333604949.7783.76.camel@marge.simpson.net> <alpine.DEB.2.00.1204042303510.7035@chino.kir.corp.google.com> <1333608177.7783.106.camel@marge.simpson.net> <alpine.DEB.2.00.1204042344090.8991@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1204050011550.9466@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

An RT workqueue worker thread spawned in a cpu cgroup with no rt_runtime
allocated is not schedulable.  Simple user error, but harmful to the box.
Save the user some unexpected trouble, just say no.

Acked-by: Paul Menage <paul@paulmenage.org>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/sched/core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -72,6 +72,7 @@
 #include <linux/slab.h>
 #include <linux/init_task.h>
 #include <linux/binfmts.h>
+#include <linux/kthread.h>
 
 #include <asm/switch_to.h>
 #include <asm/tlb.h>
@@ -7636,6 +7637,13 @@ static int cpu_cgroup_can_attach(struct cgroup *cgrp,
 		if (task->sched_class != &fair_sched_class)
 			return -EINVAL;
 #endif
+		/*
+		 * Disallow kthreadd since it can fork workers for an RT
+		 * workqueue in a cgroup which may or may not have rt_runtime
+		 * allocated.
+		 */
+		if (task == kthreadd_task)
+			return -EINVAL;
 	}
 	return 0;
 }
