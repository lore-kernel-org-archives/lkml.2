Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1CHJis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:38:48 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:44128 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab1CHJip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:38:45 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-lvm@redhat.com
Subject: 2.6.37.2: LVM pvmove hangs system
Date: Tue, 8 Mar 2011 10:38:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.31.14-0.6-desktop; KDE/4.5.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103081038.38338.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm experiencing a very annoying system lockup for some days. The setup is as 
follows:

-two pairs of SATA disks that are bundled into a software raid 1 each
-each of the raid devices is a physical volume
-a volume group that includes both pv's
-all mounted volumes (including root and swap) are in that vg

The machine is a Xeon E5520 with 16G RAM that is otherwise idle, so swap 
shouldn't matter. And from what I read out of the documentation this all looks 
perfectly sane, but:

Now I try to move the data from one pv to the other using pv. This prints out 
the current state (currently 10.9%) and then starts doing something. Two 
minutes later the kernel will complain:

INFO: task jbd2/dm-2-8:3616 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/dm-2-8   D ffff88008c211200     0  3616      2 0x00000000
 ffff88045d7f9bb0 0000000000000046 ffff88045debf000 ffff88045d7f8010
 0000000000004000 0000000000011200 ffff88045d7f9fd8 0000000000011200
 ffff88045d870cc0 ffff88045d7f9fd8 ffff88045d7f9aa0 0000000000000202
Call Trace:
 [<ffffffff8126693a>] ? 0xffffffff8126693a
 [<ffffffff81181eac>] ? 0xffffffff81181eac
 [<ffffffff81267e6e>] ? 0xffffffff81267e6e
 [<ffffffff8104db29>] ? 0xffffffff8104db29
 [<ffffffff81306d38>] 0xffffffff81306d38
 [<ffffffff810ce96c>] 0xffffffff810ce96c
 [<ffffffff8130718a>] 0xffffffff8130718a
 [<ffffffff810ce931>] ? 0xffffffff810ce931
 [<ffffffff810ce931>] ? 0xffffffff810ce931
 [<ffffffff81307226>] 0xffffffff81307226
 [<ffffffff81047104>] ? 0xffffffff81047104
 [<ffffffff810ce8f6>] 0xffffffff810ce8f6
 [<ffffffff81152a70>] 0xffffffff81152a70
 [<ffffffff81306c0a>] ? 0xffffffff81306c0a
 [<ffffffff8103b24a>] ? 0xffffffff8103b24a
 [<ffffffff81155c7e>] 0xffffffff81155c7e
 [<ffffffff810470cc>] ? 0xffffffff810470cc
 [<ffffffff81155bb0>] ? 0xffffffff81155bb0
 [<ffffffff81046c8f>] 0xffffffff81046c8f
 [<ffffffff81003654>] 0xffffffff81003654
 [<ffffffff81046c0e>] ? 0xffffffff81046c0e
 [<ffffffff81003650>] ? 0xffffffff81003650

For the records, pvmove --version gives

  LVM version:     2.02.73(2) (2010-09-18)
  Library version: 1.02.54 (2010-08-18)
  Driver version:  4.18.0

When I restart the system now and start pvmove again the status number 
increased so it actually _did_ some work, but afterwards it hangs the machine. 
The system is still alive (I can ping, start new screens, do some simple 
commands) but for me it looks like the IO stuff is completely hanging. Last 
time I tried to move some files out of the way but that changes never made it 
to disk. I was originally seeing this on 2.6.37, upgrading to .2 didn't make a 
difference. The machine is connected to a serial console and I can easily send 
some sysrq requests from a still active ssh session so things are not 
completely dead. Here is some info I collected from sysrq:

