Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab1ITNPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:15:32 -0400
Received: from mx2.netapp.com ([216.240.18.37]:40040 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab1ITNPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:15:25 -0400
X-IronPort-AV: E=Sophos;i="4.68,411,1312182000"; 
   d="scan'208";a="583272234"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH v4 1/8] SUNRPC: introduce helpers for reference counted rpcbind clients
Date: Tue, 20 Sep 2011 06:15:24 -0700
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430B47FD10@SACMVEXC2-PRD.hq.netapp.com>
In-reply-to: <4E788F8C.20103@netapp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v4 1/8] SUNRPC: introduce helpers for reference counted rpcbind clients
Thread-Index: Acx3lfNx1i5tV171Tsq2+LiY6AA09wAAPgAg
References: <20110920101031.9861.18444.stgit@localhost6.localdomain6> <20110920101341.9861.51453.stgit@localhost6.localdomain6> <4E788F8C.20103@netapp.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>,
        "Stanislav Kinsbursky" <skinsbursky@parallels.com>
Cc: <linux-nfs@vger.kernel.org>, <xemul@parallels.com>, <neilb@suse.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bfields@fieldses.org>, <davem@davemloft.net>
X-OriginalArrivalTime: 20 Sep 2011 13:15:24.0394 (UTC) FILETIME=[5B63DCA0:01CC7797]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8KDFc7L020630

> -----Original Message-----
> From: Schumaker, Bryan
> Sent: Tuesday, September 20, 2011 9:05 AM
> To: Stanislav Kinsbursky
> Cc: Myklebust, Trond; linux-nfs@vger.kernel.org; xemul@parallels.com;
> neilb@suse.de; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> bfields@fieldses.org; davem@davemloft.net
> Subject: Re: [PATCH v4 1/8] SUNRPC: introduce helpers for reference
> counted rpcbind clients
> 
> On 09/20/2011 06:13 AM, Stanislav Kinsbursky wrote:
> > This helpers will be used for dynamical creation and destruction of
> > rpcbind clients.
> > Variable rpcb_users is actually a counter of lauched RPC services. If
> > rpcbind clients has been created already, then we just increase rpcb_users.
> >
> > Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> >
> > ---
> >  net/sunrpc/rpcb_clnt.c |   50
> ++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 50 insertions(+), 0 deletions(-)
> >
> > diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c index
> > e45d2fb..8724780 100644
> > --- a/net/sunrpc/rpcb_clnt.c
> > +++ b/net/sunrpc/rpcb_clnt.c
> > @@ -114,6 +114,9 @@ static struct rpc_program	rpcb_program;
> >  static struct rpc_clnt *	rpcb_local_clnt;
> >  static struct rpc_clnt *	rpcb_local_clnt4;
> >
> > +DEFINE_SPINLOCK(rpcb_clnt_lock);
> > +unsigned int			rpcb_users;
> > +
> >  struct rpcbind_args {
> >  	struct rpc_xprt *	r_xprt;
> >
> > @@ -161,6 +164,53 @@ static void rpcb_map_release(void *data)
> >  	kfree(map);
> >  }
> >
> > +static int rpcb_get_local(void)
> > +{
> > +	spin_lock(&rpcb_clnt_lock);
> > +	if (rpcb_users)
> > +		rpcb_users++;
> > +	spin_unlock(&rpcb_clnt_lock);
> > +
> > +	return rpcb_users;
>         ^^^^^^^^^^^^^^^^^^
> Is it safe to use this variable outside of the rpcb_clnt_lock?
>
Nope. If rpcb_users was zero in the protected section above, nothing guarantees that it will still be zero here, and so the caller may get the (wrong) impression that the counter was incremented.

> > +}
> > +
> > +void rpcb_put_local(void)
> > +{
> > +	struct rpc_clnt *clnt = rpcb_local_clnt;
> > +	struct rpc_clnt *clnt4 = rpcb_local_clnt4;
> > +	int shutdown;
> > +
> > +	spin_lock(&rpcb_clnt_lock);
> > +	if (--rpcb_users == 0) {
> > +		rpcb_local_clnt = NULL;
> > +		rpcb_local_clnt4 = NULL;
> > +	}
> > +	shutdown = !rpcb_users;
> > +	spin_unlock(&rpcb_clnt_lock);
> > +
> > +	if (shutdown) {
> > +		/*
> > +		 * cleanup_rpcb_clnt - remove xprtsock's sysctls, unregister
> > +		 */
> > +		if (clnt4)
> > +			rpc_shutdown_client(clnt4);
> > +		if (clnt)
> > +			rpc_shutdown_client(clnt);
> > +	}
> > +	return;
> > +}
> > +
> > +static void rpcb_set_local(struct rpc_clnt *clnt, struct rpc_clnt
> > +*clnt4) {
> > +	/* Protected by rpcb_create_local_mutex */

Doesn't it  need to be protected by rpcb_clnt_lock too?

> > +	rpcb_local_clnt = clnt;
> > +	rpcb_local_clnt4 = clnt4;
> > +	rpcb_users++;
^^^^^^^^^^^^^^^^^^^

> > +	dprintk("RPC:       created new rpcb local clients (rpcb_local_clnt: "
> > +			"%p, rpcb_local_clnt4: %p)\n", rpcb_local_clnt,
> > +			rpcb_local_clnt4);
> > +}
> > +
> >  /*
> >   * Returns zero on success, otherwise a negative errno value
> >   * is returned.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nfs"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
