Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1BYU7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:59:53 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54762 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab1BYU7v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:59:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uCZulXYOAFseqo6rmndMTdyfx2+sHf2eUK1HPsCjaZw5Qeto0CDL6GOx1qOlgLbdkT
         c0DDMrxIsrORoTE8C1iB2Kycur5cTN7/ZozcwtR59/sTMpVBizF1eQlCEhA3ctcDskQB
         SpK2KcaaJot2KrabzmzozB5Jsst0Z5VWOsIxA=
MIME-Version: 1.0
In-Reply-To: <1298666310.2554.47.camel@bwh-desktop>
References: <1298660879.2554.23.camel@bwh-desktop>
	<20110225.111606.115927805.davem@davemloft.net>
	<1298662216.2554.33.camel@bwh-desktop>
	<20110225.114351.28809001.davem@davemloft.net>
	<1298663585.2554.39.camel@bwh-desktop>
	<1298666310.2554.47.camel@bwh-desktop>
Date: Fri, 25 Feb 2011 21:59:50 +0100
Message-ID: <AANLkTikmtKksP6o1hecf0=ZnRv0j4+_Q326UEG8ss16k@mail.gmail.com>
Subject: Re: [PATCH] don't allow CAP_NET_ADMIN to load non-netdev kernel modules
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>, segoon@openwall.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, eric.dumazet@gmail.com,
        therbert@google.com, xiaosuo@gmail.com, jesse@nicira.com,
        kees.cook@canonical.com, eugene@redhat.com, dan.j.rosenberg@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/25 Ben Hutchings <bhutchings@solarflare.com>:
> I bet something like this (plus Vasiliy's changes to static module
> aliases) would cover 99.9% of legitimate uses of this feature:
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 54aaca6..0d09baa 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1120,8 +1120,20 @@ void dev_load(struct net *net, const char *name)
>        dev = dev_get_by_name_rcu(net, name);
>        rcu_read_unlock();
>
> -       if (!dev && capable(CAP_NET_ADMIN))
> -               request_module("%s", name);
> +       if (!dev && capable(CAP_NET_ADMIN)) {
> +               /* Check whether the name looks like one that a net
> +                * driver will generate initially.  If not, require a
> +                * module alias with a suitable prefix, so that this
> +                * can't be used to load arbitrary modules.
> +                */
> +               if ((strncmp(name, "eth", 3) == 0 &&
> +                    isdigit((unsigned char)name[3])) ||
> +                   (strncmp(name, "wlan", 4) == 0 &&
> +                    isdigit((unsigned char)name[4])))
> +                       request_module("%s", name);
> +               else
> +                       request_module("netdev-%s", name);
> +       }
>  }
>  EXPORT_SYMBOL(dev_load);
>

This might be better as:

if (request_module("netdev-%s", name))
    ... fallback

Then after some years the fallback could be removed if announced properly.

Best Regards,
Micha³ Miros³aw
