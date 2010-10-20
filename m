Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab0JTSi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:38:26 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48749 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab0JTSiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:38:25 -0400
Message-ID: <4CBF370D.1060206@us.ibm.com>
Date: Wed, 20 Oct 2010 13:38:05 -0500
From: Karl Rister <kmr@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: a.p.zijlstra@chello.nl, "Andrew M. Theurer" <atheurer@us.ibm.com>
Subject: re: [RFC][PATCH 0/3] Try and make cpu-cgroup suck less
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> These patches try and make cpu-cgroup suck less..
>
> Didn't test the RT changes much at all, did poke a little at the FAIR bits.
>

Have there been any updates to this patch series?

I applied the original 3 associated patches against a recent kvm.git 
pull (cec8b6b972a572b69d4902f57fb659e8a4c749af) and attempted to do some 
tests running KVM guests.  When the cgconfig service is disabled (and 
libvirtd cannot make use of cgroups) I can start guests without issues. 
  However, when the cgconfig service is enabled (and libvirtd attempts 
to create cgroups for the guest) the host crashed immediately after 
starting the guest with 'virsh start' with the following:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
IP: [<ffffffff81058a5c>] set_next_entity+0xc/0xa0
PGD 462bb2067 PUD 46230e067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/net/vnet0/address
CPU 10
Modules linked in: tun ip6table_filter ip6_tables ebtable_nat ebtables 
xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat]

Pid: 3125, comm: libvirtd Not tainted 2.6.36-rc7+ #1 49Y6512     /System 
x3650 M2 -[7947AC1]-
RIP: 0010:[<ffffffff81058a5c>]  [<ffffffff81058a5c>] 
set_next_entity+0xc/0xa0
RSP: 0018:ffff880462551ae8  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8804653f09c0 RCX: 0000000000006db4
RDX: 0000000000006db4 RSI: 0000000000000000 RDI: ffff8804653f09c0
RBP: ffff880462551af8 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff880002595c80
FS:  00007fddf2ac5710(0000) GS:ffff880002580000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000038 CR3: 000000046ce4c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process libvirtd (pid: 3125, threadinfo ffff880462550000, task 
ffff88046cefeac0)
Stack:
  ffff8804653f09c0 0000000000000000 ffff880462551b38 ffffffff81058c1c
<0> ffff88046cefeac0 ffff880002595c80 ffff88046ceff050 000000000000000a
<0> ffffffff8160b400 0000000000000000 ffff880462551c08 ffffffff8149246f
Call Trace:
  [<ffffffff81058c1c>] pick_next_task_fair+0xdc/0x130
  [<ffffffff8149246f>] schedule+0x6df/0xa40
  [<ffffffff81492e1d>] schedule_timeout+0x20d/0x2e0
  [<ffffffff81492a4d>] wait_for_common+0x11d/0x190
  [<ffffffff81058260>] ? default_wake_function+0x0/0x20
  [<ffffffff81492b9d>] wait_for_completion+0x1d/0x20
  [<ffffffff810c75d8>] synchronize_sched+0x58/0x60
  [<ffffffff8107dcf0>] ? wakeme_after_rcu+0x0/0x20
  [<ffffffff810adbf4>] cgroup_attach_task+0x1d4/0x290
  [<ffffffff810adffc>] cgroup_tasks_write+0x5c/0xf0
  [<ffffffff810ac75e>] cgroup_file_write+0x2ce/0x330
  [<ffffffff811d2c3f>] ? security_file_permission+0x1f/0x80
  [<ffffffff81148e08>] vfs_write+0xc8/0x190
  [<ffffffff81149771>] sys_write+0x51/0x80
  [<ffffffff8100b0b2>] system_call_fastpath+0x16/0x1b
Code: 49 83 c6 10 4c 89 e2 4c 89 ee ff d0 49 8b 06 48 85 c0 75 e8 eb 98 
66 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 54 53 0f 1
RIP  [<ffffffff81058a5c>] set_next_entity+0xc/0xa0
  RSP <ffff880462551ae8>
CR2: 0000000000000038
---[ end trace e280490116460b9e ]---

-- 
Karl Rister <kmr@us.ibm.com>
