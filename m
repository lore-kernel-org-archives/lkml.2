Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2IJKaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:30:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10807 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755918Ab2IJKaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:30:06 -0400
X-IronPort-AV: E=Sophos;i="4.80,397,1344182400"; 
   d="scan'208";a="5815038"
Message-ID: <504DC198.6080602@cn.fujitsu.com>
Date: Mon, 10 Sep 2012 18:31:52 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-numa@vger.kernel.org
CC: Wen Congyang <wency@cn.fujitsu.com>
Subject: [BUG] Failed to online cpu on a hot-added NUMA node.
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 18:29:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 18:29:33,
	Serialize complete at 2012/09/10 18:29:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I hot add a node, all the cpus on it are offline.
When I online one of them, I got the following error message.

[  762.759364] Call Trace:
[  762.759371]  [<ffffffff8106ec2f>] warn_slowpath_common+0x7f/0xc0
[  762.759374]  [<ffffffff8106ec8a>] warn_slowpath_null+0x1a/0x20
[  762.759377]  [<ffffffff810b463b>] init_sched_groups_power+0xcb/0xd0
[  762.759380]  [<ffffffff810b49fc>] build_sched_domains+0x3bc/0x6a0
[  762.759387]  [<ffffffff810e2e73>] ? __lock_release+0x133/0x1a0
[  762.759390]  [<ffffffff810b51f7>] partition_sched_domains+0x347/0x530
[  762.759393]  [<ffffffff810b4ff2>] ? partition_sched_domains+0x142/0x530
[  762.759399]  [<ffffffff81102bd3>] cpuset_update_active_cpus+0x83/0x90
[  762.759402]  [<ffffffff810b5418>] cpuset_cpu_active+0x38/0x70
[  762.759411]  [<ffffffff81681167>] notifier_call_chain+0x67/0x150
[  762.759417]  [<ffffffff81670bff>] ? native_cpu_up+0x194/0x1c7
[  762.759422]  [<ffffffff810a36be>] __raw_notifier_call_chain+0xe/0x10
[  762.759426]  [<ffffffff81072d70>] __cpu_notify+0x20/0x40
[  762.759430]  [<ffffffff81672af7>] _cpu_up+0xfc/0x144
[  762.759433]  [<ffffffff81672c12>] cpu_up+0xd3/0xe6
[  762.759439]  [<ffffffff81662a1c>] store_online+0x9c/0xd0
[  762.759447]  [<ffffffff81441f80>] dev_attr_store+0x20/0x30
[  762.759454]  [<ffffffff812547a3>] sysfs_write_file+0xa3/0x100
[  762.759462]  [<ffffffff811d62a0>] vfs_write+0xd0/0x1a0
[  762.759465]  [<ffffffff811d6474>] sys_write+0x54/0xa0
[  762.759471]  [<ffffffff81686269>] system_call_fastpath+0x16/0x1b
[  762.759473] ---[ end trace 75068e651299460b ]---
[  762.759493] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000018


In init_sched_groups_power(), we got a NULL pointer sg, which should
have been initialized in build_overlap_sched_groups().

In build_overlap_sched_groups(),
     cpumask_copy(sg_span, sched_domain_span(child));

the new cpu is not set in sched_domain_span(child). It should be set in
build_sched_domain(),
     cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));

But on NUMA topology level, the cpus' masks on the new node is not set
in array sched_domains_numa_masks when they are hot added, which means
they are not set in tl->mask(cpu).

Should we set the hot added cpu masks in sched_domains_numa_masks when
they are onlined ?

If I want to fix this, do I need to add a new notifier to the notify
chain ?

Thanks. :)





