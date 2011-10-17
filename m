Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1JQRDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:03:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1JQRDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:03:49 -0400
Date: Mon, 17 Oct 2011 19:04:40 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] kvm: set affinity hint for assigned device msi
Message-ID: <20111017170440.GA8894@redhat.com>
References: <cover.1318358229.git.mst@redhat.com>
 <7458f62a58ad7d4022eefba4333336ba268e4ef9.1318358229.git.mst@redhat.com>
 <20111013145450.GA4143@amt.cnet>
 <20111016131223.GB17978@redhat.com>
 <20111017105859.GA20914@amt.cnet>
 <20111017133215.GA6406@redhat.com>
 <20111017160741.GA25476@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017160741.GA25476@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 02:07:41PM -0200, Marcelo Tosatti wrote:
> > > Configurations to consider, all common ones used for assigned devices?
> > 
> > I mean, besides round robin, any other modes that
> > have an issue? Interrupts can also be multicast,
> > I think, but we probably don't care what happens
> > to affinity then, as msi interrupts are probably never
> > broadcast ...
> 
> There is also lowest priority, which can be used with MSI.


So the following will probably address that comment?

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
index ac8b629..dabf89f 100644
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
+	struct kvm_vcpu *vcpu, *lowest = NULL, *match;
 
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
