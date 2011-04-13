Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab1DMPpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:45:13 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44933 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab1DMPpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ht9EhSRwNixMiUMG6MwnCK/40I7QD7VI2Tly/PJ0fhBFqNwyftHphOJEeuEVc9+2HR
         qY+D4cglcsXdPEvDwJj17ZvxAs8p8+Kr3fRQETpHcsiqxtKHgLtUsZwsxTqvQ0NFhnGm
         T3K/bQzHmVnP1ipIvUOD+olqiusNR/YrhM4ak=
From: Nelson Elhage <nelhage@ksplice.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nelson Elhage <nelhage@ksplice.com>
Subject: [PATCH] KVM: emulator: Handle wraparound in (cs_base + offset) when fetching.
Date: Wed, 13 Apr 2011 11:44:13 -0400
Message-Id: <1302709453-19031-1-git-send-email-nelhage@ksplice.com>
X-Mailer: git-send-email 1.7.2.43.g36c08.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, setting a large (i.e. negative) base address for %cs does not work on
a 64-bit host. The "JOS" teaching operating system, used by MIT and other
universities, relies on such segments while bootstrapping its way to full
virtual memory management.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
---
 arch/x86/kvm/emulate.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0ad47b8..54e84b2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -505,9 +505,12 @@ static int do_fetch_insn_byte(struct x86_emulate_ctxt *ctxt,
 	int size, cur_size;
 
 	if (eip == fc->end) {
+		unsigned long linear = eip + ctxt->cs_base;
+		if (ctxt->mode != X86EMUL_MODE_PROT64)
+			linear &= (u32)-1;
 		cur_size = fc->end - fc->start;
 		size = min(15UL - cur_size, PAGE_SIZE - offset_in_page(eip));
-		rc = ops->fetch(ctxt->cs_base + eip, fc->data + cur_size,
+		rc = ops->fetch(linear, fc->data + cur_size,
 				size, ctxt->vcpu, &ctxt->exception);
 		if (rc != X86EMUL_CONTINUE)
 			return rc;
-- 
1.7.2.43.g36c08.dirty