SysRq : Show Memory
Mem-Info:
Node 0 DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
CPU    4: hi:    0, btch:   1 usd:   0
CPU    5: hi:    0, btch:   1 usd:   0
CPU    6: hi:    0, btch:   1 usd:   0
CPU    7: hi:    0, btch:   1 usd:   0
Node 0 DMA32 per-cpu:
CPU    0: hi:  186, btch:  31 usd: 104
CPU    1: hi:  186, btch:  31 usd: 159
CPU    2: hi:  186, btch:  31 usd: 167
CPU    3: hi:  186, btch:  31 usd: 174
CPU    4: hi:  186, btch:  31 usd: 160
CPU    5: hi:  186, btch:  31 usd: 153
CPU    6: hi:  186, btch:  31 usd: 142
CPU    7: hi:  186, btch:  31 usd: 109
Node 0 Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd: 165
CPU    1: hi:  186, btch:  31 usd:  93
CPU    2: hi:  186, btch:  31 usd: 113
CPU    3: hi:  186, btch:  31 usd: 174
CPU    4: hi:  186, btch:  31 usd:  59
CPU    5: hi:  186, btch:  31 usd:  89
CPU    6: hi:  186, btch:  31 usd:  40
CPU    7: hi:  186, btch:  31 usd:  94
active_anon:2891 inactive_anon:3 isolated_anon:0
 active_file:22394 inactive_file:1476 isolated_file:0
 unevictable:3514 dirty:5 writeback:1 unstable:0
 free:4055871 slab_reclaimable:2434 slab_unreclaimable:4352
 mapped:1775 shmem:80 pagetables:453 bounce:0
Node 0 DMA free:15904kB min:12kB low:12kB high:16kB active_anon:0kB 
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15680kB mlocked:0kB dirty:0kB 
writeback:0kB ms
lowmem_reserve[]: 0 2173 16061 16061
Node 0 DMA32 free:2268600kB min:2192kB low:2740kB high:3288kB 
active_anon:1288kB inactive_anon:4kB active_file:868kB inactive_file:116kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:2225720kB 
mlocked:0kB dirty:o
lowmem_reserve[]: 0 0 13887 13887
Node 0 Normal free:13938980kB min:14016kB low:17520kB high:21024kB 
active_anon:10276kB inactive_anon:8kB active_file:88708kB inactive_file:5788kB 
unevictable:14056kB isolated(anon):0kB isolated(file):0kB present:14220800kB 
mloco
lowmem_reserve[]: 0 0 0 0
Node 0 DMA: 0*4kB 0*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 
1*2048kB 3*4096kB = 15904kB
Node 0 DMA32: 716*4kB 637*8kB 524*16kB 399*32kB 322*64kB 183*128kB 106*256kB 
57*512kB 45*1024kB 44*2048kB 489*4096kB = 2268600kB
Node 0 Normal: 1505*4kB 4432*8kB 3658*16kB 2488*32kB 1736*64kB 1207*128kB 
836*256kB 1031*512kB 901*1024kB 314*2048kB 2731*4096kB = 13938980kB
24670 total pagecache pages
1 pages in swap cache
Swap cache stats: add 51604, delete 51603, find 24440/27591
Free swap  = 33554424kB
Total swap = 33554428kB
4194288 pages RAM
74658

At this point the output simply was cut off. It continued with those when I 
issues the next sysrq command a while later:

SysRq : Show backtrace of all active CPUs
sending NMI to all CPUs:
NMI backtrace for cpu 0
CPU 0 
Modules linked in: ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_tcpudp iptable_filter ip_tables x_tables ipmi_devintf ipmi_poweroff ipmi_si 
ipi

Pid: 10066, comm: bash Not tainted 2.6.37.2 #2 Intel Corporation 
S5500BC/S5500BC
RIP: 0010:[<ffffffff81199a13>]  [<ffffffff81199a13>] 0xffffffff81199a13
RSP: 0018:ffff88045d55bdc8  EFLAGS: 00000807
RAX: 0000000072b54a00 RBX: 0000000000000000 RCX: 00000000001a36f0
RDX: 0000000000036e4e RSI: 0000000000000001 RDI: 0000000000068dbc
RBP: ffff88045d55bdc8 R08: 0000000000000010 R09: ffffffff8143d4f8
R10: ffff8800000bcd80 R11: 0000000000000000 R12: 0000000000001000
R13: 0000000000000002 R14: 0000000000000092 R15: 0000000000000002
FS:  00007fb99d455700(0000) GS:ffff88008c200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb99f6e6368 CR3: 0000000456682000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 10066, threadinfo ffff88045d55a000, task ffff88045f59f320)
S 000000000000000085aa>] 0xffffffff810185aa
 [<ff1fef86>] 0xffffffff811fef86
 [<fff810adda4>] 0xffffffff81 48 6b 94 02 98 00 00 00 3e 48 89 c8 f7 e2 <48> 
