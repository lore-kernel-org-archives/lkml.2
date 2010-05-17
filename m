Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0EQC0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 22:26:35 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35289 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab0EQC0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 22:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W1rZ6q2ZNnKsQzCX+4C0T7pq7jPZBqnNzocirstKOZYwLoxWROJz4HrREEEtK8foMR
         GNwdZQnZ8V4SaHfrkTrWvW3cYcLUhc4QwyJjWdC2AWo/zPA1ZeW6H7ZRNEVQqtJ/6ZRE
         uSLtVGCPhODBGtIjcYhc4spPG+utzX1jM2QIw=
Date: Mon, 17 May 2010 04:26:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/6] smbfs: BKL ioctl pushdown
Message-ID: <20100517022635.GF22299@nowhere>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com> <1273065339-21669-6-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273065339-21669-6-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 03:15:38PM +0200, John Kacur wrote:
> Convert smb_ioctl to an unlocked ioctl and push down the bkl into it.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>


Applied, thanks.



> ---
>  fs/smbfs/dir.c   |    2 +-
>  fs/smbfs/file.c  |    2 +-
>  fs/smbfs/ioctl.c |   10 +++++++---
>  fs/smbfs/proto.h |    2 +-
>  4 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
> index 3e4803b..6c97842 100644
> --- a/fs/smbfs/dir.c
> +++ b/fs/smbfs/dir.c
> @@ -39,7 +39,7 @@ const struct file_operations smb_dir_operations =
>  {
>  	.read		= generic_read_dir,
>  	.readdir	= smb_readdir,
> -	.ioctl		= smb_ioctl,
> +	.unlocked_ioctl	= smb_ioctl,
>  	.open		= smb_dir_open,
>  };
>  
> diff --git a/fs/smbfs/file.c b/fs/smbfs/file.c
> index dbf6548..84ecf0e 100644
> --- a/fs/smbfs/file.c
> +++ b/fs/smbfs/file.c
> @@ -437,7 +437,7 @@ const struct file_operations smb_file_operations =
>  	.aio_read	= smb_file_aio_read,
>  	.write		= do_sync_write,
>  	.aio_write	= smb_file_aio_write,
> -	.ioctl		= smb_ioctl,
> +	.unlocked_ioctl	= smb_ioctl,
>  	.mmap		= smb_file_mmap,
>  	.open		= smb_file_open,
>  	.release	= smb_file_release,
> diff --git a/fs/smbfs/ioctl.c b/fs/smbfs/ioctl.c
> index dbae1f8..dfc3a94 100644
> --- a/fs/smbfs/ioctl.c
> +++ b/fs/smbfs/ioctl.c
> @@ -19,17 +19,19 @@
>  #include <linux/smb_mount.h>
>  
>  #include <asm/uaccess.h>
> +#include <linux/smp_lock.h>
>  
>  #include "proto.h"
>  
> -int
> -smb_ioctl(struct inode *inode, struct file *filp,
> -	  unsigned int cmd, unsigned long arg)
> +long smb_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
> +	struct inode *inode = filp->f_dentry->d_inode;
>  	struct smb_sb_info *server = server_from_inode(inode);
>  	struct smb_conn_opt opt;
>  	int result = -EINVAL;
>  
> +	lock_kernel();
> +
>  	switch (cmd) {
>  		uid16_t uid16;
>  		uid_t uid32;
> @@ -63,5 +65,7 @@ smb_ioctl(struct inode *inode, struct file *filp,
>  		break;
>  	}
>  
> +	unlock_kernel();
> +
>  	return result;
>  }
> diff --git a/fs/smbfs/proto.h b/fs/smbfs/proto.h
> index 03f456c..05939a6 100644
> --- a/fs/smbfs/proto.h
> +++ b/fs/smbfs/proto.h
> @@ -67,7 +67,7 @@ extern const struct address_space_operations smb_file_aops;
>  extern const struct file_operations smb_file_operations;
>  extern const struct inode_operations smb_file_inode_operations;
>  /* ioctl.c */
> -extern int smb_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);
> +extern long smb_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
>  /* smbiod.c */
>  extern void smbiod_wake_up(void);
>  extern int smbiod_register_server(struct smb_sb_info *server);
> -- 
> 1.6.6.1
> 

