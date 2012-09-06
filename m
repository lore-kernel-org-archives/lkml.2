Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab2IFKIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 06:08:23 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51545 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab2IFKIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 06:08:22 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH] UDF: Fix incorrect error handling in udf_direct_IO()
Date: Thu,  6 Sep 2012 11:08:11 +0100
Message-Id: <1346926091-3654-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <20120905190239.GK18051@quack.suse.cz>
References: <20120905190239.GK18051@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My recent patch to add DIRECT_IO support to the UDF filesystem handler
contains a mistake in the error recovery if blockdev_direct_IO() fails.
The test `rw && WRITE` should be `rw & WRITE`.  Fix it.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 fs/udf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index b905448..41d5830 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -156,7 +156,7 @@ static ssize_t udf_direct_IO(int rw, struct kiocb *iocb,
 
 	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
 				  udf_get_block);
-	if (unlikely(ret < 0 && (rw && WRITE)))
+	if (unlikely(ret < 0 && (rw & WRITE)))
 		udf_write_failed(mapping, offset + iov_length(iov, nr_segs));
 	return ret;
 }
-- 
1.7.12

