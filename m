Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1FRBQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 21:16:05 -0400
Received: from lucidpixels.com ([75.144.35.66]:46670 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab1FRBQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 21:16:01 -0400
Date: Fri, 17 Jun 2011 21:16:00 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-net@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: 2.6.39.1: Intel I340-T4: irq/64-eth3-TxR: page allocation failure.
 order:1, mode:0x20
Message-ID: <alpine.DEB.2.02.1106172106080.7672@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel 2.6.39.1, x86_64.
Has anyone seen a page allocation failure on a NIC before?

I was doing 3-4 dumps (stdin/stdout) over eth0 but not eth3 when this
happened 1 minute and 14 seconds later, the network card is a 4-port Intel 
NIC:

Network card:

03:00.0 Ethernet controller: Intel Corporation 82580 Gigabit Network Connection (rev 01)
03:00.1 Ethernet controller: Intel Corporation 82580 Gigabit Network Connection (rev 01)
03:00.2 Ethernet controller: Intel Corporation 82580 Gigabit Network Connection (rev 01)
03:00.3 Ethernet controller: Intel Corporation 82580 Gigabit Network Connection (rev 01)

-v:

03:00.3 Ethernet controller: Intel Corporation 82580 Gigabit Network Connection (rev 01)
         Subsystem: Intel Corporation Ethernet Server Adapter I340-T4
         Flags: bus master, fast devsel, latency 0, IRQ 19
         Memory at f2200000 (32-bit, non-prefetchable) [size=512K]
         Memory at f2400000 (32-bit, non-prefetchable) [size=16K]
         Capabilities: [40] Power Management version 3
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
         Capabilities: [70] MSI-X: Enable+ Count=10 Masked-
         Capabilities: [a0] Express Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Device Serial Number hidden
         Capabilities: [1a0] #17
         Kernel driver in use: igb


What is interesting is eth0 => e1000e and not igb, igb typically does not 
have a lot of network traffic going through it < 50mbps.

Memory information:
Mem:  16434508k total, 16123848k used,   310660k free,  6837232k buffers
Swap: 31246388k total,      228k used, 31246160k free,  6423724k cached

Here is my udev rule configuration:

# PCI device 0x8086:0x10f0 (e1000e)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="hidden", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"

# PCI device 0x8086:0x150e (igb) - closest to motherboard
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="hidden", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth1"

# PCI device 0x8086:0x150e (igb)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="hidden", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth2"

# PCI device 0x8086:0x150e (igb)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="hidden", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth3"

# PCI device 0x8086:0x150e (igb) - furthest from motherboard
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="hidden", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth4"

# PCI device 0x8086:0x150b (ixgbe)
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="hidden", ATTR{dev_id}=="0x0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth5"

--

Do I need more memory?

--

[60295.925691] irq/64-eth3-TxR: page allocation failure. order:1, mode:0x20
[60295.945328] Pid: 2299, comm: irq/64-eth3-TxR Not tainted 2.6.39.1 #1
[60295.945329] Call Trace:
[60295.945330]  <IRQ>  [<ffffffff810882f6>] ? __alloc_pages_nodemask+0x606/0x890
[60295.945341]  [<ffffffff810b1435>] ? cache_alloc_refill+0x2c5/0x530
[60295.945343]  [<ffffffff810b180b>] ? kmem_cache_alloc+0x7b/0xa0
[60295.945347]  [<ffffffff815031ac>] ? sk_prot_alloc.clone.35+0x3c/0x120
[60295.945349]  [<ffffffff81503320>] ? sk_clone+0x10/0x2b0
[60295.945352]  [<ffffffff815580bb>] ? inet_csk_clone+0xb/0x90
[60295.945355]  [<ffffffff8156fa31>] ? tcp_create_openreq_child+0x21/0x4e0
[60295.945357]  [<ffffffff8156cbd3>] ? tcp_v4_syn_recv_sock+0x53/0x250
[60295.945359]  [<ffffffff8156f790>] ? tcp_check_req+0x200/0x480
[60295.945362]  [<ffffffff8156cab1>] ? tcp_v4_do_rcv+0x1c1/0x290
[60295.945365]  [<ffffffff8154dd30>] ? ip_rcv_finish+0x340/0x340
[60295.945367]  [<ffffffff8156f047>] ? tcp_v4_rcv+0x5f7/0x8b0
[60295.945369]  [<ffffffff8154ddf4>] ? ip_local_deliver_finish+0xc4/0x200
[60295.945373]  [<ffffffff8151158b>] ? __netif_receive_skb+0x4eb/0x610
[60295.945375]  [<ffffffff81511898>] ? netif_receive_skb+0x78/0x80
[60295.945377]  [<ffffffff81511f03>] ? napi_gro_receive+0xa3/0xc0
[60295.945379]  [<ffffffff815119b8>] ? napi_skb_finish+0x38/0x50
[60295.945383]  [<ffffffff813e6208>] ? igb_poll+0x8b8/0xd00
[60295.945386]  [<ffffffff8102e5f1>] ? enqueue_task_rt+0x121/0x320
[60295.945388]  [<ffffffff815120c9>] ? net_rx_action+0xf9/0x180
[60295.945391]  [<ffffffff8103df38>] ? __do_softirq+0x98/0x120
[60295.945395]  [<ffffffff81070010>] ? irq_thread_fn+0x40/0x40
[60295.945397]  [<ffffffff81619a4c>] ? call_softirq+0x1c/0x30
[60295.945398]  <EOI>  [<ffffffff81003d8d>] ? do_softirq+0x4d/0x80
[60295.945402]  [<ffffffff8103de94>] ? local_bh_enable+0x94/0xa0
[60295.945405]  [<ffffffff8106ff70>] ? irq_thread+0x150/0x1b0
[60295.945407]  [<ffffffff8106fe20>] ? irq_finalize_oneshot+0x130/0x130
[60295.945409]  [<ffffffff8106fe20>] ? irq_finalize_oneshot+0x130/0x130
[60295.945412]  [<ffffffff81052746>] ? kthread+0x96/0xa0
[60295.945414]  [<ffffffff81619954>] ? kernel_thread_helper+0x4/0x10
[60295.945417]  [<ffffffff810526b0>] ? kthread_worker_fn+0x120/0x120
[60295.945418]  [<ffffffff81619950>] ? gs_change+0xb/0xb
[60295.945419] Mem-Info:
[60295.945420] DMA per-cpu:
[60295.945422] CPU    0: hi:    0, btch:   1 usd:   0
[60295.945423] CPU    1: hi:    0, btch:   1 usd:   0
[60295.945425] CPU    2: hi:    0, btch:   1 usd:   0
[60295.945426] CPU    3: hi:    0, btch:   1 usd:   0
[60295.945427] CPU    4: hi:    0, btch:   1 usd:   0
[60295.945429] CPU    5: hi:    0, btch:   1 usd:   0
[60295.945430] CPU    6: hi:    0, btch:   1 usd:   0
[60295.945431] CPU    7: hi:    0, btch:   1 usd:   0
[60295.945432] DMA32 per-cpu:
[60295.945434] CPU    0: hi:  186, btch:  31 usd: 191
[60295.945435] CPU    1: hi:  186, btch:  31 usd: 162
[60295.945436] CPU    2: hi:  186, btch:  31 usd: 156
[60295.945438] CPU    3: hi:  186, btch:  31 usd: 112
[60295.945439] CPU    4: hi:  186, btch:  31 usd: 175
[60295.945440] CPU    5: hi:  186, btch:  31 usd: 183
[60295.945442] CPU    6: hi:  186, btch:  31 usd: 167
[60295.945443] CPU    7: hi:  186, btch:  31 usd: 161
[60295.945444] Normal per-cpu:
[60295.945445] CPU    0: hi:  186, btch:  31 usd:  68
[60295.945447] CPU    1: hi:  186, btch:  31 usd:  90
[60295.945448] CPU    2: hi:  186, btch:  31 usd:  79
[60295.945449] CPU    3: hi:  186, btch:  31 usd:  94
[60295.945451] CPU    4: hi:  186, btch:  31 usd: 145
[60295.945452] CPU    5: hi:  186, btch:  31 usd: 157
[60295.945453] CPU    6: hi:  186, btch:  31 usd: 210
[60295.945455] CPU    7: hi:  186, btch:  31 usd:  73
[60295.945458] active_anon:503700 inactive_anon:57605 isolated_anon:0
[60295.945459]  active_file:1082465 inactive_file:2046870 isolated_file:0
[60295.945460]  unevictable:0 dirty:44503 writeback:0 unstable:0
[60295.945460]  free:97865 slab_reclaimable:220079 slab_unreclaimable:19352
[60295.945461]  mapped:18737 shmem:1304 pagetables:10293 bounce:0
[60295.945466] DMA free:15860kB min:124kB low:152kB high:184kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15636kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[60295.945469] lowmem_reserve[]: 0 3502 16127 16127
[60295.945474] DMA32 free:136844kB min:29328kB low:36660kB high:43992kB active_anon:80236kB inactive_anon:31460kB active_file:475400kB inactive_file:2655292kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3586912kB mlocked:0kB dirty:22768kB writeback:0kB mapped:484kB shmem:0kB slab_reclaimable:180892kB slab_unreclaimable:1804kB kernel_stack:104kB pagetables:20kB unstable:0kB bounc:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[60295.945478] lowmem_reserve[]: 0 0 12625 12625
[60295.945483] Normal free:238756kB min:105708kB low:132132kB high:158560kB active_anon:1934564kB inactive_anon:198960kB active_file:3854460kB inactive_file:5532188kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:12928000kB mlocked:0kB dirty:155244kB writeback:0kB mapped:74464kB shmem:5216kB slab_reclaimable:699424kB slab_unreclaimable:75604kB kernel_stack:4880kB pagetables:41152kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:2 all_unreclaimable? no
[60295.945487] lowmem_reserve[]: 0 0 0 0
[60295.945489] DMA: 1*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15860kB
[60295.945493] DMA32: 24085*4kB 3687*8kB 372*16kB 94*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 136844kB
[60295.945498] Normal: 39611*4kB 6147*8kB 1178*16kB 294*32kB 45*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 238756kB
[60295.945503] 3130697 total pagecache pages
[60295.945504] 2 pages in swap cache
[60295.945505] Swap cache stats: add 57, delete 55, find 0/0
[60295.945506] Free swap  = 31246160kB
[60295.945507] Total swap = 31246388kB
[60296.002283] 4194288 pages RAM
[60296.002284] 85661 pages reserved
[60296.002285] 2906516 pages shared
[60296.002286] 1304532 pages non-shared

