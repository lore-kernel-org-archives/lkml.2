Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2APJbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:31:43 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44087 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2APJbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:31:41 -0500
Message-ID: <4F13EE73.1080504@linux.vnet.ibm.com>
Date: Mon, 16 Jan 2012 17:31:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/3] KVM: trace mmio read event properly
References: <4F13EE3D.2070602@linux.vnet.ibm.com>
In-Reply-To: <4F13EE3D.2070602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011609-4790-0000-0000-000000E0EE64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, we use KVM_TRACE_MMIO_READ to trace mmio read event which
only can be completed immediately, instead of it, we trace the time when
read event occur, then cooperate with then later patch, we can know the time
of mmio read emulation

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c95ca2d..0d41cfc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3432,7 +3432,6 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 		      !kvm_iodevice_read(&vcpu->arch.apic->dev, addr, n, v))
 		    && kvm_io_bus_read(vcpu->kvm, KVM_MMIO_BUS, addr, n, v))
 			break;
-		trace_kvm_mmio(KVM_TRACE_MMIO_READ, n, addr, *(u64 *)v);
 		handled += n;
 		addr += n;
 		len -= n;
@@ -3658,8 +3657,6 @@ static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
 {
 	if (vcpu->mmio_read_completed) {
 		memcpy(val, vcpu->mmio_data, bytes);
-		trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes,
-			       vcpu->mmio_phys_addr, *(u64 *)val);
 		vcpu->mmio_read_completed = 0;
 		return 1;
 	}
@@ -3681,7 +3678,6 @@ static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,

 static int write_mmio(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes, void *val)
 {
-	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, bytes, gpa, *(u64 *)val);
 	return vcpu_mmio_write(vcpu, gpa, bytes, val);
 }

@@ -3744,6 +3740,8 @@ mmio:
 	/*
 	 * Is this MMIO handled locally?
 	 */
+	trace_kvm_mmio(write ? KVM_TRACE_MMIO_WRITE : KVM_TRACE_MMIO_READ,
+			bytes, gpa, *(u64 *)val);
 	handled = ops->read_write_mmio(vcpu, gpa, bytes, val);
 	if (handled == bytes)
 		return X86EMUL_CONTINUE;
-- 
1.7.7.5

