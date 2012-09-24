Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab2IXThI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:37:08 -0400
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:40474 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757516Ab2IXThG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:37:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120925000217.947b8cd8dca6979bfedee2ca@canb.auug.org.au>
References: <20120925000217.947b8cd8dca6979bfedee2ca@canb.auug.org.au>
From: Roland Dreier <roland@purestorage.com>
Date: Mon, 24 Sep 2012 12:36:43 -0700
Message-ID: <CAL1RGDUCThiu+vxy4d5QXvqfDCDUnHOBfZT97XB+Qy_bQrxCRg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Amir Vadai <amirv@mellanox.co.il>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 7:02 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> drivers/infiniband/hw/mlx4/cm.c: In function 'id_map_alloc':
> drivers/infiniband/hw/mlx4/cm.c:228:36: error: 'MAX_ID_MASK' undeclared (first use in this function)
>
> Caused by commit d7a4e9b679e9 ("IB/mlx4: Add CM paravirtualization") from
> the infiniband tree interacting with commit "idr: rename MAX_LEVEL to
> MAX_IDR_LEVEL" from the akpm tree.
>
> I have added the following merge fix patch for today:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 24 Sep 2012 23:57:53 +1000
> Subject: [PATCH] IB/mlx4: fix for MAX_ID_MASK to MAX_IDR_MASK name change
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/infiniband/hw/mlx4/cm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
> index e25e4da..80079e5 100644
> --- a/drivers/infiniband/hw/mlx4/cm.c
> +++ b/drivers/infiniband/hw/mlx4/cm.c
> @@ -225,7 +225,7 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
>                 ret = idr_get_new_above(&sriov->pv_id_table, ent,
>                                         next_id, &id);
>                 if (!ret) {
> -                       next_id = ((unsigned) id + 1) & MAX_ID_MASK;
> +                       next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
>                         ent->pv_cm_id = (u32)id;
>                         sl_id_map_add(ibdev, ent);
>                 }

Andrew, any preference on how to handle this merge?

Jack/Amir, I wonder if there's some way we can avoid this code
entirely?  Is an IDR the right structure to use here, or would we
be better off with a radix tree maybe (where we can assign our
own ID)?

 - R.
