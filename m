Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab0KSVv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:51:59 -0500
Received: from kroah.org ([198.145.64.141]:51778 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307Ab0KSVp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:29 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:10 2010
Message-Id: <20101119214410.903294343@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:42:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com
Subject: [18/45] KVM: VMX: Fix host GDT.LIMIT corruption
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit 3444d7da1839b851eefedd372978d8a982316c36 upstream.

vmx does not restore GDT.LIMIT to the host value, instead it sets it to 64KB.
This means host userspace can learn a few bits of host memory.

Fix by reloading GDTR when we load other host state.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/vmx.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -130,6 +130,7 @@ static u64 construct_eptp(unsigned long
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 static DEFINE_PER_CPU(struct list_head, vcpus_on_cpu);
+static DEFINE_PER_CPU(struct desc_ptr, host_gdt);
 
 static unsigned long *vmx_io_bitmap_a;
 static unsigned long *vmx_io_bitmap_b;
@@ -690,6 +691,7 @@ static void __vmx_load_host_state(struct
 	save_msrs(vmx->guest_msrs, vmx->save_nmsrs);
 	load_msrs(vmx->host_msrs, vmx->save_nmsrs);
 	reload_host_efer(vmx);
+	load_gdt(&__get_cpu_var(host_gdt));
 }
 
 static void vmx_load_host_state(struct vcpu_vmx *vmx)
@@ -1176,6 +1178,8 @@ static void hardware_enable(void *garbag
 	asm volatile (ASM_VMX_VMXON_RAX
 		      : : "a"(&phys_addr), "m"(phys_addr)
 		      : "memory", "cc");
+
+	store_gdt(&__get_cpu_var(host_gdt));
 }
 
 static void vmclear_local_vcpus(void)


