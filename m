Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab2JRSTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:19:12 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46379 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292Ab2JRSTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:19:08 -0400
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 18 Oct 2012 11:18:46 -0700
Message-ID: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com>
Subject: [PATCH] ledtrig-cpu: use spin_lock to replace mutex lock
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>
Cc: akpm <akpm@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mutex lock is not safe in atomic context like the bug reported by
Miles Lane:

---
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
numa_remove_cpu cpu 1 node 0: mask now 0
Broke affinity for irq 46
smpboot: CPU 1 is now offline
BUG: sleeping function called from invalid context at kernel/mutex.c:269
in_atomic(): 0, irqs_disabled(): 1, pid: 3561, name: pm-suspend
4 locks held by pm-suspend/3561:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8113cab6>]
sysfs_write_file+0x37/0x121
 #1:  (s_active#98){.+.+.+}, at: [<ffffffff8113cb50>]
sysfs_write_file+0xd1/0x121
 #2:  (autosleep_lock){+.+.+.}, at: [<ffffffff810616c2>]
pm_autosleep_lock+0x12/0x14
 #3:  (pm_mutex){+.+.+.}, at: [<ffffffff8105c06c>] pm_suspend+0x38/0x1b8
irq event stamp: 103458
hardirqs last  enabled at (103457): [<ffffffff81460461>]
__mutex_unlock_slowpath+0x101/0x125
hardirqs last disabled at (103458): [<ffffffff8105be25>]
arch_suspend_disable_irqs+0xa/0xc
softirqs last  enabled at (103196): [<ffffffff8103445d>]
__do_softirq+0x12a/0x155
softirqs last disabled at (103171): [<ffffffff8146836c>] call_softirq+0x1c/0x30
Pid: 3561, comm: pm-suspend Not tainted 3.6.0+ #26
Call Trace:
 [<ffffffff8106b64e>] ? print_irqtrace_events+0x9d/0xa1
 [<ffffffff8104efcd>] __might_sleep+0x19f/0x1a8
 [<ffffffff81460345>] mutex_lock_nested+0x20/0x3b
 [<ffffffff81391cbb>] ledtrig_cpu+0x3b/0x7b
 [<ffffffff81391d29>] ledtrig_cpu_syscore_suspend+0xe/0x15
 [<ffffffff813329e9>] syscore_suspend+0x78/0xfd
 [<ffffffff8105bf42>] suspend_devices_and_enter+0x10f/0x201
 [<ffffffff8105c133>] pm_suspend+0xff/0x1b8
 [<ffffffff8105b4fa>] state_store+0x43/0x6c
 [<ffffffff811c5ba6>] kobj_attr_store+0xf/0x1b
 [<ffffffff8113cb68>] sysfs_write_file+0xe9/0x121
 [<ffffffff810e48a3>] vfs_write+0x9b/0xfd
 [<ffffffff8106bc63>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff810e4ac6>] sys_write+0x4d/0x7a
 [<ffffffff814672f4>] tracesys+0xdd/0xe2
---

This patch replace mutex lock with spin lock which is safe for this case.

Reported-by: Miles Lane <miles.lane@gmail.com>
Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bryan Wu <cooloney@gmail.com>
---
 drivers/leds/ledtrig-cpu.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/leds/ledtrig-cpu.c b/drivers/leds/ledtrig-cpu.c
index b312056..9e78018 100644
--- a/drivers/leds/ledtrig-cpu.c
+++ b/drivers/leds/ledtrig-cpu.c
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <linux/percpu.h>
 #include <linux/syscore_ops.h>
-#include <linux/rwsem.h>
+#include <linux/spinlock.h>
 #include "leds.h"

 #define MAX_NAME_LEN	8
@@ -33,7 +33,7 @@
 struct led_trigger_cpu {
 	char name[MAX_NAME_LEN];
 	struct led_trigger *_trig;
-	struct mutex lock;
+	spinlock_t lock;
 	int lock_is_inited;
 };

@@ -50,11 +50,11 @@ void ledtrig_cpu(enum cpu_led_event ledevt)
 {
 	struct led_trigger_cpu *trig = &__get_cpu_var(cpu_trig);

-	/* mutex lock should be initialized before calling mutex_call() */
+	/* spin lock should be initialized before calling spinlock calls */
 	if (!trig->lock_is_inited)
 		return;

-	mutex_lock(&trig->lock);
+	spin_lock(&trig->lock);

 	/* Locate the correct CPU LED */
 	switch (ledevt) {
@@ -76,7 +76,7 @@ void ledtrig_cpu(enum cpu_led_event ledevt)
 		break;
 	}

-	mutex_unlock(&trig->lock);
+	spin_unlock(&trig->lock);
 }
 EXPORT_SYMBOL(ledtrig_cpu);

@@ -117,14 +117,14 @@ static int __init ledtrig_cpu_init(void)
 	for_each_possible_cpu(cpu) {
 		struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);

-		mutex_init(&trig->lock);
+		spin_lock_init(&trig->lock);

 		snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);

-		mutex_lock(&trig->lock);
+		spin_lock(&trig->lock);
 		led_trigger_register_simple(trig->name, &trig->_trig);
 		trig->lock_is_inited = 1;
-		mutex_unlock(&trig->lock);
+		spin_unlock(&trig->lock);
 	}

 	register_syscore_ops(&ledtrig_cpu_syscore_ops);
@@ -142,15 +142,14 @@ static void __exit ledtrig_cpu_exit(void)
 	for_each_possible_cpu(cpu) {
 		struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);

-		mutex_lock(&trig->lock);
+		spin_lock(&trig->lock);

 		led_trigger_unregister_simple(trig->_trig);
 		trig->_trig = NULL;
 		memset(trig->name, 0, MAX_NAME_LEN);
 		trig->lock_is_inited = 0;

-		mutex_unlock(&trig->lock);
-		mutex_destroy(&trig->lock);
+		spin_unlock(&trig->lock);
 	}

 	unregister_syscore_ops(&ledtrig_cpu_syscore_ops);
-- 
1.7.9.5
