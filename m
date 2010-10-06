Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab0JFHsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:48:18 -0400
Received: from smtp-out.google.com ([74.125.121.35]:19594 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab0JFHsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:48:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RKA/bcDkO0TNHTNW1ujuLlmErezxCzvG4cLNnewVrAqudf1DtfDL8iIlORCGLqBDcn
         RyN2OkxRdEN4RO97XFuQ==
MIME-Version: 1.0
In-Reply-To: <20101006.003541.71128466.davem@davemloft.net>
References: <AANLkTikkv4htP1f=KFwSaa8=K6LicDN0eusXctow-Efb@mail.gmail.com> <20101006.003541.71128466.davem@davemloft.net>
From: =?UTF-8?B?Q2h1bmctWWloIFdhbmcgKOeOi+W0h+aHvyk=?= 
	<cywang@google.com>
Date: Wed, 6 Oct 2010 00:47:47 -0700
Message-ID: <AANLkTikx+GadeYfg5rZNxsEig-0Af97ER7V94fjaVc+U@mail.gmail.com>
Subject: Re: [PATCH] net: Fix sk_dst_check() to reset the obsolete dst_entry
 of a socket.
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, timo.teras@iki.fi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fact, that is what I intent to change originally. However, consider
Timo's issue, I intent to submit this patch instead.

On Wed, Oct 6, 2010 at 12:35 AM, David Miller <davem@davemloft.net> wrote:
>
> This should have been fixed by:
>
> --------------------
> commit ae2688d59b5f861dc70a091d003773975d2ae7fb
> Author: Jianzhao Wang <jianzhao.wang@6wind.com>
> Date:   Wed Sep 8 14:35:43 2010 -0700
>
>    net: blackhole route should always be recalculated
>
>    Blackhole routes are used when xfrm_lookup() returns -EREMOTE (error
>    triggered by IKE for example), hence this kind of route is always
>    temporary and so we should check if a better route exists for next
>    packets.
>    Bug has been introduced by commit d11a4dc18bf41719c9f0d7ed494d295dd2973b92.
>
>    Signed-off-by: Jianzhao Wang <jianzhao.wang@6wind.com>
>    Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 3f56b6e..6298f75 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2738,6 +2738,11 @@ slow_output:
>  }
>  EXPORT_SYMBOL_GPL(__ip_route_output_key);
>
> +static struct dst_entry *ipv4_blackhole_dst_check(struct dst_entry *dst, u32 cookie)
> +{
> +       return NULL;
> +}
> +
>  static void ipv4_rt_blackhole_update_pmtu(struct dst_entry *dst, u32 mtu)
>  {
>  }
> @@ -2746,7 +2751,7 @@ static struct dst_ops ipv4_dst_blackhole_ops = {
>        .family                 =       AF_INET,
>        .protocol               =       cpu_to_be16(ETH_P_IP),
>        .destroy                =       ipv4_dst_destroy,
> -       .check                  =       ipv4_dst_check,
> +       .check                  =       ipv4_blackhole_dst_check,
>        .update_pmtu            =       ipv4_rt_blackhole_update_pmtu,
>        .entries                =       ATOMIC_INIT(0),
>  };
>
