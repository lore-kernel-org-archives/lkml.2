Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab0GAVTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:19:40 -0400
Received: from kroah.org ([198.145.64.141]:33246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933153Ab0GAVP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:26 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:02 2010
Message-Id: <20100701174302.244634480@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [186/200] KVM: x86: Add callback to let modules decide over some supported cpuid bits
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

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

(Cherry-picked from commit d4330ef2fb2236a1e3a176f0f68360f4c0a8661b)
---
 arch/x86/include/asm/kvm_host.h |    2 ++
 arch/x86/kvm/svm.c              |    6 ++++++
 arch/x86/kvm/vmx.c              |    6 ++++++
 arch/x86/kvm/x86.c              |    3 +++
 4 files changed, 17 insertions(+)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -541,6 +541,8 @@ struct kvm_x86_ops {
 	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
 
+	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
+
 	const struct trace_print_flags *exit_reasons_str;
 };
 
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2907,6 +2907,10 @@ static void svm_cpuid_update(struct kvm_
 {
 }
 
+static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
+{
+}
+
 static const struct trace_print_flags svm_exit_reasons_str[] = {
 	{ SVM_EXIT_READ_CR0,           		"read_cr0" },
 	{ SVM_EXIT_READ_CR3,	      		"read_cr3" },
@@ -3051,6 +3055,8 @@ static struct kvm_x86_ops svm_x86_ops =
 	.cpuid_update = svm_cpuid_update,
 
 	.rdtscp_supported = svm_rdtscp_supported,
+
+	.set_supported_cpuid = svm_set_supported_cpuid,
 };
 
 static int __init svm_init(void)
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4115,6 +4115,10 @@ static void vmx_cpuid_update(struct kvm_
 	}
 }
 
+static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
+{
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -4186,6 +4190,8 @@ static struct kvm_x86_ops vmx_x86_ops =
 	.cpuid_update = vmx_cpuid_update,
 
 	.rdtscp_supported = vmx_rdtscp_supported,
+
+	.set_supported_cpuid = vmx_set_supported_cpuid,
 };
 
 static int __init vmx_init(void)
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1917,6 +1917,9 @@ static void do_cpuid_ent(struct kvm_cpui
 		entry->ecx &= kvm_supported_word6_x86_features;
 		break;
 	}
+
+	kvm_x86_ops->set_supported_cpuid(function, entry);
+
 	put_cpu();
 }
 


