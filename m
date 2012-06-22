Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab2FVWPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 18:15:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab2FVWPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 18:15:37 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/4] kvm: Pass kvm_irqfd to functions
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        mst@redhat.com
Date: Fri, 22 Jun 2012 16:15:32 -0600
Message-ID: <20120622221518.9858.95030.stgit@bling.home>
In-Reply-To: <20120622220040.9858.43665.stgit@bling.home>
References: <20120622220040.9858.43665.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prune this down to just the struct kvm_irqfd so we can avoid
changing function definition for every flag for field we use.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 include/linux/kvm_host.h |    4 ++--
 virt/kvm/eventfd.c       |   20 ++++++++++----------
 virt/kvm/kvm_main.c      |    2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 27ac8a4..ae3b426 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -824,7 +824,7 @@ static inline void kvm_free_irq_routing(struct kvm *kvm) {}
 #ifdef CONFIG_HAVE_KVM_EVENTFD
 
 void kvm_eventfd_init(struct kvm *kvm);
-int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags);
+int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args);
 void kvm_irqfd_release(struct kvm *kvm);
 void kvm_irq_routing_update(struct kvm *, struct kvm_irq_routing_table *);
 int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
@@ -833,7 +833,7 @@ int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args);
 
 static inline void kvm_eventfd_init(struct kvm *kvm) {}
 
-static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
+static inline int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	return -EINVAL;
 }
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index f59c1e8..c307c24 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -198,7 +198,7 @@ static void irqfd_update(struct kvm *kvm, struct _irqfd *irqfd,
 }
 
 static int
-kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
+kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	struct kvm_irq_routing_table *irq_rt;
 	struct _irqfd *irqfd, *tmp;
@@ -212,12 +212,12 @@ kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
 		return -ENOMEM;
 
 	irqfd->kvm = kvm;
-	irqfd->gsi = gsi;
+	irqfd->gsi = args->gsi;
 	INIT_LIST_HEAD(&irqfd->list);
 	INIT_WORK(&irqfd->inject, irqfd_inject);
 	INIT_WORK(&irqfd->shutdown, irqfd_shutdown);
 
-	file = eventfd_fget(fd);
+	file = eventfd_fget(args->fd);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 		goto fail;
@@ -298,19 +298,19 @@ kvm_eventfd_init(struct kvm *kvm)
  * shutdown any irqfd's that match fd+gsi
  */
 static int
-kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
+kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
 {
 	struct _irqfd *irqfd, *tmp;
 	struct eventfd_ctx *eventfd;
 
-	eventfd = eventfd_ctx_fdget(fd);
+	eventfd = eventfd_ctx_fdget(args->fd);
 	if (IS_ERR(eventfd))
 		return PTR_ERR(eventfd);
 
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list) {
-		if (irqfd->eventfd == eventfd && irqfd->gsi == gsi) {
+		if (irqfd->eventfd == eventfd && irqfd->gsi == args->gsi) {
 			/*
 			 * This rcu_assign_pointer is needed for when
 			 * another thread calls kvm_irq_routing_update before
@@ -338,12 +338,12 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
 }
 
 int
-kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
+kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
 {
-	if (flags & KVM_IRQFD_FLAG_DEASSIGN)
-		return kvm_irqfd_deassign(kvm, fd, gsi);
+	if (args->flags & KVM_IRQFD_FLAG_DEASSIGN)
+		return kvm_irqfd_deassign(kvm, args);
 
-	return kvm_irqfd_assign(kvm, fd, gsi);
+	return kvm_irqfd_assign(kvm, args);
 }
 
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 02cb440..b4ad14cc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2059,7 +2059,7 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = -EFAULT;
 		if (copy_from_user(&data, argp, sizeof data))
 			goto out;
-		r = kvm_irqfd(kvm, data.fd, data.gsi, data.flags);
+		r = kvm_irqfd(kvm, &data);
 		break;
 	}
 	case KVM_IOEVENTFD: {

