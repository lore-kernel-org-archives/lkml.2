Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab0KHPcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:32:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab0KHPcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:32:14 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dio: track and serialise unaligned direct IO
References: <1289202023-15102-1-git-send-email-david@fromorbit.com>
	<1289202023-15102-2-git-send-email-david@fromorbit.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Nov 2010 10:28:29 -0500
In-Reply-To: <1289202023-15102-2-git-send-email-david@fromorbit.com> (Dave
	Chinner's message of "Mon, 8 Nov 2010 18:40:21 +1100")
Message-ID: <x4962w7al7m.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> +struct dio_zero_block {
> +	struct list_head dio_list;	/* list of io in progress */
> +	sector_t	zero_block;	/* block being zeroed */
> +	struct dio	*dio;		/* owner dio */
> +	wait_queue_head_t wq;		/* New IO block here */
                      New IOs block here, or new IO blocks here?

> +/*
> + * Add a filesystem block to the list of blocks we are tracking.
> + */
> +static void
> +dio_start_zero_block(struct dio *dio, sector_t zero_block)
> +{
> +	struct dio_zero_block *zb;
> +
> +	zb = kmalloc(sizeof(*zb), GFP_NOIO);
> +	if (!zb)
> +		return;
> +	INIT_LIST_HEAD(&zb->dio_list);
> +	init_waitqueue_head(&zb->wq);
> +	zb->zero_block = zero_block;
> +	zb->dio = dio;
> +	atomic_set(&zb->ref, 1);
> +
> +	spin_lock(&dio_zero_block_lock);
> +	list_add(&zb->dio_list, &dio_zero_block_list);
> +	spin_unlock(&dio_zero_block_lock);

What protects from two processes getting here at the same time, and
hence adding the same block to the list?  i_mutex?

> @@ -1210,6 +1343,13 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  	 */
>  	memset(dio, 0, offsetof(struct dio, pages));
>  
> +	/*
> +	 * zero_blocks need to initialised to largeѕt value to avoid
                              ^ be
