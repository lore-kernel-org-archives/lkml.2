Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0ICHNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:13:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:44430 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab0ICHNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:13:34 -0400
Date: Fri, 3 Sep 2010 07:13:10 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, hpa@zytor.com,
        mingo@redhat.com, jbeulich@novell.com, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, jbeulich@novell.com, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C7FBC660200007800013F95@vpn.id2.novell.com>
References: <4C7FBC660200007800013F95@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] i386: Make kernel_execve() suitable for stack unwinding
Message-ID: <tip-7fe977dab356fbd7e86aa10bf83891761107c57c@git.kernel.org>
Git-Commit-ID: 7fe977dab356fbd7e86aa10bf83891761107c57c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 07:13:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fe977dab356fbd7e86aa10bf83891761107c57c
Gitweb:     http://git.kernel.org/tip/7fe977dab356fbd7e86aa10bf83891761107c57c
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 2 Sep 2010 14:01:58 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Sep 2010 08:16:02 +0200

i386: Make kernel_execve() suitable for stack unwinding

The explicit saving and restoring of %ebx was confusing stack
unwind data consumers, and it is plain unnecessary to do this
within the asm(), since that was only introduced for PIC user
mode consumers of the original _syscall3() macro this was
derived from.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <4C7FBC660200007800013F95@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/sys_i386_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index d5e0662..0b0cb5f 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
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
