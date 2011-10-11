Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab1JKShi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:37:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab1JKShf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:37:35 -0400
Date: Tue, 11 Oct 2011 20:38:28 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 2/2] kvm: set affinity hint for assigned device msi
Message-ID: <7458f62a58ad7d4022eefba4333336ba268e4ef9.1318358229.git.mst@redhat.com>
References: <cover.1318358229.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1318358229.git.mst@redhat.com>
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
 virt/kvm/assigned-dev.c |    8 +++++---
 virt/kvm/irq_comm.c     |   17 ++++++++++++++++-
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index f89f138..b579777 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -142,9 +142,11 @@ static void deassign_host_irq(struct kvm *kvm,
 		for (i = 0; i < assigned_dev->entries_nr; i++)
 			disable_irq(assigned_dev->host_msix_entries[i].vector);
 
-		for (i = 0; i < assigned_dev->entries_nr; i++)
-			free_irq(assigned_dev->host_msix_entries[i].vector,
-				 (void *)assigned_dev);
+		for (i = 0; i < assigned_dev->entries_nr; i++) {
+			u32 vector = assigned_dev->host_msix_entries[i].vector;
+			irq_set_affinity_hint(vector, NULL);
+			free_irq(vector, (void *)assigned_dev);
+		}
 
 		assigned_dev->entries_nr = 0;
 		kfree(assigned_dev->host_msix_entries);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index ac8b629..68b1f7c 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -22,6 +22,7 @@
 
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
+#include <linux/interrupt.h>
 #include <trace/events/kvm.h>
 
 #include <asm/msidef.h>
@@ -80,6 +81,17 @@ inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
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
@@ -102,6 +114,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 			if (r < 0)
 				r = 0;
 			r += kvm_apic_set_irq(vcpu, irq);
+			kvm_vcpu_host_irq_hint(vcpu, host_irq);
 		} else if (kvm_lapic_enabled(vcpu)) {
 			if (!lowest)
 				lowest = vcpu;
@@ -110,8 +123,10 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 		}
 	}
 
-	if (lowest)
+	if (lowest) {
 		r = kvm_apic_set_irq(lowest, irq);
+		kvm_vcpu_host_irq_hint(vcpu, host_irq);
+	}
 
 	return r;
 }
-- 
1.7.5.53.gc233e
