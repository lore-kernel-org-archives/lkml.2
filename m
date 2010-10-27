Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696Ab0J0I6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:58:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611Ab0J0I6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:58:30 -0400
Date: Wed, 27 Oct 2010 04:58:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] fs: protect inode->i_state with inode->i_lock
Message-ID: <20101027085826.GA16443@infradead.org>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
 <1288153384-8878-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288153384-8878-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 03:23:01PM +1100, Dave Chinner wrote:
>  	spin_lock(&inode_lock);
>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> -		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> +		spin_lock(&inode->i_lock);
> +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
> +			spin_unlock(&inode->i_lock);
>  			continue;
> +		}
> +		spin_unlock(&inode->i_lock);
>  		if (inode->i_mapping->nrpages == 0)
>  			continue;
>  		__iget(inode);

If you want to remove inode_lock from the lru scanning later you already
need to extend i_lock coverage to include __iget here.  Otherwise we
could race to mark the inode as I_FREEING or I_WILL_FREE before we
grabbed a reference after your patchset. 
