Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab0ENJt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 05:49:28 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:52703 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754537Ab0ENJt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 05:49:26 -0400
Subject: [PATCH] fs: inode.c use atomic_inc_return in __iget
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 10:49:22 +0100
Message-ID: <1273830562.1986.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using atomic_inc_return in __iget(struct inode *inode) makes the intent
of this code clearer and generates less code on processors that have
this operation.
   
On x86_64 this patch reduces the text size of inode.o by 12 bytes.
   
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

----
patch against 2.6.34-rc7
compiled & tested on x86_64 AMD X2

I've been running with this patch applied for several weeks with no
obvious problems.
regards
Richard



diff --git a/fs/inode.c b/fs/inode.c
index 407bf39..b405028 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -286,11 +286,9 @@ static void init_once(void *foo)
  */
 void __iget(struct inode *inode)
 {
-	if (atomic_read(&inode->i_count)) {
-		atomic_inc(&inode->i_count);
+	if (atomic_inc_return(&inode->i_count) != 1)
 		return;
-	}
-	atomic_inc(&inode->i_count);
+
 	if (!(inode->i_state & (I_DIRTY|I_SYNC)))
 		list_move(&inode->i_list, &inode_in_use);
 	inodes_stat.nr_unused--;


