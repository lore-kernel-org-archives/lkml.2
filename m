Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab0JAFyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:54:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0JAFye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:54:34 -0400
Date: Fri, 1 Oct 2010 01:54:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/17] fs: icache lock i_state
Message-ID: <20101001055433.GC32349@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285762729-17928-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		spin_lock(&inode->i_lock);
> +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)
> +				|| inode->i_mapping->nrpages == 0) {


This is some pretty strange formatting.

		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
		    inode->i_mapping->nrpages == 0) {

would be more standard.

>  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>  		struct address_space *mapping;
>  
> -		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> -			continue;
>  		mapping = inode->i_mapping;
>  		if (mapping->nrpages == 0)
>  			continue;
> +		spin_lock(&inode->i_lock);
> +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
> +			spin_unlock(&inode->i_lock);
> +			continue;
> +		}

Can we access the mapping safely when the inode isn't actually fully
setup?  Even if we can I'd rather not introduce this change hidden
inside an unrelated patch.

