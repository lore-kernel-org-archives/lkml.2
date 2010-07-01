Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab0GAUxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:53:48 -0400
Received: from kroah.org ([198.145.64.141]:47944 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875Ab0GAUv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:28 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:39 2010
Message-Id: <20100701173439.199383479@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 147/164] KVM: x86: Add callback to let modules decide over some supported cpuid bits
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds the get_supported_cpuid callback to
kvm_x86_ops. It will be used in do_cpuid_ent to delegate the
decission about some supported cpuid bits to the
architecture modules.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(cherry picked from commit d4330ef2fb2236a1e3a176f0f68360f4c0a8661b)
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/svm.c              |    5 +++++
 arch/x86/kvm/vmx.c              |    5 +++++
 arch/x86/kvm/x86.c              |    3 +++
 4 files changed, 15 insertions(+)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -533,6 +533,8 @@ struct kvm_x86_ops {
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 	bool (*gb_page_enable)(void);
 
+	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
+
 	const struct trace_print_flags *exit_reasons_str;
 };
 
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2885,6 +2885,10 @@ static u64 svm_get_mt_mask(struct kvm_vc
 	return 0;
 }
 
+static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
+{
+}
+
 static const struct trace_print_flags svm_exit_reasons_str[] = {
 	{ SVM_EXIT_READ_CR0,           		"read_cr0" },
 	{ SVM_EXIT_READ_CR3,	      		"read_cr3" },
@@ -3009,6 +3013,7 @@ static struct kvm_x86_ops svm_x86_ops =
 
 	.exit_reasons_str = svm_exit_reasons_str,
 	.gb_page_enable = svm_gb_page_enable,
+	.set_supported_cpuid = svm_set_supported_cpuid,
 };
 
 static int __init svm_init(void)
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3993,6 +3993,10 @@ static bool vmx_gb_page_enable(void)
 	return false;
 }
 
+static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
+{
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -4057,6 +4061,7 @@ static struct kvm_x86_ops vmx_x86_ops =
 
 	.exit_reasons_str = vmx_exit_reasons_str,
 	.gb_page_enable = vmx_gb_page_enable,
+	.set_supported_cpuid = vmx_set_supported_cpuid,
 };
 
 static int __init vmx_init(void)
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1688,6 +1688,9 @@ static void do_cpuid_ent(struct kvm_cpui
 		entry->ecx &= kvm_supported_word6_x86_features;
 		break;
 	}
+
+	kvm_x86_ops->set_supported_cpuid(function, entry);
+
 	put_cpu();
 }
 


