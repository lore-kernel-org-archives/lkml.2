Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab0ESHyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:54:54 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:36040 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab0ESHyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:54:52 -0400
X-Greylist: delayed 3122 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2010 03:54:52 EDT
Date: Wed, 19 May 2010 16:02:48 +0900
Message-ID: <20100519.160248.189289167.itoumsn@nttdata.co.jp>
To: <linux-kernel@vger.kernel.org>
CC: <itoumsn@nttdata.co.jp>
Subject: [PATCH] fix list_head init bug in __percpu_counter_init
From: Masanori ITOH <itoumsn@nttdata.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I got the attached patterns of list_add/list_del errors using linux-2.6.34
on Fedora 12(x86_64). 
It's because there is no initialization code for a list_head contained in
the struct backing_dev_info under CONFIG_HOTPLUG_CPU, and the bug comes up
when block device drivers calling blk_alloc_queue() are used. In case of me,
I got them by using aoe.

The patch below fixes the problem and worked fine for me.

Regards,
Masanori


Signed-off-by: Masanori Itoh <itoumsn@nttdata.co.jp>
---
diff -ru linux-2.6.34.orig/lib/percpu_counter.c linux-2.6.34/lib/percpu_counter.c
--- linux-2.6.34.orig/lib/percpu_counter.c	2010-05-17 06:17:36.000000000 +0900
+++ linux-2.6.34/lib/percpu_counter.c	2010-05-19 15:38:10.000000000 +0900
@@ -76,6 +76,7 @@
 	if (!fbc->counters)
 		return -ENOMEM;
 #ifdef CONFIG_HOTPLUG_CPU
+	INIT_LIST_HEAD(&fbc->list);
 	mutex_lock(&percpu_counters_lock);
 	list_add(&fbc->list, &percpu_counters);
 	mutex_unlock(&percpu_counters_lock);



[Pattern 1]
------------[ cut here ]------------
WARNING: at lib/list_debug.c:26 __list_add+0x3f/0x81()
Hardware name: Express5800/B120a [N8400-085]
list_add corruption. next->prev should be prev (ffffffff81a7ea00), but was dead000000200200. (next=ffff88080b872d58).
Modules linked in: aoe ipt_MASQUERADE iptable_nat nf_nat autofs4 sunrpc bridge 8021q garp stp llc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_round_robin dm_multipath kvm_intel kvm uinput lpfc scsi_transport_fc igb ioatdma scsi_tgt i2c_i801 i2c_core dca iTCO_wdt iTCO_vendor_support pcspkr shpchp megaraid_sas [last unloaded: aoe]
Pid: 54, comm: events/3 Tainted: G        W  2.6.34-vanilla1 #1
Call Trace:
[<ffffffff8104bd77>] warn_slowpath_common+0x7c/0x94
[<ffffffff8104bde6>] warn_slowpath_fmt+0x41/0x43
[<ffffffff8120fd2e>] __list_add+0x3f/0x81
[<ffffffff81212a12>] __percpu_counter_init+0x59/0x6b
[<ffffffff810d8499>] bdi_init+0x118/0x17e
[<ffffffff811f2c50>] blk_alloc_queue_node+0x79/0x143
[<ffffffff811f2d2b>] blk_alloc_queue+0x11/0x13
[<ffffffffa02a931d>] aoeblk_gdalloc+0x8e/0x1c9 [aoe]
[<ffffffffa02aa655>] aoecmd_sleepwork+0x25/0xa8 [aoe]
[<ffffffff8106186c>] worker_thread+0x1a9/0x237
[<ffffffffa02aa630>] ? aoecmd_sleepwork+0x0/0xa8 [aoe]
[<ffffffff81065827>] ? autoremove_wake_function+0x0/0x39
[<ffffffff810616c3>] ? worker_thread+0x0/0x237
[<ffffffff810653ad>] kthread+0x7f/0x87
[<ffffffff8100aa24>] kernel_thread_helper+0x4/0x10
[<ffffffff8106532e>] ? kthread+0x0/0x87
[<ffffffff8100aa20>] ? kernel_thread_helper+0x0/0x10
---[ end trace 0d76bc4268858d83 ]---

[Pattern 2]
------------[ cut here ]------------
WARNING: at lib/list_debug.c:51 list_del+0x5e/0x8b()
Hardware name: Express5800/B120a [N8400-085]
list_del corruption. next->prev should be ffff88080b872d08, but was ffffffff81a7ea00
Modules linked in: aoe(-) ipt_MASQUERADE iptable_nat nf_nat autofs4 sunrpc bridge 8021q garp stp llc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_round_robin dm_multipath kvm_intel kvm uinput lpfc scsi_transport_fc igb ioatdma scsi_tgt i2c_i801 i2c_core dca iTCO_wdt iTCO_vendor_support pcspkr shpchp megaraid_sas [last unloaded: aoe]
Pid: 7667, comm: rmmod Tainted: G        W  2.6.34-vanilla1 #1
Call Trace:
[<ffffffff8104bd77>] warn_slowpath_common+0x7c/0x94
[<ffffffff8104bde6>] warn_slowpath_fmt+0x41/0x43
[<ffffffff81058c0d>] ? spin_unlock_irqrestore+0xe/0x10
[<ffffffff8120fcc2>] list_del+0x5e/0x8b
[<ffffffff81212998>] percpu_counter_destroy+0x28/0x49
[<ffffffff810d8d4c>] bdi_destroy+0x105/0x122
[<ffffffff811f589c>] blk_release_queue+0x56/0x6a
[<ffffffff8120472b>] kobject_release+0xf9/0x1d9
[<ffffffff81204632>] ? kobject_release+0x0/0x1d9
[<ffffffff812057b5>] kref_put+0x43/0x4d
[<ffffffff81204591>] kobject_put+0x47/0x4b
[<ffffffff811f2d42>] blk_put_queue+0x15/0x17
[<ffffffff811f2f09>] blk_cleanup_queue+0x49/0x4e
[<ffffffffa029eb59>] aoedev_freedev+0xed/0x104 [aoe]
[<ffffffffa029ef09>] aoedev_exit+0x5e/0x72 [aoe]
[<ffffffffa029f1b0>] aoe_exit+0x33/0x3b [aoe]
[<ffffffff81079f66>] sys_delete_module+0x1d8/0x264
[<ffffffff8143c804>] ? do_page_fault+0x23c/0x269
[<ffffffff81095e0e>] ? audit_syscall_entry+0x11e/0x14a
[<ffffffff81009c32>] system_call_fastpath+0x16/0x1b
---[ end trace 0d76bc4268858d82 ]---
