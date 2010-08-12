Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145Ab0HLNmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:42:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab0HLNmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:42:54 -0400
Date: Thu, 12 Aug 2010 09:42:53 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, akataria@vmware.com,
        sassmann@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100812134252.23717.50702.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: local_irq_save/restore when issuing IPI in early bootup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sending out an IPI interrupts are masked off.  In the cpu wakeup code, this
is not the case.  Make the code consistent.

Alok Kataria noticed the following hang:

1.  vcpu1 is doing wakeup_secondary_cpu_via_init() is booting all the other
processors.  It tries to bring each cpu up by sending an IPI which is done
by writing the APIC ICR.

The call path is wakeup_secondary_cpu_via_init() which calls apic_icr_write->
native_apic_icr_write().  native_apic_icr_write() writes APIC_ICR2 and APIC_ICR
in order to modify the ICRHI and ICRLO values.

The ICRHI is set to the number of online cpus.

The write to APIC_ICR does not happen because

2.  vcpu1's physical cpu *may* take a timer interrupt which does
lapic_timer_broadcast(), which calls send_IPI_mask().  send_IPI_mask()
calls default_send_IPI_mask_sequence_phys() which changes the ICRHI value to
the number of online vcpus -- which is one less than what it was set to in
step 1.

3.  return to thread in step 1 ... ICRHI is different and one less
than the previous value.  This results in the IPI being sent TWICE to the
same vcpu (CPU X-1) instead of once to CPU X-1 and once to CPU X.

It may be that native_apic_icr_write() actually needs it's own irq save/restore,
however, I cannot see a code path that requires it.  A larger irq save/restore
seems more appropriate around the IPI code which seems adequate given that
other code does the same thing (see calls to __default_send_IPI_dest_field() )
and is not broken.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5162095..39f871c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -556,6 +556,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
 	int maxlvt, num_starts, j;
+	unsigned long flags;
 
 	maxlvt = lapic_get_maxlvt();
 
@@ -576,6 +577,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	/*
 	 * Send IPI
 	 */
+	local_irq_save(flags);
 	apic_icr_write(APIC_INT_LEVELTRIG | APIC_INT_ASSERT | APIC_DM_INIT,
 		       phys_apicid);
 
@@ -592,6 +594,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
+	local_irq_restore(flags);
 
 	mb();
 	atomic_set(&init_deasserted, 1);
@@ -633,6 +636,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 		/* Target chip */
 		/* Boot on the stack */
 		/* Kick the second */
+		local_irq_save(flags);
 		apic_icr_write(APIC_DM_STARTUP | (start_eip >> 12),
 			       phys_apicid);
 
@@ -645,6 +649,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 
 		pr_debug("Waiting for send to finish...\n");
 		send_status = safe_apic_wait_icr_idle();
+		local_irq_restore(flags);
 
 		/*
 		 * Give the other CPU some time to accept the IPI.
