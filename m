Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab0ICPyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:54:55 -0400
Received: from sati.usurf.usu.edu ([129.123.194.129]:23697 "EHLO
	echo.usurf.usu.edu" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0ICPyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:54:54 -0400
From: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>
To: Robert Hancock <hancockrwd@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: sata_sil24 memory fragmentation issues
Thread-Topic: sata_sil24 memory fragmentation issues
Thread-Index: ActKwLAZ2DuCZ89NRQO65hb+Lsx0hAAb8JMAABEaJpkAAsMgMA==
Date: Fri, 3 Sep 2010 15:54:52 +0000
Message-ID: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC1282815F@Mercury.usurf.usu.edu>
References: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC12824E74@Mercury.usurf.usu.edu>,<4C803FE0.10001@gmail.com>,<5ABE8A5E96C0364CAF2B4DC1DEB7CEAC1282645A@Mercury.usurf.usu.edu>
In-Reply-To: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC1282645A@Mercury.usurf.usu.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.31.22.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am having some issues with the sata_sil24 driver.  It appears that when memory gets fragmented enough, bad things start to happen.  However, this only occurs when I am receiving large amounts of data over the network as well.
>
> Here is my test setup:  I am running an AMCC 405EX processor on their Kilauea development board.  I have a PCIe SATA controller based on the 3531 single port chip (which uses the sata_sil24 driver).  I have a program that simply dumps data out to disk.  When I am running that program, I am also running ping -s 8500<some-ip>.
>
> Here is the output:
>
> 8508 bytes from 172.31.22.21: seq=137 ttl=128 time=1.306 ms
>    CNT:        129 WRIT:   35651584 RATE: 34.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.17188 MB/s AVG RD: 0.00000 MB/s
> 8508 bytes from 172.31.22.21: seq=138 ttl=128 time=1.254 ms
>    CNT:        130 WRIT:   34603008 RATE: 33.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.16279 MB/s AVG RD: 0.00000 MB/s
> 8508 bytes from 172.31.22.21: seq=139 ttl=128 time=1.291 ms
>    CNT:        131 WRIT:   34603008 RATE: 33.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.15385 MB/s AVG RD: 0.00000 MB/s
> 8508 bytes from 172.31.22.21: seq=140 ttl=128 time=1.254 ms
>    CNT:        132 WRIT:   35651584 RATE: 34.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.15267 MB/s AVG RD: 0.00000 MB/s
> sata: page allocation failure. order:0, mode:0x22

>sata is the process name, I believe? Not sure the SATA driver is
>involved here at all.

I think it is because if you look at the call trace, the exception occurs down in the kernel.  The driver I am using is the sata_sil24 driver and doing some searches online, others have experienced similar problems when the system is under heavy load (such as a high level of network interrupts).  Unfortunately the solutions to those problems is to go with different SATA controllers, which is not an option for me.

However, when you mention that the driver is not involved, are you implying that there may be a bug in my program?  I will go back and look through my code, but it is a really dumb program - I have a large statically allocated buffer that I write to disk over and over again.  I will go back and check to make sure I am not doing anything stupid, but I don't think I am.



Here is some more crash dump.  This one shows the error coming from kswapd0.  Any thoughts:

kswapd0: page allocation failure. order:2, mode:0x4020
Call Trace:
[cfff9de0] [c000711c] show_stack+0x44/0x16c (unreliable)
[cfff9e20] [c00746b4] __alloc_pages_nodemask+0x3c8/0x570
[cfff9ec0] [c007487c] __get_free_pages+0x20/0x50
[cfff9ed0] [c009e82c] __kmalloc_track_caller+0xcc/0xec
[cfff9ef0] [c01e16a8] __alloc_skb+0x64/0x124
[cfff9f10] [c01cc1c8] emac_poll_rx+0x45c/0x7cc
[cfff9f50] [c01c766c] mal_poll+0xa8/0x1ec
[cfff9f80] [c01ed61c] net_rx_action+0x9c/0x1a4
[cfff9fb0] [c0039c70] __do_softirq+0xac/0x124
[cfff9ff0] [c000cfd4] call_do_softirq+0x14/0x24
[ce433c60] [c0005238] do_softirq+0x84/0x90
[ce433c80] [c0039798] irq_exit+0x54/0x6c
[ce433c90] [c00052a8] do_IRQ+0x64/0x158
[ce433cc0] [c000dce0] ret_from_except+0x0/0x18
[ce433d80] [ce433e30] 0xce433e30
[ce433e00] [c0078718] __pagevec_release+0x28/0x44
[ce433e20] [c007a308] move_active_pages_to_lru+0xfc/0x1b0
[ce433e90] [c007a9dc] shrink_active_list+0x284/0x35c
[ce433f00] [c007c990] kswapd+0x3c4/0x540
[ce433fb0] [c004f7d0] kthread+0x7c/0x80
[ce433ff0] [c000d484] kernel_thread+0x4c/0x68
Mem-Info:
DMA per-cpu:
CPU    0: hi:   90, btch:  15 usd:  89
active_anon:895 inactive_anon:224 isolated_anon:32
 active_file:400 inactive_file:50824 isolated_file:0
 unevictable:0 dirty:1475 writeback:0 unstable:0
 free:195 slab_reclaimable:986 slab_unreclaimable:234
 mapped:424 shmem:0 pagetables:25 bounce:0
DMA free:780kB min:2036kB low:2544kB high:3052kB active_anon:3580kB inactive_anon:896kB active_file:1600kB inactive_file:203296kB unevictable:0kB isolated(anon):128kB isolated(file):0kB present:260096kB mlocked:0kB dirty:5900kB writeback:0kB mapped:1696kB shmem:0kB slab_reclaimable:3944kB slab_unreclaimable:936kB kernel_stack:280kB pagetables:100kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:64 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 25*4kB 7*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 780kB
51224 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
65536 pages RAM
1485 pages reserved
50830 pages shared
13188 pages non-shared

It appears to me that I am running out of memory.  I should not that this is an embedded system with not a whole lot of memory and no swapfile.  Also, I am using the standard drivers (not my modified EMAC network driver and a stock sata_sil24).  Am I just dead in the water or is there something I can do to get around this?

Thanks,

Jonathan