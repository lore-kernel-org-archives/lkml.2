Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2BUEaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 23:30:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58045 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2BUEaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 23:30:16 -0500
From: Ben Collins <bcollins@ubuntu.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] KVM: PPC: check error return of kvmppc_core_vcpu_create first
Date: Mon, 20 Feb 2012 23:30:11 -0500
Message-Id: <50A8F108-8055-4115-B4EB-706D97736E65@ubuntu.com>
Cc: kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Mime-Version: 1.0 (Apple Message framework v1257)
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The result of kvmppc_core_vcpu_create() was being manipulated before it was checked for IS_ERR(). Did not see the bug occur, but caught it when looking through the code.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 607fbdf..8877614 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -278,10 +278,14 @@ void kvm_arch_flush_shadow(struct kvm *kvm)
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
 	struct kvm_vcpu *vcpu;
+
 	vcpu = kvmppc_core_vcpu_create(kvm, id);
+	if (IS_ERR(vcpu))
+		return vcpu;
+
 	vcpu->arch.wqp = &vcpu->wq;
-	if (!IS_ERR(vcpu))
-		kvmppc_create_vcpu_debugfs(vcpu, id);
+	kvmppc_create_vcpu_debugfs(vcpu, id);
+
 	return vcpu;
 }
 

--
Bluecherry: http://www.bluecherrydvr.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

