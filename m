Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2ALXXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:23:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab2ALXX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:23:26 -0500
Date: Fri, 13 Jan 2012 01:25:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCHv3 2/2] kvm: set affinity hint for assigned device msi
Message-ID: <7071fb46f28fc06c7a95018236385bcbe46e74bd.1326410555.git.mst@redhat.com>
References: <cover.1326410553.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1326410553.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To forward an interrupt to a vcpu that runs on
a host cpu different from the current one,
we need an ipi which likely will cost us as much
as delivering the interrupt directly to that cpu would.

Set irq affinity hint to point there, irq balancer
can then take this into accound and balance
interrupts accordingly.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 virt/kvm/assigned-dev.c |    6 +++++-
 virt/kvm/irq_comm.c     |   25 +++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 950a25f..cc4bb7a 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -146,9 +146,12 @@ static void deassign_host_irq(struct kvm *kvm,
 		for (i = 0; i < assigned_dev->entries_nr; i++)
 			disable_irq(assigned_dev->host_msix_entries[i].vector);
 
-		for (i = 0; i < assigned_dev->entries_nr; i++)
+		for (i = 0; i < assigned_dev->entries_nr; i++) {
+			u32 vector = assigned_dev->host_msix_entries[i].vector;
+			irq_set_affinity_hint(vector, NULL);
 			free_irq(assigned_dev->host_msix_entries[i].vector,
 				 assigned_dev);
+		}
 
 		assigned_dev->entries_nr = 0;
 		kfree(assigned_dev->host_msix_entries);
@@ -158,6 +161,7 @@ static void deassign_host_irq(struct kvm *kvm,
 		/* Deal with MSI and INTx */
 		disable_irq(assigned_dev->host_irq);
 
+		irq_set_affinity_hint(assigned_dev->host_irq, NULL);
 		free_irq(assigned_dev->host_irq, assigned_dev);
 
 		if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSI)
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index ac8b629..ba892df 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -22,6 +22,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
+#include <linux/interrupt.h>
 #include <trace/events/kvm.h>
 
 #include <asm/msidef.h>
@@ -80,11 +81,23 @@ inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
 #endif
 }
 
+static void kvm_vcpu_host_irq_hint(struct kvm_vcpu *vcpu, int host_irq)
+{
+	const struct cpumask *mask;
+	/* raw_smp_processor_id() is ok here: if we get preempted we can get a
+	 * wrong value but we don't mind much. */
+	if (host_irq >= 0 && unlikely(vcpu->cpu != raw_smp_processor_id())) {
+		mask = get_cpu_mask(vcpu->cpu);
+		irq_set_affinity_hint(host_irq, mask);
+	}
+}
+
 int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		struct kvm_lapic_irq *irq, int host_irq)
 {
 	int i, r = -1;
-	struct kvm_vcpu *vcpu, *lowest = NULL;
+	int matches = 0;
+	struct kvm_vcpu *vcpu, *lowest = NULL, *uninitialized_var(match);
 
 	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
 			kvm_is_dm_lowest_prio(irq))
@@ -98,10 +111,13 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 					irq->dest_id, irq->dest_mode))
 			continue;
 
+		++matches;
+
 		if (!kvm_is_dm_lowest_prio(irq)) {
 			if (r < 0)
 				r = 0;
 			r += kvm_apic_set_irq(vcpu, irq);
+			match = vcpu;
 		} else if (kvm_lapic_enabled(vcpu)) {
 			if (!lowest)
 				lowest = vcpu;
@@ -110,8 +126,13 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		}
 	}
 
-	if (lowest)
+	if (lowest) {
 		r = kvm_apic_set_irq(lowest, irq);
+		match = lowest;
+	}
+
+	if (matches == 1)
+		kvm_vcpu_host_irq_hint(match, host_irq);
 
 	return r;
 }
-- 
1.7.8.2.325.g247f9
