Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1GZJEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:04:14 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52004
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459Ab1GZJEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:04:09 -0400
Date: Tue, 26 Jul 2011 05:03:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
        Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] vfs: dont chain pipe/anon/socket on superblock s_inodes
 list
Message-ID: <20110726090357.GA13013@infradead.org>
References: <20110718155141.GA11013@ZenIV.linux.org.uk>
 <1311093158.2707.75.camel@schen9-DESK>
 <20110721204042.GB31405@ZenIV.linux.org.uk>
 <1311294452.2576.18.camel@schen9-DESK>
 <20110723132411.GA22183@infradead.org>
 <1311633550.2576.33.camel@schen9-DESK>
 <20110725225154.GD22133@ZenIV.linux.org.uk>
 <1311636178.2576.34.camel@schen9-DESK>
 <1311660013.2996.6.camel@edumazet-laptop>
 <1311668466.2355.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311668466.2355.12.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 10:21:06AM +0200, Eric Dumazet wrote:
> Well, not 'last' contention point, as we still hit remove_inode_hash(),

There should be no ned to put pipe or anon inodes on the inode hash.
Probably sockets don't need it either, but I'd need to look at it in
detail.

> inode_wb_list_del()

The should never be on the wb list either, doing an unlocked check for
actually beeing on the list before taking the lock should help you.

> inode_lru_list_del(),

No real need to keep inodes in the LRU if we only allocate them using
new_inode but never look them up either.  You might want to try setting
.drop_inode to generic_delete_inode for these.

> +struct inode *__new_inode(struct super_block *sb)
> +{
> +	struct inode *inode = alloc_inode(sb);
> +
> +	if (inode) {
> +		spin_lock(&inode->i_lock);
> +		inode->i_state = 0;
> +		spin_unlock(&inode->i_lock);
> +		INIT_LIST_HEAD(&inode->i_sb_list);
> +	}
> +	return inode;
> +}

This needs a much better name like new_inode_pseudo, and a kerneldoc 
comment explaining when it is safe to use, and the consequences, which
appear to me:

 - fs may never be unmount
 - quotas can't work on the filesystem
 - writeback can't work on the filesystem

> @@ -814,13 +829,9 @@ struct inode *new_inode(struct super_block *sb)
>  
>  	spin_lock_prefetch(&inode_sb_list_lock);
>  
> -	inode = alloc_inode(sb);
> -	if (inode) {
> -		spin_lock(&inode->i_lock);
> -		inode->i_state = 0;
> -		spin_unlock(&inode->i_lock);
> -		inode_sb_list_add(inode);
> -	}
> +	inode = __new_inode(sb);
> +	if (inode)
> +			inode_sb_list_add(inode);

bad indentation.

