Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab1LASal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:30:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38253 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab1LASaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:30:39 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH 1/2] KVM: VMX: Notify if VMX is already in use
Date: Thu,  1 Dec 2011 20:30:17 +0200
Message-Id: <1322764218-4698-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we silently fail if VMX is already in use by a different
virtualization technology.

This is bad since it's non-obvious for the user, and its not too uncommon
for users to have several of these installed on same host.

This patch adds a message to notify the user of the problem.

Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 arch/x86/kvm/vmx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4ceced2..0ef59ed 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2300,8 +2300,11 @@ static int hardware_enable(void *garbage)
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
 	u64 old, test_bits;
 
-	if (read_cr4() & X86_CR4_VMXE)
+	if (read_cr4() & X86_CR4_VMXE) {
+		printk(KERN_ERR "hardware_enable: VMX already in use on CPU%d. "
+				"Are you already another hypervisor?\n", cpu);
 		return -EBUSY;
+	}
 
 	INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
 	rdmsrl(MSR_IA32_FEATURE_CONTROL, old);
-- 
1.7.8.rc4

