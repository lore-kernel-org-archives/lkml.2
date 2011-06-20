Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1FTNWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:22:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab1FTNWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:22:17 -0400
Date: Mon, 20 Jun 2011 15:21:44 +0200
From: Frantisek Hrbata <fhrbata@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] get_write_access()/deny_write_access() without
 inode->i_lock
Message-ID: <20110620132144.GB26576@dhcp-26-164.brq.redhat.com>
Reply-To: Frantisek Hrbata <fhrbata@redhat.com>
References: <20110619235147.GQ11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110619235147.GQ11521@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 12:51:47AM +0100, Al Viro wrote:
> 	I'm seriously tempted to throw away i_lock uses in
> {get,deny}_write_access(), as in the patch below.  The question is, how
> badly will it suck on various architectures?  I'd expect it to be not
> worse than the current version, but...
> 	BTW, I wonder if we need barriers in {put,allow}_write_access (in
> either version).
> 
> 	Related question: would it make sense to turn that into
> atomic_inc_unless_negative/atomic_dec_unless_positive?  I don't
> remember any code doing that kind of stuff - no idea if there are
> any potential users for that.
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 26bef77..7dffe2e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -341,52 +341,6 @@ ok:
>  	return security_inode_exec_permission(inode, flags);
>  }
>  
> -/*
> - * get_write_access() gets write permission for a file.
> - * put_write_access() releases this write permission.
> - * This is used for regular files.
> - * We cannot support write (and maybe mmap read-write shared) accesses and
> - * MAP_DENYWRITE mmappings simultaneously. The i_writecount field of an inode
> - * can have the following values:
> - * 0: no writers, no VM_DENYWRITE mappings
> - * < 0: (-i_writecount) vm_area_structs with VM_DENYWRITE set exist
> - * > 0: (i_writecount) users are writing to the file.
> - *
> - * Normally we operate on that counter with atomic_{inc,dec} and it's safe
> - * except for the cases where we don't hold i_writecount yet. Then we need to
> - * use {get,deny}_write_access() - these functions check the sign and refuse
> - * to do the change if sign is wrong. Exclusion between them is provided by
> - * the inode->i_lock spinlock.
> - */
> -
> -int get_write_access(struct inode * inode)
> -{
> -	spin_lock(&inode->i_lock);
> -	if (atomic_read(&inode->i_writecount) < 0) {
> -		spin_unlock(&inode->i_lock);
> -		return -ETXTBSY;
> -	}
> -	atomic_inc(&inode->i_writecount);
> -	spin_unlock(&inode->i_lock);
> -
> -	return 0;
> -}
> -
> -int deny_write_access(struct file * file)
> -{
> -	struct inode *inode = file->f_path.dentry->d_inode;
> -
> -	spin_lock(&inode->i_lock);
> -	if (atomic_read(&inode->i_writecount) > 0) {
> -		spin_unlock(&inode->i_lock);
> -		return -ETXTBSY;
> -	}
> -	atomic_dec(&inode->i_writecount);
> -	spin_unlock(&inode->i_lock);
> -
> -	return 0;
> -}
> -
>  /**
>   * path_get - get a reference to a path
>   * @path: path to get the reference to
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7302e44..ab89aa3 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2194,8 +2194,43 @@ static inline bool execute_ok(struct inode *inode)
>  	return (inode->i_mode & S_IXUGO) || S_ISDIR(inode->i_mode);
>  }
>  
> -extern int get_write_access(struct inode *);
> -extern int deny_write_access(struct file *);
> +/*
> + * get_write_access() gets write permission for a file.
> + * put_write_access() releases this write permission.
> + * This is used for regular files.
> + * We cannot support write (and maybe mmap read-write shared) accesses and
> + * MAP_DENYWRITE mmappings simultaneously. The i_writecount field of an inode
> + * can have the following values:
> + * 0: no writers, no VM_DENYWRITE mappings
> + * < 0: (-i_writecount) vm_area_structs with VM_DENYWRITE set exist
> + * > 0: (i_writecount) users are writing to the file.
> + *
> + * Normally we operate on that counter with atomic_{inc,dec} and it's safe
> + * except for the cases where we don't hold i_writecount yet. Then we need to
> + * use {get,deny}_write_access() - these functions check the sign and refuse
> + * to do the change if sign is wrong.
> + */
> +static inline int get_write_access(struct inode *inode)
> +{
> +	int v, v1;
> +	for (v = atomic_read(&inode->i_writecount); v >= 0; v = v1) {
> +		v1 = atomic_cmpxchg(&inode->i_writecount, v, v + 1);
> +		if (likely(v1 == v))
> +			return 0;
> +	}
> +	return -ETXTBSY;
> +}
> +static inline int deny_write_access(struct file *file)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	int v, v1;
> +	for (v = atomic_read(&inode->i_writecount); v <= 0; v = v1) {
> +		v1 = atomic_cmpxchg(&inode->i_writecount, v, v + 1);
                                                             ^^^^^
Shouldn't i_writecount be decreased here. Looks like cut & paste problem to
me. Please ignore if I'm wrong.

> +		if (likely(v1 == v))
> +			return 0;
> +	}
> +	return -ETXTBSY;
> +}
>  static inline void put_write_access(struct inode * inode)
>  {
>  	atomic_dec(&inode->i_writecount);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Frantisek Hrbata
