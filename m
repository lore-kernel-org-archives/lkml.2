Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab2IYJAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:00:11 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:47846 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2IYJAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:00:08 -0400
Date: Tue, 25 Sep 2012 16:59:55 +0800
From: Guo Chao <yan@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@infradead.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v4 Patch 0/4] fs/inode.c: optimization for inode lock usage
Message-ID: <20120925085955.GA15073@yanx>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
 <20120921224912.GA20960@dastard>
 <20120924024221.GB7984@yanx>
 <20120924042343.GC20960@dastard>
 <20120924061205.GA27244@yanx>
 <20120924062812.GD20960@dastard>
 <20120924070852.GA10280@yanx>
 <20120924082654.GG20960@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924082654.GG20960@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092509-5564-0000-0000-0000049B7EFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 06:26:54PM +1000, Dave Chinner wrote:
> @@ -783,14 +783,19 @@ static void __wait_on_freeing_inode(struct inode *inode);
>  static struct inode *find_inode(struct super_block *sb,
>  				struct hlist_head *head,
>  				int (*test)(struct inode *, void *),
> -				void *data)
> +				void *data, bool locked)
>  {
>  	struct hlist_node *node;
>  	struct inode *inode = NULL;
> 
>  repeat:
> -	hlist_for_each_entry(inode, node, head, i_hash) {
> +	rcu_read_lock();
> +	hlist_for_each_entry_rcu(inode, node, head, i_hash) {
>  		spin_lock(&inode->i_lock);
> +		if (inode_unhashed(inode)) {
> +			spin_unlock(&inode->i_lock);
> +			continue;
> +		}

Is this check too early? If the unhashed inode happened to be the target
inode, we are wasting our time to continue the traversal and we do not wait 
on it.

> @@ -1078,8 +1098,7 @@ struct inode *iget_locked(struct super_block *sb, unsigned long ino)
>  		struct inode *old;
> 
>  		spin_lock(&inode_hash_lock);
> -		/* We released the lock, so.. */
> -		old = find_inode_fast(sb, head, ino);
> +		old = find_inode_fast(sb, head, ino, true);
>  		if (!old) {
>  			inode->i_ino = ino;
>  			spin_lock(&inode->i_lock);

Emmmm ... couldn't we use memory barrier API instead of irrelevant spin
lock on newly allocated inode to publish I_NEW?

I go through many mails of the last trend of scaling VFS. Many patches
seem quite natural, say RCU inode lookup or per-bucket inode hash lock or 
per-superblock inode list lock, did not get merged. I wonder what
stopped them back then and what has changed that (part of) them can be
considered again.

Regards,
Guo Chao

