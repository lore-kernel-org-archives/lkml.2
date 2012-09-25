Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2IYIW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:22:56 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49206 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab2IYIWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:22:51 -0400
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: Roland Dreier <roland@purestorage.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Date: Tue, 25 Sep 2012 10:27:23 +0200
User-Agent: KMail/1.9.1
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Amir Vadai <amirv@mellanox.co.il>, linux-rdma@vger.kernel.org
References: <20120925000217.947b8cd8dca6979bfedee2ca@canb.auug.org.au> <CAL1RGDUCThiu+vxy4d5QXvqfDCDUnHOBfZT97XB+Qy_bQrxCRg@mail.gmail.com>
In-Reply-To: <CAL1RGDUCThiu+vxy4d5QXvqfDCDUnHOBfZT97XB+Qy_bQrxCRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201209251027.23840.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,
I am on vacation until next Tuesday -- I'll look at this then.

-Jack


On Monday 24 September 2012 21:36, Roland Dreier wrote:
> On Mon, Sep 24, 2012 at 7:02 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > After merging the akpm tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > drivers/infiniband/hw/mlx4/cm.c: In function 'id_map_alloc':
> > drivers/infiniband/hw/mlx4/cm.c:228:36: error: 'MAX_ID_MASK' undeclared (first use in this function)
> >
> > Caused by commit d7a4e9b679e9 ("IB/mlx4: Add CM paravirtualization") from
> > the infiniband tree interacting with commit "idr: rename MAX_LEVEL to
> > MAX_IDR_LEVEL" from the akpm tree.
> >
> > I have added the following merge fix patch for today:
> >
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 24 Sep 2012 23:57:53 +1000
> > Subject: [PATCH] IB/mlx4: fix for MAX_ID_MASK to MAX_IDR_MASK name change
> >
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/infiniband/hw/mlx4/cm.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
> > index e25e4da..80079e5 100644
> > --- a/drivers/infiniband/hw/mlx4/cm.c
> > +++ b/drivers/infiniband/hw/mlx4/cm.c
> > @@ -225,7 +225,7 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
> >                 ret = idr_get_new_above(&sriov->pv_id_table, ent,
> >                                         next_id, &id);
> >                 if (!ret) {
> > -                       next_id = ((unsigned) id + 1) & MAX_ID_MASK;
> > +                       next_id = ((unsigned) id + 1) & MAX_IDR_MASK;
> >                         ent->pv_cm_id = (u32)id;
> >                         sl_id_map_add(ibdev, ent);
> >                 }
> 
> Andrew, any preference on how to handle this merge?
> 
> Jack/Amir, I wonder if there's some way we can avoid this code
> entirely?  Is an IDR the right structure to use here, or would we
> be better off with a radix tree maybe (where we can assign our
> own ID)?
> 
>  - R.
> 
