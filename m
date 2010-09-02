Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0IBNCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:02:03 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:59656 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab0IBNCB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Thu, 2 Sep 2010 09:02:01 -0400
Message-Id: <4C7FBC660200007800013F95@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 02 Sep 2010 14:01:58 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: make kernel_execve() suitable for stack
	 unwinding
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The explicit saving and restoring of %ebx was confusing stack unwind
data consumers, and it is plain unnecessary to do this within the
asm(), since that was only introduced for PIC user mode consumers of
the original _syscall3() macro this was derived from.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Arnd Bergmann <arnd@arndb.de>

---
 arch/x86/kernel/sys_i386_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.36-rc3/arch/x86/kernel/sys_i386_32.c
+++ 2.6.36-rc3-i386-unwind-annotations/arch/x86/kernel/sys_i386_32.c
@@ -33,8 +33,8 @@ int kernel_execve(const char *filename,
 		  const char *const envp[])
 {
 	long __res;
-	asm volatile ("push %%ebx ; movl %2,%%ebx ; int $0x80 ; pop %%ebx"
+	asm volatile ("int $0x80"
 	: "=a" (__res)
-	: "0" (__NR_execve), "ri" (filename), "c" (argv), "d" (envp) : "memory");
+	: "0" (__NR_execve), "b" (filename), "c" (argv), "d" (envp) : "memory");
 	return __res;
 }