8d 7a 01 ff 15 f3 83 27 00 c9 c3 55 48 69 cf 1c 43 00 00 48 
Call Trace:
 [<ffffffff8101811a>] 0xffffffff8101811a
 [<ffffffff810185aa>] 0xffffffff810185aa
 [<ffffffff8101b0e0>] 0xffffffff8101b0e0
 [<ffffffff810186c6>] 0xffffffff810186c6
 [<ffffffff811feca9>] 0xffffffff811feca9
 [<ffffffff811fef86>] 0xffffffff811fef86
 [<ffffffff811ff054>] 0xffffffff811ff054
 [<ffffffff810f1d63>] 0xffffffff810f1d63
 [<ffffffff810adc39>] 0xffffffff810adc39
 [<ffffffff810adda4>] 0xffffffff810adda4
 [<ffffffff810028fb>] 0xffffffff810028fb
Pid: 10066, comm: bash Not tainted 2.6.37.2 #2
Call Trace:
 <NMI>  [<ffffffff8100a51c>] ? 0xffffffff8100a51c
 [<ffffffff81018850>] 0xffffffff81018850
 [<ffffffff8100445c>] 0xffffffff8100445c
 [<ffffffff81308fba>] 0xffffffff81308fba
 [<ffffffff81199a13>] ? 0xffffffff81199a13
 <<EOE>>  [<ffffffff8101811a>] 0xffffffff8101811a
 [<ffffffff810185aa>] 0xffffffff810185aa
 [<ffffffff8101b0e0>] 0xffffffff8101b0e0
 [<ffffffff810186c6>] 0xffffffff
 [<ffffffff810f1d63>] 0x028fb
NMI backtrace for cpu 1
onntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables ipmi_devintf 
ipmi_poweroff ipmi_si ipmi_watchdog ipmi_msghandler tun bridge stp llc 
kvm_intel kvm bonding ipv6 ioatdma dca rtc_cmos e1000e i2c_i801 pcspkr 
processoi

Pid: 0, comm: kworker/0:0 Not tainted 2.6.37.2 #2 Intel Corporation 
S5500BC/S5500BC
RIP: 0010:[<ffffffff811cc13a>]  [<ffffffff811cc13a>] 0xffffffff811cc13a
RSP: 0018:ffff88046e119e78  EFLAGS: 00000046
RAX: 0000000000000020 RBX: 120905f0a66d1ce7 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88046e118010 RDI: ffff88046e119fd8
RBP: ffff88046e119ec8 R08: 0000000000000000 R09: 000000000000000b
R10: 0000000100092889 R11: 0000000000000000 R12: 0000000000000020
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88008c220000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f1a6d71f020 CR3: 00000000013f7000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:0 (pid: 0, threadinfo ffff88046e118000, task 
ffff88046e117980)
Stack:
 0000000000000000 000000000000ea50 ffff88046e119ec8 ffffffff8126fe15
 0000026151d50c00 000000016e118010 ffff88046e118010 ffff88008c2387a0
 ffff88008c238670 0000000000000000 ffff88046e119ee8 ffffffff8126f0c4
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Code: 8d b7 38 e0 ff ff a8 08 75 21 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 
48 8b 87 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c96fe15
 [<ffffffff8126f0c4>] 0xtainted 2.6.37.2 #2
