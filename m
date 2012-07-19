Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab2GSLMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 07:12:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab2GSLMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 07:12:38 -0400
Date: Thu, 19 Jul 2012 14:13:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, gleb@redhat.com
Subject: [PATCH] kvm: drop parameter validation
Message-ID: <20120719111313.GA4361@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We validate irq pin number when routing is setup, so
code handling illegal irq # in pic and ioapic on each injection
is never called.
Drop it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Note: this is on top of
	[PATCHv2] kvm: fix race with level interrupts
as these patches touch the same code.

 arch/x86/kvm/i8259.c | 16 +++++++---------
 virt/kvm/ioapic.c    | 35 +++++++++++++++++------------------
 2 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 1df8fb9..277ec0d 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -190,17 +190,15 @@ void kvm_pic_update_irq(struct kvm_pic *s)
 
 int kvm_pic_set_irq(struct kvm_pic *s, int irq, int irq_source_id, int level)
 {
-	int ret = -1;
+	int ret, irq_level;
 
 	pic_lock(s);
-	if (irq >= 0 && irq < PIC_NUM_PINS) {
-		int irq_level = __kvm_irq_line_state(&s->irq_states[irq],
-						     irq_source_id, level);
-		ret = pic_set_irq1(&s->pics[irq >> 3], irq & 7, irq_level);
-		pic_update_irq(s);
-		trace_kvm_pic_set_irq(irq >> 3, irq & 7, s->pics[irq >> 3].elcr,
-				      s->pics[irq >> 3].imr, ret == 0);
-	}
+	irq_level = __kvm_irq_line_state(&s->irq_states[irq],
+					 irq_source_id, level);
+	ret = pic_set_irq1(&s->pics[irq >> 3], irq & 7, irq_level);
+	pic_update_irq(s);
+	trace_kvm_pic_set_irq(irq >> 3, irq & 7, s->pics[irq >> 3].elcr,
+			      s->pics[irq >> 3].imr, ret == 0);
 	pic_unlock(s);
 
 	return ret;
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index ef61d52..4d824c7 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -197,28 +197,27 @@ int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
 	u32 old_irr;
 	u32 mask = 1 << irq;
 	union kvm_ioapic_redirect_entry entry;
-	int ret = 1;
+	int ret, irq_level;
 
 	spin_lock(&ioapic->lock);
 	old_irr = ioapic->irr;
-	if (irq >= 0 && irq < IOAPIC_NUM_PINS) {
-		int irq_level = __kvm_irq_line_state(&ioapic->irq_states[irq],
-						     irq_source_id, level);
-		entry = ioapic->redirtbl[irq];
-		irq_level ^= entry.fields.polarity;
-		if (!irq_level)
-			ioapic->irr &= ~mask;
-		else {
-			int edge = (entry.fields.trig_mode == IOAPIC_EDGE_TRIG);
-			ioapic->irr |= mask;
-			if ((edge && old_irr != ioapic->irr) ||
-			    (!edge && !entry.fields.remote_irr))
-				ret = ioapic_service(ioapic, irq);
-			else
-				ret = 0; /* report coalesced interrupt */
-		}
-		trace_kvm_ioapic_set_irq(entry.bits, irq, ret == 0);
+	irq_level = __kvm_irq_line_state(&ioapic->irq_states[irq],
+					 irq_source_id, level);
+	entry = ioapic->redirtbl[irq];
+	irq_level ^= entry.fields.polarity;
+	if (!irq_level) {
+		ioapic->irr &= ~mask;
+		ret = 1;
+	} else {
+		int edge = (entry.fields.trig_mode == IOAPIC_EDGE_TRIG);
+		ioapic->irr |= mask;
+		if ((edge && old_irr != ioapic->irr) ||
+		    (!edge && !entry.fields.remote_irr))
+			ret = ioapic_service(ioapic, irq);
+		else
+			ret = 0; /* report coalesced interrupt */
 	}
+	trace_kvm_ioapic_set_irq(entry.bits, irq, ret == 0);
 	spin_unlock(&ioapic->lock);
 
 	return ret;
-- 
MST
