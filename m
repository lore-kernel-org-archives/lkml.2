Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1G1El0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 00:41:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49700 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1G1ElS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 00:41:18 -0400
Subject: Re: [PATCH] vfs: avoid taking locks if inode not in lists
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>, Andi Kleen <andi@firstfloor.org>,
        Matthew Wilcox <matthew@wil.cx>, Anton Blanchard <anton@samba.org>,
        npiggin@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <20110727204415.GA13308@infradead.org>
References: <1311294452.2576.18.camel@schen9-DESK>
	 <20110723132411.GA22183@infradead.org>
	 <1311633550.2576.33.camel@schen9-DESK>
	 <20110725225154.GD22133@ZenIV.linux.org.uk>
	 <1311636178.2576.34.camel@schen9-DESK>
	 <1311660013.2996.6.camel@edumazet-laptop>
	 <1311668466.2355.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110726090357.GA13013@infradead.org>
	 <1311672994.2355.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1311780065.2356.18.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110727204415.GA13308@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 06:41:09 +0200
Message-ID: <1311828069.2697.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 juillet 2011 à 16:44 -0400, Christoph Hellwig a écrit :
> On Wed, Jul 27, 2011 at 05:21:05PM +0200, Eric Dumazet wrote:
> > If I am not mistaken, we can add unlocked checks on the three hot spots.
> > 
> > After following patch, a close(socket(PF_INET, SOCK_DGRAM, 0)) pair on
> > my dev machine takes ~3us instead of ~9us.
> > 
> > Maybe its better to split it in three patches, just let me know.
> 
> I think three patches would be a lot cleaner.
> 
> As for safety of the unlocked checks:
> 
>  - inode are either hashed when created or never, so that one looks
>    fine.
>  - same for the sb list.
>  - the writeback list is a bit more dynamic as we move things around
>    quite a bit.  But in additon to the inode_wb_list_del call from
>    evict() it only ever gets remove in writeback_single_inode, which
>    for a freeing inode can only be called from the callers of evict().
> 
> Btw, I wonder if you should micro-optimize things a bit further by
> moving the unhashed checks from the deletion functions into the callers
> and thus save a function call for each of them.
> 

What about following patch, addressing the micro-optimization and Andi
Kleen concern about evict() readability ?

Thanks !

[PATCH] vfs: avoid taking inode_hash_lock on pipes and sockets

Some inodes (pipes, sockets, ...) are not hashed, no need to take
contended inode_hash_lock at dismantle time.

nice speedup on SMP machines on socket intensive workloads.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 fs/inode.c         |    6 +++---
 include/linux/fs.h |    9 ++++++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index d0c72ff..73b5598 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -399,12 +399,12 @@ void __insert_inode_hash(struct inode *inode, unsigned long hashval)
 EXPORT_SYMBOL(__insert_inode_hash);
 
 /**
- *	remove_inode_hash - remove an inode from the hash
+ *	__remove_inode_hash - remove an inode from the hash
  *	@inode: inode to unhash
  *
  *	Remove an inode from the superblock.
  */
-void remove_inode_hash(struct inode *inode)
+void __remove_inode_hash(struct inode *inode)
 {
 	spin_lock(&inode_hash_lock);
 	spin_lock(&inode->i_lock);
@@ -412,7 +412,7 @@ void remove_inode_hash(struct inode *inode)
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&inode_hash_lock);
 }
-EXPORT_SYMBOL(remove_inode_hash);
+EXPORT_SYMBOL(__remove_inode_hash);
 
 void end_writeback(struct inode *inode)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f23bcb7..786b3b1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2317,11 +2317,18 @@ extern int should_remove_suid(struct dentry *);
 extern int file_remove_suid(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
-extern void remove_inode_hash(struct inode *);
 static inline void insert_inode_hash(struct inode *inode)
 {
 	__insert_inode_hash(inode, inode->i_ino);
 }
+
+extern void __remove_inode_hash(struct inode *);
+static inline void remove_inode_hash(struct inode *inode)
+{
+	if (!inode_unhashed(inode))
+		__remove_inode_hash(inode);
+}
+
 extern void inode_sb_list_add(struct inode *inode);
 
 #ifdef CONFIG_BLOCK


