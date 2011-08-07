Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1HGPdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 11:33:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab1HGPdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 11:33:21 -0400
Message-ID: <4E3EB013.5000001@redhat.com>
Date: Sun, 07 Aug 2011 18:32:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
CC: KVM list <kvm@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: percpu crash on NetBurst
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qemu, under some conditions (-cpu host or -cpu kvm64), erroneously 
passes family=15 as the virtual cpuid.  This causes a BUG() in percpu 
code during late boot:

------------[ cut here ]------------
kernel BUG at mm/percpu.c:577!
invalid opcode: 0000 [#1] SMP
CPU 0
Modules linked in: stp llc [last unloaded: speedstep_lib]

Pid: 1061, comm: libvirtd Not tainted 3.0.0 #181 Bochs Bochs
RIP: 0010:[<ffffffff8110603e>]  [<ffffffff8110603e>] 
pcpu_free_area+0x17e/0x180
RSP: 0018:ffff880001cabd18  EFLAGS: 00010006
RAX: 0000000000000000 RBX: 000000000000001d RCX: ffff88000673ef70
RDX: 00000000001fd210 RSI: 00000000002010b8 RDI: 000000000000001d
RBP: ffff880001cabd38 R08: ffff88000673ef00 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800053e6f00
R13: 00000000000001e0 R14: 0000000000000012 R15: ffff880001e502d0
FS:  00007f9887bd5820(0000) GS:ffff880007800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003cb0aab970 CR3: 000000000175f000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process libvirtd (pid: 1061, threadinfo ffff880001caa000, task 
ffff880001e50000)
Stack:
  0000000000000282 ffffe8ffffc001e0 ffff8800053e6f00 0000000000200000
  ffff880001cabd68 ffffffff811060cc ffff880006426c00 ffffffff817ad3a0
  ffff880000a1e540 ffff8800074d8000 ffff880001cabd88 ffffffff811462a5
Call Trace:
  [<ffffffff811060cc>] free_percpu+0x8c/0x140
  [<ffffffff811462a5>] __put_super+0x45/0x80
  [<ffffffff811463d5>] put_super+0x25/0x40
  [<ffffffff8114651a>] deactivate_locked_super+0x5a/0x70
  [<ffffffff81146f0e>] deactivate_super+0x4e/0x70
  [<ffffffff811614e5>] mntput_no_expire+0xb5/0x100
  [<ffffffff8116154f>] mntput+0x1f/0x30
  [<ffffffff81245855>] mq_put_mnt+0x15/0x20
  [<ffffffff81245f77>] put_ipc_ns+0x47/0xa0
  [<ffffffff81080232>] free_nsproxy+0x42/0x90
  [<ffffffff81080440>] switch_task_namespaces+0x50/0x60
  [<ffffffff81080460>] exit_task_namespaces+0x10/0x20
  [<ffffffff8105d29c>] do_exit+0x46c/0x870
  [<ffffffff8105da02>] do_group_exit+0x42/0xa0
  [<ffffffff8105da77>] sys_exit_group+0x17/0x20
  [<ffffffff81521382>] system_call_fastpath+0x16/0x1b
Code: e7 41 89 54 24 14 e8 f2 fd ff ff 5b 41 5c 41 5d 41 5e 5d c3 31 f6 
31 db e9 f5 fe ff ff 45 31 ed 31 c9 31 db e9 02 ff ff ff 0f 0b <0f> 0b 
55 48 89 e5 48 83 ec 20 48 89 5d e0 4c 89 65 e8 4c 89 6d
RIP  [<ffffffff8110603e>] pcpu_free_area+0x17e/0x180
  RSP <ffff880001cabd18>
---[ end trace 87bc11c05d27169e ]---

I traced this to the kernel cpuid code determining the cache line size:

arch/x86/kernel/cpu/intel.c:

     if (c->x86 == 15)
         c->x86_cache_alignment = c->x86_clflush_size * 2;

If I comment out this code, the kernel boots and all is well.

I suspect that the percpu code sometimes uses x86_cache_alignment and 
sometimes some hardcoded macro; I saw some negative elements of 
chunk->map[].

All this applies to v3.0; current upstream (c2f340a69ca) fails even 
worse, haven't yet determined exactly why.

I'm surprised this hasn't been reported before; Ingo, don't you have 
family=15 hosts in your test farm?

-- 
error compiling committee.c: too many arguments to function

