Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705Ab2C2Svl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:51:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51600 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab2C2Sve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:51:34 -0400
Date: Thu, 29 Mar 2012 21:51:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] blkcg: change a spin_lock() to spin_lock_irq()
Message-ID: <20120329185119.GA21812@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F74AF2F.007C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains that we re-enable IRQs twice.  It looks like we forgot
to disable them here on the spin_trylock() failure path.  This was added
in 9f13ef678e "blkcg: use double locking instead of RCU for blkg
synchronization".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 74a76a8..bf4b76e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1598,7 +1598,7 @@ static int blkiocg_pre_destroy(struct cgroup *cgroup)
 		} else {
 			spin_unlock_irq(&blkcg->lock);
 			cpu_relax();
-			spin_lock(&blkcg->lock);
+			spin_lock_irq(&blkcg->lock);
 		}
 	}
 
