Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab1EBWZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:25:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:39448 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009Ab1EBWZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:25:17 -0400
Date: Mon, 2 May 2011 22:25:07 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-08os5wi3yq1no0y4i5m4z7he@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        alexey.zaytsev@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alexey.zaytsev@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, reboot: Fix relocations in reboot_32.S
Git-Commit-ID: 7806a49ab625ebeb1709e5e87299b64932b807a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 02 May 2011 22:25:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7806a49ab625ebeb1709e5e87299b64932b807a7
Gitweb:     http://git.kernel.org/tip/7806a49ab625ebeb1709e5e87299b64932b807a7
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 2 May 2011 14:33:24 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 2 May 2011 14:44:46 -0700

x86, reboot: Fix relocations in reboot_32.S

The use of base for %ebx in this file is arbitrary, *except* that we
also use it to compute the real-mode segment.  Therefore, make it so
that r_base really is the true address to which %ebx points.

This resolves kernel bugzilla 33302.

Reported-and-tested-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/n/tip-08os5wi3yq1no0y4i5m4z7he@git.kernel.org
---
 arch/x86/kernel/reboot_32.S |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/reboot_32.S b/arch/x86/kernel/reboot_32.S
index 29092b3..1d5c46d 100644
--- a/arch/x86/kernel/reboot_32.S
+++ b/arch/x86/kernel/reboot_32.S
@@ -21,26 +21,26 @@ r_base = .
 	/* Get our own relocated address */
 	call	1f
 1:	popl	%ebx
-	subl	$1b, %ebx
+	subl	$(1b - r_base), %ebx
 
 	/* Compute the equivalent real-mode segment */
 	movl	%ebx, %ecx
 	shrl	$4, %ecx
 	
 	/* Patch post-real-mode segment jump */
-	movw	dispatch_table(%ebx,%eax,2),%ax
-	movw	%ax, 101f(%ebx)
-	movw	%cx, 102f(%ebx)
+	movw	(dispatch_table - r_base)(%ebx,%eax,2),%ax
+	movw	%ax, (101f - r_base)(%ebx)
+	movw	%cx, (102f - r_base)(%ebx)
 
 	/* Set up the IDT for real mode. */
-	lidtl	machine_real_restart_idt(%ebx)
+	lidtl	(machine_real_restart_idt - r_base)(%ebx)
 
 	/*
 	 * Set up a GDT from which we can load segment descriptors for real
 	 * mode.  The GDT is not used in real mode; it is just needed here to
 	 * prepare the descriptors.
 	 */
-	lgdtl	machine_real_restart_gdt(%ebx)
+	lgdtl	(machine_real_restart_gdt - r_base)(%ebx)
 
 	/*
 	 * Load the data segment registers with 16-bit compatible values
