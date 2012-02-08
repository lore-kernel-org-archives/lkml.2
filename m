Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab2BHMeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:34:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65002 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab2BHMeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:34:19 -0500
MIME-Version: 1.0
In-Reply-To: <20120208115244.GA24959@sig21.net>
References: <201202041109.53003.toralf.foerster@gmx.de>
	<201202051107.26634.toralf.foerster@gmx.de>
	<CAJd=RBCvvVgWqfSkoEaWVG=2mwKhyXarDOthHt9uwOb2fuDE9g@mail.gmail.com>
	<201202080956.18727.toralf.foerster@gmx.de>
	<20120208115244.GA24959@sig21.net>
Date: Wed, 8 Feb 2012 20:34:14 +0800
Message-ID: <CAJd=RBDbYA4xZRikGtHJvKESdiSE-B4OucZ6vQ+tHCi+hG2+aw@mail.gmail.com>
Subject: Re: swap storm since kernel 3.2.x
From: Hillf Danton <dhillf@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/8 Johannes Stezenbach <js@sig21.net>:
> On Wed, Feb 08, 2012 at 09:56:15AM +0100, Toralf Förster wrote:
>>
>> From what I can tell is this:
>> If the system is under heavy I/O load and hasn't too much free RAM (git pull,
>> svn update and RAM consuming BOINC applications) then kernel 3.0.20 handle
>> this somehow while 3.2.x run into a swap storm like.
>
> FWIW, I also saw heavy swapping with 3.2.2 with the
> CONFIG_DEBUG_OBJECTS issue reported here:
> http://lkml.org/lkml/2012/1/30/227
>
> But the thing is that even though SUnreclaim was
> huge there was still 1G MemFree and it swapped heavily
> on idle system when just switching between e.g. Firefox and gvim.
>
> Today I'm running 3.2.4 with CONFIG_DEBUG_OBJECTS disabled
> (but otherwise the same config) and it doesn't swap even
> after a fair amount of I/O:

Hah, looks not related to kswapd directly;)

>
> MemTotal:        3940088 kB
> MemFree:         1024920 kB
> Buffers:          293328 kB
> Cached:           447796 kB
> SwapCached:           24 kB
> Active:           847136 kB
> Inactive:         567200 kB
> Active(anon):     478736 kB
> Inactive(anon):   246744 kB
> Active(file):     368400 kB
> Inactive(file):   320456 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> SwapTotal:       3903484 kB
> SwapFree:        3903196 kB
> Dirty:                16 kB
> Writeback:             0 kB
> AnonPages:        673192 kB
> Mapped:            40956 kB
> Shmem:             52268 kB
> Slab:            1434188 kB
> SReclaimable:    1367388 kB
> SUnreclaim:        66800 kB
> KernelStack:        1600 kB
> PageTables:         4880 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:     5873528 kB
> Committed_AS:    1744916 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      348116 kB
> VmallocChunk:   34359362739 kB
> DirectMap4k:       12288 kB
> DirectMap2M:     4098048 kB
>
>  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>  586182 353006  60%    1.74K  32595       18   1043040K ext3_inode_cache
>  289062 170979  59%    0.58K  10706       27    171296K dentry
>  247266 107729  43%    0.42K  13737       18    109896K buffer_head
>
>
And I want to ask kswapd to do less work, the attached diff is
based on 3.2.5, mind to test it with CONFIG_DEBUG_OBJECTS enabled?

Thanks
Hillf

--- a/mm/vmscan.c	Wed Feb  8 20:10:14 2012
+++ b/mm/vmscan.c	Wed Feb  8 20:15:22 2012
@@ -2113,8 +2113,11 @@ restart:
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
+		if (nr_reclaimed >= nr_to_reclaim) {
+			nr_to_reclaim = 0;
 			break;
+		}
+		nr_to_reclaim -= nr_reclaimed;
 	}
 	blk_finish_plug(&plug);
 	sc->nr_reclaimed += nr_reclaimed;
@@ -2683,12 +2686,12 @@ static unsigned long balance_pgdat(pg_da
 		 * we want to put equal scanning pressure on each zone.
 		 */
 		.nr_to_reclaim = ULONG_MAX,
-		.order = order,
 		.target_mem_cgroup = NULL,
 	};
 	struct shrink_control shrink = {
 		.gfp_mask = sc.gfp_mask,
 	};
+	sc.order = order = 0;
 loop_again:
 	total_scanned = 0;
 	sc.nr_reclaimed = 0;
--