Callc
 [<ffffffff813 0xffffffff8126f0c4
 [<able_filter ip6_tables ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter 
ip_tables x_tables ipmi_devintf ipmi_poweroff ipmi_si ipmi_watchdog ipmi_msgi

Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2 Intel Corporation 
S5500BC/S5500BC
RIP: 0010:[<ffffffff811cc13a>]  [<ffffffff811cc13a>] 0xffffffff811cc13a
RSP: 0018:ffff88046e129e78  EFLAGS: 00000046
RAX: 0000000000000020 RBX: 120905f097675bfd RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88046e128010 RDI: ffff88046e129fd8
RBP: ffff88046e129ec8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000100092886 R11: 0000000000000000 R12: 0000000000000020
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88008c240000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fce81cb00c0 CR3: 00000000013f7000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff88046e128000, task 
ffff88046e116000)
Stack:
 0000000000000000 000000000000ea50 ffff88046e129ec8 ffffffff8126fe15
 000002616fa27100 000000026e128010 ffff88046e128010 ffff88008c2587a0
 ffff88008c258670 0000000000000000 ffff88046e129ee8 ffffffff8126f0c4
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Code: 8d b7 38 e0 ff ff a8 08 75 21 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 
48 8b 87 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> 79 1b e8 ff 48 
89 c7 48 29 df e8 c5 9b e6 ff 48 89 c3 49 89 
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2
Call Trace:
 <NMI>  [<ffffffff8100a51c>] ? 0xffffffff8100a51c
 [<ffffffff81018850>] 0xffffffff81018850
 [<ffffffff8100445c>] 0xffffffff8100445c
 [<ffffffff81308fba>] 0xffffffff81308fba
 [<ffffffff811cc13a>] ? 0xffffffff811cc13a
 <<EOE>>  [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
NMI backtrace for cpu 3
CPU 3 
Modules linked in: ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_tcpudp iptable_filter ip_tables x_tables ipmi_devintf ipmi_poweroff ipmi_si 
ipi

Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2 Intel Corporation 
S5500BC/S5500BC
RIP: 0010:[<ffffffff811cc13a>]  [<ffffffff811cc13a>] 0xffffffff811cc13a
RSP: 0018:ffff88046e157e78  EFLAGS: 00000046
RAX: 0000000000000020 RBX: 120905f0b5353da5 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88046e156010 RDI: ffff88046e157fd8
RBP: ffff88046e157ec8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000020
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88008c260000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f6da87f79d0 CR3: 00000000013f7000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff88046e156000, task 
ffff88046e12a660)
Stack:
 0000000000000000 000000000000ea50 ffff88046e157ec8 ffffffff8126fe15
 00000261fa64e700 000000036e156010 ffff88046e156010 ffff88008c2787a0
 ffff88008c278670 0000000000000000 ffff88046e157ee8 ffffffff8126f0c4
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Code: 8d b7 38 e0 ff ff a8 08 75 21 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 
48 8b 87 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> 79 1b e8 ff 48 
89 c7 48 29 df e8 c5 9b e6 ff 48 89 c3 49 89 
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2
Call Trace:
 <NMI>  [<ffffffff8100a51c>] ? 0xffffffff8100a51c
 [<ffffffff81018850>] 0xffffffff81018850
 [<ffffffff8100445c>] 0xffffffff8100445c
 [<ffffffff81308fba>] 0xffffffff81308fba
 [<ffffffff811cc13a>] ? 0xffffffff811cc13a
 <<EOE>>  [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
NMI backtrace for cpu 4
CPU 4 
Modules linked in: ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_tcpudp iptable_filter ip_tables x_tables ipmi_devintf ipmi_poweroff ipmi_si 
ipi

Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2 Intel Corporation 
S5500BC/S5500BC
RIP: 0010:[<ffffffff811cc13a>]  [<ffffffff811cc13a>] 0xffffffff811cc13a
RSP: 0018:ffff88046e167e78  EFLAGS: 00000046
RAX: 0000000000000020 RBX: 120905f0b81122a9 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88046e166010 RDI: ffff88046e167fd8
RBP: ffff88046e167ec8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000100092880 R11: 0000000000000000 R12: 0000000000000020
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88008c280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f551f028710 CR3: 00000000013f7000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff88046e166000, task 
ffff88046e15ccc0)
Stack:
 ffff88046e167e88 000000000000ea50 ffff88046e167ec8 ffffffff8126fe15
 000002620781d600 000000046e166010 ffff88046e166010 ffff88008c2987a0
 ffff88008c298670 0000000000000000 ffff88046e167ee8 ffffffff8126f0c4
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Code: 8d b7 38 e0 ff ff a8 08 75 21 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 
48 8b 87 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> 79 1b e8 ff 48 
89 c7 48 29 df e8 c5 9b e6 ff 48 89 c3 49 89 
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2
Call Trace:
 <NMI>  [<ffffffff8100a51c>] ? 0xffffffff8100a51c
 [<ffffffff81018850>] 0xffffffff81018850
 [<ffffffff8100445c>] 0xffffffff8100445c
 [<ffffffff81308fba>] 0xffffffff81308fba
 [<ffffffff811cc13a>] ? 0xffffffff811cc13a
 <<EOE>>  [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
NMI backtrace for cpu 5
CPU 5 
Modules linked in: ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_tcpudp iptable_filter ip_tables x_tables ipmi_devintf ipmi_poweroff ipmi_si 
ipi

Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2 Intel Corporation 
S5500BC/S5500BC
RIP: 0010:[<ffffffff811cc13a>]  [<ffffffff811cc13a>] 0xffffffff811cc13a
RSP: 0018:ffff88046e199e78  EFLAGS: 00000046
RAX: 0000000000000020 RBX: 120905f0d08b7a62 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88046e198010 RDI: ffff88046e199fd8
RBP: ffff88046e199ec8 R08: 0000000000000000 R09: 0000000000000001
R10: 000000010008da5d R11: 0000000000000000 R12: 0000000000000020
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88008c2a0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f1a6e01daa0 CR3: 00000000013f7000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff88046e198000, task 
ffff88046e193320)
Stack:
 0000000000000000 000000000000ea50 ffff88046e199ec8 ffffffff8126fe15
 00000261f5dd3c00 000000056e198010 ffff88046e198010 ffff88008c2b87a0
 ffff88008c2b8670 0000000000000000 ffff88046e199ee8 ffffffff8126f0c4
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Code: 8d b7 38 e0 ff ff a8 08 75 21 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 
48 8b 87 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> 79 1b e8 ff 48 
89 c7 48 29 df e8 c5 9b e6 ff 48 89 c3 49 89 
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2
Call Trace:
 <NMI>  [<ffffffff8100a51c>] ? 0xffffffff8100a51c
 [<ffffffff81018850>] 0xffffffff81018850
 [<ffffffff8100445c>] 0xffffffff8100445c
 [<ffffffff81308fba>] 0xffffffff81308fba
 [<ffffffff811cc13a>] ? 0xffffffff811cc13a
 <<EOE>>  [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
NMI backtrace for cpu 6
CPU 6 
Modules linked in: ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_tcpudp iptable_filter ip_tables x_tables ipmi_devintf ipmi_poweroff ipmi_si 
ipi

Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2 Intel Corporation 
S5500BC/S5500BC
RIP: 0010:[<ffffffff811cc13a>]  [<ffffffff811cc13a>] 0xffffffff811cc13a
RSP: 0018:ffff88046e1a9e78  EFLAGS: 00000046
RAX: 0000000000000020 RBX: 120905f0d08d05fb RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88046e1a8010 RDI: ffff88046e1a9fd8
RBP: ffff88046e1a9ec8 R08: 0000000000000000 R09: 0000000000000001
R10: 000000010009287a R11: 0000000000000000 R12: 0000000000000020
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88008c2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fffbc74e368 CR3: 00000000013f7000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff88046e1a8000, task 
ffff88046e1a7980)
Stack:
 0000000000000000 000000000000ea50 ffff88046e1a9ec8 ffffffff8126fe15
 00000261e6d80500 000000066e1a8010 ffff88046e1a8010 ffff88008c2d87a0
 ffff88008c2d8670 0000000000000000 ffff88046e1a9ee8 ffffffff8126f0c4
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Code: 8d b7 38 e0 ff ff a8 08 75 21 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 
48 8b 87 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> 79 1b e8 ff 48 
89 c7 48 29 df e8 c5 9b e6 ff 48 89 c3 49 89 
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2
Call Trace:
 <NMI>  [<ffffffff8100a51c>] ? 0xffffffff8100a51c
 [<ffffffff81018850>] 0xffffffff81018850
 [<ffffffff8100445c>] 0xffffffff8100445c
 [<ffffffff81308fba>] 0xffffffff81308fba
 [<ffffffff811cc13a>] ? 0xffffffff811cc13a
 <<EOE>>  [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
NMI backtrace for cpu 7
CPU 7 
Modules linked in: ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_tcpudp iptable_filter ip_tables x_tables ipmi_devintf ipmi_poweroff ipmi_si 
ipi

Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2 Intel Corporation 
S5500BC/S5500BC
RIP: 0010:[<ffffffff811cc13a>]  [<ffffffff811cc13a>] 0xffffffff811cc13a
RSP: 0018:ffff88046e1d5e78  EFLAGS: 00000046
RAX: 0000000000000020 RBX: 120905f0d08e9c03 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff88046e1d4010 RDI: ffff88046e1d5fd8
RBP: ffff88046e1d5ec8 R08: 0000000000000000 R09: 0000000000000001
R10: 000000010008da60 R11: 0000000000000000 R12: 0000000000000020
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88008c2e0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fc00a159320 CR3: 00000000013f7000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff88046e1d4000, task 
ffff88046e1a6000)
Stack:
 0000000000000000 000000000000ea50 ffff88046e1d5ec8 ffffffff8126fe15
 0000026204a56a00 000000076e1d4010 ffff88046e1d4010 ffff88008c2f87a0
 ffff88008c2f8670 0000000000000000 ffff88046e1d5ee8 ffffffff8126f0c4
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Code: 8d b7 38 e0 ff ff a8 08 75 21 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 
48 8b 87 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> 79 1b e8 ff 48 
89 c7 48 29 df e8 c5 9b e6 ff 48 89 c3 49 89 
Call Trace:
 [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d
Pid: 0, comm: kworker/0:1 Not tainted 2.6.37.2 #2
Call Trace:
 <NMI>  [<ffffffff8100a51c>] ? 0xffffffff8100a51c
 [<ffffffff81018850>] 0xffffffff81018850
 [<ffffffff8100445c>] 0xffffffff8100445c
 [<ffffffff81308fba>] 0xffffffff81308fba
 [<ffffffff811cc13a>] ? 0xffffffff811cc13a
 <<EOE>>  [<ffffffff8126fe15>] ? 0xffffffff8126fe15
 [<ffffffff8126f0c4>] 0xffffffff8126f0c4
 [<ffffffff81001d21>] 0xffffffff81001d21
 [<ffffffff8130285d>] 0xffffffff8130285d

SysRq : Show Regs

CPU#0: ctrl:       000000070000000f
CPU#0: status:     0000000000000000
CPU#0: overflow:   0000000000000000
CPU#0: fixed:      0000000000000000
CPU#0: pebs:       0000000000000000
CPU#0: active:     0000000000000000
CPU#0:   gen-PMC0 ctrl:  0000000000000000
CPU#0:   gen-PMC0 count: 000000000000abcd
CPU#0:   gen-PMC0 left:  0000000000000000
CPU#0:   gen-PMC1 ctrl:  0000000000000000
CPU#0:   gen-PMC1 count: 0000000000000000
CPU#0:   gen-PMC1 left:  0000000000000000
CPU#0:   gen-PMC2 ctrl:  0000000000000000
CPU#0:   gen-PMC2 count: 0000000000000000
CPU#0:   gen-PMC2 left:  0000000000000000
CPU#0:   gen-PMC3 ctrl:  0000000000000000
CPU#0:   gen-PMC3 count: 0000000000000000
CPU#0:   gen-PMC3 left:  0000000000000000
CPU#0: fixed-PMC0 count: 0000000000000000
CPU#0: fixed-PMC1 count: 0000000000000000
CPU#0: fixed-PMC2 count: 0000000000000000

Sadly "d" doesn't work for whatever reason.

If anyone has a quick idea how to get some more information I will be happy to 
test as I assume finishing that move will take a while anyway.

Eike
