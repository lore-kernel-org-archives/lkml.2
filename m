Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2IYNKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:10:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32061 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab2IYNKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:10:53 -0400
X-IronPort-AV: E=Sophos;i="4.80,482,1344182400"; 
   d="scan'208";a="5914410"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com, mingo@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-numa@vger.kernel.org
Subject: [PATCH v2 0/2] Update sched_domains_numa_masks when new cpus are onlined.
Date: Tue, 25 Sep 2012 21:12:29 +0800
Message-Id: <1348578751-16904-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 21:11:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/25 21:11:05,
	Serialize complete at 2012/09/25 21:11:05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once array sched_domains_numa_masks is defined, it is never updated.
When a new cpu on a new node is onlined, the coincident member in
sched_domains_numa_masks is not initialized, and all the masks are 0.
As a result, the build_overlap_sched_groups() will initialize a NULL
sched_group for the new cpu on the new node, which will lead to kernel panic.

[ 3189.403280] Call Trace:
[ 3189.403286]  [<ffffffff8106c36f>] warn_slowpath_common+0x7f/0xc0
[ 3189.403289]  [<ffffffff8106c3ca>] warn_slowpath_null+0x1a/0x20
[ 3189.403292]  [<ffffffff810b1d57>] build_sched_domains+0x467/0x470
[ 3189.403296]  [<ffffffff810b2067>] partition_sched_domains+0x307/0x510
[ 3189.403299]  [<ffffffff810b1ea2>] ? partition_sched_domains+0x142/0x510
[ 3189.403305]  [<ffffffff810fcc93>] cpuset_update_active_cpus+0x83/0x90
[ 3189.403308]  [<ffffffff810b22a8>] cpuset_cpu_active+0x38/0x70
[ 3189.403316]  [<ffffffff81674b87>] notifier_call_chain+0x67/0x150
[ 3189.403320]  [<ffffffff81664647>] ? native_cpu_up+0x18a/0x1b5
[ 3189.403328]  [<ffffffff810a044e>] __raw_notifier_call_chain+0xe/0x10
[ 3189.403333]  [<ffffffff81070470>] __cpu_notify+0x20/0x40
[ 3189.403337]  [<ffffffff8166663e>] _cpu_up+0xe9/0x131
[ 3189.403340]  [<ffffffff81666761>] cpu_up+0xdb/0xee
[ 3189.403348]  [<ffffffff8165667c>] store_online+0x9c/0xd0
[ 3189.403355]  [<ffffffff81437640>] dev_attr_store+0x20/0x30
[ 3189.403361]  [<ffffffff8124aa63>] sysfs_write_file+0xa3/0x100
[ 3189.403368]  [<ffffffff811ccbe0>] vfs_write+0xd0/0x1a0
[ 3189.403371]  [<ffffffff811ccdb4>] sys_write+0x54/0xa0
[ 3189.403375]  [<ffffffff81679c69>] system_call_fastpath+0x16/0x1b
[ 3189.403377] ---[ end trace 1e6cf85d0859c941 ]---
[ 3189.403398] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018

This patch registers a new notifier for cpu hotplug notify chain, and
updates sched_domains_numa_masks every time a new cpu is onlined or offlined.


Tang Chen (2):
  Ensure sched_domains_numa_levels safe in other functions.
  Update sched_domains_numa_masks when new cpus are onlined.

 kernel/sched/core.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

-- 
1.7.10.1

