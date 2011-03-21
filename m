Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1CUQQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:16:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55803 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab1CUQQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:16:33 -0400
Date: Mon, 21 Mar 2011 17:16:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [held lock freed] Re: [GIT] Networking
Message-ID: <20110321161627.GB28580@elte.hu>
References: <20110320.195156.226769634.davem@davemloft.net>
 <201103211550.10694.arnd@arndb.de>
 <1300719332.2884.370.camel@edumazet-laptop>
 <201103211622.40851.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103211622.40851.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 21 March 2011, Eric Dumazet wrote:
> > > diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> > > index 4680b1e..b2cf1db 100644
> > > --- a/net/x25/af_x25.c
> > > +++ b/net/x25/af_x25.c
> > > @@ -669,8 +669,8 @@ static int x25_release(struct socket *sock)
> > >  
> > >       sock_orphan(sk);
> > >  out:
> > > -     release_sock(sk);
> > >       sock_put(sk);
> > > +     release_sock(sk);
> > >       return 0;
> > >  }
> > >  
> > 
> > Hmm, x25_release() looks fine, I believe no fix is needed.
> > 
> 
> D'oh. You're right of course. My patch would introduce the bug,
> not fix it. Updated patch below.
> 
> 	Arnd
> 8<-------------------------
> net/appletalk: fix atalk_release use after free
> 
> The BKL removal in appletalk introduced a use-after-free problem,
> where atalk_destroy_socket frees a sock, but we still release
> the socket lock on it.
> 
> An easy fix is to take an extra reference on the sock and sock_put
> it when returning from atalk_release.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> index 3d4f4b0..206e771 100644
> --- a/net/appletalk/ddp.c
> +++ b/net/appletalk/ddp.c
> @@ -1051,6 +1051,7 @@ static int atalk_release(struct socket *sock)
>  {
>  	struct sock *sk = sock->sk;
>  
> +	sock_hold(sk);
>  	lock_sock(sk);
>  	if (sk) {
>  		sock_orphan(sk);
> @@ -1058,6 +1059,8 @@ static int atalk_release(struct socket *sock)
>  		atalk_destroy_socket(sk);
>  	}
>  	release_sock(sk);
> +	sock_put(sk);
> +
>  	return 0;
>  }

I have not triggered the lockdep warning in this code yet - but i've ran the 
patch and have seen no ill effects from it so far.

Thanks,

	Ingo
