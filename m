Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab0GISbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 14:31:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:52306 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0GISbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 14:31:11 -0400
Date: Fri, 9 Jul 2010 18:30:51 GMT
From: tip-bot for Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com, jslaby@suse.cz
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jslaby@suse.cz, hpa@linux.intel.com
In-Reply-To: <1276720242-13365-1-git-send-email-jslaby@suse.cz>
References: <1276720242-13365-1-git-send-email-jslaby@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-64, mm: Initialize VDSO earlier on 64 bits
Message-ID: <tip-d7a0380dc3e6607d30ccdfc3cfc2ccee0d966716@git.kernel.org>
Git-Commit-ID: d7a0380dc3e6607d30ccdfc3cfc2ccee0d966716
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 09 Jul 2010 18:30:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7a0380dc3e6607d30ccdfc3cfc2ccee0d966716
Gitweb:     http://git.kernel.org/tip/d7a0380dc3e6607d30ccdfc3cfc2ccee0d966716
Author:     Jiri Slaby <jslaby@suse.cz>
AuthorDate: Wed, 16 Jun 2010 22:30:42 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 18 Jun 2010 13:48:14 -0700

x86-64, mm: Initialize VDSO earlier on 64 bits

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
LKML-Reference: <1276720242-13365-1-git-send-email-jslaby@suse.cz>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
