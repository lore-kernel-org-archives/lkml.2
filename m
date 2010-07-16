Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965608Ab0GPMuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 08:50:13 -0400
Received: from smtp.nokia.com ([192.100.122.233]:54080 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965450Ab0GPMt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 08:49:26 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 15/16] writeback: clean-up the warning about non-registered bdi
Date: Fri, 16 Jul 2010 15:45:11 +0300
Message-Id: <1279284312-2411-16-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 16 Jul 2010 12:49:19.0336 (UTC) FILETIME=[4E80B680:01CB24E5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

In '__mark_inode_dirty()', when the corresponding bdi was not properly
registered, we print a warning. But the corresponding code is a bit
untidy, it used if and 'WARN_ON(1)' and printk.

This patch turns it into one multi-line WARN() statement which looks
tidier and also uses 'unlikely()' for the condition which might matter
a tiny bit for this hot-path function.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 559092d..83662fb 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -981,12 +981,9 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 			struct backing_dev_info *bdi = wb->bdi;
 
-			if (bdi_cap_writeback_dirty(bdi) &&
-			    !test_bit(BDI_registered, &bdi->state)) {
-				WARN_ON(1);
-				printk(KERN_ERR "bdi-%s not registered\n",
-								bdi->name);
-			}
+			WARN(bdi_cap_writeback_dirty(bdi) &&
+			     !test_bit(BDI_registered, &bdi->state),
+			     "bdi-%s not registered\n", bdi->name);
 
 			inode->dirtied_when = jiffies;
 			list_move(&inode->i_list, &wb->b_dirty);
-- 
1.7.1.1

