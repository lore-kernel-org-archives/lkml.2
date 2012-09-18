Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab2IRDQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:16:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab2IRDQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:16:21 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v10 1/2] kvm: Provide pre-locked setup to irq ack notifier
To: avi@redhat.com, mst@redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Sep 2012 21:16:20 -0600
Message-ID: <20120918031617.12021.22195.stgit@bling.home>
In-Reply-To: <20120918031156.12021.27838.stgit@bling.home>
References: <20120918031156.12021.27838.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables better integration into irqfd setup where we can adjust
our lock ordering to hold irq_lock, making these callable and avoiding
irq source ID races.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 include/linux/kvm_host.h |    4 ++++
 virt/kvm/irq_comm.c      |   18 ++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b70b48b..84f6950 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -628,8 +628,12 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
 		int irq_source_id, int level);
 void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
+void __kvm_register_irq_ack_notifier(struct kvm *kvm,
+				     struct kvm_irq_ack_notifier *kian);
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
+void __kvm_unregister_irq_ack_notifier(struct kvm *kvm,
+				       struct kvm_irq_ack_notifier *kian);
 void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
 int kvm_request_irq_source_id(struct kvm *kvm);
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index 83402d7..dd0cbf6 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -191,19 +191,33 @@ void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
 	rcu_read_unlock();
 }
 
+/* hold kvm->irq_lock */
+void __kvm_register_irq_ack_notifier(struct kvm *kvm,
+				     struct kvm_irq_ack_notifier *kian)
+{
+	hlist_add_head_rcu(&kian->link, &kvm->irq_ack_notifier_list);
+}
+
 void kvm_register_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian)
 {
 	mutex_lock(&kvm->irq_lock);
-	hlist_add_head_rcu(&kian->link, &kvm->irq_ack_notifier_list);
+	__kvm_register_irq_ack_notifier(kvm, kian);
 	mutex_unlock(&kvm->irq_lock);
 }
 
+/* hold kvm->irq_lock and wait for rcu grace period */
+void __kvm_unregister_irq_ack_notifier(struct kvm *kvm,
+				       struct kvm_irq_ack_notifier *kian)
+{
+	hlist_del_init_rcu(&kian->link);
+}
+
 void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 				    struct kvm_irq_ack_notifier *kian)
 {
 	mutex_lock(&kvm->irq_lock);
-	hlist_del_init_rcu(&kian->link);
+	__kvm_unregister_irq_ack_notifier(kvm, kian);
 	mutex_unlock(&kvm->irq_lock);
 	synchronize_rcu();
 }

