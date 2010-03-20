Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab0CTRRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 13:17:20 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37027 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab0CTRRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 13:17:18 -0400
Message-ID: <4BA50319.3040301@in.ibm.com>
Date: Sat, 20 Mar 2010 22:47:13 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: 2.6.34-rc2: cpu hotplug test failure on x86_64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running cpu hotplug tests on a x86_64 box results in
the following BUG.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
IP: [<ffffffff81037388>] amd_pmu_cpu_offline+0x38/0x67
PGD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu1/online
CPU 0
Modules linked in: ipv6 fuse loop dm_mod sg bnx2 rtc_cmos mptctl rtc_core i2c_piix4 rtc_lib serio_raw pcspkr shpchp button i2c_core k8temp pci_hotplug ohci_hcd ehci_hcd sd_mod crc_t10dif usbcore edd ext3 jbd fan thermal processor thermal_sys hwmon mptsas mptscsih mptbase scsi_transport_sas scsi_mod

Pid: 7657, comm: bash Not tainted 2.6.34-rc2-autotest #1 Server Blade/BladeCenter LS21 -[79716AA]-
RIP: 0010:[<ffffffff81037388>]  [<ffffffff81037388>] amd_pmu_cpu_offline+0x38/0x67
RSP: 0018:ffff880129e11d88  EFLAGS: 00010246
RAX: 0000000000000001 RBX: ffff88000608b6f0 RCX: ffffffff8178f3f0
RDX: 0000000000000000 RSI: 0000000000000007 RDI: ffffffff81930f94
RBP: ffff880129e11d98 R08: 0000000000000000 R09: ffff880129e11ca8
R10: 0000000000000000 R11: 0000000000018600 R12: 00000000fffffffd
R13: ffffffff8179f4e0 R14: 0000000000000001 R15: 0000000000000007
FS:  00007f7e4c9346f0(0000) GS:ffff880006000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000004 CR3: 0000000129f51000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 7657, threadinfo ffff880129e10000, task ffff88012850b1e0)
Stack:
 ffff880129e11d98 0000000000000000 ffff880129e11da8 ffffffff81388ab3
<0> ffff880129e11de8 ffffffff8139474e 0000000000000001 ffffffff8184c5e0
<0> 0000000000000001 0000000000000000 0000000000000000 0000000000000001
Call Trace:
 [<ffffffff81388ab3>] x86_pmu_notifier+0x51/0x58
 [<ffffffff8139474e>] notifier_call_chain+0x33/0x5b
 [<ffffffff810838e0>] raw_notifier_call_chain+0xf/0x11
 [<ffffffff8137d5b1>] _cpu_down+0x1ed/0x2f3
 [<ffffffff8107c5ce>] ? __create_workqueue_key+0x204/0x22c
 [<ffffffff8137d6f0>] cpu_down+0x39/0x53
 [<ffffffff8137f58e>] store_online+0x2c/0x6f
 [<ffffffff812c3707>] sysdev_store+0x1b/0x1d
 [<ffffffff8116bfc0>] sysfs_write_file+0xdf/0x114
 [<ffffffff8111810e>] vfs_write+0xae/0x16a
 [<ffffffff8111828e>] sys_write+0x47/0x6e
 [<ffffffff810299ab>] system_call_fastpath+0x16/0x1b
Code: b6 80 00 01 76 4f 48 63 c7 48 c7 c3 f0 b6 00 00 48 c7 c7 94 0f 93 81 48 03 1c c5 c0 2e 84 81 e8 00 a2 35 00 48 8b 93 28 07 00 00 <8b> 42 04 ff c8 85 c0 89 42 04 75 0c 48 8b bb 28 07 00 00 e8 ae
RIP  [<ffffffff81037388>] amd_pmu_cpu_offline+0x38/0x67
 RSP <ffff880129e11d88>
CR2: 0000000000000004
---[ end trace d44efb4255454e5f ]---

The problem seem to have been introduced in 2.6.34-rc1-git8(397104793...)
I haven't tried a git bisect yet. The following two commits
modified the code in perf_event_amd.c.

34538ee77b39a12702e0f4c3ed9e8fa2dd5eb92c
3f6da3905398826d85731247e7fbcf53400c18bd

Will try reverting them to check if that helps.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

