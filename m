Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0LCXif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:38:35 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:47648 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab0LCXhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:37:38 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 3/5] KVM: Split up MSI-X assigned device IRQ handler
Date: Sat,  4 Dec 2010 00:37:29 +0100
Message-Id: <95b54819f55643f8388a71ef5285361e199c8a6d.1291419444.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1291419444.git.jan.kiszka@web.de>
References: <cover.1291419444.git.jan.kiszka@web.de>
In-Reply-To: <cover.1291419444.git.jan.kiszka@web.de>
References: <cover.1291419444.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX19jpqGCTBe1ByPXdo/iD+q0f4CuUzGWG3JJhhNT
	AMw7a2inP69TtsYTKifvHo2LRCVdid+JFFUUe1fJ1i/PJT2QLB
	TQ6hCShsw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

The threaded IRQ handler for MSI-X has almost nothing in common with the
INTx/MSI handler. Move its code into a dedicated handler.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 virt/kvm/assigned-dev.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index ae72ae6..3f8a745 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -58,8 +58,6 @@ static int find_index_from_host_irq(struct kvm_assigned_dev_kernel
 static irqreturn_t kvm_assigned_dev_thread(int irq, void *dev_id)
 {
 	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
-	u32 vector;
-	int index;
 
 	if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_INTX) {
 		spin_lock(&assigned_dev->intx_lock);
@@ -68,20 +66,28 @@ static irqreturn_t kvm_assigned_dev_thread(int irq, void *dev_id)
 		spin_unlock(&assigned_dev->intx_lock);
 	}
 
-	if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSIX) {
-		index = find_index_from_host_irq(assigned_dev, irq);
-		if (index >= 0) {
-			vector = assigned_dev->
-					guest_msix_entries[index].vector;
-			kvm_set_irq(assigned_dev->kvm,
-				    assigned_dev->irq_source_id, vector, 1);
-		}
-	} else
+	kvm_set_irq(assigned_dev->kvm, assigned_dev->irq_source_id,
+		    assigned_dev->guest_irq, 1);
+
+	return IRQ_HANDLED;
+}
+
+#ifdef __KVM_HAVE_MSIX
+static irqreturn_t kvm_assigned_dev_thread_msix(int irq, void *dev_id)
+{
+	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
+	int index = find_index_from_host_irq(assigned_dev, irq);
+	u32 vector;
+
+	if (index >= 0) {
+		vector = assigned_dev->guest_msix_entries[index].vector;
 		kvm_set_irq(assigned_dev->kvm, assigned_dev->irq_source_id,
-			    assigned_dev->guest_irq, 1);
+			    vector, 1);
+	}
 
 	return IRQ_HANDLED;
 }
+#endif
 
 /* Ack the irq line for an assigned device */
 static void kvm_assigned_dev_ack_irq(struct kvm_irq_ack_notifier *kian)
@@ -277,7 +283,7 @@ static int assigned_device_enable_host_msix(struct kvm *kvm,
 
 	for (i = 0; i < dev->entries_nr; i++) {
 		r = request_threaded_irq(dev->host_msix_entries[i].vector,
-					 NULL, kvm_assigned_dev_thread,
+					 NULL, kvm_assigned_dev_thread_msix,
 					 0, dev->irq_name, (void *)dev);
 		if (r)
 			goto err;
-- 
1.7.1

