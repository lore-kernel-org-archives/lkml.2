Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab2BQTPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:15:31 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:57987
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494Ab2BQTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:15:30 -0500
Date: Fri, 17 Feb 2012 14:15:23 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
        xfs@oss.sgi.com, Nam-Jae Jeon <linkinjeon@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix buffer flushing during log unmount
Message-ID: <20120217191522.GB13870@infradead.org>
References: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Whenever there is a mount/unmount failure - there is a chance of calling the
> callbacks functions once - transaction ail mount pointer is destroyed. So, it results
> in NULL pointer exception followed by hang. So, before unmount of the log - flush all
> the pending buffers.

>  void
>  xfs_log_unmount(xfs_mount_t *mp)
>  {
> +	int error = 0;
> +	/*
> +	 * Make sure all buffers have been flushed and completed before
> +	 * unmounting the log.
> +	 */
> +	error = xfs_flush_buftarg(mp->m_ddev_targp, 1);
> +	if (error)
> +		cmn_err(CE_WARN, "%d busy buffers during log unmount.", error);
> +	xfs_wait_buftarg(mp->m_ddev_targp);
> +	

We do exactly that sequence before the xfs_log_unmount_write call on
umount.  Care to explain what code in xfs_log_unmount_write would
require this to be called again?

