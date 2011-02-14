Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab1BNMQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:16:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53692 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab1BNMQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:16:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vyCGwBn8dYUhOjmcV0am255nAUilQntfBxUI4yId3MocKlSBfEE0jJCJIVDySIAYOj
         4g7FzXDeqZ5brwXgwA1derVfTXYvhKUC/60QA9/377l/PZ0vvRfqyPQcinMoOSCc+Kvv
         vnBZtq/Kr+D4nUnefIwwjJ/dXS3dGjFBvis6w=
Message-ID: <4D591D04.4050000@gmail.com>
Date: Mon, 14 Feb 2011 13:16:04 +0100
From: =?ISO-8859-1?Q?Nicolas_de_Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>, Changli Gao <xiaosuo@gmail.com>,
        Jesse Gross <jesse@nicira.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] core: dev: don't call BUG() on bad input
References: <1297680967-11893-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1297680967-11893-1-git-send-email-segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/02/2011 11:56, Vasiliy Kulikov a écrit :
> alloc_netdev() may be called with too long name (more that IFNAMSIZ bytes).
> Currently this leads to BUG().  Other insane inputs (bad txqs, rxqs) and
> even OOM don't lead to BUG().  Made alloc_netdev() return NULL, like on
> other errors.
>
> Signed-off-by: Vasiliy Kulikov<segoon@openwall.com>
> ---
>   Compile tested.
>
>   net/core/dev.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6392ea0..12ef4b0 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5761,7 +5761,10 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>   	size_t alloc_size;
>   	struct net_device *p;
>
> -	BUG_ON(strlen(name)>= sizeof(dev->name));
> +	if (strnlen(name, sizeof(dev->name))>= sizeof(dev->name)) {

"size_t strnlen(const char *s, size_t maxlen) : The strnlen() function returns strlen(s), if that is 
less than maxlen, or maxlen if there is no '\0' character among the first maxlen characters pointed 
to by s."

How can strnlen(name, sizeof(dev->name)) be greater than sizeof(dev->name)?

Shouldn't it be "if (strnlen(name, sizeof(dev->name)) == sizeof(dev->name))" instead?

         Nicolas.

> +		pr_err("alloc_netdev: Too long device name \n");
> +		return NULL;
> +	}
>
>   	if (txqs<  1) {
>   		pr_err("alloc_netdev: Unable to allocate device "

