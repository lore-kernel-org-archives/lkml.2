Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab2BGRtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:49:01 -0500
Received: from mx2.netapp.com ([216.240.18.37]:24114 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab2BGRs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:48:59 -0500
X-IronPort-AV: E=Sophos;i="4.73,378,1325491200"; 
   d="scan'208";a="623287367"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>
CC: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "xemul@parallels.com" <xemul@parallels.com>,
        "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 3/5] NFS: search for client session id in proper network
 namespace
Thread-Topic: [PATCH 3/5] NFS: search for client session id in proper
 network namespace
Thread-Index: AQHM3BtZgnaOlcRd+0mRCJwj4FE+5JYyLEEAgAAjJYA=
Date: Tue, 7 Feb 2012 17:48:52 +0000
Message-ID: <1328636931.4124.17.camel@lade.trondhjem.org>
References: <20120126110955.8386.34551.stgit@localhost6.localdomain6>
	 <20120126111149.8386.51043.stgit@localhost6.localdomain6>
	 <4F314688.5050406@netapp.com>
In-Reply-To: <4F314688.5050406@netapp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E04BB25172959408E01651C2C37D8E9@tahoe.netapp.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 07 Feb 2012 17:48:53.0566 (UTC) FILETIME=[C1D9CDE0:01CCE5C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q17Hn5Ja029798

On Tue, 2012-02-07 at 10:43 -0500, Bryan Schumaker wrote:
> On 01/26/12 06:11, Stanislav Kinsbursky wrote:
> 
> > Network namespace is taken from request transport and passed as a part of
> > cb_process_state structure.
> > 
> > Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> > 
> > ---
> >  fs/nfs/callback.h      |    1 +
> >  fs/nfs/callback_proc.c |    2 +-
> >  fs/nfs/callback_xdr.c  |    1 +
> >  fs/nfs/client.c        |    4 ++--
> >  fs/nfs/internal.h      |    3 ++-
> >  5 files changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/nfs/callback.h b/fs/nfs/callback.h
> > index c89d3b9..197e0d3 100644
> > --- a/fs/nfs/callback.h
> > +++ b/fs/nfs/callback.h
> > @@ -39,6 +39,7 @@ struct cb_process_state {
> >  	__be32			drc_status;
> >  	struct nfs_client	*clp;
> >  	int			slotid;
> > +	struct net		*net;
> >  };
> >  
> >  struct cb_compound_hdr_arg {
> > diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
> > index 0e6e63f..f71978d 100644
> > --- a/fs/nfs/callback_proc.c
> > +++ b/fs/nfs/callback_proc.c
> > @@ -461,7 +461,7 @@ __be32 nfs4_callback_sequence(struct cb_sequenceargs *args,
> >  	int i;
> >  	__be32 status = htonl(NFS4ERR_BADSESSION);
> >  
> > -	clp = nfs4_find_client_sessionid(args->csa_addr, &args->csa_sessionid);
> > +	clp = nfs4_find_client_sessionid(cps->net, args->csa_addr, &args->csa_sessionid);
> >  	if (clp == NULL)
> >  		goto out;
> >  
> > diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
> > index f2be3e1e..8c2a969 100644
> > --- a/fs/nfs/callback_xdr.c
> > +++ b/fs/nfs/callback_xdr.c
> > @@ -861,6 +861,7 @@ static __be32 nfs4_callback_compound(struct svc_rqst *rqstp, void *argp, void *r
> >  		.drc_status = 0,
> >  		.clp = NULL,
> >  		.slotid = -1,
> > +		.net = rqstp->rq_xprt->xpt_net,
> >  	};
> >  	unsigned int nops = 0;
> >  
> > diff --git a/fs/nfs/client.c b/fs/nfs/client.c
> > index 9e11d29..2328dcb 100644
> > --- a/fs/nfs/client.c
> > +++ b/fs/nfs/client.c
> > @@ -1232,11 +1232,11 @@ nfs4_find_client_ident(struct net *net, int cb_ident)
> >   * Returns NULL if no such client
> >   */
> >  struct nfs_client *
> > -nfs4_find_client_sessionid(const struct sockaddr *addr,
> > +nfs4_find_client_sessionid(struct net *net, const struct sockaddr *addr,
> >  			   struct nfs4_sessionid *sid)
> >  {
> >  	struct nfs_client *clp;
> > -	struct nfs_net *nn = net_generic(&init_net, nfs_net_id);
> > +	struct nfs_net *nn = net_generic(net, nfs_net_id);
> 
> 
> Hi,
> 
> You changed this function for the v4.1 case, but not for v4.0 (this is what I was trying to bisect earlier).  Without CONFIG_NFS_V4_1 set, I get this:
> 
>  make[1]: Nothing to be done for `all'.
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CHK     kernel/config_data.h
>   CC [M]  fs/nfs/client.o
> fs/nfs/client.c:1265:1: error: conflicting types for 'nfs4_find_client_sessionid'
> fs/nfs/internal.h:155:1: note: previous declaration of 'nfs4_find_client_sessionid' was here
> make[2]: *** [fs/nfs/client.o] Error 1
> make[1]: *** [fs/nfs] Error 2
> make: *** [fs] Error 2

Thanks for tracking this down Bryan!

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
