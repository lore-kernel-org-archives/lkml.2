Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab1DMK3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 06:29:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46541 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187Ab1DMK3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 06:29:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cg8nxfgFH26Otcc4o3rKOgU91OiKrgyv1W446E+6OBT6fXYueSSlZ/ZKmQ0XL55r0X
         X91A/et5eTX0xUbOYh/OHWjC0hG2Zohsj2OjpntjC9OYXr6aovqbKmxzK4kA1OM0F7mi
         05w6fRWHuFKl4FwmlbbnmsYMqfDs/16UstPa0=
MIME-Version: 1.0
In-Reply-To: <20110409101514.GA4262@albatros>
References: <20110409101514.GA4262@albatros>
Date: Wed, 13 Apr 2011 13:29:49 +0300
Message-ID: <BANLkTi=ogJg_uJqsJFpnwnnr6LS+SFT3Vg@mail.gmail.com>
Subject: Re: [PATCH] net: ipv4: add IPPROTO_ICMP socket kind
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Pavel Kankovsky <peak@argo.troja.mff.cuni.cz>,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Eugene Teo <eugene@redhat.com>, Nelson Elhage <nelhage@ksplice.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Pekka Savola <pekkas@netcore.fi>, James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 9, 2011 at 1:15 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> This patch adds IPPROTO_ICMP socket kind.

> +       seq_printf(f, "%5d: %08X:%04X %08X:%04X"
> +               " %02X %08X:%08X %02X:%08lX %08X %5d %8d %lu %d %p %d%n",
> +               bucket, src, srcp, dest, destp, sp->sk_state,
> +               sk_wmem_alloc_get(sp),
> +               sk_rmem_alloc_get(sp),
> +               0, 0L, 0, sock_i_uid(sp), 0, sock_i_ino(sp),

These zeroes can be embedded into format string for slightly faster printing.

> +static const struct file_operations ping_seq_fops = {
> +       .owner          = THIS_MODULE,

Unnecessary line.
->owner is unused for proc files, this is not documented anywhere, but
it's unused.

> +       .open           = ping_seq_open,
> +       .read           = seq_read,
> +       .llseek         = seq_lseek,
> +       .release        = seq_release_net,
> +};
> +
> +static const char ping_proc_name[] = "icmp";

Ewww :-)
Does not compiler create only one string?

> +static int ping_proc_register(struct net *net)
> +{
> +       struct proc_dir_entry *p;
> +       int rc = 0;
> +
> +       p = proc_create_data(ping_proc_name, S_IRUGO, net->proc_net,
> +                            &ping_seq_fops, NULL);

There is proc_net_fops_create().

> +       if (!p)
> +               rc = -ENOMEM;
> +       return rc;
> +}

> @@ -680,6 +747,15 @@ static struct ctl_table ipv4_net_table[] = {
>                .mode           = 0644,
>                .proc_handler   = proc_dointvec
>        },
> +#ifdef CONFIG_IP_PING
> +       {
> +               .procname       = "ping_group_range",
> +               .data           = &init_net.ipv4.sysctl_ping_group_range,
> +               .maxlen         = sizeof(init_net.ipv4.sysctl_ping_group_range),
> +               .mode           = 0644,
> +               .proc_handler   = ipv4_ping_group_range,
> +       },
> +#endif
>        { }
>  };
>
> @@ -714,8 +790,22 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
>                        &net->ipv4.sysctl_icmp_ratemask;
>                table[6].data =
>                        &net->ipv4.sysctl_rt_cache_rebuild_count;
> +#ifdef CONFIG_IP_PING
> +               table[7].data =
> +                       &net->ipv4.sysctl_ping_group_range;
> +#endif

Now I understand it's not related, but next sysctl will have
"table[8].data = ..." line which is off-by-one if CONFIG_IP_PING=n.
