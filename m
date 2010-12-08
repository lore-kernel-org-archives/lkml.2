Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab0LHVJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:09:11 -0500
Received: from claw.goop.org ([74.207.240.146]:46296 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab0LHVJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:09:10 -0500
Message-ID: <4CFFF3F3.90100@goop.org>
Date: Wed, 08 Dec 2010 13:09:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>
CC: NetDev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.37-rc5: NULL pointer oops in selinux_socket_unix_stream_connect
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got this oops in a freshly booted 2.6.37-rc5 Xen domain, while
sitting idle at the login prompt:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000210
IP: [<ffffffff811d55d4>] selinux_socket_unix_stream_connect+0x29/0xa0
PGD 1c99d067 PUD 1cb03067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/sched_mc_power_savings
CPU 0 
Modules linked in: sunrpc dm_mirror dm_region_hash dm_log [last unloaded: scsi_wait_scan]

Pid: 2297, comm: at-spi-registry Not tainted 2.6.37-rc5+ #293 /
RIP: e030:[<ffffffff811d55d4>]  [<ffffffff811d55d4>] selinux_socket_unix_stream_connect+0x29/0xa0
RSP: e02b:ffff880006e7dd68  EFLAGS: 00010292
RAX: ffff88001d1ed8c0 RBX: ffff88001d06d9a0 RCX: 0000000000000022
RDX: ffff88001d1ed580 RSI: 0000000000000000 RDI: ffff88001b7d6ac0
RBP: ffff880006e7de18 R08: 00000000ffff0201 R09: ffff88001e78c968
R10: 000000001f47e9c2 R11: ffff88001fbf4400 R12: ffff88001d1ed8c0
R13: ffff88001d1ed580 R14: ffff88001ca00cc0 R15: 0000000000000000
FS:  00007fa643031920(0000) GS:ffff88001ff85000(0000) knlGS:0000000000000000
CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000210 CR3: 000000001d78a000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process at-spi-registry (pid: 2297, threadinfo ffff880006e7c000, task ffff88001cdd1140)
Stack:
 ffff88001d4c0bc0 000000004cffecc5 ffff880006e7ddc8 ffffffff81028dc5
 ffff8800ffffffff 0001628b2ec3fe22 ffff880006e7dde8 ffff88001d1edb80
 0000000000000001 0000936a4da34099 0000000000000000 00000000000000fa
Call Trace:
 [<ffffffff81028dc5>] ? pvclock_clocksource_read+0x48/0xb1
 [<ffffffff810074ab>] ? xen_clocksource_read+0x20/0x22
 [<ffffffff81008fd9>] ? xen_spin_lock+0xc6/0xd9
 [<ffffffff811d1d1e>] security_unix_stream_connect+0x16/0x18
 [<ffffffff81484366>] unix_stream_connect+0x215/0x3ff
 [<ffffffff813f351d>] sys_connect+0x7a/0xa0
 [<ffffffff8108cd9d>] ? audit_syscall_entry+0x1c2/0x1ee
 [<ffffffff8100bb42>] system_call_fastpath+0x16/0x1b
Code: c9 c3 55 48 89 e5 41 55 41 54 53 48 81 ec 98 00 00 00 0f 1f 44 00 00 b9 22 00 00 00 48 8b 47 20 48 8b 76 20 48 8b 98 10 02 00 00 <4c> 8b a6 10 02 00 00 31 c0 4c 8b aa 10 02 00 00 4c 8d 85 50 ff 
RIP  [<ffffffff811d55d4>] selinux_socket_unix_stream_connect+0x29/0xa0
 RSP <ffff880006e7dd68>
CR2: 0000000000000210
---[ end trace 50030b578c1ee27e ]---

This corresponds to:

(gdb) list *0xffffffff811d55d4
0xffffffff811d55d4 is in selinux_socket_unix_stream_connect (/home/jeremy/git/upstream/security/selinux/hooks.c:3929).
3924	static int selinux_socket_unix_stream_connect(struct socket *sock,
3925						      struct socket *other,
3926						      struct sock *newsk)
3927	{
3928		struct sk_security_struct *sksec_sock = sock->sk->sk_security;
3929		struct sk_security_struct *sksec_other = other->sk->sk_security;
3930		struct sk_security_struct *sksec_new = newsk->sk_security;
3931		struct common_audit_data ad;
3932		int err;
3933	


The system is a somewhat out of date Fedora 13 with
selinux-policy-3.7.19-73.fc13.noarch and
selinux-policy-targeted-3.7.19-73.fc13.noarch installed.

I'm not sure what at-spi-registry is or what it is trying to do here.
The crash seems non-deterministic; I rebooted the domain without any issues.

Thanks,
    J
