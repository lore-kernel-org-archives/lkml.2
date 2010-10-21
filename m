Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab0JUAxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:53:52 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:42601 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756353Ab0JUAug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:50:36 -0400
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/21] exofs: use iput() for inode reference count decrements
Date: Thu, 21 Oct 2010 11:49:32 +1100
Message-Id: <1287622186-1935-8-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287622186-1935-1-git-send-email-david@fromorbit.com>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Direct modification of the inode reference count is a no-no. Convert
the exofs decrements to call iput() instead of acting directly on
i_count.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/exofs/inode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index b631ff3..0fb4d4c 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1101,7 +1101,7 @@ static void create_done(struct exofs_io_state *ios, void *p)
 
 	set_obj_created(oi);
 
-	atomic_dec(&inode->i_count);
+	iput(inode);
 	wake_up(&oi->i_wq);
 }
 
@@ -1161,7 +1161,7 @@ struct inode *exofs_new_inode(struct inode *dir, int mode)
 	ios->cred = oi->i_cred;
 	ret = exofs_sbi_create(ios);
 	if (ret) {
-		atomic_dec(&inode->i_count);
+		iput(inode);
 		exofs_put_io_state(ios);
 		return ERR_PTR(ret);
 	}
-- 
1.7.1

