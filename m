Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab1FUTKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 15:10:21 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:45008 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224Ab1FUTKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 15:10:19 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1308683405!23160978!28
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: quiet sparse noise due to __ARCH_WANT_SYS_RT_SIG(ACTION|SUSPEND)
Date: Tue, 21 Jun 2011 12:09:45 -0700
User-Agent: KMail/1.9.9
CC: ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <mikpe@it.uu.se>,
        <ebiederm@xmission.com>, <vapier@gentoo.org>, <tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106211209.46462.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM defines __ARCH_WANT_SYS_RT_SIG(ACTION|SUSPEND) which
produces the following sparse warnings in kernel/signal.c:

  warning: symbol 'sys_rt_sigaction' was not declared. Should it be static?
  warning: symbol 'sys_rt_sigsuspend' was not declared. Should it be static?

Since ARM doesn't include <asm-generic/syscalls.h>, due to different
calling conventions for some system calls, prototype the functions
in <asm/unistd.h> to quiet the noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Tony Luck <tony.luck@intel.com>

---

diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
index 2c04ed5..322c54e 100644
--- a/arch/arm/include/asm/unistd.h
+++ b/arch/arm/include/asm/unistd.h
@@ -467,6 +467,20 @@
 #define __ARCH_WANT_SYS_SOCKETCALL
 #endif
 
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <linux/linkage.h>
+#include <linux/compiler.h>
+#include <linux/signal.h>
+
+asmlinkage long sys_rt_sigaction(int sig, const struct sigaction __user *act,
+				 struct sigaction __user *oact,
+				 size_t sigsetsize);
+asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize);
+
+#endif /* !__ASSEMBLY__ */
+
 /*
  * "Conditional" syscalls
  *
