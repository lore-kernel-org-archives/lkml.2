Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab0IXQ2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:48 -0400
Received: from kroah.org ([198.145.64.141]:38484 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744Ab0IXQ2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:45 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:20 2010
Message-Id: <20100924162620.022536179@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com
Subject: [59/80] KVM: VMX: Fix host GDT.LIMIT corruption
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
@@ -177,6 +177,7 @@ static u64 construct_eptp(unsigned long
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 static DEFINE_PER_CPU(struct list_head, vcpus_on_cpu);
+static DEFINE_PER_CPU(struct desc_ptr, host_gdt);
 
 static unsigned long *vmx_io_bitmap_a;
 static unsigned long *vmx_io_bitmap_b;
@@ -812,6 +813,7 @@ static void __vmx_load_host_state(struct
 		wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 	}
 #endif
+	load_gdt(&__get_cpu_var(host_gdt));
 }
 
 static void vmx_load_host_state(struct vcpu_vmx *vmx)
@@ -1314,6 +1316,8 @@ static int hardware_enable(void *garbage
 
 	ept_sync_global();
 
+	store_gdt(&__get_cpu_var(host_gdt));
+
 	return 0;
 }
 


