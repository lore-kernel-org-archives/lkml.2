Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab0HQI0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:26:22 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:33255 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab0HQI0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:26:21 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [BUG][reiserfs] page fault during kernel boot
Date: Tue, 17 Aug 2010 11:25:25 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.36-rc1; KDE/4.4.3; x86_64; ; )
Cc: Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008171125.25956.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The function: reiserfs_evict_inode() ends with:

<snip>
out:
	end_writeback(inode);	/* note this must go after the journal_end to prevent deadlock */
	dquot_drop(inode);
	inode->i_blocks = 0;
	reiserfs_write_unlock_once(inode->i_sb, depth);

no_delete:
	end_writeback(inode);
	dquot_drop(inode);
}
<snip>

When goto out path is taken,

end_writeback(inode);
dquot_drop(inode);

are executed twice, leading to page fault (in my case) during the kernel boot.

Add return; before no_delete label (but I am not quite sure that this is correct :-).

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

====================================================================
--- a/fs/reiserfs/inode.c	2010-08-17 09:51:27.000000000 +0300
+++ b/fs/reiserfs/inode.c	2010-08-17 10:45:20.000000000 +0300
@@ -78,11 +78,12 @@ void reiserfs_evict_inode(struct inode *
 		/* no object items are in the tree */
 		;
 	}
-      out:
+out:
 	end_writeback(inode);	/* note this must go after the journal_end to prevent deadlock */
 	dquot_drop(inode);
 	inode->i_blocks = 0;
 	reiserfs_write_unlock_once(inode->i_sb, depth);
+	return;
 
 no_delete:
 	end_writeback(inode);
