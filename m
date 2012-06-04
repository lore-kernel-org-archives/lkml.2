Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2FDT4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:56:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab2FDT4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:56:12 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
Date: Mon,  4 Jun 2012 15:56:03 -0400
Message-Id: <1338839763-11140-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was reported that compiling for 32-bit caused a bunch of section
mismatch warnings:

 VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  LD      arch/x86/built-in.o
WARNING: arch/x86/built-in.o(.data+0x5af0): Section mismatch in reference from the variable
test_nmi_ipi_callback_na.10451 to the function .init.text:test_nmi_ipi_callback()
The variable test_nmi_ipi_callback_na.10451 references
the function __init test_nmi_ipi_callback()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

WARNING: arch/x86/built-in.o(.data+0x5b04): Section mismatch in reference from the variable
nmi_unk_cb_na.10399 to the function .init.text:nmi_unk_cb()
The variable nmi_unk_cb_na.10399 references
the function __init nmi_unk_cb()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Both of these are attributed to the callback functions of this self contained
test.  It seems this happened when the function added new __init sections in
commit f0ba662.

I fixed this by converting the callback functions from __init to __ref.  The file
compiles and boots on my machine for 32-bit and 64-bit.

Not sure why 64-bit never showed this warning.  Nor am I entirely sure why this
warning popped up to begin with.

Let me know if there is a better way to fix this.

Reported-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/nmi_selftest.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
index e31bf8d..692e453 100644
--- a/arch/x86/kernel/nmi_selftest.c
+++ b/arch/x86/kernel/nmi_selftest.c
@@ -33,7 +33,7 @@ static int __initdata expected_testcase_failures;
 static int __initdata unexpected_testcase_failures;
 static int __initdata unexpected_testcase_unknowns;
 
-static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
+static int __ref nmi_unk_cb(unsigned int val, struct pt_regs *regs)
 {
 	unexpected_testcase_unknowns++;
 	return NMI_HANDLED;
@@ -50,7 +50,7 @@ static void __init cleanup_nmi_testsuite(void)
 	unregister_nmi_handler(NMI_UNKNOWN, "nmi_selftest_unk");
 }
 
-static int __init test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
+static int __ref test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
 {
         int cpu = raw_smp_processor_id();
 
-- 
1.7.7.6

