Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab2GQIF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:05:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49460 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2GQIFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:05:17 -0400
Date: Tue, 17 Jul 2012 16:13:51 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] ext4: locking issue on error path
Message-ID: <20120717081351.GA4513@gmail.com>
Mail-Followup-To: Dan Carpenter <dan.carpenter@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20120717063106.GA14985@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717063106.GA14985@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 09:31:06AM +0300, Dan Carpenter wrote:
> We recently changed how the locking worked here, but this error path was
> missed.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Sorry, it is my fault.  Thanks for pointing out this bug.

Regards,
Zheng

> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8c84070..2728fb7 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3031,8 +3031,10 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  		if (!is_sync_kiocb(iocb)) {
>  			ext4_io_end_t *io_end =
>  				ext4_init_io_end(inode, GFP_NOFS);
> -			if (!io_end)
> -				return -ENOMEM;
> +			if (!io_end) {
> +				ret = -ENOMEM;
> +				goto retake_lock;
> +			}
>  			io_end->flag |= EXT4_IO_END_DIRECT;
>  			iocb->private = io_end;
>  			/*
> @@ -3094,6 +3096,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
>  			ext4_clear_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
>  		}
>  
> +retake_lock:
>  		/* take i_mutex locking again if we do a ovewrite dio */
>  		if (overwrite) {
>  			up_read(&EXT4_I(inode)->i_data_sem);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
