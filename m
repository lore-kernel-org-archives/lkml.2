Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab0IRTJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:09:09 -0400
Received: from kroah.org ([198.145.64.141]:51831 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab0IRTCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:22 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:02 2010
Message-Id: <20100918190001.989478186@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [107/123] sched: Fix vmark regression on big machines
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-fix-vmark-regression-on-big-machines.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Galbraith <efault@gmx.de>

commit 50b926e439620c469565e8be0f28be78f5fca1ce upstream

SD_PREFER_SIBLING is set at the CPU domain level if power saving isn't
enabled, leading to many cache misses on large machines as we traverse
looking for an idle shared cache to wake to.  Change the enabler of
select_idle_sibling() to SD_SHARE_PKG_RESOURCES, and enable same at the
sibling domain level.

Reported-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1262612696.15495.15.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/topology.h |    2 +-
 kernel/sched_fair.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -99,7 +99,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_WAKE_AFFINE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
-				| 0*SD_SHARE_PKG_RESOURCES		\
+				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1490,7 +1490,7 @@ select_task_rq_fair(struct rq *rq, struc
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING)
+			if (tmp->flags & SD_SHARE_PKG_RESOURCES)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {


