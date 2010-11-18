Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab0KRK54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:57:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab0KRK5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:57:54 -0500
Date: Thu, 18 Nov 2010 12:57:41 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
Message-ID: <20101118105741.GA31261@redhat.com>
References: <20101117221254.GA8296@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117221254.GA8296@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So the following on top will fix it all.
Any more comments befpre I bundle it up,
test and report?

kvm: fix up msi fastpath

This will be folded into the msi fastpath patch.
Changes:
- simplify irq_entry/irq_routing update rules:
  simply to it all under irqfds.lock
- document locking for rcu update side
- rcu_dereference for rcu pointer access

Still compile-tested only.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b6f7047..d13ced3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/preempt.h>
 #include <linux/msi.h>
+#include <linux/rcupdate.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -206,6 +207,8 @@ struct kvm {
 
 	struct mutex irq_lock;
 #ifdef CONFIG_HAVE_KVM_IRQCHIP
+	/* Update side is protected by irq_lock and,
+	 * if configured, irqfds.lock. */
 	struct kvm_irq_routing_table __rcu *irq_routing;
 	struct hlist_head mask_notifier_list;
 	struct hlist_head irq_ack_notifier_list;
@@ -605,7 +608,7 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 void kvm_eventfd_init(struct kvm *kvm);
 int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
 void kvm_irqfd_release(struct kvm *kvm);
-void kvm_irqfd_update(struct kvm *kvm, struct kvm_irq_routing_table *irq_rt);
+void kvm_irq_routing_update(struct kvm *, struct kvm_irq_routing_table *);
 int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
 
 #else
@@ -617,7 +620,12 @@ static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 }
 
 static inline void kvm_irqfd_release(struct kvm *kvm) {}
-static inline void kvm_irqfd_update(struct kvm *kvm) {}
+static inline void kvm_irq_routing_update(struct kvm *kvm,
+					  struct kvm_irq_routing_table *irq_rt)
+{
+	rcu_assign_pointer(kvm->irq_routing, irq_rt);
+}
+
 static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
 {
 	return -ENOSYS;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 49c1864..b0cfae7 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -47,6 +47,7 @@ struct _irqfd {
 	/* Used for MSI fast-path */
 	struct kvm *kvm;
 	wait_queue_t wait;
+	/* Update side is protected by irqfds.lock */
 	struct kvm_kernel_irq_routing_entry __rcu *irq_entry;
 	/* Used for level IRQ fast-path */
 	int gsi;
@@ -133,7 +134,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 
 	if (flags & POLLIN) {
 		rcu_read_lock();
-		irq = irqfd->irq_entry;
+		irq = rcu_dereference(irqfd->irq_entry);
 		/* An event has been signaled, inject an interrupt */
 		if (irq)
 			kvm_set_msi(irq, irqfd->kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1);
@@ -175,6 +176,27 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
 	add_wait_queue(wqh, &irqfd->wait);
 }
 
+/* Must be called under irqfds.lock */
+static void irqfd_update(struct kvm *kvm, struct _irqfd *irqfd,
+			 struct kvm_irq_routing_table *irq_rt)
+{
+	struct kvm_kernel_irq_routing_entry *e;
+	struct hlist_node *n;
+
+	if (irqfd->gsi >= irq_rt->nr_rt_entries) {
+		rcu_assign_pointer(irqfd->irq_entry, NULL);
+		return;
+	}
+
+	hlist_for_each_entry(e, n, &irq_rt->map[irqfd->gsi], link) {
+		/* Only fast-path MSI. */
+		if (e->type == KVM_IRQ_ROUTING_MSI)
+			rcu_assign_pointer(irqfd->irq_entry, e);
+		else
+			rcu_assign_pointer(irqfd->irq_entry, NULL);
+	}
+}
+
 static int
 kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 {
@@ -228,9 +250,9 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 		goto fail;
 	}
 
-	rcu_read_lock();
-	irqfd_update(kvm, irqfd, rcu_dereference(kvm->irq_routing));
-	rcu_read_unlock();
+	irq_rt = rcu_dereference_protected(kvm->irq_routing,
+					   lockdep_is_held(&kvm->irqfds.lock));
+	irqfd_update(kvm, irqfd, irq_rt);
 
 	events = file->f_op->poll(file, &irqfd->pt);
 
@@ -345,35 +367,17 @@ kvm_irqfd_release(struct kvm *kvm)
 
 }
 
-/* Must be called under irqfds.lock */
-static void irqfd_update(struct kvm *kvm, struct _irqfd *irqfd,
-			 struct kvm_irq_routing_table *irq_rt)
-{
-	struct kvm_kernel_irq_routing_entry *e;
-	struct hlist_node *n;
-
-	if (irqfd->gsi >= irq_rt->nr_rt_entries) {
-		rcu_assign_pointer(irqfd->irq_entry, NULL);
-		return;
-	}
-
-	hlist_for_each_entry(e, n, &irq_rt->map[irqfd->gsi], link) {
-		/* Only fast-path MSI. */
-		if (e->type == KVM_IRQ_ROUTING_MSI)
-			rcu_assign_pointer(irqfd->irq_entry, e);
-		else
-			rcu_assign_pointer(irqfd->irq_entry, NULL);
-	}
-}
-
-/* Update irqfd after a routing change.  Caller must invoke synchronize_rcu
+/* Change irq_routing and irqfd.  Caller must invoke synchronize_rcu
  * afterwards. */
-void kvm_irqfd_update(struct kvm *kvm, struct kvm_irq_routing_table *irq_rt)
+void kvm_irq_routing_update(struct kvm *kvm,
+			    struct kvm_irq_routing_table *irq_rt)
 {
 	struct _irqfd *irqfd;
 
 	spin_lock_irq(&kvm->irqfds.lock);
 
+	rcu_assign_pointer(kvm->irq_routing, irq_rt);
+
 	list_for_each_entry(irqfd, &kvm->irqfds.items, list)
 		irqfd_update(kvm, irqfd, irq_rt);
 
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 265ab72..9f614b4 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -409,8 +409,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
 
 	mutex_lock(&kvm->irq_lock);
 	old = kvm->irq_routing;
-	rcu_assign_pointer(kvm->irq_routing, new);
-	kvm_irqfd_update(kvm, new);
+	kvm_irq_routing_update(kvm, new);
 	mutex_unlock(&kvm->irq_lock);
 
 	synchronize_rcu();
