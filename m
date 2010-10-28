Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408Ab0J1Sm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:42:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50752 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab0J1SmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Z6fOne8MH3DsIlqMTfbVxeuGeP54tK3tj8C6LHWw4QVPEDAs755eJAw2irRhDdRNYv
         9w4Bnt/jz+omAMC2dU88z2Oubk+RKVzwmGAtoVJjP1HChjmrEaiUnG9hbUj6pRQkxhbQ
         tshSsIiSacPpXbuSGKhNf4tT8b+Ujtft25TnE=
MIME-Version: 1.0
In-Reply-To: <201010231923.o9NJN2oc012438@hera.kernel.org>
References: <201010231923.o9NJN2oc012438@hera.kernel.org>
Date: Thu, 28 Oct 2010 20:42:21 +0200
X-Google-Sender-Auth: Tdapb2OoPS7Dml0qEPhmTdaSCfI
Message-ID: <AANLkTikuvBb79Q-mKK-u3tL=f433Om4T3NqJUynv=8=w@mail.gmail.com>
Subject: Re: netfilter: nf_nat: make find/put static
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Hemminger <shemminger@vyatta.com>,
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
> Gitweb:     http://git.kernel.org/linus/0c200d935346fe0ebde9b6dffbb683dddd166fb9
> Commit:     0c200d935346fe0ebde9b6dffbb683dddd166fb9
> Parent:     758ff03387228824617cef9507e5682488bf9e0c
> Author:     Stephen Hemminger <shemminger@vyatta.com>
> AuthorDate: Mon Oct 4 20:53:18 2010 +0200
> Committer:  Patrick McHardy <kaber@trash.net>
> CommitDate: Mon Oct 4 20:53:18 2010 +0200
>
>    netfilter: nf_nat: make find/put static
>
>    The functions nf_nat_proto_find_get and nf_nat_proto_put are
>    only used internally in nf_nat_core. This might break some out
>    of tree NAT module.
>
>    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>    Signed-off-by: Patrick McHardy <kaber@trash.net>
> ---
>  include/net/netfilter/nf_nat_protocol.h |    3 ---
>  net/ipv4/netfilter/nf_nat_core.c        |    6 ++----
>  2 files changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/include/net/netfilter/nf_nat_protocol.h b/include/net/netfilter/nf_nat_protocol.h
> index df17bac..93cc90d 100644
> --- a/include/net/netfilter/nf_nat_protocol.h
> +++ b/include/net/netfilter/nf_nat_protocol.h
> @@ -45,9 +45,6 @@ struct nf_nat_protocol {
>  extern int nf_nat_protocol_register(const struct nf_nat_protocol *proto);
>  extern void nf_nat_protocol_unregister(const struct nf_nat_protocol *proto);
>
> -extern const struct nf_nat_protocol *nf_nat_proto_find_get(u_int8_t protocol);
> -extern void nf_nat_proto_put(const struct nf_nat_protocol *proto);
> -
>  /* Built-in protocols. */
>  extern const struct nf_nat_protocol nf_nat_protocol_tcp;
>  extern const struct nf_nat_protocol nf_nat_protocol_udp;
> diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
> index 2c084b3..e2e00c4 100644
> --- a/net/ipv4/netfilter/nf_nat_core.c
> +++ b/net/ipv4/netfilter/nf_nat_core.c
> @@ -47,7 +47,7 @@ __nf_nat_proto_find(u_int8_t protonum)
>        return rcu_dereference(nf_nat_protos[protonum]);
>  }
>
> -const struct nf_nat_protocol *
> +static const struct nf_nat_protocol *
>  nf_nat_proto_find_get(u_int8_t protonum)
>  {
>        const struct nf_nat_protocol *p;
> @@ -60,14 +60,12 @@ nf_nat_proto_find_get(u_int8_t protonum)
>
>        return p;
>  }
> -EXPORT_SYMBOL_GPL(nf_nat_proto_find_get);
>
> -void
> +static void
>  nf_nat_proto_put(const struct nf_nat_protocol *p)
>  {
>        module_put(p->me);
>  }
> -EXPORT_SYMBOL_GPL(nf_nat_proto_put);
>
>  /* We keep an extra hash for each conntrack, for fast searching. */
>  static inline unsigned int

They should be moved inside the
"#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)",
as I now get:

net/ipv4/netfilter/nf_nat_core.c:52: warning: ‘nf_nat_proto_find_get’
defined but not used
net/ipv4/netfilter/nf_nat_core.c:66: warning: ‘nf_nat_proto_put’
defined but not used

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
