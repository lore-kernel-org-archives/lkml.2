Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab1GMG3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 02:29:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49861 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab1GMG3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 02:29:16 -0400
Message-ID: <4E1D3BAC.5090109@cn.fujitsu.com>
Date: Wed, 13 Jul 2011 14:31:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/3] KVM: x86: fix broken read emulation spans a page boundary
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-13 14:28:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-13 14:28:29,
	Serialize complete at 2011-07-13 14:28:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the range spans a page boundary, the mmio access can be broke, fix it as
write emulation.

And we already get the guest physical address, so use it to read guest data
directly to avoid walking guest page table again

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |   39 +++++++++++++++++++++++++++++++--------
 1 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 84a28ea..1453248 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4045,13 +4045,12 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 	return 0;
 }
 
-static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
-				  unsigned long addr,
-				  void *val,
-				  unsigned int bytes,
-				  struct x86_exception *exception)
+static int emulator_read_emulated_onepage(unsigned long addr,
+					  void *val,
+					  unsigned int bytes,
+					  struct x86_exception *exception,
+					  struct kvm_vcpu *vcpu)
 {
-	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	gpa_t gpa;
 	int handled, ret;
 
@@ -4071,8 +4070,7 @@ static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
 	if (ret)
 		goto mmio;
 
-	if (kvm_read_guest_virt(ctxt, addr, val, bytes, exception)
-	    == X86EMUL_CONTINUE)
+	if (!kvm_read_guest(vcpu->kvm, gpa, val, bytes))
 		return X86EMUL_CONTINUE;
 
 mmio:
@@ -4101,6 +4099,31 @@ mmio:
 	return X86EMUL_IO_NEEDED;
 }
 
+static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
+				  unsigned long addr,
+				  void *val,
+				  unsigned int bytes,
+				  struct x86_exception *exception)
+{
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+
+	/* Crossing a page boundary? */
+	if (((addr + bytes - 1) ^ addr) & PAGE_MASK) {
+		int rc, now;
+
+		now = -addr & ~PAGE_MASK;
+		rc = emulator_read_emulated_onepage(addr, val, now, exception,
+							vcpu);
+		if (rc != X86EMUL_CONTINUE)
+			return rc;
+		addr += now;
+		val += now;
+		bytes -= now;
+	}
+	return emulator_read_emulated_onepage(addr, val, bytes, exception,
+						vcpu);
+}
+
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			const void *val, int bytes)
 {
-- 
1.7.5.4
