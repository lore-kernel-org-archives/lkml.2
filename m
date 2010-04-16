Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab0DPPdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:33:42 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:63577 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757732Ab0DPPdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:33:41 -0400
Subject: [PATCH] fs-writeback : check sync bit earlier in
 inode_wait_for_writeback
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 16:33:39 +0100
Message-ID: <1271432019.2075.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When wb_writeback() hasn't written anything it will re-acquire the inode
lock before calling inode_wait_for_writeback. 

This change tests the sync bit first so that is doesn't need to drop &
re-acquire the lock if the inode became available while wb_writeback()
was waiting to get the lock.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
patch against 2.6.34-rc4
compiled & tested on 86_64

regards
Richard


diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 4b37f7c..b1e398e 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -398,11 +398,11 @@ static void inode_wait_for_writeback(struct inode *inode)
 	wait_queue_head_t *wqh;
 
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
-	do {
+	 while (inode->i_state & I_SYNC) {
 		spin_unlock(&inode_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
 		spin_lock(&inode_lock);
-	} while (inode->i_state & I_SYNC);
+	}
 }
 
 /*


