Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1ASNus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 08:50:48 -0500
Received: from ns2.q-leap.de ([88.79.172.217]:60001 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab1ASNur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 08:50:47 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2011 08:50:46 EST
Message-ID: <4D36E9D6.9040805@q-leap.com>
Date: Wed, 19 Jan 2011 14:40:38 +0100
From: Peter Kruse <pk@q-leap.com>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: page allocation failure leads to server unusability in igb_alloc_rx_buffers_adv
Content-Type: multipart/mixed;
 boundary="------------060605020608050702080701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060605020608050702080701
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

one of our servers (Supermicro X8DTN) experiences random "crashes"
every two weeks or so.  The only real hint for a reason is
the page allocation error, which I have attached.  There
are no messages in kern.log indicating a broken hardware.
I put the "crashes" in quotes because the server keeps running
and for example writing messages to syslog, running cronjobs,
and so on, but it seems that all network related actions
fail.  For example:

----------------------------8<-----------------------------------------------------

nagios3: HOST ALERT: beo-06;DOWN;SOFT;8;CRITICAL - popen timeout received, but 
no child process
...
postfix/sendmail[6969]: fatal: no login name found for user ID 2403
# (although the ID is known)
...
CRON[11286]: Authentication service cannot retrieve authentication info.
...
sshd[14990]: fatal: login_init_entry: Cannot find user "..."
# (although that user exists!)
...
postfix/cleanup[18772]: warning: problem talking to service rewrite: 
Connection timed out

----------------------------8<-----------------------------------------------------

So the server insofar is unusable as login is no longer possible
and network related services like NFS no longer respond.

The message I have attached occured four days before the server
showed the other errors so it is hard to believe that there
is a relation but since this is the only message that we have
we think there must be some relation.  We would appreciate
if you could help interpret the messages.  The server has
48GB of RAM and no swap is defined.  For now we
increase the value in /proc/sys/vm/min_free_kbytes and hope
that the allocation error will happen less frequent.

Thanks,

   Peter

ps: please CC to me as I'm not subscribed

--------------060605020608050702080701
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

[1902575.722718] swapper: page allocation failure. order:0, mode:0x20
[1902575.722738] Pid: 0, comm: swapper Not tainted 2.6.32.23-ql-server-14 #1
[1902575.722756] Call Trace:
[1902575.722765]  <IRQ>  [<ffffffff81071f46>] __alloc_pages_nodemask+0x5ca/0x600
[1902575.722796]  [<ffffffff8109428b>] kmem_getpages+0x5c/0x127
[1902575.722812]  [<ffffffff81094475>] fallback_alloc+0x11f/0x195
[1902575.722829]  [<ffffffff81094614>] ____cache_alloc_node+0x129/0x138
[1902575.722847]  [<ffffffff810946bf>] kmem_cache_alloc_node+0x9c/0xc7
[1902575.722864]  [<ffffffff8109472d>] __kmalloc_node+0x43/0x45
[1902575.722883]  [<ffffffff81340625>] __alloc_skb+0x6b/0x164
[1902575.722899]  [<ffffffff81341654>] __netdev_alloc_skb+0x31/0x4d
[1902575.722925]  [<ffffffffa00147ff>] igb_alloc_rx_buffers_adv+0x13f/0x29b [igb]
[1902575.722947]  [<ffffffff811da4fa>] ? swiotlb_map_page+0x0/0xd3
[1902575.722966]  [<ffffffffa00166b9>] igb_poll+0x523/0x86a [igb]
[1902575.722983]  [<ffffffff81346cb6>] net_rx_action+0xa7/0x178
[1902575.723001]  [<ffffffff8103bd21>] __do_softirq+0x96/0x119
[1902575.723019]  [<ffffffff8100bf5c>] call_softirq+0x1c/0x28
[1902575.723035]  [<ffffffff8100d9e7>] do_softirq+0x33/0x6b
[1902575.723050]  [<ffffffff8103b844>] irq_exit+0x36/0x38
[1902575.723081]  [<ffffffff8100d0e9>] do_IRQ+0xa3/0xba
[1902575.723111]  [<ffffffff8100b7d3>] ret_from_intr+0x0/0xa
[1902575.723141]  <EOI>  [<ffffffffa006e5c1>] ? acpi_idle_enter_bm+0x2a5/0x2d3 [processor]
[1902575.723200]  [<ffffffffa006e5b7>] ? acpi_idle_enter_bm+0x29b/0x2d3 [processor]
[1902575.723252]  [<ffffffff8132f917>] ? cpuidle_idle_call+0x92/0xcb
[1902575.723285]  [<ffffffff8100a2cf>] ? cpu_idle+0x4b/0x7e
[1902575.723317]  [<ffffffff813c0322>] ? rest_init+0x66/0x68
[1902575.723350]  [<ffffffff8163fc12>] ? start_kernel+0x340/0x34b
[1902575.723383]  [<ffffffff8163f29a>] ? x86_64_start_reservations+0xaa/0xae
[1902575.723417]  [<ffffffff8163f37f>] ? x86_64_start_kernel+0xe1/0xe8
[1902575.723449] Mem-Info:
[1902575.723472] Node 0 DMA per-cpu:
[1902575.723501] CPU    0: hi:    0, btch:   1 usd:   0
[1902575.723530] CPU    1: hi:    0, btch:   1 usd:   0
[1902575.723559] CPU    2: hi:    0, btch:   1 usd:   0
[1902575.723588] CPU    3: hi:    0, btch:   1 usd:   0
[1902575.723617] CPU    4: hi:    0, btch:   1 usd:   0
[1902575.723647] CPU    5: hi:    0, btch:   1 usd:   0
[1902575.723676] CPU    6: hi:    0, btch:   1 usd:   0
[1902575.723705] CPU    7: hi:    0, btch:   1 usd:   0
[1902575.723734] Node 0 DMA32 per-cpu:
[1902575.723762] CPU    0: hi:  186, btch:  31 usd:  49
[1902575.723791] CPU    1: hi:  186, btch:  31 usd: 123
[1902575.723820] CPU    2: hi:  186, btch:  31 usd: 157
[1902575.723849] CPU    3: hi:  186, btch:  31 usd: 161
[1902575.723879] CPU    4: hi:  186, btch:  31 usd: 138
[1902575.723908] CPU    5: hi:  186, btch:  31 usd: 110
[1902575.723937] CPU    6: hi:  186, btch:  31 usd:  72
[1902575.723966] CPU    7: hi:  186, btch:  31 usd:  57
[1902575.723995] Node 0 Normal per-cpu:
[1902575.724023] CPU    0: hi:  186, btch:  31 usd:  47
[1902575.724053] CPU    1: hi:  186, btch:  31 usd: 175
[1902575.724082] CPU    2: hi:  186, btch:  31 usd: 168
[1902575.724112] CPU    3: hi:  186, btch:  31 usd: 155
[1902575.724141] CPU    4: hi:  186, btch:  31 usd: 178
[1902575.724170] CPU    5: hi:  186, btch:  31 usd: 129
[1902575.724200] CPU    6: hi:  186, btch:  31 usd:   0
[1902575.724229] CPU    7: hi:  186, btch:  31 usd: 101
[1902575.724258] Node 1 Normal per-cpu:
[1902575.724286] CPU    0: hi:  186, btch:  31 usd: 192
[1902575.724315] CPU    1: hi:  186, btch:  31 usd: 179
[1902575.724344] CPU    2: hi:  186, btch:  31 usd: 175
[1902575.724374] CPU    3: hi:  186, btch:  31 usd: 150
[1902575.724403] CPU    4: hi:  186, btch:  31 usd: 161
[1902575.724432] CPU    5: hi:  186, btch:  31 usd: 177
[1902575.724462] CPU    6: hi:  186, btch:  31 usd: 174
[1902575.724491] CPU    7: hi:  186, btch:  31 usd: 179
[1902575.724523] active_anon:1450564 inactive_anon:223603 isolated_anon:0
[1902575.724524]  active_file:3101544 inactive_file:6476956 isolated_file:0
[1902575.724525]  unevictable:0 dirty:48046 writeback:257 unstable:0
[1902575.724526]  free:28765 slab_reclaimable:966523 slab_unreclaimable:86066
[1902575.724528]  mapped:15953 shmem:2918 pagetables:15544 bounce:0
[1902575.724682] Node 0 DMA free:15572kB min:8kB low:8kB high:12kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:14960kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
[1902575.724864] lowmem_reserve[]: 0 2991 24201 24201
[1902575.724903] Node 0 DMA32 free:85416kB min:1736kB low:2168kB high:2604kB active_anon:210256kB inactive_anon:83488kB active_file:450296kB inactive_file:907016kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:3063520kB mlocked:0kB dirty:6948kB writeback:4kB mapped:5860kB shmem:5120kB slab_reclaimable:877796kB slab_unreclaimable:76568kB kernel_stack:1488kB pagetables:3344kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1902575.725096] lowmem_reserve[]: 0 0 21210 21210
[1902575.725134] Node 0 Normal free:7148kB min:12332kB low:15412kB high:18496kB active_anon:2754904kB inactive_anon:440324kB active_file:5148832kB inactive_file:11469892kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:21719040kB mlocked:0kB dirty:60504kB writeback:280kB mapped:29320kB shmem:2200kB slab_reclaimable:1924196kB slab_unreclaimable:171340kB kernel_stack:1952kB pagetables:25784kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1902575.725346] lowmem_reserve[]: 0 0 0 0
[1902575.725383] Node 1 Normal free:8412kB min:14092kB low:17612kB high:21136kB active_anon:2837096kB inactive_anon:370600kB active_file:6807048kB inactive_file:13529124kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:24821760kB mlocked:0kB dirty:124732kB writeback:744kB mapped:28632kB shmem:4352kB slab_reclaimable:1064100kB slab_unreclaimable:96356kB kernel_stack:2568kB pagetables:33048kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1902575.725598] lowmem_reserve[]: 0 0 0 0
[1902575.725635] Node 0 DMA: 1*4kB 2*8kB 2*16kB 1*32kB 2*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15572kB
[1902575.725721] Node 0 DMA32: 20745*4kB 29*8kB 13*16kB 6*32kB 2*64kB 2*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 85788kB
[1902575.725808] Node 0 Normal: 304*4kB 302*8kB 7*16kB 8*32kB 3*64kB 4*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 7520kB
[1902575.725896] Node 1 Normal: 1280*4kB 8*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 9280kB
[1902575.725982] 9580976 total pagecache pages
[1902575.726010] 0 pages in swap cache
[1902575.726036] Swap cache stats: add 66229, delete 66229, find 480000005/480037265
[1902575.726086] Free swap  = 0kB
[1902575.726110] Total swap = 0kB
[1902575.937535] 12582896 pages RAM
[1902575.937562] 193198 pages reserved
[1902575.937587] 5476994 pages shared
[1902575.937612] 7122987 pages non-shared

--------------060605020608050702080701--
