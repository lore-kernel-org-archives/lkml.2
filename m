Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab1GMG35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 02:29:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63124 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1GMG34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 02:29:56 -0400
Message-ID: <4E1D3BD6.6030306@cn.fujitsu.com>
Date: Wed, 13 Jul 2011 14:31:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: x86: abstract the operation for read/write emulation
References: <4E1D3BAC.5090109@cn.fujitsu.com>
In-Reply-To: <4E1D3BAC.5090109@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-13 14:29:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-13 14:29:10,
	Serialize complete at 2011-07-13 14:29:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The operations of read emulation and write emulation are very similar, so we
can abstract the operation of them, in larter patch, it is used to cleanup the
same code

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1453248..f5c60a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4136,6 +4136,78 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 	return 1;
 }
 
+struct read_write_emulator_ops {
+	int (*read_write_prepare)(struct kvm_vcpu *vcpu, void *val,
+				  int bytes);
+	int (*read_write_emulate)(struct kvm_vcpu *vcpu, gpa_t gpa,
+				  void *val, int bytes);
+	int (*read_write_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       int bytes, void *val);
+	int (*read_write_exit_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
+				    void *val, int bytes);
+	bool write;
+};
+
+static int read_prepare(struct kvm_vcpu *vcpu, void *val, int bytes)
+{
+	if (vcpu->mmio_read_completed) {
+		memcpy(val, vcpu->mmio_data, bytes);
+		trace_kvm_mmio(KVM_TRACE_MMIO_READ, bytes,
+			       vcpu->mmio_phys_addr, *(u64 *)val);
+		vcpu->mmio_read_completed = 0;
+		return 1;
+	}
+
+	return 0;
+}
+
+static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
+			void *val, int bytes)
+{
+	return !kvm_read_guest(vcpu->kvm, gpa, val, bytes);
+}
+
+static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
+			 void *val, int bytes)
+{
+	return emulator_write_phys(vcpu, gpa, val, bytes);
+}
+
+static int write_mmio(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes, void *val)
+{
+	trace_kvm_mmio(KVM_TRACE_MMIO_WRITE, bytes, gpa, *(u64 *)val);
+	return vcpu_mmio_write(vcpu, gpa, bytes, val);
+}
+
+static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
+			  void *val, int bytes)
+{
+	trace_kvm_mmio(KVM_TRACE_MMIO_READ_UNSATISFIED, bytes, gpa, 0);
+	return X86EMUL_IO_NEEDED;
+}
+
+static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
+			   void *val, int bytes)
+{
+	memcpy(vcpu->mmio_data, val, bytes);
+	memcpy(vcpu->run->mmio.data, vcpu->mmio_data, 8);
+	return X86EMUL_CONTINUE;
+}
+
+static struct read_write_emulator_ops read_emultor = {
+	.read_write_prepare = read_prepare,
+	.read_write_emulate = read_emulate,
+	.read_write_mmio = vcpu_mmio_read,
+	.read_write_exit_mmio = read_exit_mmio,
+};
+
+static struct read_write_emulator_ops write_emultor = {
+	.read_write_emulate = write_emulate,
+	.read_write_mmio = write_mmio,
+	.read_write_exit_mmio = write_exit_mmio,
+	.write = true,
+};
+
 static int emulator_write_emulated_onepage(unsigned long addr,
 					   const void *val,
 					   unsigned int bytes,
-- 
1.7.5.4

