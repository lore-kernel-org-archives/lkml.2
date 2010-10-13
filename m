Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0JMNcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:32:15 -0400
Received: from canuck.infradead.org ([134.117.69.58]:58851 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0JMNcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:32:13 -0400
Date: Wed, 13 Oct 2010 09:32:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/18] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101013133213.GC5263@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-4-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  			 */
>  			redirty_tail(inode);
> -		} else if (atomic_read(&inode->i_count)) {
> -			/*
> -			 * The inode is clean, inuse
> -			 */
> -			list_move(&inode->i_list, &inode_in_use);
>  		} else {
> -			/*
> -			 * The inode is clean, unused
> -			 */
> -			list_move(&inode->i_list, &inode_unused);
> +			/* The inode is clean */
> +			list_del_init(&inode->i_list);
> +			inode_lru_list_add(inode);

Just noticed this when reviewing a later patch: why do we lose the
i_count check here?  There's no point in adding an inode that is still
in use onto the LRU - we'll just remove it again once we find it
during LRU scanning.

