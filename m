Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600Ab1CXRCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:02:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51016 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540Ab1CXRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:02:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TC2SZyJDX3WHf8UMXR9gRliHUeHmhMmapiNXHuONENtLYimYQX0V7JFv7sBY5Yagwh
         R7yrfmKOGNZrRWvxIWVzLXVm0zO/RGl9Gs8yDDKDglFrBxzbDXoR/Ar7O1/itYJSoS8e
         F9FVpLS9rF0t2jFB239xbHA1+WH+THD33o6NU=
Subject: [PATCH] ipv4: fix fib metrics
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>,
        David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <1300983340.3747.44.camel@edumazet-laptop>
References: <AANLkTik6+TrjiC6ZF+KHhZ1iPzEe2jDayr363C0HgQN4@mail.gmail.com>
	 <1300980118.3747.42.camel@edumazet-laptop>
	 <AANLkTikZhT5LaA-UEXniDvkneH8JScaVaCaCd4LT59cV@mail.gmail.com>
	 <1300983340.3747.44.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 18:01:24 +0100
Message-ID: <1300986084.3747.101.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 17:15 +0100, Eric Dumazet a écrit :

> I am testing following patch :
> 
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 622ac4c..654ef5b 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -251,7 +251,7 @@ static struct fib_info *fib_find_info(const struct fib_info *nfi)
>  		    nfi->fib_prefsrc == fi->fib_prefsrc &&
>  		    nfi->fib_priority == fi->fib_priority &&
>  		    memcmp(nfi->fib_metrics, fi->fib_metrics,
> -			   sizeof(fi->fib_metrics)) == 0 &&
> +			   sizeof(u32) * RTAX_MAX) == 0 &&
>  		    ((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_F_DEAD) == 0 &&
>  		    (nfi->fib_nhs == 0 || nh_comp(fi, nfi) == 0))
>  			return fi;
> 
> 

This works. Here is the formal submission :

Thanks !

[PATCH] ipv4: fix fib metrics

Alessandro Suardi reported that we could not change route metrics :

ip ro change default .... advmss 1400

This regression came with commit 9c150e82ac50 (Allocate fib metrics
dynamically). fib_metrics is no longer an array, but a pointer to an
array.

Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/fib_semantics.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 622ac4c..75b9fb5 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -251,7 +251,7 @@ static struct fib_info *fib_find_info(const struct fib_info *nfi)
 		    nfi->fib_prefsrc == fi->fib_prefsrc &&
 		    nfi->fib_priority == fi->fib_priority &&
 		    memcmp(nfi->fib_metrics, fi->fib_metrics,
-			   sizeof(fi->fib_metrics)) == 0 &&
+			   sizeof(u32) * RTAX_MAX) == 0 &&
 		    ((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_F_DEAD) == 0 &&
 		    (nfi->fib_nhs == 0 || nh_comp(fi, nfi) == 0))
 			return fi;


