Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0ELJCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:02:53 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:47960 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab0ELJCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:02:51 -0400
Message-ID: <4BEA6E7A.20500@udo.edu>
Date: Wed, 12 May 2010 11:01:46 +0200
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: linux@brodo.de, ashok.raj@intel.com, jacob.shin@amd.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [CPUFREQ] fix race condition in store_scaling_governor
References: <4BE967B9.5050107@udo.edu> <20100512080837.GD5718@cr0.nay.redhat.com>
In-Reply-To: <20100512080837.GD5718@cr0.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i have reported a bug (https://bugzilla.kernel.org/show_bug.cgi?id=15948
). I get a kernel panic with my tool, which switch the scaling governor 
to conservative (default is compiled in ondemand) if there no ac online 
(i have attached the code to the bug report). In bug report i have 
attached the dmesg output before the kernel panic (i get it with kernel 
crash dump). Something like this:

...
<4>------------[ cut here ]------------
<4>WARNING: at /home/andrej/kernel/linux/fs/sysfs/dir.c:451 
sysfs_add_one+0xab/0xc0()
<4>Hardware name: 287655G
<4>sysfs: cannot create duplicate filename 
'/devices/system/cpu/cpu0/cpufreq/ondemand'
<4>Modules linked in:
<4>Pid: 1878, comm: achook Tainted: G        W  2.6.34-rc7 #20
<4>Call Trace:
<4> [<ffffffff81054736>] warn_slowpath_common+0x76/0xb0
<4> [<ffffffff810547cc>] warn_slowpath_fmt+0x3c/0x40
<4> [<ffffffff8111242b>] sysfs_add_one+0xab/0xc0
<4> [<ffffffff8111249e>] create_dir+0x5e/0xb0
<4> [<ffffffff81112506>] sysfs_create_subdir+0x16/0x20
<4> [<ffffffff8111387a>] internal_create_group+0x5a/0x190
<4> [<ffffffff811139de>] sysfs_create_group+0xe/0x10
<4> [<ffffffff813c1c95>] cpufreq_governor_dbs+0x75/0x330
<4> [<ffffffff813bf92e>] __cpufreq_governor+0x4e/0xe0
<4> [<ffffffff813c05c0>] ? lock_policy_rwsem_write+0x20/0x40
<4> [<ffffffff813c088c>] __cpufreq_set_policy+0x13c/0x180
<4> [<ffffffff813c0b6a>] store_scaling_governor+0xca/0x200
<4> [<ffffffff813c10b0>] ? handle_update+0x0/0x10
<4> [<ffffffff81526400>] ? do_nanosleep+0x90/0xc0
<4> [<ffffffff813c0722>] store+0x62/0x90
<4> [<ffffffff81110f4d>] sysfs_write_file+0xed/0x170
<4> [<ffffffff810bfbdd>] vfs_write+0xad/0x170
<4> [<ffffffff810bfecc>] sys_write+0x4c/0x80
<4> [<ffffffff81029c49>] ? do_device_not_available+0x9/0x10
<4> [<ffffffff81027c68>] system_call_fastpath+0x16/0x1b
<4>---[ end trace 2ed7331f299577b7 ]---
<4>------------[ cut here ]------------
<4>WARNING: at /home/andrej/kernel/linux/fs/sysfs/dir.c:451 
sysfs_add_one+0xab/0xc0()
<4>Hardware name: 287655G
<4>sysfs: cannot create duplicate filename 
'/devices/system/cpu/cpu0/cpufreq/conservative'
<4>Modules linked in:
<4>Pid: 1878, comm: achook Tainted: G        W  2.6.34-rc7 #20
<4>Call Trace:
<4> [<ffffffff81054736>] warn_slowpath_common+0x76/0xb0
<4> [<ffffffff810547cc>] warn_slowpath_fmt+0x3c/0x40
<4> [<ffffffff8111242b>] sysfs_add_one+0xab/0xc0
<4> [<ffffffff8111249e>] create_dir+0x5e/0xb0
<4> [<ffffffff81112506>] sysfs_create_subdir+0x16/0x20
<4> [<ffffffff8111387a>] internal_create_group+0x5a/0x190
<4> [<ffffffff8104fa74>] ? __cond_resched+0x24/0x40
<4> [<ffffffff811139de>] sysfs_create_group+0xe/0x10
<4> [<ffffffff813c2bf5>] cpufreq_governor_dbs+0x75/0x380
<4> [<ffffffff813bf92e>] __cpufreq_governor+0x4e/0xe0
<4> [<ffffffff813c08c3>] __cpufreq_set_policy+0x173/0x180
<4> [<ffffffff813c0b6a>] store_scaling_governor+0xca/0x200
<4> [<ffffffff813c10b0>] ? handle_update+0x0/0x10
<4> [<ffffffff81526400>] ? do_nanosleep+0x90/0xc0
<4> [<ffffffff813c0722>] store+0x62/0x90
<4> [<ffffffff81110f4d>] sysfs_write_file+0xed/0x170
<4> [<ffffffff810bfbdd>] vfs_write+0xad/0x170
...

So there is a lock needed to avoid this race condition (old staff is not 
jet removed and new staff is added). I think it is not a bad idea to 
protect policy object in store_scaling_governor (this is a shared
object). That if your remove the new policy after cpufreq_parse_governor 
call? Then you will try to set a policy, which is not available any 
more, so i think cpufreq_governor_mutex is proper
mutex here.

Regards,
Andrej Gelenberg

On 05/12/2010 10:08 AM, Américo Wang wrote:
>
> Sorry, I don't get it, cpufreq_governor_mutex is used to protect
> cpufreq_governor_list. What is the point of moving it up?
> Can you explain what the race condition is?
>
> Thanks!
>

