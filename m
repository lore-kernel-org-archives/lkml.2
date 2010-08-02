Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab0HBX4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 19:56:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38828 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0HBX4C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 19:56:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=arZvgAZsQ5JqLxHkS5qFGu5mrHOjRYOCHjYfhIz/XLWUMwAPzzERoL0WULeMbx4dTt
         TCIO1BZwhpRHndxskJnnRnhgb5h0kejwlzrQWQl9/34xHvcpgeu+jKbvcPWiehlszhHp
         uG99COoSYbxTne+FbAIZuKp4oIwqVVhfXGA0A=
MIME-Version: 1.0
In-Reply-To: <20100802124734.GI2486@arachsys.com>
References: <20100802124734.GI2486@arachsys.com>
Date: Tue, 3 Aug 2010 08:55:59 +0900
Message-ID: <AANLkTinnWQA-K6r_+Y+giEC9zs-MbY6GFs8dWadSq0kh@mail.gmail.com>
Subject: Re: Over-eager swapping
From: Minchan Kim <minchan.kim@gmail.com>
To: Chris Webb <chris@arachsys.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 9:47 PM, Chris Webb <chris@arachsys.com> wrote:
> We run a number of relatively large x86-64 hosts with twenty or so qemu-kvm
> virtual machines on each of them, and I'm have some trouble with over-eager
> swapping on some (but not all) of the machines. This is resulting in
> customer reports of very poor response latency from the virtual machines
> which have been swapped out, despite the hosts apparently having large
> amounts of free memory, and running fine if swap is turned off.
>
> All of the hosts are running a 2.6.32.7 kernel and have ksm enabled with
> 32GB of RAM and 2x quad-core processors. There is a cluster of Xeon E5420
> machines which apparently doesn't exhibit the problem, and a cluster of
> 2352/2378 Opteron (NUMA) machines, some of which do. The kernel config of
> the affected machines is at
>
>  http://cdw.me.uk/tmp/config-2.6.32.7
>
> This differs very little from the config on the unaffected Xeon machines,
> essentially just
>
>  -CONFIG_MCORE2=y
>  +CONFIG_MK8=y
>  -CONFIG_X86_P6_NOP=y
>
> On a typical affected machine, the virtual machines and other processes
> would apparently leave around 5.5GB of RAM available for buffers, but the
> system seems to want to swap out 3GB of anonymous pages to give itself more
> like 9GB of buffers:
>
>  # cat /proc/meminfo
>  MemTotal:       33083420 kB
>  MemFree:          693164 kB
>  Buffers:         8834380 kB
>  Cached:            11212 kB
>  SwapCached:      1443524 kB
>  Active:         21656844 kB
>  Inactive:        8119352 kB
>  Active(anon):   17203092 kB
>  Inactive(anon):  3729032 kB
>  Active(file):    4453752 kB
>  Inactive(file):  4390320 kB
>  Unevictable:        5472 kB
>  Mlocked:            5472 kB
>  SwapTotal:      25165816 kB
>  SwapFree:       21854572 kB
>  Dirty:              4300 kB
>  Writeback:             4 kB
>  AnonPages:      20780368 kB
>  Mapped:             6056 kB
>  Shmem:                56 kB
>  Slab:             961512 kB
>  SReclaimable:     438276 kB
>  SUnreclaim:       523236 kB
>  KernelStack:       10152 kB
>  PageTables:        67176 kB
>  NFS_Unstable:          0 kB
>  Bounce:                0 kB
>  WritebackTmp:          0 kB
>  CommitLimit:    41707524 kB
>  Committed_AS:   39870868 kB
>  VmallocTotal:   34359738367 kB
>  VmallocUsed:      150880 kB
>  VmallocChunk:   34342404996 kB
>  HardwareCorrupted:     0 kB
>  HugePages_Total:       0
>  HugePages_Free:        0
>  HugePages_Rsvd:        0
>  HugePages_Surp:        0
>  Hugepagesize:       2048 kB
>  DirectMap4k:        5824 kB
>  DirectMap2M:     3205120 kB
>  DirectMap1G:    30408704 kB
>
> We see this despite the machine having vm.swappiness set to 0 in an attempt
> to skew the reclaim as far as possible in favour of releasing page cache
> instead of swapping anonymous pages.
>

Hmm, Strange.
We reclaim only anon pages when the system has few page cache.
(ie, file + free <= high_water_mark)
But in your meminfo, your system has lots of page cache page.
So It isn't likely.

Another possibility is _zone_reclaim_ in NUMA.
Your working set has many anonymous page.

The zone_reclaim set priority to ZONE_RECLAIM_PRIORITY.
It can make reclaim mode to lumpy so it can page out anon pages.

Could you show me /proc/sys/vm/[zone_reclaim_mode/min_unmapped_ratio] ?

-- 
Kind regards,
Minchan Kim
