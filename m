Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab0GNS2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:28:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab0GNS2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:28:44 -0400
Date: Wed, 14 Jul 2010 14:28:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: don't block on buffer read errors
Message-ID: <20100714182836.GA12108@infradead.org>
References: <1279007450-10457-1-git-send-email-david@fromorbit.com>
 <1279007450-10457-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279007450-10457-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, except that I'd rework the snipplet below

>  	status = xfs_buf_iorequest(bp);
> -	if (!status && !(flags & XBF_ASYNC))
> +	if (!(status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC)))
>  		status = xfs_buf_iowait(bp);
>  	return status;

as:

	if (status || XFS_BUF_ISERROR(bp) || (flags & XBF_ASYNC))
		return status;
	return xfs_buf_iowait(bp);

to make it a bit more clear.
