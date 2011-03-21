Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1CUO4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:56:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39247 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab1CUO4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RpWdnLhteltsik3D9vRbf3m99+lY3VI+Lw4M/ckfUHIsWEvIbxtSW/ghcXOtAgLoO2
         jO5ryvPFnJSCUTKomwjPMk5ABd5Pkzw0q9PMfNhUbbmn7nEHAOtEJ79s+y64wq/WEbLS
         cCq2gpAsQQUnXpCq3OojxwrD08xzen3QLzSrI=
Subject: Re: [held lock freed] Re: [GIT] Networking
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <201103211550.10694.arnd@arndb.de>
References: <20110320.195156.226769634.davem@davemloft.net>
	 <20110321125320.GA23490@elte.hu>
	 <1300714346.2884.284.camel@edumazet-laptop>
	 <201103211550.10694.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 15:55:32 +0100
Message-ID: <1300719332.2884.370.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 21 mars 2011 à 15:50 +0100, Arnd Bergmann a écrit :
> On Monday 21 March 2011, Eric Dumazet wrote:
> > [PATCH] ipx: fix ipx_release()
> > 
> > Commit b0d0d915d1d1a0 (remove the BKL) added a regression, because
> > sock_put() can free memory while we are going to use it later.
> > 
> > Fix is to delay sock_put() after release_sock().
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> 
> Your fix looks good, thanks Eric!
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> I believe I made the same mistake in atalk_release and x25_release:
> 
> 8<------------
> net: fix atalk_release and x25_release
> 
> The recent BKL removal has introduced a use-after-free problem
> in multiple network protocols. This fixes the problem in appletalk
> and x25 by ensuring that we call the final sock_put() after
> releasing the socket lock.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>


> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> index 4680b1e..b2cf1db 100644
> --- a/net/x25/af_x25.c
> +++ b/net/x25/af_x25.c
> @@ -669,8 +669,8 @@ static int x25_release(struct socket *sock)
>  
>  	sock_orphan(sk);
>  out:
> -	release_sock(sk);
>  	sock_put(sk);
> +	release_sock(sk);
>  	return 0;
>  }
>  

Hmm, x25_release() looks fine, I believe no fix is needed.




