Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2AVLC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 06:02:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62385 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2AVLC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 06:02:29 -0500
Subject: [PATCH v2 2/2] KVM: Fix writeback on page boundary that propagate changes in spite of #PF
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1327000617-4283-2-git-send-email-namit@cs.technion.ac.il>
Date: Sun, 22 Jan 2012 13:01:18 +0200
Cc: Nadav Amit <namit@cs.technion.ac.il>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <CEFC4249-A4B6-4533-A568-89E3050BAF8D@gmail.com>
References: <1327000617-4283-1-git-send-email-namit@cs.technion.ac.il> <1327000617-4283-2-git-send-email-namit@cs.technion.ac.il>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider the case in which an instruction emulation writeback is performed on a page boundary.
In such case, if a #PF occurs on the second page, the write to the first page already occurred and cannot be retracted.
Therefore, validation of the second page access must be performed prior to writeback.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
arch/x86/kvm/x86.c |   60 +++++++++++++++++++++++++++++----------------------
1 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 05fd3d7..0e86f3a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3689,33 +3689,27 @@ static struct read_write_emulator_ops write_emultor = {
	.write = true,
};

-static int emulator_read_write_onepage(unsigned long addr, void *val,
+static int emulator_read_write_onepage(gpa_t gpa, void *val,
				       unsigned int bytes,
-				       struct x86_exception *exception,
				       struct kvm_vcpu *vcpu,
-				       struct read_write_emulator_ops *ops)
+				       struct read_write_emulator_ops *ops,
+				       bool mmio)
{
-	gpa_t gpa;
-	int handled, ret;
+	int handled;
	bool write = ops->write;

	if (ops->read_write_prepare &&
		  ops->read_write_prepare(vcpu, val, bytes))
		return X86EMUL_CONTINUE;

-	ret = vcpu_mmio_gva_to_gpa(vcpu, addr, &gpa, exception, write);
-
-	if (ret < 0)
-		return X86EMUL_PROPAGATE_FAULT;
-
	/* For APIC access vmexit */
-	if (ret)
-		goto mmio;
+	if (mmio)
+		goto do_mmio;

	if (ops->read_write_emulate(vcpu, gpa, val, bytes))
		return X86EMUL_CONTINUE;

-mmio:
+do_mmio:
	/*
	 * Is this MMIO handled locally?
	 */
@@ -3744,24 +3738,38 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
			struct read_write_emulator_ops *ops)
{
	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	int i, rc;
+	bool write = ops->write;
+	gpa_t gpa[2];
+	int npages = (((addr + bytes - 1) ^ addr) & PAGE_MASK) ? 2 : 1;
+	unsigned int offset[2] = {0};
+	unsigned int p_bytes[2] = {bytes, 0};
+	bool mmio[2];
+
+	if (npages == 2) {
+		p_bytes[0] = offset[1] = -addr & ~PAGE_MASK;
+		p_bytes[1] = bytes - p_bytes[0];
+	}
+
+	/* First check there is no page-fault on the next page */
+	for (i = 0; i < npages; i++) {
+		rc = vcpu_mmio_gva_to_gpa(vcpu, addr + offset[i], &gpa[i],
+			exception, write);
+		if (rc < 0)
+			return X86EMUL_PROPAGATE_FAULT;
+		mmio[i] = (rc > 0);
+	}

-	/* Crossing a page boundary? */
-	if (((addr + bytes - 1) ^ addr) & PAGE_MASK) {
-		int rc, now;
-
-		now = -addr & ~PAGE_MASK;
-		rc = emulator_read_write_onepage(addr, val, now, exception,
-						 vcpu, ops);
-
+	/* Actual read/write */
+	for (i = 0; i < npages; i++) {
+		rc = emulator_read_write_onepage(gpa[i], val + offset[i],
+						 p_bytes[i], vcpu, ops,
+						 mmio[i]);
		if (rc != X86EMUL_CONTINUE)
			return rc;
-		addr += now;
-		val += now;
-		bytes -= now;
	}

-	return emulator_read_write_onepage(addr, val, bytes, exception,
-					   vcpu, ops);
+	return X86EMUL_CONTINUE;
}

static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
-- 
1.7.4.1


