Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1GNUfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 16:35:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:53946 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab1GNUfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 16:35:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=riinYISUb4YHLthk1yL+C53VGv5mZct05MqfsjTQrss6VDukoKNWwGRqtaJvy1k6Z
	e/SyDIuzWOmLTKfk5dwrw==
From: Mike Waychison <mikew@google.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mike Waychison <mikew@google.com>
Subject: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
Date: Thu, 14 Jul 2011 13:34:53 -0700
Message-Id: <1310675693-9204-2-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310675693-9204-1-git-send-email-mikew@google.com>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some build environments, it is useful to allow disabling of IO
accesses to hardware, without having to rely on CAP_SYS_RAWIO (which is
already overloaded to mean many other things).  One way that userland
has access to IO accesses is via the iopl(2) and ioperm(2) system calls.

Allow disabling of these system calls from ever being available via a
configuration option, X86_SYS_IOPL.   This is implemented by simply
stubbing out the system calls and having them return ENOSYS when their
functionality is disabled.

Note that we default this option to 'y', so that existing kernel configs
will continue to support sys_iopl and sys_ioperm as before.

Google-Bug-Id: 3177114
Signed-off-by: Mike Waychison <mikew@google.com>
---
 arch/x86/Kconfig         |   12 ++++++++++++
 arch/x86/kernel/ioport.c |   12 ++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..295ae4d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1497,6 +1497,18 @@ config CC_STACKPROTECTOR
 	  detected and for those versions, this configuration option is
 	  ignored. (and a warning is printed during bootup)
 
+config X86_SYS_IOPL
+	bool "Enable use of sys_iopl and sys_ioperm system calls"
+	default y
+	---help---
+	  The sys_iopl and sys_ioperm allow applications that have the
+	  CAP_SYS_RAWIO to elevate their priviledge level so that they
+	  can perform IO accesses directly from userland.  This
+	  functionality is often used by userland drivers to drive
+	  hardware directly, bypassing the kernel.  Disabling this
+	  option may break certain hardware functions, so if in doubt,
+	  say yes.
+
 source kernel/Kconfig.hz
 
 config KEXEC
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 8c96897..709db2f 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -17,6 +17,7 @@
 #include <linux/bitmap.h>
 #include <asm/syscalls.h>
 
+#ifdef CONFIG_X86_SYS_IOPL
 /*
  * this changes the io permissions bitmap in the current task.
  */
@@ -111,3 +112,14 @@ long sys_iopl(unsigned int level, struct pt_regs *regs)
 
 	return 0;
 }
+
+#else /* CONFIG_X86_SYS_IOPL */
+
+asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on) {
+	return -ENOSYS;
+}
+
+long sys_iopl(unsigned int level, struct pt_regs *regs) {
+	return -ENOSYS;
+}
+#endif /* CONFIG_X86_SYS_IOPL */
-- 
1.7.3.1

