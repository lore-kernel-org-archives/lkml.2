Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab1DNCLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:11:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39175 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1DNCLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:11:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LFleSoMsX03nfQMh5p1iPvGhaZfIkI6hhz/Ur1GOiJzupn5jT/mkkVQPSyfzQNKtaD
         BDq5ZKesYdB2O3JwQc2QCFNPKP3f1tIrN51pbXg1UwTspMvb8Bvq4mnMyqg9c/UxrPfk
         cYB1DpYmkQN4KjQ070v7koILL4D2NicIb2Olw=
Subject: Re: Regression from 2.6.36
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Changli Gao <xiaosuo@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20110413141600.28793661.akpm@linux-foundation.org>
References: <20110315132527.130FB80018F1@mail1005.cent>
	 <20110317001519.GB18911@kroah.com> <20110407120112.E08DCA03@pobox.sk>
	 <4D9D8FAA.9080405@suse.cz>
	 <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>
	 <1302177428.3357.25.camel@edumazet-laptop>
	 <1302178426.3357.34.camel@edumazet-laptop>
	 <BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
	 <1302190586.3357.45.camel@edumazet-laptop>
	 <20110412154906.70829d60.akpm@linux-foundation.org>
	 <BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>
	 <20110412183132.a854bffc.akpm@linux-foundation.org>
	 <1302662256.2811.27.camel@edumazet-laptop>
	 <20110413141600.28793661.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 04:10:58 +0200
Message-ID: <1302747058.3549.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 13 avril 2011 à 14:16 -0700, Andrew Morton a écrit :

> So am I correct in believing that this regression is due to the
> high-order allocations putting excess stress onto page reclaim?
> 

I suppose so.

> If so, then how large _are_ these allocations?  This perhaps can be
> determined from /proc/slabinfo.  They must be pretty huge, because slub
> likes to do excessively-large allocations and the system handles that
> reasonably well.
> 
> I suppose that a suitable fix would be
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Azurit reports large increases in system time after 2.6.36 when running
> Apache.  It was bisected down to a892e2d7dcdfa6c76e6 ("vfs: use kmalloc()
> to allocate fdmem if possible").
> 
> That patch caused the vfs to use kmalloc() for very large allocations and
> this is causing excessive work (and presumably excessive reclaim) within
> the page allocator.
> 
> Fix it by falling back to vmalloc() earlier - when the allocation attempt
> would have been considered "costly" by reclaim.
> 
> Reported-by: azurIt <azurit@pobox.sk>
> Cc: Changli Gao <xiaosuo@gmail.com>
> Cc: Americo Wang <xiyou.wangcong@gmail.com>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/file.c |   17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff -puN fs/file.c~a fs/file.c
> --- a/fs/file.c~a
> +++ a/fs/file.c
> @@ -39,14 +39,17 @@ int sysctl_nr_open_max = 1024 * 1024; /*
>   */
>  static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
>  
> -static inline void *alloc_fdmem(unsigned int size)
> +static void *alloc_fdmem(unsigned int size)
>  {
> -	void *data;
> -
> -	data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
> -	if (data != NULL)
> -		return data;
> -
> +	/*
> +	 * Very large allocations can stress page reclaim, so fall back to
> +	 * vmalloc() if the allocation size will be considered "large" by the VM.
> +	 */
> +	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER) {
> +		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
> +		if (data != NULL)
> +			return data;
> +	}
>  	return vmalloc(size);
>  }
>  
> _
> 

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

#define PAGE_ALLOC_COSTLY_ORDER 3

On x86_64, this means we try kmalloc() up to 4096 files in fdtable.

Thanks !


