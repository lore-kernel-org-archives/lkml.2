Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab2AVLCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 06:02:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62385 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2AVLCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 06:02:23 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1251.1)
Subject: [PATCH v2 1/2] KVM: Exception during emulation decode should propagate
From: Nadav Amit <nadav.amit@gmail.com>
Date: Sun, 22 Jan 2012 13:01:14 +0200
Cc: Nadav Amit <namit@cs.technion.ac.il>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>
Content-Transfer-Encoding: 7bit
Message-Id: <48B3D680-626C-4CF8-B4F3-214D0282B0A5@gmail.com>
References: <1327000666-4326-1-git-send-email-namit@cs.technion.ac.il>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An exception might occur during decode (e.g., #PF during fetch).
Currently, the exception is ignored and emulation is performed.
Instead, emulation should be skipped and the fault should be injected.
Skipping instruction should report a failure in this case.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
arch/x86/kvm/emulate.c |    5 +++++
arch/x86/kvm/x86.c     |    8 ++++++++
2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 05a562b..9a07dcd 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3869,6 +3869,11 @@ done:
	if (ctxt->memopp && ctxt->memopp->type == OP_MEM && ctxt->rip_relative)
		ctxt->memopp->addr.mem.ea += ctxt->_eip;

+	if (rc == X86EMUL_PROPAGATE_FAULT) {
+		ctxt->have_exception = true;
+		return EMULATION_OK;
+	}
+
	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
}

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1171def..05fd3d7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4443,10 +4443,17 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
	}

	if (emulation_type & EMULTYPE_SKIP) {
+		if (ctxt->have_exception)
+			return EMULATE_FAIL;
		kvm_rip_write(vcpu, ctxt->_eip);
		return EMULATE_DONE;
	}

+	if (ctxt->have_exception) {
+		writeback = false;
+		goto post;
+	}
+
	if (retry_instruction(ctxt, cr2, emulation_type))
		return EMULATE_DONE;

@@ -4470,6 +4477,7 @@ restart:
		return handle_emulation_failure(vcpu);
	}

+post:
	if (ctxt->have_exception) {
		inject_emulated_exception(vcpu);
		r = EMULATE_DONE;
-- 
1.7.4.1


