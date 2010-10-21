Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab0JUPW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:22:58 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:55958 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab0JUPWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:22:53 -0400
Date: Thu, 21 Oct 2010 17:22:34 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH 1/2] BKL: remove BKL from qnx4
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <201010211538.24733.arnd@arndb.de>
	<201010211550.34289.arnd@arndb.de>
In-Reply-To: <201010211550.34289.arnd@arndb.de> (from arnd@arndb.de on Thu
	Oct 21 15:49:59 2010)
X-Mailer: Balsa 2.3.14
Message-Id: <1287674554l.10972l.0l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-21 15:49:59, Arnd Bergmann wrote:
> All uses of the BKL in qnx4 were the result of a pushdown into
> code that doesn't really need it. As Christoph points out, this
> is a read-only file system, which eliminates most of the races in
> readdir/lookup.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Anders Larsen <al@alarsen.net>
> Cc: Christoph Hellwig <hch@infradead.org>

Acked-by: Anders Larsen <al@alarsen.net>

> ---
>  fs/qnx4/dir.c   |    3 ---
>  fs/qnx4/inode.c |   14 +-------------
>  fs/qnx4/namei.c |    4 ----
>  3 files changed, 1 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
> index 6e8fc62..06de116 100644
> --- a/fs/qnx4/dir.c
> +++ b/fs/qnx4/dir.c
> @@ -11,7 +11,6 @@
>   * 20-06-1998 by Frank Denis : Linux 2.1.99+ & dcache support.
>   */
>  
> -#include <linux/smp_lock.h>
>  #include <linux/buffer_head.h>
>  #include "qnx4.h"
>  
> @@ -29,8 +28,6 @@ static int qnx4_readdir(struct file *filp, void *dirent, filldir_t filldir)
>  	QNX4DEBUG((KERN_INFO "qnx4_readdir:i_size = %ld\n", (long) inode->i_size));
>  	QNX4DEBUG((KERN_INFO "filp->f_pos         = %ld\n", (long) filp->f_pos));
>  
> -	lock_kernel();
> -
>  	while (filp->f_pos < inode->i_size) {
>  		blknum = qnx4_block_map( inode, filp->f_pos >> QNX4_BLOCK_SIZE_BITS );
>  		bh = sb_bread(inode->i_sb, blknum);
> diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
> index 86a7be1..01bad30 100644
> --- a/fs/qnx4/inode.c
> +++ b/fs/qnx4/inode.c
> @@ -16,7 +16,6 @@
>  #include <linux/init.h>
>  #include <linux/slab.h>
>  #include <linux/highuid.h>
> -#include <linux/smp_lock.h>
>  #include <linux/pagemap.h>
>  #include <linux/buffer_head.h>
>  #include <linux/writeback.h>
> @@ -157,8 +156,6 @@ static int qnx4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	struct super_block *sb = dentry->d_sb;
>  	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
>  
> -	lock_kernel();
> -
>  	buf->f_type    = sb->s_magic;
>  	buf->f_bsize   = sb->s_blocksize;
>  	buf->f_blocks  = le32_to_cpu(qnx4_sb(sb)->BitMap->di_size) * 8;
> @@ -168,8 +165,6 @@ static int qnx4_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_fsid.val[0] = (u32)id;
>  	buf->f_fsid.val[1] = (u32)(id >> 32);
>  
> -	unlock_kernel();
> -
>  	return 0;
>  }
>  
> @@ -234,13 +229,9 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
>  	struct qnx4_sb_info *qs;
>  	int ret = -EINVAL;
>  
> -	lock_kernel();
> -
>  	qs = kzalloc(sizeof(struct qnx4_sb_info), GFP_KERNEL);
> -	if (!qs) {
> -		unlock_kernel();
> +	if (!qs)
>  		return -ENOMEM;
> -	}
>  	s->s_fs_info = qs;
>  
>  	sb_set_blocksize(s, QNX4_BLOCK_SIZE);
> @@ -287,8 +278,6 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
>   		goto outi;
>  
>  	brelse(bh);
> -
> -	unlock_kernel();
>  	return 0;
>  
>        outi:
> @@ -298,7 +287,6 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
>        outnobh:
>  	kfree(qs);
>  	s->s_fs_info = NULL;
> -	unlock_kernel();
>  	return ret;
>  }
>  
> diff --git a/fs/qnx4/namei.c b/fs/qnx4/namei.c
> index 58703eb..275327b 100644
> --- a/fs/qnx4/namei.c
> +++ b/fs/qnx4/namei.c
> @@ -12,7 +12,6 @@
>   * 04-07-1998 by Frank Denis : first step for rmdir/unlink.
>   */
>  
> -#include <linux/smp_lock.h>
>  #include <linux/buffer_head.h>
>  #include "qnx4.h"
>  
> @@ -109,7 +108,6 @@ struct dentry * qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nam
>  	int len = dentry->d_name.len;
>  	struct inode *foundinode = NULL;
>  
> -	lock_kernel();
>  	if (!(bh = qnx4_find_entry(len, dir, name, &de, &ino)))
>  		goto out;
>  	/* The entry is linked, let's get the real info */
> @@ -123,13 +121,11 @@ struct dentry * qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nam
>  
>  	foundinode = qnx4_iget(dir->i_sb, ino);
>  	if (IS_ERR(foundinode)) {
> -		unlock_kernel();
>  		QNX4DEBUG((KERN_ERR "qnx4: lookup->iget -> error %ld\n",
>  			   PTR_ERR(foundinode)));
>  		return ERR_CAST(foundinode);
>  	}
>  out:
> -	unlock_kernel();
>  	d_add(dentry, foundinode);
>  
>  	return NULL;
> -- 
> 1.7.1

