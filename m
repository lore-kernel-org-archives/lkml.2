Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046Ab2EJRrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:47:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45282 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760365Ab2EJReL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:11 -0400
Message-Id: <20120510173134.346026244@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Paris <eparis@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 16/52] ARM: 7411/1: audit: fix treatment of saved ip register during syscall tracing
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 6a68b6f574c8ad2c1d90f0db8fd95b8abe8a0a73 upstream.

The ARM audit code incorrectly uses the saved application ip register
value to infer syscall entry or exit. Additionally, the saved value will
be clobbered if the current task is not being traced, which can lead to
libc corruption if ip is live (apparently glibc uses it for the TLS
pointer).

This patch fixes the syscall tracing code so that the why parameter is
used to infer the syscall direction and the saved ip is only updated if
we know that we will be signalling a ptrace trap.

Reported-and-Tested-by: Jon Masters <jcm@jonmasters.org>

Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/ptrace.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -915,14 +915,7 @@ asmlinkage int syscall_trace(int why, st
 {
 	unsigned long ip;
 
-	/*
-	 * Save IP.  IP is used to denote syscall entry/exit:
-	 *  IP = 0 -> entry, = 1 -> exit
-	 */
-	ip = regs->ARM_ip;
-	regs->ARM_ip = why;
-
-	if (!ip)
+	if (why)
 		audit_syscall_exit(regs);
 	else
 		audit_syscall_entry(AUDIT_ARCH_NR, scno, regs->ARM_r0,
@@ -935,6 +928,13 @@ asmlinkage int syscall_trace(int why, st
 
 	current_thread_info()->syscall = scno;
 
+	/*
+	 * IP is used to denote syscall entry/exit:
+	 * IP = 0 -> entry, =1 -> exit
+	 */
+	ip = regs->ARM_ip;
+	regs->ARM_ip = why;
+
 	/* the 0x80 provides a way for the tracing parent to distinguish
 	   between a syscall stop and SIGTRAP delivery */
 	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)


