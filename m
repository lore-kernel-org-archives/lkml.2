Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2KSSFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 13:05:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47077 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2KSSFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 13:05:10 -0500
Date: Mon, 19 Nov 2012 12:04:58 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH review 14/16] proc: Generalize proc inode allocation
Message-ID: <20121119180458.GD1883@serge-ThinkPad-X130e>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
 <1353337961-12962-14-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353337961-12962-14-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Generalize the proc inode allocation so that it can be
> used without having to having to create a proc_dir_entry.
> 
> This will allow namespace file descriptors to remain light
> weight entitities but still have the same inode number
> when the backing namespace is the same.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  fs/proc/generic.c       |   26 +++++++++++++-------------
>  include/linux/proc_fs.h |   10 ++++++++++
>  2 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 0d80cef..7b3ae3c 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -350,14 +350,14 @@ static DEFINE_SPINLOCK(proc_inum_lock); /* protects the above */
>   * Return an inode number between PROC_DYNAMIC_FIRST and
>   * 0xffffffff, or zero on failure.
>   */
> -static unsigned int get_inode_number(void)
> +int proc_alloc_inum(unsigned int *inum)
>  {
>  	unsigned int i;
>  	int error;
>  
>  retry:
> -	if (ida_pre_get(&proc_inum_ida, GFP_KERNEL) == 0)
> -		return 0;
> +	if (!ida_pre_get(&proc_inum_ida, GFP_KERNEL))
> +		return -ENOMEM;
>  
>  	spin_lock(&proc_inum_lock);
>  	error = ida_get_new(&proc_inum_ida, &i);
> @@ -365,18 +365,19 @@ retry:
>  	if (error == -EAGAIN)
>  		goto retry;
>  	else if (error)
> -		return 0;
> +		return error;
>  
>  	if (i > UINT_MAX - PROC_DYNAMIC_FIRST) {
>  		spin_lock(&proc_inum_lock);
>  		ida_remove(&proc_inum_ida, i);
>  		spin_unlock(&proc_inum_lock);
> -		return 0;
> +		return -ENOSPC;
>  	}
> -	return PROC_DYNAMIC_FIRST + i;
> +	*inum = PROC_DYNAMIC_FIRST + i;
> +	return 0;
>  }
>  
> -static void release_inode_number(unsigned int inum)
> +void proc_free_inum(unsigned int inum)
>  {
>  	spin_lock(&proc_inum_lock);
>  	ida_remove(&proc_inum_ida, inum - PROC_DYNAMIC_FIRST);
> @@ -554,13 +555,12 @@ static const struct inode_operations proc_dir_inode_operations = {
>  
>  static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp)
>  {
> -	unsigned int i;
>  	struct proc_dir_entry *tmp;
> +	int ret;
>  	
> -	i = get_inode_number();
> -	if (i == 0)
> -		return -EAGAIN;
> -	dp->low_ino = i;
> +	ret = proc_alloc_inum(&dp->low_ino);
> +	if (ret)
> +		return ret;
>  
>  	if (S_ISDIR(dp->mode)) {
>  		if (dp->proc_iops == NULL) {
> @@ -764,7 +764,7 @@ EXPORT_SYMBOL(proc_create_data);
>  
>  static void free_proc_entry(struct proc_dir_entry *de)
>  {
> -	release_inode_number(de->low_ino);
> +	proc_free_inum(de->low_ino);
>  
>  	if (S_ISLNK(de->mode))
>  		kfree(de->data);
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 3144781..bf1d000 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -176,6 +176,8 @@ extern struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
>  extern struct file *proc_ns_fget(int fd);
>  extern bool proc_ns_inode(struct inode *inode);
>  
> +extern int proc_alloc_inum(unsigned int *pino);
> +extern void proc_free_inum(unsigned int inum);
>  #else
>  
>  #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
> @@ -235,6 +237,14 @@ static inline bool proc_ns_inode(struct inode *inode)
>  	return false;
>  }
>  
> +static inline int proc_alloc_inum(unsigned int *inum)
> +{
> +	*inum = 1;
> +	return 0;
> +}
> +static inline void proc_free_inum(unsigned int inum)
> +{
> +}
>  #endif /* CONFIG_PROC_FS */
>  
>  #if !defined(CONFIG_PROC_KCORE)
> -- 
> 1.7.5.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
