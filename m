Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2HVMrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:47:45 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52752 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab2HVMrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:47:43 -0400
Message-ID: <5034D4E3.2080801@linux.vnet.ibm.com>
Date: Wed, 22 Aug 2012 20:47:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 12/12] KVM: indicate readonly access fault
References: <5032F8FD.2020306@linux.vnet.ibm.com> <5032FA78.9040405@linux.vnet.ibm.com> <5034CB60.30107@redhat.com>
In-Reply-To: <5034CB60.30107@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082212-3568-0000-0000-0000025656F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 08:06 PM, Avi Kivity wrote:
> On 08/21/2012 06:03 AM, Xiao Guangrong wrote:
>> Introduce write_readonly_mem in mmio-exit-info to indicate this exit is
>> caused by write access on readonly memslot
> 
> Please document this in chapter 5 of apic.txt.
> 

Okay, please review this one.

Subject: [PATCH v6 12/12] KVM: indicate readonly access fault

Introduce write_readonly_mem in mmio-exit-info to indicate this exit is
caused by write access on readonly memslot

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/api.txt |    8 +++++++-
 arch/x86/kvm/x86.c                |   23 ++++++++++++++---------
 include/linux/kvm.h               |    3 +++
 include/linux/kvm_host.h          |    1 +
 virt/kvm/kvm_main.c               |    3 +++
 5 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index b91bfd4..baf477e 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2089,12 +2089,18 @@ Unused.
 			__u8  data[8];
 			__u32 len;
 			__u8  is_write;
+#ifdef __KVM_HAVE_READONLY_MEM
+			__u8 write_readonly_mem;
+#endif
 		} mmio;

 If exit_reason is KVM_EXIT_MMIO, then the vcpu has
 executed a memory-mapped I/O instruction which could not be satisfied
 by kvm.  The 'data' member contains the written data if 'is_write' is
-true, and should be filled by application code otherwise.
+true, and should be filled by application code otherwise. When the
+KVM_CAP_READONLY_MEM capability, the 'write_readonly_mem' member indicates
+whether the exit is caused by write access on the readonly memslot
+(see KVM_MEM_READONLY in 4.35 KVM_SET_USER_MEMORY_REGION).

 NOTE: For KVM_EXIT_IO, KVM_EXIT_MMIO and KVM_EXIT_OSI, the corresponding
 operations are complete (and guest state is consistent) only after userspace
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42bbf41..6d7fe4a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3710,9 +3710,10 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,

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
@@ -3742,7 +3743,7 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
 static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
 			void *val, int bytes)
 {
-	return !kvm_read_guest(vcpu->kvm, gpa, val, bytes);
+	return kvm_read_guest(vcpu->kvm, gpa, val, bytes);
 }

 static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
@@ -3807,7 +3808,8 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 	if (ret)
 		goto mmio;

-	if (ops->read_write_emulate(vcpu, gpa, val, bytes))
+	ret = ops->read_write_emulate(vcpu, gpa, val, bytes);
+	if (!ret)
 		return X86EMUL_CONTINUE;

 mmio:
@@ -3829,6 +3831,7 @@ mmio:
 		frag->gpa = gpa;
 		frag->data = val;
 		frag->len = now;
+		frag->write_readonly_mem = (ret == -EPERM);

 		gpa += now;
 		val += now;
@@ -3842,8 +3845,8 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
 			struct x86_exception *exception,
 			struct read_write_emulator_ops *ops)
 {
+	struct kvm_mmio_fragment *frag;
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	gpa_t gpa;
 	int rc;

 	if (ops->read_write_prepare &&
@@ -3875,17 +3878,18 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
 	if (!vcpu->mmio_nr_fragments)
 		return rc;

-	gpa = vcpu->mmio_fragments[0].gpa;
+	frag = &vcpu->mmio_fragments[0];

 	vcpu->mmio_needed = 1;
 	vcpu->mmio_cur_fragment = 0;

-	vcpu->run->mmio.len = vcpu->mmio_fragments[0].len;
+	vcpu->run->mmio.len = frag->len;
 	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
 	vcpu->run->exit_reason = KVM_EXIT_MMIO;
-	vcpu->run->mmio.phys_addr = gpa;
+	vcpu->run->mmio.phys_addr = frag->gpa;
+	vcpu->run->mmio.write_readonly_mem = frag->write_readonly_mem;

-	return ops->read_write_exit_mmio(vcpu, gpa, val, bytes);
+	return ops->read_write_exit_mmio(vcpu, frag->gpa, val, bytes);
 }

 static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
@@ -5525,6 +5529,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
 		++frag;
 		run->exit_reason = KVM_EXIT_MMIO;
 		run->mmio.phys_addr = frag->gpa;
+		vcpu->run->mmio.write_readonly_mem = frag->write_readonly_mem;
 		if (vcpu->mmio_is_write)
 			memcpy(run->mmio.data, frag->data, frag->len);
 		run->mmio.len = frag->len;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index d808694..9d8002f 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -226,6 +226,9 @@ struct kvm_run {
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
index 5972c98..c37b225 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -189,6 +189,7 @@ struct kvm_mmio_fragment {
 	gpa_t gpa;
 	void *data;
 	unsigned len;
+	bool write_readonly_mem;
 };

 struct kvm_vcpu {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3416f8a..0c7def7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1456,6 +1456,9 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
 	unsigned long addr;

 	addr = gfn_to_hva(kvm, gfn);
+	if (addr == KVM_HVA_ERR_RO_BAD)
+		return -EPERM;
+
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	r = __copy_to_user((void __user *)addr + offset, data, len);
-- 
1.7.7.6

