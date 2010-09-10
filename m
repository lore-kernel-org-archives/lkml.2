Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0IJMnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 08:43:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab0IJMnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 08:43:10 -0400
Date: Fri, 10 Sep 2010 08:46:29 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 15/30] smbfs: Convert server->sem to mutex
Message-ID: <20100910084629.239dc62f@corrin.poochiereds.net>
In-Reply-To: <20100907125056.136212826@linutronix.de>
References: <20100907124636.880953480@linutronix.de>
	<20100907125056.136212826@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010 14:32:52 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> server->sem is used as mutex so make it a mutex.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> 
> ---
>  fs/smbfs/inode.c          |    2 +-
>  include/linux/smb_fs_sb.h |    8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/fs/smbfs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/smbfs/inode.c
> +++ linux-2.6/fs/smbfs/inode.c
> @@ -536,7 +536,7 @@ static int smb_fill_super(struct super_b
>  	server->mnt = NULL;
>  	server->sock_file = NULL;
>  	init_waitqueue_head(&server->conn_wq);
> -	init_MUTEX(&server->sem);
> +	mutex_init(&server->mutex);
>  	INIT_LIST_HEAD(&server->entry);
>  	INIT_LIST_HEAD(&server->xmitq);
>  	INIT_LIST_HEAD(&server->recvq);
> Index: linux-2.6/include/linux/smb_fs_sb.h
> ===================================================================
> --- linux-2.6.orig/include/linux/smb_fs_sb.h
> +++ linux-2.6/include/linux/smb_fs_sb.h
> @@ -58,7 +58,7 @@ struct smb_sb_info {
>  	struct smb_conn_opt opt;
>  	wait_queue_head_t conn_wq;
>  	int conn_complete;
> -	struct semaphore sem;
> +	struct mutex mutex;
>  
>  	unsigned char      header[SMB_HEADER_LEN + 20*2 + 2];
>  	u32                header_len;
> @@ -82,19 +82,19 @@ struct smb_sb_info {
>  static inline int
>  smb_lock_server_interruptible(struct smb_sb_info *server)
>  {
> -	return down_interruptible(&(server->sem));
> +	return mutex_lock_interruptible(&server->mutex);
>  }
>  
>  static inline void
>  smb_lock_server(struct smb_sb_info *server)
>  {
> -	down(&(server->sem));
> +	mutex_lock(&server->mutex);
>  }
>  
>  static inline void
>  smb_unlock_server(struct smb_sb_info *server)
>  {
> -	up(&(server->sem));
> +	mutex_unlock(&server->mutex);
>  }
>  
>  #endif
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Seems harmless...

Acked-by: Jeff Layton <jlayton@redhat.com>
