Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab2AQIEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:04:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41117 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab2AQIEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:04:21 -0500
MIME-Version: 1.0
In-Reply-To: <1326775643.2564.36.camel@edumazet-laptop>
References: <CAGsizz+x1GVNR9Pz=b7wO0ELx29=FMosfvhQWL5K26EpkwsUCg@mail.gmail.com>
 <1326745733.2564.14.camel@edumazet-laptop> <CAGsizz+2nH+Sx+7TjZwEeKBiHbio0BxoN7CgT4Sspp0EzRN6Ug@mail.gmail.com>
 <1326775643.2564.36.camel@edumazet-laptop>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Tue, 17 Jan 2012 09:04:00 +0100
X-Google-Sender-Auth: gDofVjCFtwfArC2nzh1XOfK4c3Y
Message-ID: <CAGsizz+kgBB9APmU9dPExkGQvPUVa3m6qz3NvSguPYNuJQQ_7Q@mail.gmail.com>
Subject: Re: [patch v2, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dňa 17. januára 2012 5:47, Eric Dumazet <eric.dumazet@gmail.com> napísal/a:
> Le mardi 17 janvier 2012 à 00:11 +0100, Štefan Gula a écrit :
>
>> I agree with you, but for the start of this feature I believe static
>> slots size is enough here - same limitation is inside the original
>> linux bridge code. I have merged hopefully all your comments and here
>> is the newest patch:
>
>
>
> 1) Before sending a new version of your patch, please fix your mailer,
> you can read Documentation/email-clients.txt for hints.
>
Sorry, I have to test it as I am using clasical gmail web GUI to send emails

> Send it to you and check you can apply it.
> Then, once you are confident its OK, you can send it to netdev.
>
> Right now, it doesnt apply, because of unexpected line wraps.
>
> # cd next-next
> # cat /tmp/patch | patch -p1
> patching file include/net/ipip.h
> patching file net/ipv4/Kconfig
> patching file net/ipv4/ip_gre.c
> patch: **** malformed patch at line 495: ipgre_tap_bridge_entry *entry)
>
>
> 2) You call ipgre_tap_bridge_fini() from ipgre_exit_net() and
> ipgre_init_net(), thats completely bogus if CONFIG_NET_NS=y
>
> Just remove the struct kmem_cache *ipgre_tap_bridge_cache
> and use instead kmalloc(sizeof(...))/kfree(ptr) instead.
>
As this is completely the same part of code from net/bridge/br_fdb.c,
can you give me a hint about how change that as I believe it should be
changed also there?

> 3) ipgre_tap_bridge_init() should not be __net_init, but __init
>
Ok

>
> 4) I cant find why you store 'struct net_device *dev;' in a
> ipgre_tap_bridge_entry, it seems you never read it ?
>
yes you are right, it is not needed - removed from code

> 5) Also please add an empty line between variable declaration and
> function body. Also, we prefer an alignement of parameters.
>
I used scripts/checkpatch.pl to check my coding styles, but apparently
this is missing from it as it never complains before about this.
Anyway hopefully done ok based your comments

> For example :
>
> static __be32 ipgre_tap_bridge_get_raddr(struct ip_tunnel *tunnel,
>        const unsigned char *addr)
> {
>        __be32 raddr;
>        struct ipgre_tap_bridge_entry *entry;
>        rcu_read_lock();
>        entry = __ipgre_tap_bridge_get(tunnel, addr);
>        if (entry == NULL)
>                raddr = 0;
>        else
>                raddr = entry->raddr;
>        rcu_read_unlock();
>        return raddr;
> }
>
> should be :
>
> static __be32 ipgre_tap_bridge_get_raddr(struct ip_tunnel *tunnel,
>                                         const unsigned char *addr)
> {
>        __be32 raddr = 0;
>        struct ipgre_tap_bridge_entry *entry;
>
>        rcu_read_lock();
>        entry = __ipgre_tap_bridge_get(tunnel, addr);
>        if (entry)
>                raddr = entry->raddr;
>        rcu_read_unlock();
>
>        return raddr;
> }
>
>
>
>
>
>
