Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab0JSGeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 02:34:37 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48190 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab0JSGeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 02:34:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BBGPElKdokyNq2ncM+inDIUKzHmqtTwfwUe5VPnwfOlvgfInx9MhawO3o1iZAeLr33
         AufmMJKuhhvaOctw5kQpHvKgQH4PDvYBR2j56PWONDA+4gGhE1es6SIk0BhTMIVEWKgz
         CQhKvOnhqmCptLyKdgp1hIZOCob3ox28hi1jA=
From: Namhyung Kim <namhyung@gmail.com>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext3: Check return value of sb_getblk()
Date: Tue, 19 Oct 2010 15:34:21 +0900
Message-Id: <1287470061-4158-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check return value of sb_getblk() is NULL. unlikely is addded here
since it is called from a loop and we've been OK without the check
until now.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/inode.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index ef1c23a..a7ac778 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -655,6 +655,12 @@ static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
 		 * parent to disk.
 		 */
 		bh = sb_getblk(inode->i_sb, new_blocks[n-1]);
+		if (unlikely(!bh)) {
+			n--;
+			err = -ENOMEM;
+			goto failed;
+		}
+
 		branch[n].bh = bh;
 		lock_buffer(bh);
 		BUFFER_TRACE(bh, "call get_create_access");
-- 
1.7.0.4

