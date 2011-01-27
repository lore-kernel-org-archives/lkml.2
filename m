Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1A0WPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 17:15:16 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:26584 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab1A0WPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 17:15:14 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFIhi0PEiUl
X-RZG-CLASS-ID: mo00
Date: Thu, 27 Jan 2011 23:15:11 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] move x86 specific oops=panic to generic code
Message-ID: <20110127221511.GA32313@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The oops=panic cmdline option is not x86 specific, move it to generic code.
Update documentation.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 Documentation/kernel-parameters.txt       |    5 +++++
 Documentation/x86/x86_64/boot-options.txt |    5 -----
 arch/x86/kernel/dumpstack.c               |   10 ----------
 kernel/panic.c                            |   10 ++++++++++
 4 files changed, 15 insertions(+), 15 deletions(-)

--- linux-2.6.38.rc.orig/Documentation/kernel-parameters.txt
+++ linux-2.6.38.rc/Documentation/kernel-parameters.txt
@@ -1805,6 +1805,11 @@ and is between 256 and 4096 characters.
 				perfmon on Intel CPUs instead of the
 				CPU specific event set.
 
+	oops=panic	Always panic on oopses. Default is to just kill the process,
+			but there is a small probability of deadlocking the machine.
+			This will also cause panics on machine check exceptions.
+			Useful together with panic=30 to trigger a reboot.
+
 	OSS		[HW,OSS]
 			See Documentation/sound/oss/oss-parameters.txt
 
--- linux-2.6.38.rc.orig/Documentation/x86/x86_64/boot-options.txt
+++ linux-2.6.38.rc/Documentation/x86/x86_64/boot-options.txt
@@ -293,11 +293,6 @@ IOMMU (input/output memory management un
 
 Debugging
 
-  oops=panic	Always panic on oopses. Default is to just kill the process,
-		but there is a small probability of deadlocking the machine.
-		This will also cause panics on machine check exceptions.
-		Useful together with panic=30 to trigger a reboot.
-
   kstack=N	Print N words from the kernel stack in oops dumps.
 
   pagefaulttrace  Dump all page faults. Only useful for extreme debugging
--- linux-2.6.38.rc.orig/arch/x86/kernel/dumpstack.c
+++ linux-2.6.38.rc/arch/x86/kernel/dumpstack.c
@@ -345,16 +345,6 @@ die_nmi(char *str, struct pt_regs *regs,
 	do_exit(SIGBUS);
 }
 
-static int __init oops_setup(char *s)
-{
-	if (!s)
-		return -EINVAL;
-	if (!strcmp(s, "panic"))
-		panic_on_oops = 1;
-	return 0;
-}
-early_param("oops", oops_setup);
-
 static int __init kstack_setup(char *s)
 {
 	if (!s)
--- linux-2.6.38.rc.orig/kernel/panic.c
+++ linux-2.6.38.rc/kernel/panic.c
@@ -433,3 +433,13 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
+
+static int __init oops_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	if (!strcmp(s, "panic"))
+		panic_on_oops = 1;
+	return 0;
+}
+early_param("oops", oops_setup);
