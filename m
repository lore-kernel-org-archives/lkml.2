Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0IBRDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:03:03 -0400
Received: from sati.usurf.usu.edu ([129.123.194.129]:32870 "EHLO
	echo.usurf.usu.edu" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0IBRDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:03:00 -0400
From: Jonathan Haws <Jonathan.Haws@sdl.usu.edu>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: sata_sil24 memory fragmentation issues
Thread-Topic: sata_sil24 memory fragmentation issues
Thread-Index: ActKwLAZ2DuCZ89NRQO65hb+Lsx0hA==
Date: Thu, 2 Sep 2010 17:02:58 +0000
Message-ID: <5ABE8A5E96C0364CAF2B4DC1DEB7CEAC12824E74@Mercury.usurf.usu.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {77A321C4-9B31-4EFD-82B5-164526F56CC4}
x-cr-hashedpuzzle: AAy8 ABZk AmGf AzPt CFq8 C31F DG4H F1P6 GC74 Gpdy Gpef
 H1NN Ip4i JYNR JmeI
 J5cj;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{77A321C4-9B31-4EFD-82B5-164526F56CC4};agBvAG4AYQB0AGgAYQBuAC4AaABhAHcAcwBAAHMAZABsAC4AdQBzAHUALgBlAGQAdQA=;Thu,
 02 Sep 2010 17:02:55
 GMT;cwBhAHQAYQBfAHMAaQBsADIANAAgAG0AZQBtAG8AcgB5ACAAZgByAGEAZwBtAGUAbgB0AGEAdABpAG8AbgAgAGkAcwBzAHUAZQBzAA==
x-originating-ip: [172.31.40.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am having some issues with the sata_sil24 driver.  It appears that when memory gets fragmented enough, bad things start to happen.  However, this only occurs when I am receiving large amounts of data over the network as well.

Here is my test setup:  I am running an AMCC 405EX processor on their Kilauea development board.  I have a PCIe SATA controller based on the 3531 single port chip (which uses the sata_sil24 driver).  I have a program that simply dumps data out to disk.  When I am running that program, I am also running ping -s 8500 <some-ip>.

Here is the output:

8508 bytes from 172.31.22.21: seq=137 ttl=128 time=1.306 ms
  CNT:        129 WRIT:   35651584 RATE: 34.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.17188 MB/s AVG RD: 0.00000 MB/s
8508 bytes from 172.31.22.21: seq=138 ttl=128 time=1.254 ms
  CNT:        130 WRIT:   34603008 RATE: 33.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.16279 MB/s AVG RD: 0.00000 MB/s
8508 bytes from 172.31.22.21: seq=139 ttl=128 time=1.291 ms
  CNT:        131 WRIT:   34603008 RATE: 33.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.15385 MB/s AVG RD: 0.00000 MB/s
8508 bytes from 172.31.22.21: seq=140 ttl=128 time=1.254 ms
  CNT:        132 WRIT:   35651584 RATE: 34.00000 MB/s READ:          0 RATE: 0.00000 MB/s AVG WR: 34.15267 MB/s AVG RD: 0.00000 MB/s
sata: page allocation failure. order:0, mode:0x22
Call Trace:
[ccad9a10] [c0006ef0] show_stack+0x44/0x16c (unreliable)
[ccad9a50] [c006f9f0] __alloc_pages_nodemask+0x38c/0x4f8
[ccad9ad0] [c01a7e3c] emac_poll_rx+0x5ac/0x768
[ccad9b10] [c01a28e4] mal_poll+0xa8/0x1ec
[ccad9b40] [c01d3eec] net_rx_action+0x9c/0x1b4
[ccad9b70] [c003b3c0] __do_softirq+0xc4/0x148
[ccad9bb0] [c0004d18] do_softirq+0x78/0x80
[ccad9bc0] [c003afac] irq_exit+0x64/0x7c
[ccad9bd0] [c0005210] do_IRQ+0x9c/0xb4
[ccad9bf0] [c000fa7c] ret_from_except+0x0/0x18
[ccad9cb0] [00000001] 0x1
[ccad9cd0] [c00c2a68] generic_write_end+0x24/0xe0
[ccad9d00] [c0069cc0] generic_file_buffered_write+0x18c/0x304
[ccad9d90] [c006a38c] __generic_file_aio_write_nolock+0x288/0x4fc
[ccad9e00] [c006a8e4] generic_file_aio_write+0x68/0xf8
[ccad9e30] [c009a9b4] do_sync_write+0xc4/0x138
[ccad9ef0] [c009b41c] vfs_write+0xb4/0x158
[ccad9f10] [c009ba4c] sys_write+0x4c/0x90
[ccad9f40] [c000f434] ret_from_syscall+0x0/0x3c
Mem-Info:
DMA per-cpu:
CPU    0: hi:   90, btch:  15 usd:  53
Active_anon:554 active_file:1753 inactive_anon:608
 inactive_file:49910 unevictable:0 dirty:6020 writeback:0 unstable:0
 free:192 slab:2573 mapped:445 pagetables:25 bounce:0
DMA free:768kB min:2036kB low:2544kB high:3052kB active_anon:2216kB inactive_anon:2432kB active_file:7012kB inactive_file:199640kB unevictable:0kB present:260096kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 2*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 768kB
51673 total pagecache pages
0 pages in swap cache
Swap cache stats: add 0, delete 0, find 0/0
Free swap  = 0kB
Total swap = 0kB
65536 pages RAM
1400 pages reserved
51949 pages shared
12273 pages non-shared
emac_alloc_rx_skb: allocating new page after consumption

I am seeing a few different issues - one, the SATA driver is failing to allocate memory, even though there is memory available.  Also, the ibm_newemac driver is failing to allocate memory even though there is memory available.

I have already modified the ibm_newemac driver to only ever allocate single pages.  Before, it would allocate based on MTU size - so if I had the MTU set to 9000, it would try and allocate 4 contiguous pages, which it would fail because there were no contiguous 16k pages available.

Can anyone help me with this issue?  I have been trying to move to Linux on this hardware for a long time, but just cannot seem to get past this issue.  I am very new to kernel development and am not very familiar with the ATA system at all, let alone the memory manager.  I had a hard enough time getting to understand the networking stack (which I still feel like I don't understand completely).

Thanks for the help.

Jonathan


