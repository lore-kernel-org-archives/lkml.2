Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab1HXGUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:20:10 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:41688 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1HXGUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:20:08 -0400
MIME-Version: 1.0
In-Reply-To: <4E5494D4.1050605@profihost.ag>
References: <4E5494D4.1050605@profihost.ag>
Date: Wed, 24 Aug 2011 09:20:07 +0300
X-Google-Sender-Auth: Af8pbctgonFjD5Vd53TSh0XrErM
Message-ID: <CAOJsxLEFYW0eDbXQ0Uixf-FjsxHZ_1nmnovNx1CWj=m-c-_vJw@mail.gmail.com>
Subject: Re: slow performance on disk/network i/o full speed after drop_caches
From: Pekka Enberg <penberg@kernel.org>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Jens Axboe <jaxboe@fusionio.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 9:06 AM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
> i hope this is the correct list to write to if it would be nice to give me a
> hint where i can ask.
>
> Kernel: 2.6.38
>
> I'm seeing some strange problems on some of our servers after upgrading to
> 2.6.38.
>
> I'm copying a 1GB file via scp from Machine A to Machine B. When B is
> freshly booted the file transfer is done with about 80 to 85 Mb/s. I can
> repeat that various times to performance degrease.
>
> Then after some days copying is only done with about 900kb/s up to 3Mb/s
> going up and down while transfering the file.
>
> When i then do drop_caches it works again on 80Mb/s.
>
> sync && echo 3 >/proc/sys/vm/drop_caches && sleep 2 && echo 0
>>/proc/sys/vm/drop_caches
>
> Attached is also an output of meminfo before and after drop_caches.
>
> What's going on here? MemFree is pretty high.
>
> Please CC me i'm not on list.

Interesting. I can imagine one or more of the following to be
involved: networking, vmscan, block, and writeback. Lets CC all of
them!

> # before drop_caches
>
> # cat /proc/meminfo
> MemTotal:        8185544 kB
> MemFree:         6670292 kB
> Buffers:          105164 kB
> Cached:           166672 kB
> SwapCached:            0 kB
> Active:           728308 kB
> Inactive:         567428 kB
> Active(anon):     639204 kB
> Inactive(anon):   394932 kB
> Active(file):      89104 kB
> Inactive(file):   172496 kB
> Unevictable:        2976 kB
> Mlocked:            2992 kB
> SwapTotal:       1464316 kB
> SwapFree:        1464316 kB
> Dirty:                52 kB
> Writeback:             0 kB
> AnonPages:       1026920 kB
> Mapped:            54208 kB
> Shmem:              8380 kB
> Slab:              80724 kB
> SReclaimable:      22844 kB
> SUnreclaim:        57880 kB
> KernelStack:        2872 kB
> PageTables:        35448 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:     5557088 kB
> Committed_AS:    6187972 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      292360 kB
> VmallocChunk:   34359425327 kB
> HardwareCorrupted:     0 kB
> DirectMap4k:        5632 kB
> DirectMap2M:     2082816 kB
> DirectMap1G:     6291456 kB
>
> # cat /proc/meminfo
> MemTotal:        8185544 kB
> MemFree:         6888060 kB
> Buffers:             372 kB
> Cached:            61492 kB
> SwapCached:            0 kB
> Active:           659156 kB
> Inactive:         426664 kB
> Active(anon):     638892 kB
> Inactive(anon):   395200 kB
> Active(file):      20264 kB
> Inactive(file):    31464 kB
> Unevictable:        2976 kB
> Mlocked:            2992 kB
> SwapTotal:       1464316 kB
> SwapFree:        1464316 kB
> Dirty:                 0 kB
> Writeback:             0 kB
> AnonPages:       1026952 kB
> Mapped:            54236 kB
> Shmem:              8316 kB
> Slab:              70616 kB
> SReclaimable:      12264 kB
> SUnreclaim:        58352 kB
> KernelStack:        2864 kB
> PageTables:        35448 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:     5557088 kB
> Committed_AS:    6187932 kB
> VmallocTotal:   34359738367 kB
> VmallocUsed:      292360 kB
> VmallocChunk:   34359425327 kB
> HardwareCorrupted:     0 kB
> DirectMap4k:        5632 kB
> DirectMap2M:     2082816 kB
> DirectMap1G:     6291456 kB
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
