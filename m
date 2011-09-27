Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab1I0G7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:59:24 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:39008 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1I0G7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:59:23 -0400
Date: Tue, 27 Sep 2011 16:59:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the akpm tree with the  tree
Message-Id: <20110927165920.14b00e8595d10135d2a4397a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Today's linux-next merge of the scsi-post-merge tree got conflicts in
arch/x86/kernel/apic/apic.c, arch/x86/kernel/cpu/mcheck/therm_throt.c,
arch/x86/kernel/cpu/mcheck/threshold.c and arch/x86/kernel/irq.c between
commit ef14aea88fee ("x86: Call idle notifier after irq_enter()") from
the rcu tree and commit 6a541324a31f ("The current interrupt traces from
irq_handler_entry and irq_handler_exit") from the akpm tree.

Just context changes. I fixed them up (see below) and can carry the fixes
as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/apic/apic.c
index 4af04d4,0fe559f..0000000
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@@ -857,9 -858,11 +858,11 @@@ void __irq_entry smp_apic_timer_interru
  	 * Besides, if we don't timer interrupts ignore the global
  	 * interrupt lock, which is the WrongThing (tm) to do.
  	 */
 -	exit_idle();
  	irq_enter();
 +	exit_idle();
+ 	trace_irq_vector_entry(LOCAL_TIMER_VECTOR);
  	local_apic_timer_interrupt();
+ 	trace_irq_vector_exit(LOCAL_TIMER_VECTOR);
  	irq_exit();
  
  	set_irq_regs(old_regs);
@@@ -1790,8 -1794,9 +1793,9 @@@ void smp_spurious_interrupt(struct pt_r
  {
  	u32 v;
  
 -	exit_idle();
  	irq_enter();
 +	exit_idle();
+ 	trace_irq_vector_entry(SPURIOUS_APIC_VECTOR);
  	/*
  	 * Check if this really is a spurious interrupt and ACK it
  	 * if it is a vectored one.  Just in case...
@@@ -1827,8 -1833,9 +1832,9 @@@ void smp_error_interrupt(struct pt_reg
  		"Illegal register address",	/* APIC Error Bit 7 */
  	};
  
 -	exit_idle();
  	irq_enter();
 +	exit_idle();
+ 	trace_irq_vector_entry(ERROR_APIC_VECTOR);
  	/* First tickle the hardware, only then report what went on. -- REW */
  	v0 = apic_read(APIC_ESR);
  	apic_write(APIC_ESR, 0);
diff --cc arch/x86/kernel/cpu/mcheck/therm_throt.c
index ce21561,6b7edb5..0000000
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@@ -397,10 -398,12 +398,12 @@@ static void (*smp_thermal_vector)(void
  
  asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
  {
 -	exit_idle();
  	irq_enter();
 +	exit_idle();
+ 	trace_irq_vector_entry(THERMAL_APIC_VECTOR);
  	inc_irq_stat(irq_thermal_count);
  	smp_thermal_vector();
+ 	trace_irq_vector_exit(THERMAL_APIC_VECTOR);
  	irq_exit();
  	/* Ack only at the end to avoid potential reentry */
  	ack_APIC_irq();
diff --cc arch/x86/kernel/cpu/mcheck/threshold.c
index aa578ca,ffde17b..0000000
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@@ -19,10 -20,12 +20,12 @@@ void (*mce_threshold_vector)(void) = de
  
  asmlinkage void smp_threshold_interrupt(void)
  {
 -	exit_idle();
  	irq_enter();
 +	exit_idle();
+ 	trace_irq_vector_entry(THRESHOLD_APIC_VECTOR);
  	inc_irq_stat(irq_threshold_count);
  	mce_threshold_vector();
+ 	trace_irq_vector_exit(THRESHOLD_APIC_VECTOR);
  	irq_exit();
  	/* Ack only at the end to avoid potential reentry */
  	ack_APIC_irq();
diff --cc arch/x86/kernel/irq.c
index 5d31e5b,64aad37..0000000
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@@ -209,10 -212,10 +212,9 @@@ void smp_x86_platform_ipi(struct pt_reg
  
  	ack_APIC_irq();
  
 -	exit_idle();
 -
  	irq_enter();
- 
 +	exit_idle();
- 
+ 	trace_irq_vector_entry(X86_PLATFORM_IPI_VECTOR);
  	inc_irq_stat(x86_platform_ipis);
  
  	if (x86_platform_ipi_callback)
