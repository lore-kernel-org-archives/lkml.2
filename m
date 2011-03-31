Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab1CaSDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:03:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34779 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab1CaSDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=vd4twa0qKmkXiVY0VCCDTXgV3Mwlc+c18n4tMxO0h4JtwIbELgpVw/0PV5APYAFGvo
         aQzpMKBoK009hSsYnyPCD3jMFEHOKzFnNwS7gK1/phGbB0JQ5MJF7U4mLrXVWWWp28Z4
         5T5/kO9uNYKOMEiJHr59y9Ujb8INyzqQ1nvzY=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        cl@linux-foundation.org, yinghai@kernel.org
Cc: torvalds@linux-foundation.org, aarcange@redhat.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] x86-32: Remove restrictions on ARCH_SUPPORTS_MEMORY_FAILURE
Date: Thu, 31 Mar 2011 20:02:45 +0200
Message-Id: <1301594566-10139-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301594566-10139-1-git-send-email-tj@kernel.org>
References: <1301594566-10139-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d949f36f18 (x86: Fix hwpoison code related build failure on 32-bit
NUMAQ) disabled ARCH_SUPPORTS_MEMORY_FAILURE on some 32bit
configurations because the extra page flag usage triggered build
failure when combined with memory section/node bits.

The root cause of build failures depending on config options is
SECTIONS_WIDTH difference depending on X86_PAE.  As the previous patch
removes the problem, we can remove the restrictions on MEMORY_FAILURE.

This makes the configuration more consistent.  For example,
TRANSPARENT_HUGEPAGE also consumes a page flag but didn't trigger
build failure thanks to the removal of PG_buddy and Kconfig ends up
enforcing rather arbitrary preference for TRANSPARENT_HUGEPAGE over
MEMORY_FAILURE.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0db96ae..7f83405 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -446,16 +446,6 @@ config X86_NUMAQ
 	  of Flat Logical.  You will need a new lynxer.elf file to flash your
 	  firmware with - send email to <Martin.Bligh@us.ibm.com>.
 
-config X86_SUPPORTS_MEMORY_FAILURE
-	def_bool y
-	# MCE code calls memory_failure():
-	depends on X86_MCE
-	# On 32-bit this adds too big of NODES_SHIFT and we run out of page flags:
-	depends on !X86_NUMAQ
-	# On 32-bit SPARSEMEM adds too big of SECTIONS_WIDTH:
-	depends on X86_64 || !SPARSEMEM
-	select ARCH_SUPPORTS_MEMORY_FAILURE
-
 config X86_VISWS
 	bool "SGI 320/540 (Visual Workstation)"
 	depends on X86_32 && PCI && X86_MPPARSE && PCI_GODIRECT
@@ -845,6 +835,7 @@ config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 
 config X86_MCE
 	bool "Machine Check / overheating reporting"
+	select ARCH_SUPPORTS_MEMORY_FAILURE
 	---help---
 	  Machine Check support allows the processor to notify the
 	  kernel if it detects a problem (e.g. overheating, data corruption).
-- 
1.7.1

