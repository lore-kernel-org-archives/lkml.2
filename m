Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0C0PAF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 11:00:05 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36285 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab0C0PAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 11:00:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=l8Qms+7XxTRvvm/bg2YJz1dZE1iD7ruQohQ+oCosmssKgiECjdjkstyA5br2SI1WsB
         9WF8Tmotgk8xAx1IYjuMIoHJRX/gY82BsEEQTx3gqT1GNDRr4jl/rD1Qk6u5i1b5Vec9
         4drS1lEMuLlw2Yat4JlUEAcM2aI2KY4ztF+rI=
Date: Sat, 27 Mar 2010 17:59:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Ellenberg <drbd-dev@lists.linbit.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] drbd: potential null dereference
Message-ID: <20100327145950.GG5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Ellenberg <drbd-dev@lists.linbit.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If "e" is NULL then "bm_ext" would be NULL too.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Found by static analysis and compile tested only.  Sorry.  :/

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 17956ff..b68b778 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -1328,7 +1328,7 @@ int drbd_rs_del_all(struct drbd_conf *mdev)
 		for (i = 0; i < mdev->resync->nr_elements; i++) {
 			e = lc_element_by_index(mdev->resync, i);
 			bm_ext = e ? lc_entry(e, struct bm_extent, lce) : NULL;
-			if (bm_ext->lce.lc_number == LC_FREE)
+			if (!bm_ext || bm_ext->lce.lc_number == LC_FREE)
 				continue;
 			if (bm_ext->lce.lc_number == mdev->resync_wenr) {
 				dev_info(DEV, "dropping %u in drbd_rs_del_all, apparently"
