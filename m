Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab0EZR5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:57:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17189 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab0EZR5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:57:02 -0400
Message-ID: <4BFD6076.9000005@oracle.com>
Date: Wed, 26 May 2010 10:55:02 -0700
From: Andy Grover <andy.grover@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: "David S. Miller" <davem@davemloft.net>, rds-devel@oss.oracle.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 1/17] net/rds: Add missing mutex_unlock
References: <Pine.LNX.4.64.1005261754030.23743@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005261754030.23743@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090208.4BFD60E9.013E:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Zach Brown <zach.brown@oracle.com>
Acked-by: Andy Grover <andy.grover@oracle.com>

-- Andy

On 05/26/2010 08:54 AM, Julia Lawall wrote:
> From: Julia Lawall<julia@diku.dk>
>
> Add a mutex_unlock missing on the error path.  In each case, whenever the
> label out is reached from elsewhere in the function, mutex is not locked.
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> //<smpl>
> @@
> expression E1;
> @@
>
> * mutex_lock(E1);
>    <+... when != E1
>    if (...) {
>      ... when != E1
> *   return ...;
>    }
>    ...+>
> * mutex_unlock(E1);
> //</smpl>
>
> Signed-off-by: Julia Lawall<julia@diku.dk>
>
> ---
>   net/rds/ib_cm.c |    1 +
>   net/rds/iw_cm.c |    1 +
>   2 files changed, 2 insertions(+)
>
> diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
> index 10ed0d5..f688327 100644
> --- a/net/rds/ib_cm.c
> +++ b/net/rds/ib_cm.c
> @@ -475,6 +475,7 @@ int rds_ib_cm_handle_connect(struct rdma_cm_id *cm_id,
>   	err = rds_ib_setup_qp(conn);
>   	if (err) {
>   		rds_ib_conn_error(conn, "rds_ib_setup_qp failed (%d)\n", err);
> +		mutex_unlock(&conn->c_cm_lock);
>   		goto out;
>   	}
>
> diff --git a/net/rds/iw_cm.c b/net/rds/iw_cm.c
> index a9d951b..b5dd6ac 100644
> --- a/net/rds/iw_cm.c
> +++ b/net/rds/iw_cm.c
> @@ -452,6 +452,7 @@ int rds_iw_cm_handle_connect(struct rdma_cm_id *cm_id,
>   	err = rds_iw_setup_qp(conn);
>   	if (err) {
>   		rds_iw_conn_error(conn, "rds_iw_setup_qp failed (%d)\n", err);
> +		mutex_unlock(&conn->c_cm_lock);
>   		goto out;
>   	}
>

