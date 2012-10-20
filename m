Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2JTKJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 06:09:40 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40274 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2JTKJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 06:09:38 -0400
Message-ID: <508276D3.5000708@gmail.com>
Date: Sat, 20 Oct 2012 12:02:59 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] hostfs: fix a not needed double check
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the commit 3be2be0a32c18b0fd6d623cda63174a332ca0de1 we removed vmtruncate,
but actaully there is no need to call inode_newsize_ok() because the checks are
already done in inode_change_ok() at the begin of the function.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/hostfs/hostfs_kern.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 457addc..c9d5254 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -845,15 +845,8 @@ int hostfs_setattr(struct dentry *dentry, struct iattr *attr)
 		return err;
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode)) {
-		int error;
-
-		error = inode_newsize_ok(inode, attr->ia_size);
-		if (error)
-			return error;
-
+	    attr->ia_size != i_size_read(inode))
 		truncate_setsize(inode, attr->ia_size);
-	}
 
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
-- 
1.7.3.4
