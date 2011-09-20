Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750952Ab1ITOOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:14:33 -0400
Received: from mx2.netapp.com ([216.240.18.37]:5820 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1ITOOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:14:32 -0400
X-IronPort-AV: E=Sophos;i="4.68,411,1312182000"; 
   d="scan'208";a="583290615"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH v4 1/8] SUNRPC: introduce helpers for reference counted rpcbind clients
Date: Tue, 20 Sep 2011 07:14:15 -0700
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430B47FD22@SACMVEXC2-PRD.hq.netapp.com>
In-reply-to: <4E789679.1060601@parallels.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v4 1/8] SUNRPC: introduce helpers for reference counted rpcbind clients
Thread-Index: Acx3miMsbAE82sEjSyCXLwwPyfLMSwABOZDw
References: <20110920101031.9861.18444.stgit@localhost6.localdomain6> <20110920101341.9861.51453.stgit@localhost6.localdomain6> <4E788F8C.20103@netapp.com> <2E1EB2CF9ED1CB4AA966F0EB76EAB4430B47FD10@SACMVEXC2-PRD.hq.netapp.com> <4E789679.1060601@parallels.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Stanislav Kinsbursky" <skinsbursky@parallels.com>
Cc: "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>,
        <linux-nfs@vger.kernel.org>, "Pavel Emelianov" <xemul@parallels.com>,
        <neilb@suse.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bfields@fieldses.org>,
        <davem@davemloft.net>
X-OriginalArrivalTime: 20 Sep 2011 14:14:15.0260 (UTC) FILETIME=[93F341C0:01CC779F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8KEEoGv021017

> -----Original Message-----
> From: Stanislav Kinsbursky [mailto:skinsbursky@parallels.com]
> Sent: Tuesday, September 20, 2011 9:35 AM
> To: Myklebust, Trond
> Cc: Schumaker, Bryan; linux-nfs@vger.kernel.org; Pavel Emelianov;
> neilb@suse.de; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> bfields@fieldses.org; davem@davemloft.net
> Subject: Re: [PATCH v4 1/8] SUNRPC: introduce helpers for reference
> counted rpcbind clients
> 
> 20.09.2011 17:15, Myklebust, Trond Ğ¿Ğ¸ÑˆĞµÑ‚:
> >> -----Original Message-----
> >> From: Schumaker, Bryan
> >> Sent: Tuesday, September 20, 2011 9:05 AM
> >> To: Stanislav Kinsbursky
> >> Cc: Myklebust, Trond; linux-nfs@vger.kernel.org; xemul@parallels.com;
> >> neilb@suse.de; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> >> bfields@fieldses.org; davem@davemloft.net
> >> Subject: Re: [PATCH v4 1/8] SUNRPC: introduce helpers for reference
> >> counted rpcbind clients
> >>
> >> On 09/20/2011 06:13 AM, Stanislav Kinsbursky wrote:
> >>> This helpers will be used for dynamical creation and destruction of
> >>> rpcbind clients.
> >>> Variable rpcb_users is actually a counter of lauched RPC services.
> >>> If rpcbind clients has been created already, then we just increase
> rpcb_users.
> >>>
> >>> Signed-off-by: Stanislav Kinsbursky<skinsbursky@parallels.com>
> >>>
> >>> ---
> >>>   net/sunrpc/rpcb_clnt.c |   50
> >> ++++++++++++++++++++++++++++++++++++++++++++++++
> >>>   1 files changed, 50 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c index
> >>> e45d2fb..8724780 100644
> >>> --- a/net/sunrpc/rpcb_clnt.c
> >>> +++ b/net/sunrpc/rpcb_clnt.c
> >>> @@ -114,6 +114,9 @@ static struct rpc_program	rpcb_program;
> >>>   static struct rpc_clnt *	rpcb_local_clnt;
> >>>   static struct rpc_clnt *	rpcb_local_clnt4;
> >>>
> >>> +DEFINE_SPINLOCK(rpcb_clnt_lock);
> >>> +unsigned int			rpcb_users;
> >>> +
> >>>   struct rpcbind_args {
> >>>   	struct rpc_xprt *	r_xprt;
> >>>
> >>> @@ -161,6 +164,53 @@ static void rpcb_map_release(void *data)
> >>>   	kfree(map);
> >>>   }
> >>>
> >>> +static int rpcb_get_local(void)
> >>> +{
> >>> +	spin_lock(&rpcb_clnt_lock);
> >>> +	if (rpcb_users)
> >>> +		rpcb_users++;
> >>> +	spin_unlock(&rpcb_clnt_lock);
> >>> +
> >>> +	return rpcb_users;
> >>          ^^^^^^^^^^^^^^^^^^
> >> Is it safe to use this variable outside of the rpcb_clnt_lock?
> >>
> > Nope. If rpcb_users was zero in the protected section above, nothing
> guarantees that it will still be zero here, and so the caller may get the (wrong)
> impression that the counter was incremented.
> >
> 
> Yep, you right. Will fix this races.
> 
> >>> +}
> >>> +
> >>> +void rpcb_put_local(void)
> >>> +{
> >>> +	struct rpc_clnt *clnt = rpcb_local_clnt;
> >>> +	struct rpc_clnt *clnt4 = rpcb_local_clnt4;
> >>> +	int shutdown;
> >>> +
> >>> +	spin_lock(&rpcb_clnt_lock);
> >>> +	if (--rpcb_users == 0) {
> >>> +		rpcb_local_clnt = NULL;
> >>> +		rpcb_local_clnt4 = NULL;
> >>> +	}
> >>> +	shutdown = !rpcb_users;
> >>> +	spin_unlock(&rpcb_clnt_lock);
> >>> +
> >>> +	if (shutdown) {
> >>> +		/*
> >>> +		 * cleanup_rpcb_clnt - remove xprtsock's sysctls, unregister
> >>> +		 */
> >>> +		if (clnt4)
> >>> +			rpc_shutdown_client(clnt4);
> >>> +		if (clnt)
> >>> +			rpc_shutdown_client(clnt);
> >>> +	}
> >>> +	return;
> >>> +}
> >>> +
> >>> +static void rpcb_set_local(struct rpc_clnt *clnt, struct rpc_clnt
> >>> +*clnt4) {
> >>> +	/* Protected by rpcb_create_local_mutex */
> >
> > Doesn't it  need to be protected by rpcb_clnt_lock too?
> >
> 
> Nope from my pow. It's protected by rpcb_create_local_mutex. I.e. no one
> will change rpcb_users since it's zero. If it's non zero - we willn't get to
> rpcb_set_local().

OK, so you are saying that the rpcb_users++ below could be replaced by rpcb_users=1?

In that case, don't you need a smp_wmb() between the setting of rpcb_local_clnt/4 and the setting of rpcb_users? Otherwise, how do you guarantee that rpcb_users != 0 implies rpbc_local_clnt/4 != NULL?

> >>> +	rpcb_local_clnt = clnt;
> >>> +	rpcb_local_clnt4 = clnt4;
> >>> +	rpcb_users++;
> > ^^^^^^^^^^^^^^^^^^^
> >
> >>> +	dprintk("RPC:       created new rpcb local clients (rpcb_local_clnt: "
> >>> +			"%p, rpcb_local_clnt4: %p)\n", rpcb_local_clnt,
> >>> +			rpcb_local_clnt4);
> >>> +}
> >>> +

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
