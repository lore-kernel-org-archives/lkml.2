Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab0KLS2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:28:04 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33186 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab0KLS2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:28:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RzC4ziTMDHcid5nEHZQdZauZNv1SaPEwcebKZBhINY6Ci5RzS3ANdJZv4Yu1IXx0Ez
         vULqU2AYR8hXt24D7xB3SxyKpTNKSTmWkNaabq3U6tHPyWJVB6R/0HSs+o/HnqsDUY53
         sAoaANu2UyeVWXhPYSGvWITTMFceiYBPQ25e8=
Subject: Re: a problem tcp_v4_err()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Patrick McHardy <kaber@trash.net>, David Lamparter <equinox@diac24.net>,
        Eric Paris <eparis@redhat.com>, Hua Zhong <hzhong@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, paul.moore@hp.com,
        Damian Lukowski <damian@tvk.rwth-aachen.de>
In-Reply-To: <1289586114.3185.271.camel@edumazet-laptop>
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com>
	 <00c201cb81eb$84e18160$8ea48420$@com>
	 <1289578108.3083.95.camel@localhost.localdomain>
	 <1289578532.3185.265.camel@edumazet-laptop>
	 <20101112163543.GB122902@jupiter.n2.diac24.net>
	 <4CDD7145.8070606@trash.net>  <20101112175715.GB16544@ms2.inr.ac.ru>
	 <1289585578.3185.268.camel@edumazet-laptop>
	 <1289586114.3185.271.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 19:27:57 +0100
Message-ID: <1289586477.3185.273.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 novembre 2010 à 19:21 +0100, Eric Dumazet a écrit :
> Le vendredi 12 novembre 2010 à 19:12 +0100, Eric Dumazet a écrit :
> > Le vendredi 12 novembre 2010 à 20:57 +0300, Alexey Kuznetsov a écrit :
> > > Hello!
> > > 
> > > I looked at tcp_v4_err() and found something strange. Quite non-trivial operations
> > > are performed on unlocked sockets. It looks like at least this BUG_ON():
> > > 
> > >                 skb = tcp_write_queue_head(sk);
> > >                 BUG_ON(!skb);
> > > 
> > > can be easily triggered.
> > > 
> > > Do I miss something?
> > > 
> > 
> > Hi Alexey !
> > 
> > I see socket is locked around line 368,
> > 
> >         bh_lock_sock(sk);
> >         /* If too many ICMPs get dropped on busy
> >          * servers this needs to be solved differently.
> >          */
> >         if (sock_owned_by_user(sk))
> >                 NET_INC_STATS_BH(net, LINUX_MIB_LOCKDROPPEDICMPS);
> > 
> > 
> > Hmm, maybe some goto is missing ;)
> > 
> 
> Well, goto is not missing.
> 
> Why do you think BUG_ON(!skb) can be triggered ?
> 
> We test before :
> 
> 	if (seq != tp->snd_una  || !icsk->icsk_retransmits ||
> 		!icsk->icsk_backoff)
> 		break;
> 
> So a concurrent user only can add new skb(s) in the (non empty) queue ?
> 
> 

Oh well, it seems you are right (backlog processing)

Bug was introduced in commit f1ecd5d9e736660 (Revert Backoff [v3]:
Revert RTO on ICMP destination unreachable) from Damian Lukowski



