Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab1ABHdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:33:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:37117 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab1ABHZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:39 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 235/260] KVM: VMX: Fix host GDT.LIMIT corruption
Date: Sun,  2 Jan 2011 02:18:51 -0500
Message-Id: <1293952756-15010-236-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:27.0042 (UTC) FILETIME=[166A3020:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>

commit 3444d7da1839b851eefedd372978d8a982316c36 upstream.

vmx does not restore GDT.LIMIT to the host value, instead it sets it to 64KB.
This means host userspace can learn a few bits of host memory.

Fix by reloading GDTR when we load other host state.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kvm/vmx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3c86c42..11db911 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -170,6 +170,7 @@ static u64 construct_eptp(unsigned long root_hpa);
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 static DEFINE_PER_CPU(struct list_head, vcpus_on_cpu);
+static DEFINE_PER_CPU(struct desc_ptr, host_gdt);
 
 static unsigned long *vmx_io_bitmap_a;
 static unsigned long *vmx_io_bitmap_b;
@@ -717,6 +718,7 @@ static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 		wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 	}
 #endif
+	load_gdt(&__get_cpu_var(host_gdt));
 }
 
 static void vmx_load_host_state(struct vcpu_vmx *vmx)
@@ -1218,6 +1220,8 @@ static int hardware_enable(void *garbage)
 
 	ept_sync_global();
 
+	store_gdt(&__get_cpu_var(host_gdt));
+
 	return 0;
 }
 
-- 
1.7.3.3

