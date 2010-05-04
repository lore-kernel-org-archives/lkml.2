Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768Ab0EDNG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:06:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44809 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0EDNGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:06:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=kXsLq/YU5Yp7iyNGcnoYjbOuD4eefQBv6MQ6xUVNsRst7vI025U+mjjOaZlqNZBjf3
         RzUeQB+2eYcixBZWTetQHqErWaWMSO5epKDvXwG8jLp6W/4ez1LwL4cQl9U+e0bKOXBZ
         5HYZqAbtMgTAv6ncDhN2o3oD3jFGJ4OZBqq1o=
Date: Tue, 4 May 2010 22:06:20 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de,
       yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 9/12] KVM: introduce a wrapper function of
 set_bit_user_non_atomic()
Message-Id: <20100504220620.97e90535.takuya.yoshikawa@gmail.com>
In-Reply-To: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not to break the build for other architectures than x86 and ppc.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---
 arch/ia64/include/asm/kvm_host.h    |    5 +++++
 arch/powerpc/include/asm/kvm_host.h |    6 ++++++
 arch/s390/include/asm/kvm_host.h    |    6 ++++++
 arch/x86/include/asm/kvm_host.h     |    5 +++++
 4 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index a362e67..938041b 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -589,6 +589,11 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int kvm_pal_emul(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 void kvm_sal_emul(struct kvm_vcpu *vcpu);
 
+static inline int kvm_set_bit_user(int nr, void __user *addr)
+{
+	return 0;
+}
+
 #endif /* __ASSEMBLY__*/
 
 #endif
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 0c9ad86..9463524 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/kvm_types.h>
 #include <asm/kvm_asm.h>
+#include <asm/uaccess.h>
 
 #define KVM_MAX_VCPUS 1
 #define KVM_MEMORY_SLOTS 32
@@ -287,4 +288,9 @@ struct kvm_vcpu_arch {
 #endif
 };
 
+static inline int kvm_set_bit_user(int nr, void __user *addr)
+{
+	return set_bit_user_non_atomic(nr, addr);
+}
+
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 27605b6..36710ee 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -238,4 +238,10 @@ struct kvm_arch{
 };
 
 extern int sie64a(struct kvm_s390_sie_block *, unsigned long *);
+
+static inline int kvm_set_bit_user(int nr, void __user *addr)
+{
+	return 0;
+}
+
 #endif
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3f0007b..9e22df9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -795,4 +795,9 @@ void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
+static inline int kvm_set_bit_user(int nr, void __user *addr)
+{
+	return set_bit_user_non_atomic(nr, addr);
+}
+
 #endif /* _ASM_X86_KVM_HOST_H */
-- 
1.7.0.4

