Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab0KRLKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:10:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab0KRLKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:10:51 -0500
Date: Thu, 18 Nov 2010 13:10:37 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
Message-ID: <20101118111037.GB31261@redhat.com>
References: <20101117221254.GA8296@redhat.com>
 <20101118105741.GA31261@redhat.com>
 <4CE50810.3090502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE50810.3090502@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 01:03:44PM +0200, Avi Kivity wrote:
> On 11/18/2010 12:57 PM, Michael S. Tsirkin wrote:
> >So the following on top will fix it all.
> >Any more comments befpre I bundle it up,
> >test and report?
> >
> 
> Nope (not that I can comment on an incremental).

Here it is rolled up.

> I guess I should create an empty Documentation/kvm/locking.txt and
> force everyone else to update it.

Comments near the relevant fields not better?

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a055742..d13ced3 100644
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
@@ -462,6 +465,8 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
 				   unsigned long *deliver_bitmask);
 #endif
 int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
+		int irq_source_id, int level);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
@@ -603,6 +608,7 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 void kvm_eventfd_init(struct kvm *kvm);
 int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
 void kvm_irqfd_release(struct kvm *kvm);
+void kvm_irq_routing_update(struct kvm *, struct kvm_irq_routing_table *);
 int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
 
 #else
@@ -614,6 +620,12 @@ static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
 }
 
 static inline void kvm_irqfd_release(struct kvm *kvm) {}
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
index c1f1e3c..b0cfae7 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -44,14 +44,19 @@
  */
 
 struct _irqfd {
-	struct kvm               *kvm;
-	struct eventfd_ctx       *eventfd;
-	int                       gsi;
-	struct list_head          list;
-	poll_table                pt;
-	wait_queue_t              wait;
-	struct work_struct        inject;
-	struct work_struct        shutdown;
+	/* Used for MSI fast-path */
+	struct kvm *kvm;
+	wait_queue_t wait;
+	/* Update side is protected by irqfds.lock */
+	struct kvm_kernel_irq_routing_entry __rcu *irq_entry;
+	/* Used for level IRQ fast-path */
+	int gsi;
+	struct work_struct inject;
+	/* Used for setup/shutdown */
+	struct eventfd_ctx *eventfd;
+	struct list_head list;
+	poll_table pt;
+	struct work_struct shutdown;
 };
 
 static struct workqueue_struct *irqfd_cleanup_wq;
@@ -125,10 +130,18 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
 	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
 	unsigned long flags = (unsigned long)key;
+	struct kvm_kernel_irq_routing_entry *irq;
 
-	if (flags & POLLIN)
+	if (flags & POLLIN) {
+		rcu_read_lock();
+		irq = rcu_dereference(irqfd->irq_entry);
 		/* An event has been signaled, inject an interrupt */
-		schedule_work(&irqfd->inject);
+		if (irq)
+			kvm_set_msi(irq, irqfd->kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1);
+		else
+			schedule_work(&irqfd->inject);
+		rcu_read_unlock();
+	}
 
 	if (flags & POLLHUP) {
 		/* The eventfd is closing, detach from KVM */
@@ -163,9 +176,31 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
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
+	struct kvm_irq_routing_table *irq_rt;
 	struct _irqfd *irqfd, *tmp;
 	struct file *file = NULL;
 	struct eventfd_ctx *eventfd = NULL;
@@ -215,6 +250,10 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 		goto fail;
 	}
 
+	irq_rt = rcu_dereference_protected(kvm->irq_routing,
+					   lockdep_is_held(&kvm->irqfds.lock));
+	irqfd_update(kvm, irqfd, irq_rt);
+
 	events = file->f_op->poll(file, &irqfd->pt);
 
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
@@ -271,8 +310,15 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd == eventfd && irqfd->gsi == gsi)
+		if (irqfd->eventfd == eventfd && irqfd->gsi == gsi) {
+			/* This rcu_assign_pointer is needed for when
+			 * another thread calls kvm_irqfd_update before
+			 * we flush workqueue below.
+			 * It is paired with synchronize_rcu done by caller
+			 * of that function. */
+			rcu_assign_pointer(irqfd->irq_entry, NULL);
 			irqfd_deactivate(irqfd);
+		}
 	}
 
 	spin_unlock_irq(&kvm->irqfds.lock);
@@ -321,6 +367,23 @@ kvm_irqfd_release(struct kvm *kvm)
 
 }
 
+/* Change irq_routing and irqfd.  Caller must invoke synchronize_rcu
+ * afterwards. */
+void kvm_irq_routing_update(struct kvm *kvm,
+			    struct kvm_irq_routing_table *irq_rt)
+{
+	struct _irqfd *irqfd;
+
+	spin_lock_irq(&kvm->irqfds.lock);
+
+	rcu_assign_pointer(kvm->irq_routing, irq_rt);
+
+	list_for_each_entry(irqfd, &kvm->irqfds.items, list)
+		irqfd_update(kvm, irqfd, irq_rt);
+
+	spin_unlock_irq(&kvm->irqfds.lock);
+}
+
 /*
  * create a host-wide workqueue for issuing deferred shutdown requests
  * aggregated from all vm* instances. We need our own isolated single-thread
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 8edca91..9f614b4 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -114,8 +114,8 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 	return r;
 }
 
-static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
-		       struct kvm *kvm, int irq_source_id, int level)
+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id, int level)
 {
 	struct kvm_lapic_irq irq;
 
@@ -409,8 +409,9 @@ int kvm_set_irq_routing(struct kvm *kvm,
 
 	mutex_lock(&kvm->irq_lock);
 	old = kvm->irq_routing;
-	rcu_assign_pointer(kvm->irq_routing, new);
+	kvm_irq_routing_update(kvm, new);
 	mutex_unlock(&kvm->irq_lock);
+
 	synchronize_rcu();
 
 	new = old;
