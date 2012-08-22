Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab2HVV1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:27:10 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:33413 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2HVV1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:27:06 -0400
Subject: Re: [PATCH v6 01/13] block: Generalized bio pool freeing
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        target-devel <target-devel@vger.kernel.org>
In-Reply-To: <1345655050-28199-2-git-send-email-koverstreet@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
	 <1345655050-28199-2-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Aug 2012 14:27:03 -0700
Message-ID: <1345670823.10190.21.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 10:03 -0700, Kent Overstreet wrote:
> With the old code, when you allocate a bio from a bio pool you have to
> implement your own destructor that knows how to find the bio pool the
> bio was originally allocated from.
> 
> This adds a new field to struct bio (bi_pool) and changes
> bio_alloc_bioset() to use it. This makes various bio destructors
> unnecessary, so they're then deleted.
> 
> v6: Explain the temporary if statement in bio_put
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: NeilBrown <neilb@suse.de>
> CC: Alasdair Kergon <agk@redhat.com>
> CC: Nicholas Bellinger <nab@linux-iscsi.org>
> CC: Lars Ellenberg <lars.ellenberg@linbit.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/block/drbd/drbd_main.c      | 13 +------------
>  drivers/md/dm-crypt.c               |  9 ---------
>  drivers/md/dm-io.c                  | 11 -----------
>  drivers/md/dm.c                     | 20 --------------------
>  drivers/md/md.c                     | 28 ++++------------------------
>  drivers/target/target_core_iblock.c |  9 ---------
>  fs/bio.c                            | 31 +++++++++++++------------------
>  include/linux/blk_types.h           |  3 +++
>  8 files changed, 21 insertions(+), 103 deletions(-)
> 

<SNIP>

> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index 76db75e..e58cd7d 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -543,14 +543,6 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
>  	kfree(ibr);
>  }
>  
> -static void iblock_bio_destructor(struct bio *bio)
> -{
> -	struct se_cmd *cmd = bio->bi_private;
> -	struct iblock_dev *ib_dev = cmd->se_dev->dev_ptr;
> -
> -	bio_free(bio, ib_dev->ibd_bio_set);
> -}
> -
>  static struct bio *
>  iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
>  {
> @@ -572,7 +564,6 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
>  
>  	bio->bi_bdev = ib_dev->ibd_bd;
>  	bio->bi_private = cmd;
> -	bio->bi_destructor = iblock_bio_destructor;
>  	bio->bi_end_io = &iblock_bio_done;
>  	bio->bi_sector = lba;
>  	return bio;

The change to drop iblock_bio_destructor() looks fine to me.  For the
drivers/target/ bit, feel free to add:

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

Nice work Kent!

