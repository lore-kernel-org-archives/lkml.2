Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2AQKoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:44:21 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48926 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2AQKoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:44:19 -0500
MIME-Version: 1.0
In-Reply-To: <1326788970.2564.52.camel@edumazet-laptop>
References: <CAGsizz+x1GVNR9Pz=b7wO0ELx29=FMosfvhQWL5K26EpkwsUCg@mail.gmail.com>
 <1326745733.2564.14.camel@edumazet-laptop> <CAGsizz+2nH+Sx+7TjZwEeKBiHbio0BxoN7CgT4Sspp0EzRN6Ug@mail.gmail.com>
 <1326775643.2564.36.camel@edumazet-laptop> <CAGsizz+kgBB9APmU9dPExkGQvPUVa3m6qz3NvSguPYNuJQQ_7Q@mail.gmail.com>
 <1326788970.2564.52.camel@edumazet-laptop>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
Date: Tue, 17 Jan 2012 11:43:58 +0100
X-Google-Sender-Auth: b2rfc32dGHP_oZykH_gW9hdf7ig
Message-ID: <CAGsizzLwCTpuZsZyx24T9WZy1DSJo+rfhDxLsE8UmeZOSxw+mA@mail.gmail.com>
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

Dňa 17. januára 2012 9:29, Eric Dumazet <eric.dumazet@gmail.com> napísal/a:
> Le mardi 17 janvier 2012 à 09:04 +0100, Štefan Gula a écrit :
>> Dňa 17. januára 2012 5:47, Eric Dumazet <eric.dumazet@gmail.com> napísal/a:
>> >
>> > 2) You call ipgre_tap_bridge_fini() from ipgre_exit_net() and
>> > ipgre_init_net(), thats completely bogus if CONFIG_NET_NS=y
>> >
>> > Just remove the struct kmem_cache *ipgre_tap_bridge_cache
>> > and use instead kmalloc(sizeof(...))/kfree(ptr) instead.
>> >
>> As this is completely the same part of code from net/bridge/br_fdb.c,
>> can you give me a hint about how change that as I believe it should be
>> changed also there?
>
> Please dont copy code you dont understand :(
>
> bridge code is ok, but not yours, since you destroy the kmem_cache when
> a net namespace exits.
>
> Either you fix your code, either you change your memory allocations to
> mere kmalloc()/kfree() calls and dont care of a private kmem_cache you
> have to create and destroy.
>
> Since you ask a SLAB_HWCACHE_ALIGN, the SLUB allocator will anyway merge
> your kmem_cache with the standard one (kmalloc-64 I guess)
>
>
>
ok maybe I am getting it wrong, but I am little bit stuck here. I
recheck the original bridge code. The difference I recognize is that
in bridge code function:
br_fdb_init() and br_fdb_fini()
are called from module init and module exit functions:
br_init and br_deinit

in my code they are called from functions:
ipgre_init_net and ipgre_exit_net
instead of:
ipgre_init and ipgre_fini

To be honest I am not so familiar enough with kernel structure that I
see the difference on the first time. But I think that with your help
it can be done easily. The main idea was to create hash-table that is
used to determine the destination IPv4 address (part of the entry
structure). That hash-table should be different per each gretap
interface - I think that's the reason why I put those init and fini
inside ipgre_init_net and ipgre_exit_net. Am I right that the
placement of this calls is correct or not? If not where those calls
should be placed?

On the other hand I have no idea how to substitute those two function
with a code that you are suggesting kmalloc()/kfree(). I would be glad
if you can help me here by providing me example how to substitute
those two functions with kmalloc/kfree for the future usage (I am more
reverse engineer learner type of person than manuals reading one)
