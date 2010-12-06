Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0LFRQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:16:45 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:21412 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753644Ab0LFRQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:16:41 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: CK.KpDQVM1kPmgyR2OR_HwYabG3Bns3DVMxydvNvI0QbAeH
 wZd93HjJ8nTRSG981WaqGFhf3iYDuaqDNI_WKeRuZbx_sjW_IW9sls70VUpF
 1Oqwjyao_vVb6BkK7sm9mFf.dKR3ul6hLlfD.Ren3qtvzgMW1OMTxio5G9DJ
 Qoo8s64TJTDHcyWqH9aTZhFoAzSlMxbx7tSCmME4lJzXDgmHp3lT6kcnjs7c
 6FCnT2YHgWQOCHYzqlK0wnSOtW6k8qFrgFEHj9Jg5XdvoZE8kUpMm
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206171639.749599301@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:16:24 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, Neil Horman <nhorman@tuxdriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [Use cpuops V1 06/11] drivers: Replace __get_cpu_var with __this_cpu_read if not used for an address.
References: <20101206171618.302060721@linux.com>
Content-Disposition: inline; filename=cpuops_drivers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_cpu_var() can be replaced with this_cpu_read and will then use a single
read instruction with implied address calculation to access the correct per cpu
instance.

However, the address of a per cpu variable passed to __this_cpu_read() cannot be
determed (since its an implied address conversion through segment prefixes).
Therefore apply this only to uses of __get_cpu_var where the addres of the
variable is not used.

V3->V4:
	- Move one instance of this_cpu_inc_return to a later patch
	  so that this one can go in without percpu infrastructrure
	  changes.

Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 drivers/acpi/processor_idle.c     |    6 +++---
 drivers/cpuidle/cpuidle.c         |    2 +-
 drivers/s390/cio/cio.c            |    2 +-
 drivers/staging/speakup/fakekey.c |    4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_idle.c	2010-12-03 14:48:28.000000000 -0600
+++ linux-2.6/drivers/acpi/processor_idle.c	2010-12-06 10:26:16.000000000 -0600
@@ -746,7 +746,7 @@ static int acpi_idle_enter_c1(struct cpu
 	struct acpi_processor *pr;
 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
 
-	pr = __get_cpu_var(processors);
+	pr = __this_cpu_read(processors);
 
 	if (unlikely(!pr))
 		return 0;
@@ -787,7 +787,7 @@ static int acpi_idle_enter_simple(struct
 	s64 idle_time_ns;
 	s64 idle_time;
 
-	pr = __get_cpu_var(processors);
+	pr = __this_cpu_read(processors);
 
 	if (unlikely(!pr))
 		return 0;
@@ -864,7 +864,7 @@ static int acpi_idle_enter_bm(struct cpu
 	s64 idle_time;
 
 
-	pr = __get_cpu_var(processors);
+	pr = __this_cpu_read(processors);
 
 	if (unlikely(!pr))
 		return 0;
Index: linux-2.6/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6.orig/drivers/cpuidle/cpuidle.c	2010-12-03 14:48:28.000000000 -0600
+++ linux-2.6/drivers/cpuidle/cpuidle.c	2010-12-06 10:26:16.000000000 -0600
@@ -49,7 +49,7 @@ static int __cpuidle_register_device(str
  */
 static void cpuidle_idle_call(void)
 {
-	struct cpuidle_device *dev = __get_cpu_var(cpuidle_devices);
+	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_state *target_state;
 	int next_state;
 
Index: linux-2.6/drivers/s390/cio/cio.c
===================================================================
--- linux-2.6.orig/drivers/s390/cio/cio.c	2010-12-03 14:48:28.000000000 -0600
+++ linux-2.6/drivers/s390/cio/cio.c	2010-12-06 10:26:16.000000000 -0600
@@ -619,7 +619,7 @@ void __irq_entry do_IRQ(struct pt_regs *
 	s390_idle_check(regs, S390_lowcore.int_clock,
 			S390_lowcore.async_enter_timer);
 	irq_enter();
-	__get_cpu_var(s390_idle).nohz_delay = 1;
+	__this_cpu_write(s390_idle.nohz_delay, 1);
 	if (S390_lowcore.int_clock >= S390_lowcore.clock_comparator)
 		/* Serve timer interrupts first. */
 		clock_comparator_work();
Index: linux-2.6/drivers/staging/speakup/fakekey.c
===================================================================
--- linux-2.6.orig/drivers/staging/speakup/fakekey.c	2010-12-03 14:48:28.000000000 -0600
+++ linux-2.6/drivers/staging/speakup/fakekey.c	2010-12-06 10:26:16.000000000 -0600
@@ -78,10 +78,10 @@ void speakup_fake_down_arrow(void)
 	/* don't change CPU */
 	preempt_disable();
 
-	__get_cpu_var(reporting_keystroke) = true;
+	__this_cpu_write(reporting_keystroke), true);
 	input_report_key(virt_keyboard, KEY_DOWN, PRESSED);
 	input_report_key(virt_keyboard, KEY_DOWN, RELEASED);
-	__get_cpu_var(reporting_keystroke) = false;
+	__this_cpu_write(reporting_keystroke, false);
 
 	/* reenable preemption */
 	preempt_enable();

