Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab0HYAsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:48:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44010 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab0HYAsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:48:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4C7214DD.30500@superonline.com>
References: <20100823091948.6029.A69D9226@jp.fujitsu.com> <4C7214DD.30500@superonline.com>
Message-Id: <20100824094152.F3B0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 25 Aug 2010 09:48:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello,
> 
> On 23/08/10 03:22 AM, KOSAKI Motohiro wrote:
> > 
> > sorry, my last mail has some mistake.
> > 
> 
> No problem. I did the tests again according to your new instructions,
> and I am appending the results.

Great!

> > 1. Please let me know your machine & test script
> >
> 
> % ./your-fills-up-the-tmpfs-script   (i.e. run your script)
> 
> > % cat /proc/meminfo
> 
> MemTotal:        3104484 kB
> MemFree:         1258780 kB

Hm, free memory is enough lots.


> Buffers:           30820 kB
> Cached:          1693836 kB
> SwapCached:            0 kB
> Active:          1670344 kB
> Inactive:         137960 kB
> Active(anon):    1633940 kB
> Inactive(anon):    26224 kB
> Active(file):      36404 kB
> Inactive(file):   111736 kB
> Unevictable:          32 kB
> Mlocked:              32 kB
> HighTotal:       2226632 kB
> HighFree:         437684 kB

You are using 32 bit system.

> LowTotal:         877852 kB
> LowFree:          821096 kB

low memory is empty!


> SwapTotal:       1999540 kB
> SwapFree:        1999540 kB
> Dirty:                28 kB
> Writeback:             0 kB
> AnonPages:         83676 kB
> Mapped:            44220 kB
> Shmem:           1576520 kB

tmpfs files are using about 1.5GB memory.
(because tmpfs is limited totalmem/2 by default)


> Slab:              17136 kB
> SReclaimable:       9480 kB
> SUnreclaim:         7656 kB
> KernelStack:        1832 kB
> PageTables:         2440 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:     3551780 kB
> Committed_AS:    1892636 kB
> VmallocTotal:     122880 kB
> VmallocUsed:       16308 kB
> VmallocChunk:      92764 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       4096 kB
> DirectMap4k:       24568 kB
> DirectMap4M:      884736 kB


> > % cat /proc/zoneinfo
> 
> Node 0, zone      DMA
>  recent_anon_rotated: 0
>  recent_anon_scanned: 0
>  recent_file_rotated: 0
>  recent_file_scanned: 0
>  anon_ratio:          30
> Node 0, zone   Normal
>  recent_anon_rotated: 0
>  recent_anon_scanned: 0
>  recent_file_rotated: 272
>  recent_file_scanned: 1385
>  anon_ratio:          7
> Node 0, zone  HighMem
>  recent_anon_rotated: 1259857
>  recent_anon_scanned: 2522124
>  recent_file_rotated: 1269
>  recent_file_scanned: 5591
>  anon_ratio:          16

anon/file reclaim scanning ratio is NOT strange.


> 
> > % df
> 
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sda15            10317828   7309436   2484276  75% /
> tmpfs                  1552240         8   1552232   1% /lib/init/rw
> udev                   1549148       220   1548928   1% /dev
> tmpfs                  1552240         4   1552236   1% /dev/shm
> tmpfs                  1552240   1552240         0 100% /tmp

Seems typical one drive system. no strange.


> > % cat your-fills-up-the-tmpfs-script
> 
> #!/bin/bash
> 
> rm -vf /tmp/tmp
> dd if=/dev/zero of=/tmp/tmp bs=1024k count=1600
> shred -vn1 /tmp/tmp
> 
> exit 0 ### removed when testing hibernation
> 
> read -p "Press enter to hibernate..."
> 
> echo -n reboot > /sys/power/disk
> echo -n disk > /sys/power/state
> 
> echo "Exit code: $?"
> 
> rm -vf /tmp/tmp

Almostly same with my test program ;)


> > # echo 1 > /proc/sys/vm/shrink_all_memory
> 
> > # tail /var/log/messages
> 
> [  439.165652] shrink_all_memory start
> [  439.165960] shrink_all_memory: req:1 reclaimed:32 free:313765
> 

My code doesn't makes hang!


Hmm... Hmm...
To be honest, I have no idea why your hang was happen.

1) zone normal is not used. your system don't need additional reclaim
   at all.
2) reclaim logic seems to doesn't makes hang.


Can you please try following additional test?

# echo 8 > /proc/sysrq-trigger
# echo disk > /sys/power/state




