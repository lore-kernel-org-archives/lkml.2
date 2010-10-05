Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0JEHaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:30:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:43487 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab0JEHaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:30:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Namhyung Kim <namhyung@gmail.com>
Subject: Build failure on CONFIG_DEBUG_FORCE_WEAK_PER_CPU?
Date: Tue, 05 Oct 2010 16:23:27 +0900
Message-ID: <874od1w1ao.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 211.201.182.38
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Cancel-Lock: sha1:yPWJHM3xulOpozKx7ViPswplIIc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I tried to build 2.6.36-rc6 on x86_64 allyesconfig,
I got following messages and the build was broken:

  LD      vmlinux.o
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
ld: arch/x86/kernel/init_task.o:(.debug_info+0xeee): error: undefined reference to '__pcpu_scope_init_tss'
ld: arch/x86/kernel/init_task.o:(.debug_info+0x1558): error: undefined reference to '__pcpu_unique_init_tss'
ld: arch/x86/built-in.o:(.debug_info+0x2bed2): error: undefined reference to '__pcpu_unique_shared_msrs'
ld: arch/x86/built-in.o:(.debug_info+0x2c037): error: undefined reference to '__pcpu_unique_cpu_tsc_khz'
ld: arch/x86/built-in.o:(.debug_info+0x2c0ab): error: undefined reference to '__pcpu_unique_current_vcpu'
ld: arch/x86/built-in.o:(.debug_info+0x5801a): error: undefined reference to '__pcpu_unique_vmxarea'
ld: arch/x86/built-in.o:(.debug_info+0x58046): error: undefined reference to '__pcpu_unique_current_vmcs'
ld: arch/x86/built-in.o:(.debug_info+0x58072): error: undefined reference to '__pcpu_unique_vcpus_on_cpu'
ld: arch/x86/built-in.o:(.debug_info+0x5809e): error: undefined reference to '__pcpu_unique_host_gdt'
ld: arch/x86/built-in.o:(.debug_info+0x6086f): error: undefined reference to '__pcpu_unique_svm_data'
ld: arch/x86/built-in.o:(.debug_info+0x659ff): error: undefined reference to '__pcpu_scope_xen_vcpu'
ld: arch/x86/built-in.o:(.debug_info+0x65a41): error: undefined reference to '__pcpu_scope_xen_vcpu_info'
ld: arch/x86/built-in.o:(.debug_info+0x65b2c): error: undefined reference to '__pcpu_unique_xen_vcpu'
ld: arch/x86/built-in.o:(.debug_info+0x65b42): error: undefined reference to '__pcpu_unique_xen_vcpu_info'
ld: arch/x86/built-in.o:(.debug_info+0x65b96): error: undefined reference to '__pcpu_unique_idt_desc'
... (snipped)
make[2]: *** [.tmp_vmlinux1] Error 1
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

After reading comments on CONFIG_DEBUG_FORCE_WEAK_PER_CPU, I am
not sure whether it is intended or not. I think it's not, but
I can't find any report about this though the change was made
last year by 7c756e6e19e71f0327760d8955f7077118ebb2b1. Or Am I
missing something?

Anyway, the breakage was due to conflict between
CONFIG_DEBUG_FORCE_WEAK_PER_CPU and CONFIG_DEBUG_INFO. I think a
kconfig dependency has to be set between them something like:


diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1b4afd2..bb94392 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -634,7 +634,7 @@ config DEBUG_BUGVERBOSE
 
 config DEBUG_INFO
 	bool "Compile the kernel with debug info"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && !DEBUG_FORCE_WEAK_PER_CPU
 	help
           If you say Y here the resulting kernel image will include
 	  debugging info resulting in a larger kernel image.

-- 
Regards,
Namhyung Kim

