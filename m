Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2GCGg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:36:56 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:32929 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab2GCGgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:36:54 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Shuah Khan <shuahkhan@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Bryan Wu <bryan.wu@canonical.com>, Feng Tang <feng.tang@intel.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] leds: heartbeat: fix bug on panic
Date: Tue,  3 Jul 2012 08:35:47 +0200
Message-Id: <1341297347-19336-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <20120612162629.15519f39@feng-i7>
References: <20120612162629.15519f39@feng-i7>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With commit 49dca5aebfdeadd4bf27b6cb4c60392147dc35a4 I introduced
a bug (visible if CONFIG_PROVE_RCU is enabled) which occures when a panic
has happened:

[ 1526.520230] ===============================
[ 1526.520230] [ INFO: suspicious RCU usage. ]
[ 1526.520230] 3.5.0-rc1+ #12 Not tainted
[ 1526.520230] -------------------------------
[ 1526.520230] /c/kernel-tests/mm/include/linux/rcupdate.h:436 Illegal context switch in RCU read-side critical section!
[ 1526.520230]
[ 1526.520230] other info that might help us debug this:
[ 1526.520230]
[ 1526.520230]
[ 1526.520230] rcu_scheduler_active = 1, debug_locks = 0
[ 1526.520230] 3 locks held by net.agent/3279:
[ 1526.520230]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff82f85962>] do_page_fault+0x193/0x390
[ 1526.520230]  #1:  (panic_lock){+.+...}, at: [<ffffffff82ed2830>] panic+0x37/0x1d3
[ 1526.520230]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff810b9b28>] rcu_lock_acquire+0x0/0x29
[ 1526.520230]
[ 1526.520230] stack backtrace:
[ 1526.520230] Pid: 3279, comm: net.agent Not tainted 3.5.0-rc1+ #12
[ 1526.520230] Call Trace:
[ 1526.520230]  [<ffffffff810e1570>] lockdep_rcu_suspicious+0x109/0x112
[ 1526.520230]  [<ffffffff810bfe3a>] rcu_preempt_sleep_check+0x45/0x47
[ 1526.520230]  [<ffffffff810bfe5a>] __might_sleep+0x1e/0x19a
[ 1526.520230]  [<ffffffff82f8010e>] down_write+0x26/0x81
[ 1526.520230]  [<ffffffff8276a966>] led_trigger_unregister+0x1f/0x9c
[ 1526.520230]  [<ffffffff8276def5>] heartbeat_reboot_notifier+0x15/0x19
[ 1526.520230]  [<ffffffff82f85bf5>] notifier_call_chain+0x96/0xcd
[ 1526.520230]  [<ffffffff82f85cba>] __atomic_notifier_call_chain+0x8e/0xff
[ 1526.520230]  [<ffffffff81094b7c>] ? kmsg_dump+0x37/0x1eb
[ 1526.520230]  [<ffffffff82f85d3f>] atomic_notifier_call_chain+0x14/0x16
[ 1526.520230]  [<ffffffff82ed28e1>] panic+0xe8/0x1d3
[ 1526.520230]  [<ffffffff811473e2>] out_of_memory+0x15d/0x1d3

So in case of a panic, now just turn of the LED. Other approaches like
scheduling a work to unregister the trigger aren't working because there
isn't much which still runs after a panic occured (except timers).

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/leds/ledtrig-heartbeat.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
index 41dc76d..a019fbb 100644
--- a/drivers/leds/ledtrig-heartbeat.c
+++ b/drivers/leds/ledtrig-heartbeat.c
@@ -21,6 +21,8 @@
 #include <linux/reboot.h>
 #include "leds.h"
 
+static int panic_heartbeats;
+
 struct heartbeat_trig_data {
 	unsigned int phase;
 	unsigned int period;
@@ -34,6 +36,11 @@ static void led_heartbeat_function(unsigned long data)
 	unsigned long brightness = LED_OFF;
 	unsigned long delay = 0;
 
+	if (unlikely(panic_heartbeats)) {
+		led_set_brightness(led_cdev, LED_OFF);
+		return;
+	}
+
 	/* acts like an actual heart beat -- ie thump-thump-pause... */
 	switch (heartbeat_data->phase) {
 	case 0:
@@ -111,12 +118,19 @@ static int heartbeat_reboot_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static int heartbeat_panic_notifier(struct notifier_block *nb,
+				     unsigned long code, void *unused)
+{
+	panic_heartbeats = 1;
+	return NOTIFY_DONE;
+}
+
 static struct notifier_block heartbeat_reboot_nb = {
 	.notifier_call = heartbeat_reboot_notifier,
 };
 
 static struct notifier_block heartbeat_panic_nb = {
-	.notifier_call = heartbeat_reboot_notifier,
+	.notifier_call = heartbeat_panic_notifier,
 };
 
 static int __init heartbeat_trig_init(void)
-- 
1.7.6.5

