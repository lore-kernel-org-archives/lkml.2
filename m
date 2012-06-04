Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab2FDGVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 02:21:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39612 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2FDGVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 02:21:11 -0400
Date: Mon, 4 Jun 2012 15:21:00 +0900
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v3.5-rc1] blkcg: fix blkg_alloc() failure path
Message-ID: <20120604062100.GA2843@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When policy data allocation fails in the middle, blkg_alloc() invokes
blkg_free() to destroy the half constructed blkg.  This ends up
calling pd_exit_fn() on policy datas which didn't go through
pd_init_fn().  Fix it by making blkg_alloc() call pd_init_fn()
immediately after each policy data allocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
Jens, this was posted as part of "block: implement per-blkg request
allocation" patchset[1] but should be applied as fix on v3.5-rc1.

[1] http://thread.gmane.org/gmane.linux.kernel.containers/23159/focus=2007

 block/blk-cgroup.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -125,12 +125,8 @@ static struct blkcg_gq *blkg_alloc(struc
 
 		blkg->pd[i] = pd;
 		pd->blkg = blkg;
-	}
-
-	/* invoke per-policy init */
-	for (i = 0; i < BLKCG_MAX_POLS; i++) {
-		struct blkcg_policy *pol = blkcg_policy[i];
 
+		/* invoke per-policy init */
 		if (blkcg_policy_enabled(blkg->q, pol))
 			pol->pd_init_fn(blkg);
 	}
