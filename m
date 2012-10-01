Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab2JAX25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:28:57 -0400
Received: from 1wt.eu ([62.212.114.60]:35231 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736Ab2JAXAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:47 -0400
Message-Id: <20121001225159.478878308@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 044/180] KVM: x86: disallow multiple KVM_CREATE_IRQCHIP
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit 3ddea128ad75bd33e88780fe44f44c3717369b98 upstream

Otherwise kvm will leak memory on multiple KVM_CREATE_IRQCHIP.
Also serialize multiple accesses with kvm->lock.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kvm/irq.h |    6 +++++-
 arch/x86/kvm/x86.c |   30 ++++++++++++++++++++++--------
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 7d6058a..85a8721 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -85,7 +85,11 @@ static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
 
 static inline int irqchip_in_kernel(struct kvm *kvm)
 {
-	return pic_irqchip(kvm) != NULL;
+	int ret;
+
+	ret = (pic_irqchip(kvm) != NULL);
+	smp_rmb();
+	return ret;
 }
 
 void kvm_pic_reset(struct kvm_kpic_state *s);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23b5a71..5908461 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2273,25 +2273,39 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (r)
 			goto out;
 		break;
-	case KVM_CREATE_IRQCHIP:
+	case KVM_CREATE_IRQCHIP: {
+		struct kvm_pic *vpic;
+
+		mutex_lock(&kvm->lock);
+		r = -EEXIST;
+		if (kvm->arch.vpic)
+			goto create_irqchip_unlock;
 		r = -ENOMEM;
-		kvm->arch.vpic = kvm_create_pic(kvm);
-		if (kvm->arch.vpic) {
+		vpic = kvm_create_pic(kvm);
+		if (vpic) {
 			r = kvm_ioapic_init(kvm);
 			if (r) {
-				kfree(kvm->arch.vpic);
-				kvm->arch.vpic = NULL;
-				goto out;
+				kfree(vpic);
+				goto create_irqchip_unlock;
 			}
 		} else
-			goto out;
+			goto create_irqchip_unlock;
+		smp_wmb();
+		kvm->arch.vpic = vpic;
+		smp_wmb();
 		r = kvm_setup_default_irq_routing(kvm);
 		if (r) {
+			mutex_lock(&kvm->irq_lock);
 			kfree(kvm->arch.vpic);
 			kfree(kvm->arch.vioapic);
-			goto out;
+			kvm->arch.vpic = NULL;
+			kvm->arch.vioapic = NULL;
+			mutex_unlock(&kvm->irq_lock);
 		}
+	create_irqchip_unlock:
+		mutex_unlock(&kvm->lock);
 		break;
+	}
 	case KVM_CREATE_PIT:
 		u.pit_config.flags = KVM_PIT_SPEAKER_DUMMY;
 		goto create_pit;
-- 
1.7.2.1.45.g54fbc



