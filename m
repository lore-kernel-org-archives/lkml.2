Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2JIB5C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 21:57:02 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:60013 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab2JIB44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 21:56:56 -0400
MIME-Version: 1.0
In-Reply-To: <20121009011106.GA17038@kernel.org>
References: <20121009011106.GA17038@kernel.org>
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 8 Oct 2012 21:56:35 -0400
X-Google-Sender-Auth: LAtV5JXlSzBv9tcKBq0BTO2rA5s
Message-ID: <CAMM=eLcw8-r7iYSYG4uhJd_Q1rRYifye8T-Wv4PR9hQjF8j9gQ@mail.gmail.com>
Subject: Re: [patch]block: add plug for blkdev_issue_discard
To: Shaohua Li <shli@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 9:11 PM, Shaohua Li <shli@kernel.org> wrote:
> Now discard merge works, add plug for blkdev_issue_discard. This will help
> discard request merge especially for raid0 case. In raid0, a big discard
> request is split to small requests, and if correct plug is added, such small
> requests can be merged in low layer.
>
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  block/blk-lib.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> Index: linux/block/blk-lib.c
> ===================================================================
> --- linux.orig/block/blk-lib.c  2012-09-28 15:09:38.655327319 +0800
> +++ linux/block/blk-lib.c       2012-10-09 08:45:04.358598888 +0800
> @@ -48,6 +48,7 @@ int blkdev_issue_discard(struct block_de
>         struct bio_batch bb;
>         struct bio *bio;
>         int ret = 0;
> +       struct blk_plug plug;
>
>         if (!q)
>                 return -ENXIO;
> @@ -81,6 +82,7 @@ int blkdev_issue_discard(struct block_de
>         bb.flags = 1 << BIO_UPTODATE;
>         bb.wait = &wait;
>
> +       blk_start_plug(&plug);
>         while (nr_sects) {
>                 unsigned int req_sects;
>                 sector_t end_sect;
> @@ -117,6 +119,7 @@ int blkdev_issue_discard(struct block_de
>                 atomic_inc(&bb.done);
>                 submit_bio(type, bio);
>         }
> +       blk_finish_plug(&plug);
>
>         /* Wait for bios in-flight */
>         if (!atomic_dec_and_test(&bb.done))

That plug looks rather coarse-grained.  Any adverse affects when mkfs
discards an entire (large) raid0 device?  (I suspect not but figured
I'd ask)
