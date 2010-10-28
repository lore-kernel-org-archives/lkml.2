Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136Ab0J1Svw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:51:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35535 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab0J1Svp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=taLK/mIS9/gfVnsrBmlAGju66HvvahdRYN0/qJGPtRE4e8EnoOBBcFOP2cwMI690yi
         hScdssCBNR46S/aMc1qnaLImBQuOTYlDVMC2BmkJrjAUKm2xvKZ/8p/NCsBY/a4MBPv7
         OFj0W7Anyc5XchNz56Eeks9cUKcl5kms80Ato=
MIME-Version: 1.0
In-Reply-To: <201010231923.o9NJNK9U013494@hera.kernel.org>
References: <201010231923.o9NJNK9U013494@hera.kernel.org>
Date: Thu, 28 Oct 2010 20:51:43 +0200
X-Google-Sender-Auth: 7_a-D62mZs5X932rxT3JMVC_LU8
Message-ID: <AANLkTi=KRAcoonwFHKNaptap2LQHDswRCGpect82aHzx@mail.gmail.com>
Subject: Re: tproxy: added IPv6 support to the socket match
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Balazs Scheidler <bazsi@balabit.hu>, KOVACS Krisztian <hidden@balabit.hu>,
        Patrick McHardy <kaber@trash.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 21:23, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/b64c9256a9b76fc9f059f71bd08ba88fb0cbba2e
> Commit:     b64c9256a9b76fc9f059f71bd08ba88fb0cbba2e
> Parent:     6ad7889327a5ee6ab4220bd34e4428c7d0de0f32
> Author:     Balazs Scheidler <bazsi@balabit.hu>
> AuthorDate: Thu Oct 21 16:19:42 2010 +0200
> Committer:  Patrick McHardy <kaber@trash.net>
> CommitDate: Thu Oct 21 16:19:42 2010 +0200
>
>    tproxy: added IPv6 support to the socket match
>
>    The ICMP extraction bits were contributed by Harry Mason.
>
>    Signed-off-by: Balazs Scheidler <bazsi@balabit.hu>
>    Signed-off-by: KOVACS Krisztian <hidden@balabit.hu>
>    Signed-off-by: Patrick McHardy <kaber@trash.net>
> ---
>  net/netfilter/xt_socket.c |  165 ++++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 154 insertions(+), 11 deletions(-)
>
> diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
> index 266faa0..2dbd4c8 100644
> --- a/net/netfilter/xt_socket.c
> +++ b/net/netfilter/xt_socket.c

> +static bool
> +socket_mt6_v1(const struct sk_buff *skb, struct xt_action_param *par)
> +{
> +       struct ipv6hdr *iph = ipv6_hdr(skb);
> +       struct udphdr _hdr, *hp = NULL;
> +       struct sock *sk;
> +       struct in6_addr *daddr, *saddr;
> +       __be16 dport, sport;
> +       int thoff;
> +       u8 tproto;

tproto is unsigned...

> +       const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
> +
> +       tproto = ipv6_find_hdr(skb, &thoff, -1, NULL);

but ipv6_find_hdr() returns int, and negative values for errors...

> +       if (tproto < 0) {

which it can never catch.

> +               pr_debug("unable to find transport header in IPv6 packet, dropping\n");
> +               return NF_DROP;
> +       }

net/netfilter/xt_socket.c:256: warning: comparison is always false due
to limited range of data type

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
