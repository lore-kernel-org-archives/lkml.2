Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2KEOUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:20:35 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:53287 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab2KEOUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:20:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:date:message-id; q=dns; s=sasl; b=Kl9p/oPEUGFSADxh23eWR
	0GGj8bqGpcTeJ9ctZxvPcxv+X1aRSr+aHVImWbKiG8rfXpyibecHBvo4ytNm67YB
	W0AcitKj9nILjiI6FqfE23+avM5m+JbWQUj6i1s8EhR7duCeZvzD9RseKUV88AsN
	VcCCRSlY71qrHiinngJx8A=
From: Nathan Lynch <ntl@pobox.com>
To: linux-leds@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, miles.lane@gmail.com, cooloney@gmail.com
Subject: [PATCH] ledtrig-cpu: kill useless mutex to fix sleep in atomic
 context
Date: Mon,  5 Nov 2012 08:20:31 -0600
Message-Id: <1352125231-8388-1-git-send-email-ntl@pobox.com>
X-Mailer: git-send-email 1.7.11.7
X-Pobox-Relay-ID: F549B232-2753-11E2-A4FB-0E600E5B5709-04752483!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing the following every time the CPU enters or leaves idle on a
Beagleboard:

BUG: sleeping function called from invalid context at kernel/mutex.c:269
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
no locks held by swapper/0/0.
[<c001659c>] (unwind_backtrace+0x0/0xf8) from [<c05aaa7c>] (mutex_lock_nested+0x24/0x380)
[<c05aaa7c>] (mutex_lock_nested+0x24/0x380) from [<c043bd1c>] (ledtrig_cpu+0x38/0x88)
[<c043bd1c>] (ledtrig_cpu+0x38/0x88) from [<c000f4b0>] (cpu_idle+0xf4/0x120)
[<c000f4b0>] (cpu_idle+0xf4/0x120) from [<c07e47c8>] (start_kernel+0x2bc/0x30c)

Miles Lane has reported seeing similar splats during system suspend.

The mutex in struct led_trigger_cpu appears to have no function: it
resides in a per-cpu data structure which never changes after the
trigger is registered.  So just remove it.

Reported-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Nathan Lynch <ntl@pobox.com>
---
 drivers/leds/ledtrig-cpu.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/leds/ledtrig-cpu.c b/drivers/leds/ledtrig-cpu.c
index b312056..4239b39 100644
--- a/drivers/leds/ledtrig-cpu.c
+++ b/drivers/leds/ledtrig-cpu.c
@@ -33,8 +33,6 @@
 struct led_trigger_cpu {
 	char name[MAX_NAME_LEN];
 	struct led_trigger *_trig;
-	struct mutex lock;
-	int lock_is_inited;
 };
 
 static DEFINE_PER_CPU(struct led_trigger_cpu, cpu_trig);
@@ -50,12 +48,6 @@ void ledtrig_cpu(enum cpu_led_event ledevt)
 {
 	struct led_trigger_cpu *trig = &__get_cpu_var(cpu_trig);
 
-	/* mutex lock should be initialized before calling mutex_call() */
-	if (!trig->lock_is_inited)
-		return;
-
-	mutex_lock(&trig->lock);
-
 	/* Locate the correct CPU LED */
 	switch (ledevt) {
 	case CPU_LED_IDLE_END:
@@ -75,8 +67,6 @@ void ledtrig_cpu(enum cpu_led_event ledevt)
 		/* Will leave the LED as it is */
 		break;
 	}
-
-	mutex_unlock(&trig->lock);
 }
 EXPORT_SYMBOL(ledtrig_cpu);
 
@@ -117,14 +107,9 @@ static int __init ledtrig_cpu_init(void)
 	for_each_possible_cpu(cpu) {
 		struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
 
-		mutex_init(&trig->lock);
-
 		snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);
 
-		mutex_lock(&trig->lock);
 		led_trigger_register_simple(trig->name, &trig->_trig);
-		trig->lock_is_inited = 1;
-		mutex_unlock(&trig->lock);
 	}
 
 	register_syscore_ops(&ledtrig_cpu_syscore_ops);
@@ -142,15 +127,9 @@ static void __exit ledtrig_cpu_exit(void)
 	for_each_possible_cpu(cpu) {
 		struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
 
-		mutex_lock(&trig->lock);
-
 		led_trigger_unregister_simple(trig->_trig);
 		trig->_trig = NULL;
 		memset(trig->name, 0, MAX_NAME_LEN);
-		trig->lock_is_inited = 0;
-
-		mutex_unlock(&trig->lock);
-		mutex_destroy(&trig->lock);
 	}
 
 	unregister_syscore_ops(&ledtrig_cpu_syscore_ops);
-- 
1.7.11.7

