Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab0DVKeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:34:17 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:39818 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab0DVKdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:33:36 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L19XBO-01-038-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 5/8] KVM: X86: Add callback to let modules decide over some supported cpuid bits
Date: Thu, 22 Apr 2010 12:33:11 +0200
Message-ID: <1271932394-13968-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Apr 2010 10:33:19.0106 (UTC) FILETIME=[3983AE20:01CAE207]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the get_supported_cpuid callback to
kvm_x86_ops. It will be used in do_cpuid_ent to delegate the
decission about some supported cpuid bits to the
architecture modules.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/svm.c              |    6 ++++++
 arch/x86/kvm/vmx.c              |    6 ++++++
 arch/x86/kvm/x86.c              |    3 +++
 4 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d47d087..357573a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -528,6 +528,8 @@ struct kvm_x86_ops {
 	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
 
+	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
+
 	const struct trace_print_flags *exit_reasons_str;
 };
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b10d163..0fa2035 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3152,6 +3152,10 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 {
 }
 
+static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
+{
+}
+
 static const struct trace_print_flags svm_exit_reasons_str[] = {
 	{ SVM_EXIT_READ_CR0,			"read_cr0" },
 	{ SVM_EXIT_READ_CR3,			"read_cr3" },
@@ -3297,6 +3301,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.cpuid_update = svm_cpuid_update,
 
 	.rdtscp_supported = svm_rdtscp_supported,
+
+	.set_supported_cpuid = svm_set_supported_cpuid,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d0a10b5..dc023bc 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4111,6 +4111,10 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
+{
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -4183,6 +4187,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.cpuid_update = vmx_cpuid_update,
 
 	.rdtscp_supported = vmx_rdtscp_supported,
+
+	.set_supported_cpuid = vmx_set_supported_cpuid,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf37ac6..c2c3c29 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1960,6 +1960,9 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->ecx &= kvm_supported_word6_x86_features;
 		break;
 	}
+
+	kvm_x86_ops->set_supported_cpuid(function, entry);
+
 	put_cpu();
 }
 
-- 
1.7.0.4


