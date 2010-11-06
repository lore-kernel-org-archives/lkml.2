Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab0KFJLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 05:11:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:32952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0KFJLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 05:11:48 -0400
Message-ID: <4CD51BD0.8040609@kernel.org>
Date: Sat, 06 Nov 2010 10:11:44 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Ben Greear <greearb@candelatech.com>, NetDev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: OOM when adding ipv6 route:  How to make available more per-cpu
 memory?
References: <4CD43C87.5040403@candelatech.com>	 <1288980361.2882.1070.camel@edumazet-laptop>	 <4CD449A5.5070305@candelatech.com>	 <1288988403.2665.268.camel@edumazet-laptop> <1288995103.2665.653.camel@edumazet-laptop>
In-Reply-To: <1288995103.2665.653.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 06 Nov 2010 09:11:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/05/2010 11:11 PM, Eric Dumazet wrote:
> Le vendredi 05 novembre 2010 à 21:20 +0100, Eric Dumazet a écrit :
>> Your vmalloc space is very fragmented. pcpu_get_vm_areas() want
>> hugepages (4MB on your machine, 2MB on mine because I have
>> CONFIG_HIGHMEM64G=y)
> 
> Well, this is wrong. We use normal (4KB) pages, unfortunately.
>
> I have a NUMA machine, with two nodes, so pcpu_get_vm_areas() allocates
> two zones, one for each node, with a 'known' offset between them.
> Then, 4KB pages are allocated to populate the zone when needed.
> 
> # grep pcpu_get_vm_areas /proc/vmallocinfo 
> 0xffffe8ffa0400000-0xffffe8ffa0600000 2097152 pcpu_get_vm_areas+0x0/0x740 vmalloc
> 0xffffe8ffffc00000-0xffffe8ffffe00000 2097152 pcpu_get_vm_areas+0x0/0x740 vmalloc
> 
> BTW, we dont have the number of pages currently allocated in each
> 'vmalloc' zone, and/or node information.
> 
> Tejun, do you have plans to use hugepages eventually ?
> (and fallback to 4KB pages, but most percpu data are allocated right
> after boot)

Well, it's rather complicated.  Till now, the percpu usage hasn't
justified allocating hugepages but it might someday, but more
importantly the reason why those big chunks of address space are used
is to keep the first chunk embedded in the regular linear kernel
address space to avoid extra TLB pressure.

On configurations where vmalloc area is a scarce resource,
percpu_alloc=page can be specified to use page-mapped allocation.
This will use much smaller chunks in vmalloc area at the cost of
additional 4k page TLB pressure for percpu memory in the first chunk
(all the static percpu variables and then some).

pcpu_embed_first_chunk() contains heuristic which makes it yield to
page allocator but the parameter is pretty generous (maximum distance
between chunks > 75% of vmalloc area).  It's there just to avoid
completely crazy cases.  Also, x86 setup_per_cpu_areas() chooses page
allocator on 32bit NUMAs.  This case didn't trigger either.  We
probably need to add another condition.

That large machine on 32bit is bound to be flaky.  To be short on
virtual address space is a pretty silly and stupid thing.  Anyways,
any good idea on what criteria we could test?

Thanks.

-- 
tejun
