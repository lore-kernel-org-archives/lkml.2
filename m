Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2GPUea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 16:34:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab2GPUeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 16:34:13 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v5 4/4] kvm: Convert eoifd to use kvm_clear_irq
To: avi@redhat.com, mst@redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Mon, 16 Jul 2012 14:34:11 -0600
Message-ID: <20120716203409.1752.2837.stgit@bling.home>
In-Reply-To: <20120716202711.1752.71007.stgit@bling.home>
References: <20120716202711.1752.71007.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can drop any kind of serialization on the injection side as we
expect spurious injections to be both rare and safe.  On the EOI
side, this continues to filter out both the pic/ioapic work and
the eventfd signaling if our source ID has not set the interrupt.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 virt/kvm/eventfd.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 1f9412a..164b4c0 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -42,8 +42,6 @@
  */
 struct _irq_source {
 	int id; /* the IRQ source ID */
-	bool level_asserted; /* Track assertion state and protect with lock */
-	spinlock_t lock;     /* to avoid unnecessary re-assert/spurious eoi. */
 	struct kvm *kvm;
 	struct kref kref;
 };
@@ -89,7 +87,6 @@ static struct _irq_source *_irq_source_alloc(struct kvm *kvm)
 	}
 
 	kref_init(&source->kref);
-	spin_lock_init(&source->lock);
 	source->kvm = kvm;
 	source->id = id;
 
@@ -173,8 +170,6 @@ irqfd_inject_level(struct work_struct *work)
 	struct _irqfd *irqfd = container_of(work, struct _irqfd, inject);
 
 	/*
-	 * Inject an interrupt only if not already asserted.
-	 *
 	 * We can safely ignore the kvm_set_irq return value here.  If
 	 * masked, the irr bit is still set and will eventually be serviced.
 	 * This interface does not guarantee immediate injection.  If
@@ -182,12 +177,7 @@ irqfd_inject_level(struct work_struct *work)
 	 * re-inject if necessary.  NB, if you need to know if an interrupt
 	 * was coalesced, this interface is not for you.
 	 */
-	spin_lock(&irqfd->source->lock);
-	if (!irqfd->source->level_asserted) {
-		kvm_set_irq(irqfd->kvm, irqfd->source->id, irqfd->gsi, 1);
-		irqfd->source->level_asserted = true;
-	}
-	spin_unlock(&irqfd->source->lock);
+	kvm_set_irq(irqfd->kvm, irqfd->source->id, irqfd->gsi, 1);
 }
 
 /*
@@ -828,17 +818,11 @@ static void eoifd_event(struct kvm_irq_ack_notifier *notifier)
 
 	/*
 	 * Ack notifier is per GSI, which may be shared with others.
-	 * Only de-assert and send EOI if our source ID is asserted.
-	 * User needs to re-assert if device still requires service.
+	 * Only send EOI if pending from our source ID.  User needs to
+	 * re-assert if device still requires service.
 	 */
-	spin_lock(&eoifd->source->lock);
-	if (eoifd->source->level_asserted) {
-		kvm_set_irq(eoifd->kvm,
-			    eoifd->source->id, eoifd->notifier.gsi, 0);
-		eoifd->source->level_asserted = false;
+	if (kvm_clear_irq(eoifd->kvm, eoifd->source->id, notifier->gsi) > 0)
 		eventfd_signal(eoifd->eventfd, 1);
-	}
-	spin_unlock(&eoifd->source->lock);
 }
 
 static int kvm_assign_eoifd(struct kvm *kvm, struct kvm_eoifd *args)

