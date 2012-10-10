Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab2JJHTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 03:19:09 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55549 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab2JJHS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 03:18:59 -0400
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] IB/lmx4: silence GCC warning
Date: Wed, 10 Oct 2012 09:23:43 +0200
User-Agent: KMail/1.9.1
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1348836538.3626.21.camel@x61.thuisdomein>
In-Reply-To: <1348836538.3626.21.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201210100923.43927.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You could use:

   u16 uninitialized_var(vlan);

instead.

Although this in the special QP data flow, I still prefer to avoid adding extra code (even setting
initial values at procedure entry).  The line above will also do the job.  "uninitialized_var"
is used elsewhere in the driver.  See, for example, mlx4_ib_post_send() in the same file (qp.c).

-Jack

On Friday 28 September 2012 14:48, Paul Bolle wrote:
> Building qp.o (part of the "Mellanox ConnectX HCA support" driver)
> triggers this GCC warning:
>     drivers/infiniband/hw/mlx4/qp.c: In function ‘mlx4_ib_post_send’:
>     drivers/infiniband/hw/mlx4/qp.c:1828:30: warning: ‘vlan’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>     drivers/infiniband/hw/mlx4/qp.c:1718:6: note: ‘vlan’ was declared here
> 
> Looking at the code it is clear 'vlan' is only set and used if 'is_eth'
> is non-zero. But there's no harm in initializing 'vlan' to 0 (which
> matches ib_get_cached_gid()'s default return) to silence GCC.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) I noticed this warning while building v3.6-rc7 on current Fedora 17,
> using Fedora's default config.
> 
> 1) Compile tested only. I tested against v3.6-rc7, with commit
> a41262bb5721f2b708ee8b23f67be2f2e16a2fab ("IB/mlx4: SR-IOV IB context
> objects and proxy/tunnel SQP") from linux-next cherry-picked, to take
> into account a trivial context change in linux-next.
> 
>  drivers/infiniband/hw/mlx4/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
> index a862251..71fdda6 100644
> --- a/drivers/infiniband/hw/mlx4/qp.c
> +++ b/drivers/infiniband/hw/mlx4/qp.c
> @@ -1715,7 +1715,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
>  	int is_eth;
>  	int is_vlan = 0;
>  	int is_grh;
> -	u16 vlan;
> +	u16 vlan = 0;
>  	int err = 0;
>  
>  	send_size = 0;
