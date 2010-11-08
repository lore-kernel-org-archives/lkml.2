Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0KHLK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:10:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab0KHLK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:10:27 -0500
Date: Mon, 8 Nov 2010 06:10:23 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 4/4] fs: rcu protect inode hash lookups
Message-ID: <20101108111023.GA1797@infradead.org>
References: <1289201305-14866-1-git-send-email-david@fromorbit.com>
 <1289201305-14866-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289201305-14866-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	hlist_add_fake(&inode->i_hash);
> +	hlist_nulls_add_fake(&inode->i_hash);

Please add a preparatory inode_fake_hash/inode_mark_hashed or similar
helper to isolate filesystems from the implementation details of the
hash list.

> +	/*
> +	 * reset the inode number so during RCU traversals we do not match this
> +	 * inode in any lookups until it is fully re-initialised again during
> +	 * allocation.
> +	 */
> +	inode->i_ino = 0;

There is no hard rule that i_ino is an invalid inode number.  It can
happen quite easily for inodes using the generic last_ino allocator,
and I would not be surprised if there's some filesystems using it as
part of the on disk layour either.

> +			rcu_read_unlock();
> +			if (locked)
> +				spin_unlock(&inode_hash_lock);
>  			__wait_on_freeing_inode(inode);
> +			if (locked)
> +				spin_lock(&inode_hash_lock);

I can't say I like the locked argument, but I don't see an easy way
around it.  Can you at least keept the unlocking/relocking inside
__wait_on_freeing_inode so that it's centralized in a single place for
both find_inode pathes?

While at it moving __wait_on_freeing_inode to be above ifind would
making changes in this area a lot easier to read, so maybe you can throw
in a patch for that, too?

>  static struct inode *ifind(struct super_block *sb,
> -		struct hlist_head *head, int (*test)(struct inode *, void *),
> +		struct hlist_nulls_head *head, int chain,
> +		int (*test)(struct inode *, void *),
>  		void *data, const int wait)
>  {
>  	struct inode *inode;
>  
> -	spin_lock(&inode_hash_lock);
> -	inode = find_inode(sb, head, test, data);
> +	inode = find_inode(sb, head, chain, test, data, false);
>  	if (inode) {
> -		spin_unlock(&inode_hash_lock);
>  		if (likely(wait))
>  			wait_on_inode(inode);
>  		return inode;
>  	}
> -	spin_unlock(&inode_hash_lock);
>  	return NULL;
>  }

This is starting to get a rather pointless helper.  I'd suggest just
killing ifind/ifind_fast and opencoding them in the caller, possibly
as a preparatory patch.

