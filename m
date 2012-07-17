Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab2GQOqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:46:44 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:56824 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab2GQOqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:46:42 -0400
Message-ID: <50057ACB.2060501@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 22:46:35 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 10/10] KVM: indicate readonly access fault
References: <5005791B.8040807@linux.vnet.ibm.com>
In-Reply-To: <5005791B.8040807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071714-8256-0000-0000-00000359A714
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce write_readonly_mem in mmio-exit-info to indicate this exit is
caused by write access on readonly memslot

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c       |   12 ++++++++----
 include/linux/kvm.h      |    3 +++
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |    3 +++
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 46e13a1..cc5f8f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3703,9 +3703,10 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,

 	ret = kvm_write_guest(vcpu->kvm, gpa, val, bytes);
 	if (ret < 0)
-		return 0;
+		return ret;
+
 	kvm_mmu_pte_write(vcpu, gpa, val, bytes);
-	return 1;
+	return 0;
 }

 struct read_write_emulator_ops {
@@ -3735,7 +3736,7 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
 static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
 			void *val, int bytes)
 {
-	return !kvm_read_guest(vcpu->kvm, gpa, val, bytes);
+	return kvm_read_guest(vcpu->kvm, gpa, val, bytes);
 }

 static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
@@ -3797,7 +3798,8 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	if (ret)
 		goto mmio;

-	if (ops->read_write_emulate(vcpu, gpa, val, bytes))
+	ret = ops->read_write_emulate(vcpu, gpa, val, bytes);
+	if (!ret)
 		return X86EMUL_CONTINUE;

 mmio:
@@ -3819,6 +3821,7 @@ mmio:
 		frag->gpa = gpa;
 		frag->data = val;
 		frag->len = now;
+		frag->write_readonly_mem = (ret == -EPERM);

 		gpa += now;
 		val += now;
@@ -3836,6 +3839,7 @@ static void set_mmio_exit_info(struct kvm_vcpu *vcpu,
 	run->mmio.phys_addr = frag->gpa;
 	run->mmio.len = frag->len;
 	run->mmio.is_write = vcpu->mmio_is_write = write;
+	run->mmio.write_readonly_mem = frag->write_readonly_mem;

 	if (write)
 		memcpy(run->mmio.data, frag->data, frag->len);
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 94867d0..9261541 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -222,6 +222,9 @@ struct kvm_run {
 			__u8  data[8];
 			__u32 len;
 			__u8  is_write;
+#ifdef __KVM_HAVE_READONLY_MEM
+			__u8 write_readonly_mem;
+#endif
 		} mmio;
 		/* KVM_EXIT_HYPERCALL */
 		struct {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a2302e7..7e45014 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -142,6 +142,7 @@ struct kvm_mmio_fragment {
 	gpa_t gpa;
 	void *data;
 	unsigned len;
+	bool write_readonly_mem;
 };

 struct kvm_vcpu {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 50e18c0..8d4bc55 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1527,6 +1527,9 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
 	unsigned long addr;

 	addr = gfn_to_hva(kvm, gfn);
+	if (kvm_is_readonly_bad_hva(addr))
+		return -EPERM;
+
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	r = __copy_to_user((void __user *)addr + offset, data, len);
-- 
1.7.7.6

