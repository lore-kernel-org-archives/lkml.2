Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566Ab0FPUbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:31:07 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:35196 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759510Ab0FPUbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:31:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: [PATCH 1/1] x86_64: initialize VDSO earlier
Date: Wed, 16 Jun 2010 22:30:42 +0200
Message-Id: <1276720242-13365-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When initrd is in use and a driver does request_module() in its
module_init (i.e. __initcall or device_initcall), a modprobe process
is created with VDSO mapping. But VDSO is inited even in __initcall,
i.e. on the same level (at the same time), so it may not be inited
yet (link order matters).

Move the VDSO initialization code earlier by switching to something
before rootfs_initcall where initrd is loaded as rootfs. Specifically
to subsys_initcall. Do it for standard 64-bit path (init_vdso_vars)
and for compat (sysenter_setup), just in case people have 32-bit
initrd and ia32 emulation built-in.

i386 (pure 32-bit) is not affected, since sysenter_setup() is called
from check_bugs()->identify_boot_cpu() in start_kernel() before
rest_init()->kernel_thread(kernel_init) where even kernel_init() calls
do_basic_setup()->do_initcalls().

What this patch fixes are early modprobe crashes such as:
Unpacking initramfs...
Freeing initrd memory: 9324k freed
modprobe[368]: segfault at 7fff4429c020 ip 00007fef397e160c \
    sp 00007fff442795c0 error 4 in ld-2.11.2.so[7fef397df000+1f000]

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/vdso/vdso32-setup.c |    2 +-
 arch/x86/vdso/vma.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 02b442e..36df991 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -374,7 +374,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 #ifdef CONFIG_X86_64
 
-__initcall(sysenter_setup);
+subsys_initcall(sysenter_setup);
 
 #ifdef CONFIG_SYSCTL
 /* Register vsyscall32 into the ABI table */
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index ac74869..43456ee 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -74,7 +74,7 @@ static int __init init_vdso_vars(void)
 	vdso_enabled = 0;
 	return -ENOMEM;
 }
-__initcall(init_vdso_vars);
+subsys_initcall(init_vdso_vars);
 
 struct linux_binprm;
 
-- 
1.7.1


