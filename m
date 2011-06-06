Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab1FFOr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756749Ab1FFOrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:47:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] MN10300: die_if_no_fixup() shouldn't use get_user() as it
 doesn't call set_fs()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Mon, 06 Jun 2011 15:47:14 +0100
Message-ID: <20110606144714.19155.2243.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110606144705.19155.22278.stgit@warthog.procyon.org.uk>
References: <20110606144705.19155.22278.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

die_if_no_fixup() shouldn't use get_user() as it doesn't call set_fs() to
indicate that it wants to probe a kernel address.  Instead it should use
probe_kernel_read().

This fixes the problem of gdb seeing SIGILL rather than SIGTRAP when hitting
the KGDB special breakpoint upon SysRq+g being seen.  The problem was that
die_if_no_fixup() was failing to read the opcode of the instruction that caused
the exception, and thus not fixing up the exception.

This caused gdb to get a S04 response to the $? request in its remote protocol
rather than S05 - which would then cause it to continue with $C04 rather than
$c in an attempt to pass the signal onto the inferior process.  The kernel,
however, does not support $Cnn, and so objects by returning an E22 response,
indicating an error.  gdb does not expect this and prints:

	warning: Remote failure reply: E22

and then returns to the gdb command prompt unable to continue.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/traps.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index f03cb27..bd3e5e7 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -28,7 +28,7 @@
 #include <linux/irq.h>
 #include <asm/processor.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/io.h>
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -156,7 +156,7 @@ int die_if_no_fixup(const char *str, struct pt_regs *regs,
 
 	case EXCEP_TRAP:
 	case EXCEP_UNIMPINS:
-		if (get_user(opcode, (uint8_t __user *)regs->pc) != 0)
+		if (probe_kernel_read(&opcode, (u8 *)regs->pc, 1) < 0)
 			break;
 		if (opcode == 0xff) {
 			if (notify_die(DIE_BREAKPOINT, str, regs, code, 0, 0))

