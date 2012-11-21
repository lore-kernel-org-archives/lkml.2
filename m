Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab2KUIFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:05:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab2KUIFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:05:39 -0500
Date: Wed, 21 Nov 2012 00:05:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
Message-Id: <20121121000533.a0ab9eea.akpm@linux-foundation.org>
In-Reply-To: <20121121014851.GH10507@quack.suse.cz>
References: <8762541uyx.fsf@devron.myhome.or.jp>
	<873906vumh.fsf@devron.myhome.or.jp>
	<20121119145140.GA20532@quack.suse.cz>
	<20121119194102.GB20532@quack.suse.cz>
	<87a9udtiyk.fsf@devron.myhome.or.jp>
	<20121119212448.GA29498@quack.suse.cz>
	<876251tg3b.fsf@devron.myhome.or.jp>
	<20121121011111.GE10507@quack.suse.cz>
	<20121121014851.GH10507@quack.suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 02:48:51 +0100 Jan Kara <jack@suse.cz> wrote:

> +/*
> + * Add inode to LRU if needed (inode is unused and clean).
> + *
> + * Needs inode->i_lock held.
> + */
> +void inode_add_lru(struct inode *inode)
> +{
> +	if (!(inode->i_state & (I_DIRTY | I_FREEING | I_SYNC)) &&
> +	    !atomic_read(&inode->i_count) && inode->i_sb->s_flags & MS_ACTIVE)
> +		inode_lru_list_add(inode);
> +}

Is i_lock sufficient to stabilise i_count?

<looks at the code a bit>

Is evict_inodes() wrong to test i_count outside i_lock?

invalidate_inodes() looks better.

can_unuse() must be called under i_lock, and is.  Apparently this
requirement was sufficiently obvious to not meed documenting.

prune_icache_sb() gets it right.

iput() gets it right.

So to answer my own question: yes, it is sufficient.  But a) the
comment for inode.i_lock is out of date and b) evict_inodes() looks
fishy.

