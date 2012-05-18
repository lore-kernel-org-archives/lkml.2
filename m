Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946090Ab2ERW2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:28:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030489Ab2ERW2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:28:10 -0400
Date: Fri, 18 May 2012 15:26:39 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 14/14] pstore/platform: Remove automatic updates
Message-ID: <20120518222639.GN23089@lizard>
References: <20120518222314.GA9425@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120518222314.GA9425@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having automatic updates seems pointless, and even dangerous
and thus counter-productive:

1. If we can mount pstore, or read files, we can as well read
   /proc/kmsg. So, there's little point in duplicating the
   functionality and present the same information but via another
   userland ABI;

2. Expecting the kernel to behave sanely after oops/panic is naive.
   It might work, but you'd rather not try it. Screwed up kernel
   can do rather bad things, like recursive faults[1]; and pstore
   rather provoking bad things to happen. It uses:

   1. Timers (assumes sane interrupts state);
   2. Workqueues and mutexes (assumes scheduler in a sane state);
   3. kzalloc (a working slab allocator);

   That's too much for a dead kernel, so the debugging facility
   itself might just make debugging harder, which is not what
   we want.

So, let's remove the automatic updates, this keeps things simple
and safe.

(Maybe for non-oops message types it would make sense to add
automatic updates, but so far I don't see any use case for this.
Even for tracing, it has its own run-time/normal ABI, so we're
only interested in pstore upon next boot, to retrieve what has
gone wrong with HW or SW.)

[1]
BUG: unable to handle kernel paging request at fffffffffffffff8
IP: [<ffffffff8104801b>] kthread_data+0xb/0x20
[...]
Process kworker/0:1 (pid: 14, threadinfo ffff8800072c0000, task ffff88000725b100)
[...
Call Trace:
 [<ffffffff81043710>] wq_worker_sleeping+0x10/0xa0
 [<ffffffff813687a8>] __schedule+0x568/0x7d0
 [<ffffffff8106c24d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81087e22>] ? call_rcu_sched+0x12/0x20
 [<ffffffff8102b596>] ? release_task+0x156/0x2d0
 [<ffffffff8102b45e>] ? release_task+0x1e/0x2d0
 [<ffffffff8106c24d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81368ac4>] schedule+0x24/0x70
 [<ffffffff8102cba8>] do_exit+0x1f8/0x370
 [<ffffffff810051e7>] oops_end+0x77/0xb0
 [<ffffffff8135c301>] no_context+0x1a6/0x1b5
 [<ffffffff8135c4de>] __bad_area_nosemaphore+0x1ce/0x1ed
 [<ffffffff81053156>] ? ttwu_queue+0xc6/0xe0
 [<ffffffff8135c50b>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff8101fa47>] do_page_fault+0x2c7/0x450
 [<ffffffff8106e34b>] ? __lock_release+0x6b/0xe0
 [<ffffffff8106bf21>] ? mark_held_locks+0x61/0x140
 [<ffffffff810502fe>] ? __wake_up+0x4e/0x70
 [<ffffffff81185f7d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81158970>] ? pstore_register+0x120/0x120
 [<ffffffff8136a37f>] page_fault+0x1f/0x30
 [<ffffffff81158970>] ? pstore_register+0x120/0x120
 [<ffffffff81185ab8>] ? memcpy+0x68/0x110
 [<ffffffff8115875a>] ? pstore_get_records+0x3a/0x130
 [<ffffffff811590f4>] ? persistent_ram_copy_old+0x64/0x90
 [<ffffffff81158bf4>] ramoops_pstore_read+0x84/0x130
 [<ffffffff81158799>] pstore_get_records+0x79/0x130
 [<ffffffff81042536>] ? process_one_work+0x116/0x450
 [<ffffffff81158970>] ? pstore_register+0x120/0x120
 [<ffffffff8115897e>] pstore_dowork+0xe/0x10
 [<ffffffff81042594>] process_one_work+0x174/0x450
 [<ffffffff81042536>] ? process_one_work+0x116/0x450
 [<ffffffff81042e13>] worker_thread+0x123/0x2d0
 [<ffffffff81042cf0>] ? manage_workers.isra.28+0x120/0x120
 [<ffffffff81047d8e>] kthread+0x8e/0xa0
 [<ffffffff8136ba74>] kernel_thread_helper+0x4/0x10
 [<ffffffff8136a199>] ? retint_restore_args+0xe/0xe
 [<ffffffff81047d00>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8136ba70>] ? gs_change+0xb/0xb
Code: be e2 00 00 00 48 c7 c7 d1 2a 4e 81 e8 bf fb fd ff 48 8b 5d f0 4c 8b 65 f8 c9 c3 0f 1f 44 00 00 48 8b 87 08 02 00 00 55 48 89 e5 <48> 8b 40 f8 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
RIP  [<ffffffff8104801b>] kthread_data+0xb/0x20
 RSP <ffff8800072c1888>
CR2: fffffffffffffff8
---[ end trace 996a332dc399111d ]---
Fixing recursive fault but reboot is needed!

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/platform.c |   37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index a3f6d96..3c7ac9b 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -27,30 +27,13 @@
 #include <linux/module.h>
 #include <linux/pstore.h>
 #include <linux/string.h>
-#include <linux/timer.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
-#include <linux/workqueue.h>
 
 #include "internal.h"
 
 /*
- * We defer making "oops" entries appear in pstore - see
- * whether the system is actually still running well enough
- * to let someone see the entry
- */
-#define	PSTORE_INTERVAL	(60 * HZ)
-
-static int pstore_new_entry;
-
-static void pstore_timefunc(unsigned long);
-static DEFINE_TIMER(pstore_timer, pstore_timefunc, 0, 0);
-
-static void pstore_dowork(struct work_struct *);
-static DECLARE_WORK(pstore_work, pstore_dowork);
-
-/*
  * pstore_lock just protects "psinfo" during
  * calls to pstore_register()
  */
@@ -140,8 +123,6 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 
 		ret = psinfo->write(PSTORE_TYPE_DMESG, reason, &id, part,
 				   hsize + l1_cpy + l2_cpy, psinfo);
-		if (ret == 0 && reason == KMSG_DUMP_OOPS && pstore_is_mounted())
-			pstore_new_entry = 1;
 		l1 -= l1_cpy;
 		l2 -= l2_cpy;
 		total += l1_cpy + l2_cpy;
@@ -227,9 +208,6 @@ int pstore_register(struct pstore_info *psi)
 	kmsg_dump_register(&pstore_dumper);
 	pstore_register_console();
 
-	pstore_timer.expires = jiffies + PSTORE_INTERVAL;
-	add_timer(&pstore_timer);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pstore_register);
@@ -275,20 +253,5 @@ out:
 		       failed, psi->name);
 }
 
-static void pstore_dowork(struct work_struct *work)
-{
-	pstore_get_records(1);
-}
-
-static void pstore_timefunc(unsigned long dummy)
-{
-	if (pstore_new_entry) {
-		pstore_new_entry = 0;
-		schedule_work(&pstore_work);
-	}
-
-	mod_timer(&pstore_timer, jiffies + PSTORE_INTERVAL);
-}
-
 module_param(backend, charp, 0444);
 MODULE_PARM_DESC(backend, "Pstore backend to use");
-- 
1.7.9.2
