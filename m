Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0K3TI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:08:56 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:45233 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756012Ab0K3TIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:51 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: SB7iFjkVM1kSWF5GTttfJHq4PAHWTokvqEyZcyjdXXO6ijN
 kYYTDAWgjWMO5RUzq0xG8wypoGjc2xpdwdcNH6lQAs77ek2HuTRf5B.xIupU
 JEroEo2X0ompWHIA4.69b2S3otqmFsE04u3.MEUqM4bml5h7n7IyWY6exCbJ
 enY2WJI0iyvnpP7D0JHQXInlWoq6LO003SmsE3oP.GdK5hJor7Fb.oJusa05
 oxYrDw6eGSB2OFFCShMNgANPj4ABoSPEXUJtOC3j2eq9VeFZkaGa9
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190848.707716729@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:20 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Neil Horman <nhorman@tuxdriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 13/18] drivers: Replace __get_cpu_var with __this_cpu_read if not used for an address.
References: <20101130190707.457099608@linux.com>
Content-Disposition: inline; filename=this_cpu_drivers
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

Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 drivers/acpi/processor_idle.c     |    6 +++---
 drivers/char/random.c             |    2 +-
 drivers/cpuidle/cpuidle.c         |    2 +-
 drivers/s390/cio/cio.c            |    2 +-
 drivers/staging/speakup/fakekey.c |    4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_idle.c	2010-11-30 12:40:22.000000000 -0600
+++ linux-2.6/drivers/acpi/processor_idle.c	2010-11-30 12:40:47.000000000 -0600
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
Index: linux-2.6/drivers/char/random.c
===================================================================
--- linux-2.6.orig/drivers/char/random.c	2010-11-30 12:40:22.000000000 -0600
+++ linux-2.6/drivers/char/random.c	2010-11-30 12:40:47.000000000 -0600
@@ -626,7 +626,7 @@ static void add_timer_randomness(struct
 	preempt_disable();
 	/* if over the trickle threshold, use only 1 in 4096 samples */
 	if (input_pool.entropy_count > trickle_thresh &&
-	    (__get_cpu_var(trickle_count)++ & 0xfff))
+	    (__this_cpu_inc_return(trickle_count) & 0xfff))
 		goto out;
 
 	sample.jiffies = jiffies;
Index: linux-2.6/drivers/cpuidle/cpuidle.c
===================================================================
--- linux-2.6.orig/drivers/cpuidle/cpuidle.c	2010-11-30 12:40:22.000000000 -0600
+++ linux-2.6/drivers/cpuidle/cpuidle.c	2010-11-30 12:40:47.000000000 -0600
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
--- linux-2.6.orig/drivers/s390/cio/cio.c	2010-11-30 12:40:22.000000000 -0600
+++ linux-2.6/drivers/s390/cio/cio.c	2010-11-30 12:40:47.000000000 -0600
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
--- linux-2.6.orig/drivers/staging/speakup/fakekey.c	2010-11-30 12:40:22.000000000 -0600
+++ linux-2.6/drivers/staging/speakup/fakekey.c	2010-11-30 12:40:47.000000000 -0600
@@ -79,10 +79,10 @@ void speakup_fake_down_arrow(void)
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

