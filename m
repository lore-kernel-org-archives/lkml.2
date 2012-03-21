Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab2CUO7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:59:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871Ab2CUO7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:59:48 -0400
Message-ID: <4F69EC88.2070006@redhat.com>
Date: Wed, 21 Mar 2012 10:58:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: =?windows-1252?Q?Karol_=8Aebesta?= <sebesta.karol@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-admin@vger.kernel.org
Subject: Re: extreme system load [kswapd]
References: <CA+pWcCZ28ByXuOu72FAAAQAPny3O0WDvd+vv1TryXw+9DMKwiA@mail.gmail.com>
In-Reply-To: <CA+pWcCZ28ByXuOu72FAAAQAPny3O0WDvd+vv1TryXw+9DMKwiA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 05:08 AM, Karol Šebesta wrote:
> Hello @All,
>
> We have a problem on our production machine with high CPU utilization
> caused by kswapd3 daemon. Server is 128GB of physical memory and 81GB
> of SWAP.

> # free -m
>               total       used       free     shared    buffers     cached
> Mem:        128989      75577      53412          0        416      57131
> -/+ buffers/cache:      18029     110960
> Swap:        81919      31310      50609
> #

Looks like a combination of NUMA and the workload thrown
at the system.  You did not post any vmstat output, or
info on the size of your Oracle SGA, so I will take some
wild guesses here :)

Not only are you 31GB in swap, you also have 53GB of
memory free. Additionally, only kswapd3 is very busy,
while kswapd on the other NUMA nodes do not even show
up in top.

I would guess that the value of /proc/sys/vm/zone_reclaim_mode
is 1, causing the system to reclaim memory from the NUMA node
where things are running, instead of overflowing memory
allocations into other NUMA nodes.

Setting zone_reclaim_mode to 0 could resolve some of your
issues.

Another, more fundamental, issue is that on older kernels
we mix page cache and process pages on the same LRU lists.
This causes the pageout code to scan over many pages that
we do not want to evict, increasing CPU use by kswapd and
other processes invoking the pageout code.

That issue got fixed in newer kernels, including the
kernel in RHEL 6.

