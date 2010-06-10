Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab0FJI1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 04:27:20 -0400
Received: from verein.lst.de ([213.95.11.210]:39452 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab0FJI1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 04:27:17 -0400
Date: Thu, 10 Jun 2010 10:27:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tao Ma <tao.ma@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joel Becker <joel.becker@oracle.com>, Christoph Hellwig <hch@lst.de>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH v3] ocfs2: Let ocfs2_setattr use new truncate sequence.
Message-ID: <20100610082711.GA2173@lst.de>
References: <20100610044234.GD26335@laptop> <1276146485-9346-1-git-send-email-tao.ma@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276146485-9346-1-git-send-email-tao.ma@oracle.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 01:08:05PM +0800, Tao Ma wrote:
> Let ocfs2 use the new truncate sequence. The changes include:
> 1. Use truncate_setsize directly since we don't implement our
>    own ->truncate and what we need is "update i_size and
>    truncate_pagecache" which truncate_setsize now does.
> 2. For direct write, ocfs2 actually don't allow write to pass
>    i_size(see ocfs2_prepare_inode_for_write), so we don't have
>    a chance to increase i_size. So remove the bogus check.

You just leave the duplicate inode_newsize_ok in, but still have
one as part of inode_change_ok.  See the previous thread - we'll
need to move inode_change_ok to under the cluster locks, both
for the truncate and non-truncate case.

>  	/*
> +	 * Since all the work for a size change has been done above.
> +	 * Call truncate_setsize directly to change size and truncate
> +	 * pagecache.
>  	 */
>  	if ((attr->ia_valid & ATTR_SIZE) &&
> +	    attr->ia_size != inode->i_size)

this could be on one line now.

> +		truncate_setsize(inode, attr->ia_size);

But any reason this isn't done inside the

        if (size_change && attr->ia_size != inode->i_size) {

conditional above?  You'll never get size and uid/gid changes in the
same request, so there won't be any change in behaviour.


