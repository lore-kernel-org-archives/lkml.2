Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1KQWil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:38:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:12670 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab1KQWhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:37:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="77077676"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 4/8] x86-64, ia32: Move compat_ni_syscall into C and its own file
Date: Thu, 17 Nov 2011 14:37:22 -0800
Message-Id: <1321569446-20433-5-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Move compat_ni_syscall out of ia32entry.S and into its own .c file.
Although this is a trivial function, it is not performance-critical,
and this will simplify further cleanups.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/ia32/Makefile    |    1 +
 arch/x86/ia32/ia32entry.S |    3 ---
 arch/x86/ia32/nosyscall.c |    7 +++++++
 3 files changed, 8 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/ia32/nosyscall.c

diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index 52d0ccf..eea9a1c 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o
+obj-$(CONFIG_IA32_EMULATION) += nosyscall.o
 
 sysv-$(CONFIG_SYSVIPC) := ipc32.o
 obj-$(CONFIG_IA32_EMULATION) += $(sysv-y)
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a6253ec..59538a7 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -453,9 +453,6 @@ ia32_badsys:
 	movq $-ENOSYS,%rax
 	jmp ia32_sysret
 
-quiet_ni_syscall:
-	movq $-ENOSYS,%rax
-	ret
 	CFI_ENDPROC
 	
 	.macro PTREGSCALL label, func, arg
diff --git a/arch/x86/ia32/nosyscall.c b/arch/x86/ia32/nosyscall.c
new file mode 100644
index 0000000..51ecd5b
--- /dev/null
+++ b/arch/x86/ia32/nosyscall.c
@@ -0,0 +1,7 @@
+#include <linux/kernel.h>
+#include <linux/errno.h>
+
+long compat_ni_syscall(void)
+{
+	return -ENOSYS;
+}
-- 
1.7.6.4

