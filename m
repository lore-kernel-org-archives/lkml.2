Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab1GMCCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 22:02:15 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:39327 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755008Ab1GMCCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 22:02:14 -0400
Date: Wed, 13 Jul 2011 02:02:23 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        dhowells@redhat.com, ebiederm@xmission.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [RFC PATCH 08/14] af_netlink.c: make netlink_capable
 userns-aware
Message-ID: <20110713020223.GA14187@hallyn.com>
References: <1310513452-13397-1-git-send-email-serge@hallyn.com>
 <1310513452-13397-9-git-send-email-serge@hallyn.com>
 <1310520819.2634.6.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1310520819.2634.6.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Dumazet (eric.dumazet@gmail.com):
> Le mardi 12 juillet 2011 à 23:30 +0000, Serge Hallyn a écrit :
> > From: Serge E. Hallyn <serge.hallyn@canonical.com>
> > 
> > netlink_capable should check for permissions against the user
> > namespace owning the socket in question.
> > 
> > Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > ---
> >  net/netlink/af_netlink.c |   11 +++++++++--
> >  1 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> > index 6ef64ad..81c1099 100644
> > --- a/net/netlink/af_netlink.c
> > +++ b/net/netlink/af_netlink.c
> > @@ -580,8 +580,15 @@ retry:
> >  
> >  static inline int netlink_capable(struct socket *sock, unsigned int flag)
> >  {
> > -	return (nl_table[sock->sk->sk_protocol].nl_nonroot & flag) ||
> > -	       capable(CAP_NET_ADMIN);
> > +	struct net *net;
> > +	if (nl_table[sock->sk->sk_protocol].nl_nonroot & flag)
> > +		return 1;
> > +#ifdef CONFIG_NET_NS
> > +	net = sock->sk->sk_net;
> > +#else
> > +	net = &init_net;
> > +#endif
> 
> This is really ugly, please use :
> 
> 	net = sock_net(sk);
> 
> And no more #ifdef

thanks, will do!
