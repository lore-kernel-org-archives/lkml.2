Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031665Ab2I1TrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:47:04 -0400
Received: from mx2.netapp.com ([216.240.18.37]:26189 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030262Ab2I1TrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:47:00 -0400
X-IronPort-AV: E=Sophos;i="4.80,503,1344236400"; 
   d="scan'208";a="695347353"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Dick Streefland <dick.streefland@altium.nl>
Subject: Re: [ 089/262] SUNRPC: Fix a UDP transport regression
Thread-Topic: [ 089/262] SUNRPC: Fix a UDP transport regression
Thread-Index: AQHNnatEib0LnDpgI06SN+myU1eULZegnguA
Date: Fri, 28 Sep 2012 19:46:57 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908FF37D3@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120928182957.993484211@linuxfoundation.org>
	 <20120928183008.625737819@linuxfoundation.org>
In-Reply-To: <20120928183008.625737819@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <51B7C1BC6582DC42BE1EBBDCFE7BB926@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8SJl90R014203

On Fri, 2012-09-28 at 11:50 -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> 3.5-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> commit f39c1bfb5a03e2d255451bff05be0d7255298fa4 upstream.
> 
> Commit 43cedbf0e8dfb9c5610eb7985d5f21263e313802 (SUNRPC: Ensure that
> we grab the XPRT_LOCK before calling xprt_alloc_slot) is causing
> hangs in the case of NFS over UDP mounts.
> 
> Since neither the UDP or the RDMA transport mechanism use dynamic slot
> allocation, we can skip grabbing the socket lock for those transports.
> Add a new rpc_xprt_op to allow switching between the TCP and UDP/RDMA
> case.
> 
> Note that the NFSv4.1 back channel assigns the slot directly
> through rpc_run_bc_task, so we can ignore that case.
> 
> Reported-by: Dick Streefland <dick.streefland@altium.nl>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  include/linux/sunrpc/xprt.h     |    3 +++
>  net/sunrpc/xprt.c               |   34 ++++++++++++++++++++--------------
>  net/sunrpc/xprtrdma/transport.c |    1 +
>  net/sunrpc/xprtsock.c           |    3 +++
>  4 files changed, 27 insertions(+), 14 deletions(-)
> 
> --- a/include/linux/sunrpc/xprt.h
> +++ b/include/linux/sunrpc/xprt.h
> @@ -114,6 +114,7 @@ struct rpc_xprt_ops {
>  	void		(*set_buffer_size)(struct rpc_xprt *xprt, size_t sndsize, size_t rcvsize);
>  	int		(*reserve_xprt)(struct rpc_xprt *xprt, struct rpc_task *task);
>  	void		(*release_xprt)(struct rpc_xprt *xprt, struct rpc_task *task);
> +	void		(*alloc_slot)(struct rpc_xprt *xprt, struct rpc_task *task);
>  	void		(*rpcbind)(struct rpc_task *task);
>  	void		(*set_port)(struct rpc_xprt *xprt, unsigned short port);
>  	void		(*connect)(struct rpc_task *task);
> @@ -279,6 +280,8 @@ void			xprt_connect(struct rpc_task *tas
>  void			xprt_reserve(struct rpc_task *task);
>  int			xprt_reserve_xprt(struct rpc_xprt *xprt, struct rpc_task *task);
>  int			xprt_reserve_xprt_cong(struct rpc_xprt *xprt, struct rpc_task *task);
> +void			xprt_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task);
> +void			xprt_lock_and_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task);
>  int			xprt_prepare_transmit(struct rpc_task *task);
>  void			xprt_transmit(struct rpc_task *task);
>  void			xprt_end_transmit(struct rpc_task *task);
> --- a/net/sunrpc/xprt.c
> +++ b/net/sunrpc/xprt.c
> @@ -969,11 +969,11 @@ static bool xprt_dynamic_free_slot(struc
>  	return false;
>  }
>  
> -static void xprt_alloc_slot(struct rpc_task *task)
> +void xprt_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
>  {
> -	struct rpc_xprt	*xprt = task->tk_xprt;
>  	struct rpc_rqst *req;
>  
> +	spin_lock(&xprt->reserve_lock);
>  	if (!list_empty(&xprt->free)) {
>  		req = list_entry(xprt->free.next, struct rpc_rqst, rq_list);
>  		list_del(&req->rq_list);
> @@ -994,12 +994,29 @@ static void xprt_alloc_slot(struct rpc_t
>  	default:
>  		task->tk_status = -EAGAIN;
>  	}
> +	spin_unlock(&xprt->reserve_lock);
>  	return;
>  out_init_req:
>  	task->tk_status = 0;
>  	task->tk_rqstp = req;
>  	xprt_request_init(task, xprt);
> +	spin_unlock(&xprt->reserve_lock);
> +}
> +EXPORT_SYMBOL_GPL(xprt_alloc_slot);
> +
> +void xprt_lock_and_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
> +{
> +	/* Note: grabbing the xprt_lock_write() ensures that we throttle
> +	 * new slot allocation if the transport is congested (i.e. when
> +	 * reconnecting a stream transport or when out of socket write
> +	 * buffer space).
> +	 */
> +	if (xprt_lock_write(xprt, task)) {
> +		xprt_alloc_slot(xprt, task);
> +		xprt_release_write(xprt, task);
> +	}
>  }
> +EXPORT_SYMBOL_GPL(xprt_lock_and_alloc_slot);
>  
>  static void xprt_free_slot(struct rpc_xprt *xprt, struct rpc_rqst *req)
>  {
> @@ -1083,20 +1100,9 @@ void xprt_reserve(struct rpc_task *task)
>  	if (task->tk_rqstp != NULL)
>  		return;
>  
> -	/* Note: grabbing the xprt_lock_write() here is not strictly needed,
> -	 * but ensures that we throttle new slot allocation if the transport
> -	 * is congested (e.g. if reconnecting or if we're out of socket
> -	 * write buffer space).
> -	 */
>  	task->tk_timeout = 0;
>  	task->tk_status = -EAGAIN;
> -	if (!xprt_lock_write(xprt, task))
> -		return;
> -
> -	spin_lock(&xprt->reserve_lock);
> -	xprt_alloc_slot(task);
> -	spin_unlock(&xprt->reserve_lock);
> -	xprt_release_write(xprt, task);
> +	xprt->ops->alloc_slot(xprt, task);
>  }
>  
>  static inline __be32 xprt_alloc_xid(struct rpc_xprt *xprt)
> --- a/net/sunrpc/xprtrdma/transport.c
> +++ b/net/sunrpc/xprtrdma/transport.c
> @@ -713,6 +713,7 @@ static void xprt_rdma_print_stats(struct
>  static struct rpc_xprt_ops xprt_rdma_procs = {
>  	.reserve_xprt		= xprt_rdma_reserve_xprt,
>  	.release_xprt		= xprt_release_xprt_cong, /* sunrpc/xprt.c */
> +	.alloc_slot		= xprt_alloc_slot,
>  	.release_request	= xprt_release_rqst_cong,       /* ditto */
>  	.set_retrans_timeout	= xprt_set_retrans_timeout_def, /* ditto */
>  	.rpcbind		= rpcb_getport_async,	/* sunrpc/rpcb_clnt.c */
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -2433,6 +2433,7 @@ static void bc_destroy(struct rpc_xprt *
>  static struct rpc_xprt_ops xs_local_ops = {
>  	.reserve_xprt		= xprt_reserve_xprt,
>  	.release_xprt		= xs_tcp_release_xprt,
> +	.alloc_slot		= xprt_alloc_slot,
>  	.rpcbind		= xs_local_rpcbind,
>  	.set_port		= xs_local_set_port,
>  	.connect		= xs_connect,
> @@ -2449,6 +2450,7 @@ static struct rpc_xprt_ops xs_udp_ops =
>  	.set_buffer_size	= xs_udp_set_buffer_size,
>  	.reserve_xprt		= xprt_reserve_xprt_cong,
>  	.release_xprt		= xprt_release_xprt_cong,
> +	.alloc_slot		= xprt_alloc_slot,
>  	.rpcbind		= rpcb_getport_async,
>  	.set_port		= xs_set_port,
>  	.connect		= xs_connect,
> @@ -2466,6 +2468,7 @@ static struct rpc_xprt_ops xs_udp_ops =
>  static struct rpc_xprt_ops xs_tcp_ops = {
>  	.reserve_xprt		= xprt_reserve_xprt,
>  	.release_xprt		= xs_tcp_release_xprt,
> +	.alloc_slot		= xprt_lock_and_alloc_slot,
>  	.rpcbind		= rpcb_getport_async,
>  	.set_port		= xs_set_port,
>  	.connect		= xs_connect,
> 
> 

Hi Greg,

Can we please hold on this one for now. It appears that it requires an
extra initialiser in the 'bc_tcp_ops' declaration in
net/sunrpc/xprtsock.c (to set '.alloc_slot = xprt_alloc_slot').

I have a separate patch for that, but it has not yet made it upstream.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
