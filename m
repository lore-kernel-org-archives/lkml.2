Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab0HKLC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 07:02:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55053 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab0HKLC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 07:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=noFMyjZUZK1X202XpiqCq7743MdvlBd1g6d4jEh4AY+e7zrpSFfdE6A2BZcTc4SCrI
         P8XYaNsuTanpS3Hl8z/P1F1brlNU5GJerzezoOFBhJZ9TZvPiSDPLqjVnOKA15t2ztib
         8ciQOHJJaRdKTJy7HxdHatT0yS0M0YKk2ez10=
Date: Wed, 11 Aug 2010 14:07:01 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fix reiserfs_evict_inode end_writeback second call
Message-ID: <20100811110701.GA5362@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reiserfs_evict_inode calls end_writeback two times hitting
kernel BUG at fs/inode.c:298 becase inode->i_state is I_CLEAR already.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index ae35413..87e11d2 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -83,7 +83,8 @@ void reiserfs_evict_inode(struct inode *inode)
 	dquot_drop(inode);
 	inode->i_blocks = 0;
 	reiserfs_write_unlock_once(inode->i_sb, depth);
-
+	return;
+	
 no_delete:
 	end_writeback(inode);
 	dquot_drop(inode);


