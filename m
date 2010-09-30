Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab0I3WPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 18:15:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756592Ab0I3WP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 18:15:27 -0400
Date: Fri, 1 Oct 2010 00:14:30 +0200
From: Jan Kara <jack@suse.cz>
To: Jan Andres <jandres@gmx.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] isofs: Fix lseek() to position beyond 4 GB
Message-ID: <20100930221429.GF3573@quack.suse.cz>
References: <20100803211814.GA4436@pitr.home.jan>
 <20100804205245.GA5312@pitr.home.jan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804205245.GA5312@pitr.home.jan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 04-08-10 22:52:46, Jan Andres wrote:
> isofs supports files larger than 4 GB by using multi-extent files.
> However an lseek() to a position beyond 4 GB in such a file will
> fail with EINVAL, because s_maxbytes in the isofs superblock is
> initialized to 2^32-1, and generic_file_llseek() checks against
> that value.
> 
> I therefore suggest increasing the value of s_maxbytes to have
> full support for large files in isofs. With multi-extent files, file
> size is only limited by the maximum size of the file system (8 TB),
> so this seems a reasonable value for s_maxbytes.
  OK, I had a look into the relevant code and it seems that the isofs
code should properly handle files upto 4TB and with a small fix (attached)
upto 8TB as you claim. So I'll take your patch and merge it with Linus.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--

>From 258d9d44217700e2a7b513b9a029ad28daeca7b0 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 1 Oct 2010 00:05:33 +0200
Subject: [PATCH] isofs: Fix isofs_get_blocks for 8TB files

Currently isofs_get_blocks() was limited to handle only 4TB files on 32-bit
architectures because of unnecessary use of iblock variable which was signed
long. Just remove the variable. The error messages that were using this
variable should have rather used b_off anyway because that is the block we
are currently mapping.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/isofs/inode.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index d8a68e7..a2de39d 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -962,26 +962,23 @@ static int isofs_statfs (struct dentry *dentry, struct kstatfs *buf)
  * or getblk() if they are not.  Returns the number of blocks inserted
  * (-ve == error.)
  */
-int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
+int isofs_get_blocks(struct inode *inode, sector_t iblock,
 		     struct buffer_head **bh, unsigned long nblocks)
 {
-	unsigned long b_off;
+	unsigned long b_off = iblock;
 	unsigned offset, sect_size;
 	unsigned int firstext;
 	unsigned long nextblk, nextoff;
-	long iblock = (long)iblock_s;
 	int section, rv, error;
 	struct iso_inode_info *ei = ISOFS_I(inode);
 
 	error = -EIO;
 	rv = 0;
-	if (iblock < 0 || iblock != iblock_s) {
+	if (iblock != b_off) {
 		printk(KERN_DEBUG "%s: block number too large\n", __func__);
 		goto abort;
 	}
 
-	b_off = iblock;
-
 	offset = 0;
 	firstext = ei->i_first_extent;
 	sect_size = ei->i_section_size >> ISOFS_BUFFER_BITS(inode);
@@ -998,8 +995,9 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 		 * I/O errors.
 		 */
 		if (b_off > ((inode->i_size + PAGE_CACHE_SIZE - 1) >> ISOFS_BUFFER_BITS(inode))) {
-			printk(KERN_DEBUG "%s: block >= EOF (%ld, %ld)\n",
-				__func__, iblock, (unsigned long) inode->i_size);
+			printk(KERN_DEBUG "%s: block >= EOF (%lu, %llu)\n",
+				__func__, b_off,
+				(unsigned long long)inode->i_size);
 			goto abort;
 		}
 
@@ -1025,9 +1023,9 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 			if (++section > 100) {
 				printk(KERN_DEBUG "%s: More than 100 file sections ?!?"
 					" aborting...\n", __func__);
-				printk(KERN_DEBUG "%s: block=%ld firstext=%u sect_size=%u "
+				printk(KERN_DEBUG "%s: block=%lu firstext=%u sect_size=%u "
 					"nextblk=%lu nextoff=%lu\n", __func__,
-					iblock, firstext, (unsigned) sect_size,
+					b_off, firstext, (unsigned) sect_size,
 					nextblk, nextoff);
 				goto abort;
 			}
-- 
1.6.4.2

