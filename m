Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2A3DTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:19:41 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:20351 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab2A3DTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:19:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Nathan Fontenot <nfont@austin.ibm.com>, Robin Holt <holt@sgi.com>
Subject: [PATCH -v3] mm: Fix memory_dev_init() long delay
Date: Sun, 29 Jan 2012 19:18:33 -0800
Message-Id: <1327893513-27166-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F260C1B.0052,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One system with 2048g ram, reported soft lockup on recent kernel.

[   34.426749] cpu_dev_init done
[   61.166399] BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:1]
[   61.166733] Modules linked in:
[   61.166904] irq event stamp: 1935610
[   61.178431] hardirqs last  enabled at (1935609): [<ffffffff81ce8c05>] mutex_lock_nested+0x299/0x2b4
[   61.178923] hardirqs last disabled at (1935610): [<ffffffff81cf2bab>] apic_timer_interrupt+0x6b/0x80
[   61.198767] softirqs last  enabled at (1935476): [<ffffffff8106e59c>] __do_softirq+0x195/0x1ab
[   61.218604] softirqs last disabled at (1935471): [<ffffffff81cf359c>] call_softirq+0x1c/0x30
[   61.238408] CPU 0 
[   61.238549] Modules linked in:
[   61.238744] 
[   61.238825] Pid: 1, comm: swapper/0 Not tainted 3.3.0-rc1-tip-yh-02076-g962f689-dirty #171
[   61.278212] RIP: 0010:[<ffffffff810b3e3a>]  [<ffffffff810b3e3a>] lock_release+0x90/0x9c
[   61.278627] RSP: 0018:ffff883f64dbfd70  EFLAGS: 00000246
[   61.298287] RAX: ffff883f64dc0000 RBX: 0000000000000000 RCX: 000000000000008b
[   61.298690] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   61.318383] RBP: ffff883f64dbfda0 R08: 0000000000000001 R09: 000000000000008b
[   61.338215] R10: 0000000000000000 R11: 0000000000000000 R12: ffff883f64dbfd10
[   61.338610] R13: ffff883f64dc0708 R14: ffff883f64dc0708 R15: ffffffff81095657
[   61.358299] FS:  0000000000000000(0000) GS:ffff883f7d600000(0000) knlGS:0000000000000000
[   61.378118] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   61.378450] CR2: 0000000000000000 CR3: 00000000024af000 CR4: 00000000000007f0
[   61.398144] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   61.417918] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   61.418260] Process swapper/0 (pid: 1, threadinfo ffff883f64dbe000, task ffff883f64dc0000)
[   61.445358] Stack:
[   61.445511]  0000000000000002 ffff897f649ba168 ffff883f64dbfe10 ffff88ff64bb57a8
[   61.458040]  0000000000000000 0000000000000000 ffff883f64dbfdc0 ffffffff81ceb1b4
[   61.458491]  000000000011608c ffff88ff64bb58a8 ffff883f64dbfdf0 ffffffff81c57638
[   61.478215] Call Trace:
[   61.478367]  [<ffffffff81ceb1b4>] _raw_spin_unlock+0x21/0x2e
[   61.497994]  [<ffffffff81c57638>] klist_next+0x9e/0xbc
[   61.498264]  [<ffffffff8148ba99>] next_device+0xe/0x1e
[   61.517867]  [<ffffffff8148c0cc>] subsys_find_device_by_id+0xb7/0xd6
[   61.518197]  [<ffffffff81498846>] find_memory_block_hinted+0x3d/0x66
[   61.537927]  [<ffffffff8149887f>] find_memory_block+0x10/0x12
[   61.538193]  [<ffffffff814988b6>] add_memory_section+0x35/0x9e
[   61.557932]  [<ffffffff827fecef>] memory_dev_init+0x68/0xda
[   61.558227]  [<ffffffff827fec01>] driver_init+0x97/0xa7
[   61.577853]  [<ffffffff827cdf3c>] kernel_init+0xf6/0x1c0
[   61.578140]  [<ffffffff81cf34a4>] kernel_thread_helper+0x4/0x10
[   61.597850]  [<ffffffff81ceb59d>] ? retint_restore_args+0xe/0xe
[   61.598144]  [<ffffffff827cde46>] ? start_kernel+0x3ab/0x3ab
[   61.617826]  [<ffffffff81cf34a0>] ? gs_change+0xb/0xb
[   61.618060] Code: 10 48 83 3b 00 eb e8 4c 89 f2 44 89 fe 4c 89 ef e8 e1 fe ff ff 65 48 8b 04 25 40 bc 00 00 c7 80 cc 06 00 00 00 00 00 00 41 54 9d <5e> 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 48 89 e5 41 57 41 89 cf 
[   89.285380] memory_dev_init done

