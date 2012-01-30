Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2A3HIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 02:08:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:5268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab2A3HHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 02:07:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101015146"
Message-Id: <20120130070634.907002093@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 30 Jan 2012 15:02:18 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, david@fromorbit.com,
        jack@suse.cz, zhu.yanhai@gmail.com, namhyung.kim@lge.com,
        shaohua.li@intel.com
Subject: [patch v2 5/8]block: fiops preserve vios key for deep queue depth workload
References: <20120130070213.793690895@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=fiops-vios-key-preserve.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the task has running request, even it's added into service tree newly,
we preserve its vios key, so it will not lost its share. This should work
for task driving big queue depth. For single depth task, there is no approach
to preserve its vios key.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/fiops-iosched.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux/block/fiops-iosched.c
===================================================================
--- linux.orig/block/fiops-iosched.c	2012-01-18 14:43:51.000000000 +0800
+++ linux/block/fiops-iosched.c	2012-01-18 14:44:25.000000000 +0800
@@ -188,9 +188,12 @@ static void fiops_service_tree_add(struc
 	int left;
 
 	/* New added IOC */
-	if (RB_EMPTY_NODE(&ioc->rb_node))
-		vios = max_vios(service_tree->min_vios, ioc->vios);
-	else {
+	if (RB_EMPTY_NODE(&ioc->rb_node)) {
+		if (ioc->in_flight > 0)
+			vios = ioc->vios;
+		else
+			vios = max_vios(service_tree->min_vios, ioc->vios);
+	} else {
 		vios = ioc->vios;
 		/* ioc->service_tree might not equal to service_tree */
 		fiops_rb_erase(&ioc->rb_node, ioc->service_tree);

