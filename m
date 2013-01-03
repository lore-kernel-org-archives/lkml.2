Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3ACQ1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:27:55 -0500
Received: from linode.aoot.com ([69.164.194.13]:52676 "EHLO linode.aoot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab3ACQ1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:27:53 -0500
Message-ID: <50E5B183.4030706@opengridcomputing.com>
Date: Thu, 03 Jan 2013 10:27:47 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH -v2 09/26] infiniband: rename random32() to prandom_u32()
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com> <1357215562-6288-10-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1357215562-6288-10-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are there other "non pseudo-random" services that warrant this rename?

On 1/3/2013 6:19 AM, Akinobu Mita wrote:
> Use more preferable function name which implies using a pseudo-random
> number generator.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Roland Dreier <roland@kernel.org>
> Cc: Sean Hefty <sean.hefty@intel.com>
> Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
> Cc: Steve Wise <swise@chelsio.com>
> Cc: linux-rdma@vger.kernel.org
> ---
>
> * Change from v1
> - leave net_random() callers as-is because that is a useful indirection
>
>   drivers/infiniband/hw/cxgb3/cxio_resource.c | 4 ++--
>   drivers/infiniband/hw/cxgb4/id_table.c      | 4 ++--
>   drivers/infiniband/hw/mlx4/mad.c            | 2 +-
>   drivers/infiniband/ulp/ipoib/ipoib_cm.c     | 2 +-
>   4 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb3/cxio_resource.c b/drivers/infiniband/hw/cxgb3/cxio_resource.c
> index 31f9201..c40088e 100644
> --- a/drivers/infiniband/hw/cxgb3/cxio_resource.c
> +++ b/drivers/infiniband/hw/cxgb3/cxio_resource.c
> @@ -62,13 +62,13 @@ static int __cxio_init_resource_fifo(struct kfifo *fifo,
>   		kfifo_in(fifo, (unsigned char *) &entry, sizeof(u32));
>   	if (random) {
>   		j = 0;
> -		random_bytes = random32();
> +		random_bytes = prandom_u32();
>   		for (i = 0; i < RANDOM_SIZE; i++)
>   			rarray[i] = i + skip_low;
>   		for (i = skip_low + RANDOM_SIZE; i < nr - skip_high; i++) {
>   			if (j >= RANDOM_SIZE) {
>   				j = 0;
> -				random_bytes = random32();
> +				random_bytes = prandom_u32();
>   			}
>   			idx = (random_bytes >> (j * 2)) & 0xF;
>   			kfifo_in(fifo,
> diff --git a/drivers/infiniband/hw/cxgb4/id_table.c b/drivers/infiniband/hw/cxgb4/id_table.c
> index f95e5df..0161ae6 100644
> --- a/drivers/infiniband/hw/cxgb4/id_table.c
> +++ b/drivers/infiniband/hw/cxgb4/id_table.c
> @@ -54,7 +54,7 @@ u32 c4iw_id_alloc(struct c4iw_id_table *alloc)
>   
>   	if (obj < alloc->max) {
>   		if (alloc->flags & C4IW_ID_TABLE_F_RANDOM)
> -			alloc->last += random32() % RANDOM_SKIP;
> +			alloc->last += prandom_u32() % RANDOM_SKIP;
>   		else
>   			alloc->last = obj + 1;
>   		if (alloc->last >= alloc->max)
> @@ -88,7 +88,7 @@ int c4iw_id_table_alloc(struct c4iw_id_table *alloc, u32 start, u32 num,
>   	alloc->start = start;
>   	alloc->flags = flags;
>   	if (flags & C4IW_ID_TABLE_F_RANDOM)
> -		alloc->last = random32() % RANDOM_SKIP;
> +		alloc->last = prandom_u32() % RANDOM_SKIP;
>   	else
>   		alloc->last = 0;
>   	alloc->max  = num;
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
> index 0a903c1..b247c5b 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -93,7 +93,7 @@ static void __propagate_pkey_ev(struct mlx4_ib_dev *dev, int port_num,
>   __be64 mlx4_ib_gen_node_guid(void)
>   {
>   #define NODE_GUID_HI	((u64) (((u64)IB_OPENIB_OUI) << 40))
> -	return cpu_to_be64(NODE_GUID_HI | random32());
> +	return cpu_to_be64(NODE_GUID_HI | prandom_u32());
>   }
>   
>   __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx)
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> index 03103d2..0e0016d 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
> @@ -460,7 +460,7 @@ static int ipoib_cm_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *even
>   		goto err_qp;
>   	}
>   
> -	psn = random32() & 0xffffff;
> +	psn = prandom_u32() & 0xffffff;
>   	ret = ipoib_cm_modify_rx_qp(dev, cm_id, p->qp, psn);
>   	if (ret)
>   		goto err_modify;

