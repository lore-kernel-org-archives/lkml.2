Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab0KLSd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:33:29 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39272 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab0KLSd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:33:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MsaA0BQBRlAS5k2v1jxLa8WINJvgkHLbZgVRx0wPZRtDbxZhIUo4CB0rKwFxHfR5uJ
         ouTuTxDWRFYQmFDV24DSVtuIsTqRWGMjVILadVHH7htUJjEmte6RmG9W83LsCZ19MBDx
         ydHqwLo7Ayeq+qbYrC1dO++Etw2gooW6+JJ9Q=
Subject: Re: a problem tcp_v4_err()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Patrick McHardy <kaber@trash.net>, David Lamparter <equinox@diac24.net>,
        Eric Paris <eparis@redhat.com>, Hua Zhong <hzhong@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, paul.moore@hp.com,
        Damian Lukowski <damian@tvk.rwth-aachen.de>
In-Reply-To: <20101112182959.GA20459@ms2.inr.ac.ru>
References: <20101111210341.31350.86916.stgit@paris.rdu.redhat.com>
	 <00c201cb81eb$84e18160$8ea48420$@com>
	 <1289578108.3083.95.camel@localhost.localdomain>
	 <1289578532.3185.265.camel@edumazet-laptop>
	 <20101112163543.GB122902@jupiter.n2.diac24.net>
	 <4CDD7145.8070606@trash.net> <20101112175715.GB16544@ms2.inr.ac.ru>
	 <1289585578.3185.268.camel@edumazet-laptop>
	 <20101112182959.GA20459@ms2.inr.ac.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 19:33:23 +0100
Message-ID: <1289586803.3185.275.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 novembre 2010 à 21:29 +0300, Alexey Kuznetsov a écrit :
> Hello!
> 
> On Fri, Nov 12, 2010 at 07:12:58PM +0100, Eric Dumazet wrote:
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
> 
> It is not missing, sock_owned_by_user() is checked later when some operation which
> cannot be done without lock is required. It was done to save error in sk_err_soft even
> when socket is locked.
> 
> This code also _understands_ this: look at
> 
>                 } else if (sock_owned_by_user(sk)) {
>                         /* RTO revert clocked out retransmission,
>                          * but socket is locked. Will defer. */
>                         inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
>                                                   HZ/20, TCP_RTO_MAX);
> 
> but somehow it considers the manipulations with rto/backoff/write_queue as safe.
> Seems, they are not.

Indeed, right you are, I came to same conclusion.

I CC Damian Lukowski in my previous answer (and this one too)

Thanks !


