Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab2CRTse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 15:48:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59241 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2CRTsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 15:48:33 -0400
MIME-Version: 1.0
X-Originating-IP: [121.44.4.35]
Date: Mon, 19 Mar 2012 06:41:56 +1100
Message-ID: <CAOzFzEiufg40gKBH6D7zeB47SebfPvgzqOLxhF5eQqpYd-r4zQ@mail.gmail.com>
Subject: Kernel Panic with bonding + IPoIB on 3.2.9
From: Joseph Glanville <joseph.glanville@orionvm.com.au>
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I am getting an annoying kernel panic on 3.2.9 that seems to be
related to bonding (as I can't reproduce the crash without it)
I believe it might be related to LRO/GRO but there isnt a param to
disable it anymore that I could see in /ulp/ipoib/
Let me know if there is anything further I can do to help debug.

Useful information:

Hardware:
Dell C2100 - Intel Xeon dual socket with 144GB RAM
Mellanox Connect-X DDR using in kernel mlx4 driver
Machine is also a Xen dom0

ibstatCA 'mlx4_0'
	CA type: MT26418
	Number of ports: 2
	Firmware version: 2.9.1000
	Hardware version: a0
	Node GUID: 0x0002c9030008d7be
	System image GUID: 0x0002c9030008d7c1
	Port 1:
		State: Active
		Physical state: LinkUp
		Rate: 20
		Base lid: 6
		LMC: 0
		SM lid: 1
		Capability mask: 0x02590868
		Port GUID: 0x0002c9030008d7bf
		Link layer: InfiniBand
	Port 2:
		State: Active
		Physical state: LinkUp
		Rate: 20
		Base lid: 9
		LMC: 0
		SM lid: 1
		Capability mask: 0x02590868
		Port GUID: 0x0002c9030008d7c0
		Link layer: InfiniBand


ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ib0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 65220 qdisc
pfifo_fast master bond0 state UP qlen 256
    link/infiniband
80:00:00:48:fe:80:00:00:00:00:00:00:00:02:c9:03:00:08:d7:bf brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
3: ib1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 65220 qdisc
pfifo_fast master bond0 state UP qlen 256
    link/infiniband
80:00:00:49:fe:80:00:00:00:00:00:00:00:02:c9:03:00:08:d7:c0 brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
4: gre0: <NOARP> mtu 1476 qdisc noop state DOWN
    link/gre 0.0.0.0 brd 0.0.0.0
5: sit0: <NOARP> mtu 1480 qdisc noop state DOWN
    link/sit 0.0.0.0 brd 0.0.0.0
6: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 65220 qdisc
noqueue state UP
    link/infiniband
80:00:00:48:fe:80:00:00:00:00:00:00:00:02:c9:03:00:08:d7:bf brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:f

The KP itself:
[  422.046837] ------------[ cut here ]------------
[  422.047024] kernel BUG at net/core/dev.c:1896!
[  422.047126] invalid opcode: 0000 [#1] SMP
[  422.047289] CPU 1
[  422.047328] Modules linked in: ib_srpt(O) scst_vdisk(O) scst(O)
bonding raid1 raid0 md_mod dm_multipath
[  422.047869]
[  422.047962] Pid: 3352, comm: sshd Tainted: G           O
3.2.1-orion #4 Dell                   PowerEdge C2100       /0P19C9
[  422.048237] RIP: e030:[<ffffffff81559b92>]  [<ffffffff81559b92>]
skb_checksum_help+0x142/0x150
[  422.048450] RSP: e02b:ffff88006cb11758  EFLAGS: 00010282
[  422.048556] RAX: 0000000000000108 RBX: ffff880072f7f4e8 RCX: 0000000060004420
[  422.048668] RDX: 0000000000000108 RSI: 0000000000000000 RDI: ffff880072f7f4e8
[  422.048780] RBP: ffff88006cb11778 R08: ffff88000e53529c R09: 0000000000000104
[  422.048892] R10: ffffffff8151a7d0 R11: 0000000000000000 R12: 00000000ffff0018
[  422.049005] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  422.049119] FS:  00007fea22aa8700(0000) GS:ffff8800bf435000(0000)
knlGS:0000000000000000
[  422.049288] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  422.049395] CR2: 00007fff14d07ed8 CR3: 00000000085dc000 CR4: 0000000000002660
[  422.049506] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  422.049618] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  422.049742] Process sshd (pid: 3352, threadinfo ffff88006cb10000,
task ffff88000cea4920)
[  422.049909] Stack:
[  422.050002]  ffff880072f7f4e8 ffff88000ce64000 0000000000000000
0000000000000000
[  422.050290]  ffff88006cb117e8 ffffffff8155f15e ffff88006cb11858
ffffffff8187ba80
[  422.050580]  ffff88000ce5bc80 0000000000000000 0000000000000006
0000000000000000
[  422.050869] Call Trace:
[  422.050967]  [<ffffffff8155f15e>] dev_hard_start_xmit+0x36e/0x6c0
[  422.051084]  [<ffffffff8157a19b>] sch_direct_xmit+0xdb/0x1e0
[  422.051191]  [<ffffffff8155f638>] dev_queue_xmit+0x188/0x620
[  422.051301]  [<ffffffffa003b297>] bond_dev_queue_xmit+0x27/0x70 [bonding]
[  422.051413]  [<ffffffffa003b5e4>] bond_start_xmit+0x304/0x4e0 [bonding]
[  422.051524]  [<ffffffff8155f099>] dev_hard_start_xmit+0x2a9/0x6c0
[  422.051633]  [<ffffffff8155f895>] dev_queue_xmit+0x3e5/0x620
[  422.051742]  [<ffffffff81567cbd>] neigh_connected_output+0xbd/0xf0
[  422.051853]  [<ffffffff815a7120>] ? ip_fragment+0x850/0x850
[  422.051960]  [<ffffffff815a72ae>] ip_finish_output+0x18e/0x300
[  422.052068]  [<ffffffff815a7dd8>] ip_output+0x98/0xa0
[  422.052172]  [<ffffffff815a74be>] ? __ip_local_out+0x9e/0xa0
[  422.052279]  [<ffffffff815a74e4>] ip_local_out+0x24/0x30
[  422.052385]  [<ffffffff815a764a>] ip_queue_xmit+0x15a/0x400
[  422.052510]  [<ffffffff815bdade>] tcp_transmit_skb+0x3de/0x8f0
[  422.052617]  [<ffffffff815be702>] tcp_write_xmit+0x1d2/0x9c0
[  422.052725]  [<ffffffff81129057>] ? ksize+0x17/0xc0
[  422.052829]  [<ffffffff815bef41>] __tcp_push_pending_frames+0x21/0x90
[  422.052939]  [<ffffffff815b09ae>] tcp_sendmsg+0x75e/0xd80
[  422.053047]  [<ffffffff815d4c0f>] inet_sendmsg+0x5f/0xb0
[  422.053155]  [<ffffffff81009f3f>] ? xen_restore_fl_direct_reloc+0x4/0x4
[  422.053267]  [<ffffffff8126734e>] ? selinux_socket_sendmsg+0x1e/0x20
[  422.053377]  [<ffffffff8154732a>] sock_aio_write+0x15a/0x170
[  422.053486]  [<ffffffff812652d1>] ? inode_has_perm.clone.15+0x21/0x30
[  422.053597]  [<ffffffff8113133a>] do_sync_write+0xda/0x120
[  422.053704]  [<ffffffff81268003>] ? selinux_file_permission+0xb3/0x140
[  422.053821]  [<ffffffff812e8efa>] ? put_ldisc+0x5a/0xc0
[  422.053937]  [<ffffffff81262237>] ? security_file_permission+0x27/0xb0
[  422.054048]  [<ffffffff81131ca9>] vfs_write+0x169/0x180
[  422.054153]  [<ffffffff81131f1c>] sys_write+0x4c/0x90
[  422.054260]  [<ffffffff816891d2>] system_call_fastpath+0x16/0x1b
[  422.054367] Code: 65 86 ff ff 85 c0 0f 84 75 ff ff ff eb a6 41 29
d4 48 8b 83 d8 00 00 00 0f b7 53 72 45 8d 64 04 02 41 39 d4 77 cd e9
5d ff ff ff <0f> 0b 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 55 b8 ea ff ff
ff 48
[  422.056691] RIP  [<ffffffff81559b92>] skb_checksum_help+0x142/0x150
[  422.056831]  RSP <ffff88006cb11758>
[  422.056930] ---[ end trace 751906f8ee2b0c91 ]---
[  422.057032] Kernel panic - not syncing: Fatal exception in interrupt
[  422.057141] Pid: 3352, comm: sshd Tainted: G      D    O 3.2.1-orion #4
[  422.057250] Call Trace:
[  422.057348]  [<ffffffff8167e944>] panic+0x8c/0x1a0
[  422.057451]  [<ffffffff816825fa>] oops_end+0xea/0xf0
[  422.057557]  [<ffffffff81016636>] die+0x56/0x90
[  422.057660]  [<ffffffff81681f64>] do_trap+0xc4/0x170
[  422.057764]  [<ffffffff81013e50>] do_invalid_op+0x90/0xb0
[  422.057870]  [<ffffffff81559b92>] ? skb_checksum_help+0x142/0x150
[  422.057989]  [<ffffffff8168b1ab>] invalid_op+0x1b/0x20
[  422.058101]  [<ffffffff8151a7d0>] ? ipoib_setup+0x330/0x330
[  422.058207]  [<ffffffff81559b92>] ? skb_checksum_help+0x142/0x150
[  422.058316]  [<ffffffff8155f15e>] dev_hard_start_xmit+0x36e/0x6c0
[  422.058425]  [<ffffffff8157a19b>] sch_direct_xmit+0xdb/0x1e0
[  422.058533]  [<ffffffff8155f638>] dev_queue_xmit+0x188/0x620
[  422.058641]  [<ffffffffa003b297>] bond_dev_queue_xmit+0x27/0x70 [bonding]
[  422.058753]  [<ffffffffa003b5e4>] bond_start_xmit+0x304/0x4e0 [bonding]
[  422.058864]  [<ffffffff8155f099>] dev_hard_start_xmit+0x2a9/0x6c0
[  422.058973]  [<ffffffff8155f895>] dev_queue_xmit+0x3e5/0x620
[  422.059080]  [<ffffffff81567cbd>] neigh_connected_output+0xbd/0xf0
[  422.059190]  [<ffffffff815a7120>] ? ip_fragment+0x850/0x850
[  422.059296]  [<ffffffff815a72ae>] ip_finish_output+0x18e/0x300
[  422.059412]  [<ffffffff815a7dd8>] ip_output+0x98/0xa0
[  422.059517]  [<ffffffff815a74be>] ? __ip_local_out+0x9e/0xa0
[  422.059624]  [<ffffffff815a74e4>] ip_local_out+0x24/0x30
[  422.059730]  [<ffffffff815a764a>] ip_queue_xmit+0x15a/0x400
[  422.059836]  [<ffffffff815bdade>] tcp_transmit_skb+0x3de/0x8f0
[  422.059944]  [<ffffffff815be702>] tcp_write_xmit+0x1d2/0x9c0

-- 
Founder | Director | VP Research
Orion Virtualisation Solutions | www.orionvm.com.au | Phone: 1300 56
99 52 | Mobile: 0428 754 846
