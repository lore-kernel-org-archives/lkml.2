Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab2AQErb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 23:47:31 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52597 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2AQEra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 23:47:30 -0500
Message-ID: <1326775643.2564.36.camel@edumazet-laptop>
Subject: Re: [patch v2, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?UTF-8?Q?=C5=A0tefan?= Gula <steweg@ynet.sk>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 17 Jan 2012 05:47:23 +0100
In-Reply-To: <CAGsizz+2nH+Sx+7TjZwEeKBiHbio0BxoN7CgT4Sspp0EzRN6Ug@mail.gmail.com>
References: <CAGsizz+x1GVNR9Pz=b7wO0ELx29=FMosfvhQWL5K26EpkwsUCg@mail.gmail.com>
	 <1326745733.2564.14.camel@edumazet-laptop>
	 <CAGsizz+2nH+Sx+7TjZwEeKBiHbio0BxoN7CgT4Sspp0EzRN6Ug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 janvier 2012 à 00:11 +0100, Štefan Gula a écrit :

> I agree with you, but for the start of this feature I believe static
> slots size is enough here - same limitation is inside the original
> linux bridge code. I have merged hopefully all your comments and here
> is the newest patch:



1) Before sending a new version of your patch, please fix your mailer,
you can read Documentation/email-clients.txt for hints.

Send it to you and check you can apply it.
Then, once you are confident its OK, you can send it to netdev.

Right now, it doesnt apply, because of unexpected line wraps.

# cd next-next
# cat /tmp/patch | patch -p1
patching file include/net/ipip.h
patching file net/ipv4/Kconfig
patching file net/ipv4/ip_gre.c
patch: **** malformed patch at line 495: ipgre_tap_bridge_entry *entry)


2) You call ipgre_tap_bridge_fini() from ipgre_exit_net() and
ipgre_init_net(), thats completely bogus if CONFIG_NET_NS=y

Just remove the struct kmem_cache *ipgre_tap_bridge_cache
and use instead kmalloc(sizeof(...))/kfree(ptr) instead.

3) ipgre_tap_bridge_init() should not be __net_init, but __init


4) I cant find why you store 'struct net_device *dev;' in a
ipgre_tap_bridge_entry, it seems you never read it ?

5) Also please add an empty line between variable declaration and
function body. Also, we prefer an alignement of parameters.

For example :

static __be32 ipgre_tap_bridge_get_raddr(struct ip_tunnel *tunnel,
	const unsigned char *addr)
{
	__be32 raddr;
	struct ipgre_tap_bridge_entry *entry;
	rcu_read_lock();
	entry = __ipgre_tap_bridge_get(tunnel, addr);
	if (entry == NULL)
		raddr = 0;
	else
		raddr = entry->raddr;
	rcu_read_unlock();
 	return raddr;
}

should be :

static __be32 ipgre_tap_bridge_get_raddr(struct ip_tunnel *tunnel,
					 const unsigned char *addr)
{
	__be32 raddr = 0;
	struct ipgre_tap_bridge_entry *entry;

	rcu_read_lock();
	entry = __ipgre_tap_bridge_get(tunnel, addr);
	if (entry)
		raddr = entry->raddr;
	rcu_read_unlock();

	return raddr;
}






