Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab2IGWcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:32:41 -0400
Received: from mx2.netapp.com ([216.240.18.37]:29443 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683Ab2IGWcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:32:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,388,1344236400"; 
   d="scan'208";a="687036367"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Jeff Layton <jlayton@redhat.com>
CC: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v2] SUNRPC: check current nsproxy before set of node
 name on client creation
Thread-Topic: [PATCH v2] SUNRPC: check current nsproxy before set of node
 name on client creation
Thread-Index: AQHNeUylwnVjh2tbW02Id+IcJKD75ZeAFAKA
Date: Fri, 7 Sep 2012 22:32:16 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908F90888@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120813113731.9629.31906.stgit@localhost.localdomain>
	 <20120813081054.0ee39037@corrin.poochiereds.net>
In-Reply-To: <20120813081054.0ee39037@corrin.poochiereds.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <72A991EA8A7E2848989859B8CB96B816@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q87MWmKh009795

On Mon, 2012-08-13 at 08:10 -0400, Jeff Layton wrote:
> On Mon, 13 Aug 2012 15:37:31 +0400
> Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:
> 
> > v2:
> > 1) rpc_clnt_set_nodename() prototype updated.
> > 2) fixed errors in comment.
> > 
> > When child reaper exits, it can destroy mount namespace it belongs to, and if
> > there are NFS mounts inside, then it will try to umount them. But in this
> > point current->nsproxy is set to NULL and all namespaces will be destroyed one
> > by one. I.e. we can't dereference current->nsproxy to obtain uts namespace.
> > 
> > Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> > ---
> >  net/sunrpc/clnt.c |   16 +++++++++++++---
> >  1 files changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
> > index 9a9676e..8fbcbc8 100644
> > --- a/net/sunrpc/clnt.c
> > +++ b/net/sunrpc/clnt.c
> > @@ -277,8 +277,18 @@ void rpc_clients_notifier_unregister(void)
> >  	return rpc_pipefs_notifier_unregister(&rpc_clients_block);
> >  }
> >  
> > -static void rpc_clnt_set_nodename(struct rpc_clnt *clnt, const char *nodename)
> > +static void rpc_clnt_set_nodename(struct rpc_clnt *clnt)
> >  {
> > +	const char *nodename;
> > +
> > +	/*
> > +	 * We have to protect against dying child reaper, which has released
> > +	 * its nsproxy already and is trying to destroy mount namespace.
> > +	 */
> > +	if (current->nsproxy == NULL)
> > +		return;
> > +
> > +	nodename = utsname()->nodename;
> >  	clnt->cl_nodelen = strlen(nodename);
> >  	if (clnt->cl_nodelen > UNX_MAXNODENAME)
> >  		clnt->cl_nodelen = UNX_MAXNODENAME;
> > @@ -365,7 +375,7 @@ static struct rpc_clnt * rpc_new_client(const struct rpc_create_args *args, stru
> >  	}
> >  
> >  	/* save the nodename */
> > -	rpc_clnt_set_nodename(clnt, utsname()->nodename);
> > +	rpc_clnt_set_nodename(clnt);
> >  	rpc_register_client(clnt);
> >  	return clnt;
> >  
> > @@ -524,7 +534,7 @@ rpc_clone_client(struct rpc_clnt *clnt)
> >  	err = rpc_setup_pipedir(new, clnt->cl_program->pipe_dir_name);
> >  	if (err != 0)
> >  		goto out_no_path;
> > -	rpc_clnt_set_nodename(new, utsname()->nodename);
> > +	rpc_clnt_set_nodename(new);
> >  	if (new->cl_auth)
> >  		atomic_inc(&new->cl_auth->au_count);
> >  	atomic_inc(&clnt->cl_count);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Acked-by: Jeff Layton <jlayton@redhat.com>

OK, colour me confused (again). Why should a umount trigger an
rpc_create() or rpc_clone_client()?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
