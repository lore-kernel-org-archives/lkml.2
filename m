Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab1CXSPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:15:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46730 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1CXSPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:15:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wSd8mm8hNigfswzMdHn3xdiDPuPy0GBOyUuwOMisna9PTn8j9jxJYkw7TG52vyGjIl
         UacW/ZJyjcx8TSAYfT9lIrmV1ZNliJ3cQHWd9GbCKz+v1BDyKjKHjXuAkyYQB52I713U
         vS3FREPt2Xt5nD+7zSWPVselkiBROJ7tw/hhI=
MIME-Version: 1.0
In-Reply-To: <1300986084.3747.101.camel@edumazet-laptop>
References: <AANLkTik6+TrjiC6ZF+KHhZ1iPzEe2jDayr363C0HgQN4@mail.gmail.com>
	<1300980118.3747.42.camel@edumazet-laptop>
	<AANLkTikZhT5LaA-UEXniDvkneH8JScaVaCaCd4LT59cV@mail.gmail.com>
	<1300983340.3747.44.camel@edumazet-laptop>
	<1300986084.3747.101.camel@edumazet-laptop>
Date: Thu, 24 Mar 2011 19:14:51 +0100
Message-ID: <AANLkTik+Rf45wUxN86t+Zp7+AXjcJsy0vmZgvmLj-95x@mail.gmail.com>
Subject: Re: [PATCH] ipv4: fix fib metrics
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 6:01 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 24 mars 2011 à 17:15 +0100, Eric Dumazet a écrit :
>
>> I am testing following patch :
>>
>> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
>> index 622ac4c..654ef5b 100644
>> --- a/net/ipv4/fib_semantics.c
>> +++ b/net/ipv4/fib_semantics.c
>> @@ -251,7 +251,7 @@ static struct fib_info *fib_find_info(const struct fib_info *nfi)
>>                   nfi->fib_prefsrc == fi->fib_prefsrc &&
>>                   nfi->fib_priority == fi->fib_priority &&
>>                   memcmp(nfi->fib_metrics, fi->fib_metrics,
>> -                        sizeof(fi->fib_metrics)) == 0 &&
>> +                        sizeof(u32) * RTAX_MAX) == 0 &&
>>                   ((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_F_DEAD) == 0 &&
>>                   (nfi->fib_nhs == 0 || nh_comp(fi, nfi) == 0))
>>                       return fi;
>>
>>
>
> This works. Here is the formal submission :
>
> Thanks !
>
> [PATCH] ipv4: fix fib metrics
>
> Alessandro Suardi reported that we could not change route metrics :
>
> ip ro change default .... advmss 1400
>
> This regression came with commit 9c150e82ac50 (Allocate fib metrics
> dynamically). fib_metrics is no longer an array, but a pointer to an
> array.
>
> Reported-by: Alessandro Suardi <alessandro.suardi@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  net/ipv4/fib_semantics.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 622ac4c..75b9fb5 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -251,7 +251,7 @@ static struct fib_info *fib_find_info(const struct fib_info *nfi)
>                    nfi->fib_prefsrc == fi->fib_prefsrc &&
>                    nfi->fib_priority == fi->fib_priority &&
>                    memcmp(nfi->fib_metrics, fi->fib_metrics,
> -                          sizeof(fi->fib_metrics)) == 0 &&
> +                          sizeof(u32) * RTAX_MAX) == 0 &&
>                    ((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_F_DEAD) == 0 &&
>                    (nfi->fib_nhs == 0 || nh_comp(fi, nfi) == 0))
>                        return fi;

Tested-by: Alessandro Suardi <alessandro.suardi@gmail.com>



I will however make one more bug report, as vpnc is broken before
 and after this patch - have to dig out what vpnc-script tries to do,
 which results in

Error: either "to" is duplicate, or "ipid" is a garbage.

 after establishing the VPN tunnel.


Thanks,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
