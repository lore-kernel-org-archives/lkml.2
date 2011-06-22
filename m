Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab1FVO1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:27:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53248 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab1FVO1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:27:15 -0400
Message-ID: <4E01FC39.2080709@cn.fujitsu.com>
Date: Wed, 22 Jun 2011 22:29:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 03/22] KVM: x86: fix broken read emulation spans a page
 boundary
References: <4E01FBC9.3020009@cn.fujitsu.com>
In-Reply-To: <4E01FBC9.3020009@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:26:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-22 22:26:49,
	Serialize complete at 2011-06-22 22:26:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the range spans a boundary, the mmio access can be broke, fix it as
write emulation.

And we already get the guest physical address, so use it to read guest data
directly to avoid walking guest page table again

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/x86.c |   41 ++++++++++++++++++++++++++++++++---------
 1 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b803f0..eb27be4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3944,14 +3944,13 @@ out:
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
 
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
-	gpa_t                 gpa;
+	gpa_t gpa;
 	int handled;
 
 	if (vcpu->mmio_read_completed) {
@@ -3971,8 +3970,7 @@ static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
 	if ((gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
 		goto mmio;
 
-	if (kvm_read_guest_virt(ctxt, addr, val, bytes, exception)
-	    == X86EMUL_CONTINUE)
+	if (!kvm_read_guest(vcpu->kvm, gpa, val, bytes))
 		return X86EMUL_CONTINUE;
 
 mmio:
@@ -4001,6 +3999,31 @@ mmio:
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

