Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2ILXgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:36:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59246 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601Ab2ILXgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:36:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Milton Miller <miltonm@bga.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 082/108] powerpc: Make sure IPI handlers see data written by IPI senders
Date: Wed, 12 Sep 2012 16:29:20 -0700
Message-Id: <20120912232459.104672205@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit 9fb1b36ca1234e64a5d1cc573175303395e3354d upstream.

We have been observing hangs, both of KVM guest vcpu tasks and more
generally, where a process that is woken doesn't properly wake up and
continue to run, but instead sticks in TASK_WAKING state.  This
happens because the update of rq->wake_list in ttwu_queue_remote()
is not ordered with the update of ipi_message in
smp_muxed_ipi_message_pass(), and the reading of rq->wake_list in
scheduler_ipi() is not ordered with the reading of ipi_message in
smp_ipi_demux().  Thus it is possible for the IPI receiver not to see
the updated rq->wake_list and therefore conclude that there is nothing
for it to do.

In order to make sure that anything done before smp_send_reschedule()
is ordered before anything done in the resulting call to scheduler_ipi(),
this adds barriers in smp_muxed_message_pass() and smp_ipi_demux().
The barrier in smp_muxed_message_pass() is a full barrier to ensure that
there is a full ordering between the smp_send_reschedule() caller and
scheduler_ipi().  In smp_ipi_demux(), we use xchg() rather than
xchg_local() because xchg() includes release and acquire barriers.
Using xchg() rather than xchg_local() makes sense given that
ipi_message is not just accessed locally.

This moves the barrier between setting the message and calling the
cause_ipi() function into the individual cause_ipi implementations.
Most of them -- those that used outb, out_8 or similar -- already had
a full barrier because out_8 etc. include a sync before the MMIO
store.  This adds an explicit barrier in the two remaining cases.

These changes made no measurable difference to the speed of IPIs as
measured using a simple ping-pong latency test across two CPUs on
different cores of a POWER7 machine.

The analysis of the reason why processes were not waking up properly
is due to Milton Miller.

Reported-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/dbell.c       |    2 ++
 arch/powerpc/kernel/smp.c         |   11 +++++++++--
 arch/powerpc/sysdev/xics/icp-hv.c |    6 +++++-
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/dbell.c
+++ b/arch/powerpc/kernel/dbell.c
@@ -28,6 +28,8 @@ void doorbell_setup_this_cpu(void)
 
 void doorbell_cause_ipi(int cpu, unsigned long data)
 {
+	/* Order previous accesses vs. msgsnd, which is treated as a store */
+	mb();
 	ppc_msgsnd(PPC_DBELL, 0, data);
 }
 
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -197,8 +197,15 @@ void smp_muxed_ipi_message_pass(int cpu,
 	struct cpu_messages *info = &per_cpu(ipi_message, cpu);
 	char *message = (char *)&info->messages;
 
+	/*
+	 * Order previous accesses before accesses in the IPI handler.
+	 */
+	smp_mb();
 	message[msg] = 1;
-	mb();
+	/*
+	 * cause_ipi functions are required to include a full barrier
+	 * before doing whatever causes the IPI.
+	 */
 	smp_ops->cause_ipi(cpu, info->data);
 }
 
@@ -210,7 +217,7 @@ irqreturn_t smp_ipi_demux(void)
 	mb();	/* order any irq clear */
 
 	do {
-		all = xchg_local(&info->messages, 0);
+		all = xchg(&info->messages, 0);
 
 #ifdef __BIG_ENDIAN
 		if (all & (1 << (24 - 8 * PPC_MSG_CALL_FUNCTION)))
--- a/arch/powerpc/sysdev/xics/icp-hv.c
+++ b/arch/powerpc/sysdev/xics/icp-hv.c
@@ -65,7 +65,11 @@ static inline void icp_hv_set_xirr(unsig
 static inline void icp_hv_set_qirr(int n_cpu , u8 value)
 {
 	int hw_cpu = get_hard_smp_processor_id(n_cpu);
-	long rc = plpar_hcall_norets(H_IPI, hw_cpu, value);
+	long rc;
+
+	/* Make sure all previous accesses are ordered before IPI sending */
+	mb();
+	rc = plpar_hcall_norets(H_IPI, hw_cpu, value);
 	if (rc != H_SUCCESS) {
 		pr_err("%s: bad return code qirr cpu=%d hw_cpu=%d mfrr=0x%x "
 			"returned %ld\n", __func__, n_cpu, hw_cpu, value, rc);


