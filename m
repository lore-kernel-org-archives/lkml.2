Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1KXTqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:46:34 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39995 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab1KXTqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:46:32 -0500
Date: Thu, 24 Nov 2011 11:46:26 -0800
From: Tejun Heo <tj@kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>, rickyb@google.com,
        aberkan@google.com
Subject: [PATCH] ext4: fix racy use-after-free in ext4_end_io_dio()
Message-ID: <20111124194626.GA5260@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext4_end_io_dio() queues io_end->work and then clears iocb->private;
however, io_end->work completes the iocb by calling aio_complete(),
which may happen before io_end->work clearing thus leading to
use-after-free.

Detected and tested with slab poisoning.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Kent Overstreet <koverstreet@google.com>
Tested-by: Kent Overstreet <koverstreet@google.com>
Cc: stable@kernel.org
---
I *think* this is the corret fix but am not too familiar with code
path, so please proceed with caution.

Thank you.

 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 240f6e2..0f5583b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2806,8 +2806,8 @@ out:
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 
 	/* queue the work to convert unwritten extents to written */
-	queue_work(wq, &io_end->work);
 	iocb->private = NULL;
+	queue_work(wq, &io_end->work);
 
 	/* XXX: probably should move into the real I/O completion handler */
 	inode_dio_done(inode);
