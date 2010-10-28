Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097Ab0J1OTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:19:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab0J1OTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:19:51 -0400
Date: Thu, 28 Oct 2010 10:19:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] fs: move i_wb_list out from under inode_lock
Message-ID: <20101028141949.GB19174@infradead.org>
References: <1288266161-28897-1-git-send-email-david@fromorbit.com>
 <1288266161-28897-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288266161-28897-3-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * Write out an inode's dirty pages.  Called under inode_wb_list_lock.  Either
> + * the caller has ref on the inode (either via __iget or via syscall against an
> + * fd) or the inode has I_WILL_FREE set.

Just drop mentioning of how we got the reference ,it's rather pointless.

>  writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
> @@ -354,7 +368,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  	inode->i_state |= I_SYNC;
>  	inode->i_state &= ~I_DIRTY_PAGES;
>  	spin_unlock(&inode->i_lock);
> -	spin_unlock(&inode_lock);
> +	spin_unlock(&inode_wb_list_lock);

We don't actually need inode_wb_list_lock here.  But I guess we can
fix this later and be conservative for now.

> @@ -963,63 +976,62 @@ void __mark_inode_dirty(struct inode *inode, int flags)

I think the __mark_inode_dirty cleanup should be a separate patch,
it's rather confusing in the current form.

> +	if (was_dirty) {
> +out_unlock_inode:
>  		spin_unlock(&inode->i_lock);
> +		return;
> +	}

Please just move the label to the end of the function and add another
goto here.

