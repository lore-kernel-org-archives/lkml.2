Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0DLXoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:44:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754314Ab0DLXoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:44:21 -0400
Date: Mon, 12 Apr 2010 16:44:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Blunck <jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] JFS: Free sbi memory in error path
Message-Id: <20100412164408.0df38c01.akpm@linux-foundation.org>
In-Reply-To: <1271090417-19408-1-git-send-email-jblunck@suse.de>
References: <1271090417-19408-1-git-send-email-jblunck@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Apr 2010 18:40:17 +0200
Jan Blunck <jblunck@suse.de> wrote:

> I spotted the missing kfree() while removing the BKL.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> ---
>  fs/jfs/super.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> index 266699d..a402b7d 100644
> --- a/fs/jfs/super.c
> +++ b/fs/jfs/super.c
> @@ -457,6 +457,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	if (newLVSize) {
>  		printk(KERN_ERR "resize option for remount only\n");
> +		kfree(sbi);
>  		return -EINVAL;
>  	}

It'd be best to remove those multiple return statements so that leaks
of this nature are less likely to be reintroduced:


From: Jan Blunck <jblunck@suse.de>

I spotted the missing kfree() while removing the BKL.

[akpm@linux-foundation.org: avoid multiple returns so it doesn't happen again]
Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/super.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/jfs/super.c~jfs-free-sbi-memory-in-error-path fs/jfs/super.c
--- a/fs/jfs/super.c~jfs-free-sbi-memory-in-error-path
+++ a/fs/jfs/super.c
@@ -446,10 +446,8 @@ static int jfs_fill_super(struct super_b
 	/* initialize the mount flag and determine the default error handler */
 	flag = JFS_ERR_REMOUNT_RO;
 
-	if (!parse_options((char *) data, sb, &newLVSize, &flag)) {
-		kfree(sbi);
-		return -EINVAL;
-	}
+	if (!parse_options((char *) data, sb, &newLVSize, &flag))
+		goto out_kfree;
 	sbi->flag = flag;
 
 #ifdef CONFIG_JFS_POSIX_ACL
@@ -458,7 +456,7 @@ static int jfs_fill_super(struct super_b
 
 	if (newLVSize) {
 		printk(KERN_ERR "resize option for remount only\n");
-		return -EINVAL;
+		goto out_kfree;
 	}
 
 	/*
@@ -478,7 +476,7 @@ static int jfs_fill_super(struct super_b
 	inode = new_inode(sb);
 	if (inode == NULL) {
 		ret = -ENOMEM;
-		goto out_kfree;
+		goto out_unload;
 	}
 	inode->i_ino = 0;
 	inode->i_nlink = 1;
@@ -550,9 +548,10 @@ out_mount_failed:
 	make_bad_inode(sbi->direct_inode);
 	iput(sbi->direct_inode);
 	sbi->direct_inode = NULL;
-out_kfree:
+out_unload:
 	if (sbi->nls_tab)
 		unload_nls(sbi->nls_tab);
+out_kfree:
 	kfree(sbi);
 	return ret;
 }
_