Finally it takes about 55s to create 16400 memory entries.

Root cause: for x86_64, 2048g (with 2g hole at [2g,4g), and TOP2 will be 2050g), will have 16400 memory block.

find_memory_block/subsys_find_device_by_id will be expensive with that many entries.

Actually, we don't need to find that memory block for BOOT path.

Skip that finding make it get back to normal.

[   34.466696] cpu_dev_init done
[   35.290080] memory_dev_init done

-v2: check the sections_per_block, and update cc list
-v3: Reuse memory_block from previous loop when sections_per_block is not 1.
	try to change block size to 256M manually.  It still works without delay.
	Also solved the delay with topology_init when sections_per_block is not 1.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>

---
 drivers/base/memory.c |   31 ++++++++++++++++++++++++++-----
 drivers/base/node.c   |    8 ++++++++
 2 files changed, 34 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/base/memory.c
===================================================================
--- linux-2.6.orig/drivers/base/memory.c
+++ linux-2.6/drivers/base/memory.c
@@ -572,19 +572,36 @@ static int init_memory_block(struct memo
 }
 
 static int add_memory_section(int nid, struct mem_section *section,
+			struct memory_block **mem_p,
 			unsigned long state, enum mem_add_context context)
 {
-	struct memory_block *mem;
+	struct memory_block *mem = NULL;
+	int scn_nr = __section_nr(section);
 	int ret = 0;
 
 	mutex_lock(&mem_sysfs_mutex);
 
-	mem = find_memory_block(section);
+	if (context == BOOT) {
+		/* same memory block ? */
+		if (mem_p && *mem_p)
+			if (scn_nr >= (*mem_p)->start_section_nr &&
+			    scn_nr <= (*mem_p)->end_section_nr) {
+				mem = *mem_p;
+				kobject_get(&mem->dev.kobj);
+			}
+	} else
+		mem = find_memory_block(section);
+
 	if (mem) {
 		mem->section_count++;
 		kobject_put(&mem->dev.kobj);
-	} else
+	} else {
 		ret = init_memory_block(&mem, section, state);
+		/* store memory_block pointer for next loop */
+		if (!ret && context == BOOT)
+			if (mem_p)
+				*mem_p = mem;
+	}
 
 	if (!ret) {
 		if (context == HOTPLUG &&
@@ -627,7 +644,7 @@ int remove_memory_block(unsigned long no
  */
 int register_new_memory(int nid, struct mem_section *section)
 {
-	return add_memory_section(nid, section, MEM_OFFLINE, HOTPLUG);
+	return add_memory_section(nid, section, NULL, MEM_OFFLINE, HOTPLUG);
 }
 
 int unregister_memory_section(struct mem_section *section)
@@ -647,6 +664,7 @@ int __init memory_dev_init(void)
 	int ret;
 	int err;
 	unsigned long block_sz;
+	struct memory_block *mem = NULL;
 
 	ret = subsys_system_register(&memory_subsys, NULL);
 	if (ret)
@@ -662,7 +680,10 @@ int __init memory_dev_init(void)
 	for (i = 0; i < NR_MEM_SECTIONS; i++) {
 		if (!present_section_nr(i))
 			continue;
-		err = add_memory_section(0, __nr_to_section(i), MEM_ONLINE,
+		/* don't need to reuse memory_block if only one per block */
+		err = add_memory_section(0, __nr_to_section(i),
+				 (sections_per_block == 1) ? NULL : &mem,
+					 MEM_ONLINE,
 					 BOOT);
 		if (!ret)
 			ret = err;
Index: linux-2.6/drivers/base/node.c
===================================================================
--- linux-2.6.orig/drivers/base/node.c
+++ linux-2.6/drivers/base/node.c
@@ -456,7 +456,15 @@ static int link_mem_sections(int nid)
 		if (!present_section_nr(section_nr))
 			continue;
 		mem_sect = __nr_to_section(section_nr);
+
+		/* same memblock ? */
+		if (mem_blk)
+			if ((section_nr >= mem_blk->start_section_nr) &&
+			    (section_nr <= mem_blk->end_section_nr))
+				continue;
+
 		mem_blk = find_memory_block_hinted(mem_sect, mem_blk);
+
 		ret = register_mem_sect_under_node(mem_blk, nid);
 		if (!err)
 			err = ret;
