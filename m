Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab1BSB0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 20:26:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:59118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab1BSBZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 20:25:59 -0500
Date: Sat, 19 Feb 2011 01:25:13 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, castet.matthieu@free.fr, tglx@linutronix.de,
        sfr@canb.auug.org.au, hpa@linux.intel.com, rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, castet.matthieu@free.fr, tglx@linutronix.de,
        sfr@canb.auug.org.au, hpa@linux.intel.com, rjw@sisk.pl
In-Reply-To: <AANLkTikxqk=HEw9R-Du=v-1ti1HDGAY9vaNUep2XARaz@mail.gmail.com>
References: <AANLkTikxqk=HEw9R-Du=v-1ti1HDGAY9vaNUep2XARaz@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, reboot: Fix the use of passed arguments in 32-bit BIOS reboot
Message-ID: <tip-ee1b06ea6aed979da3b4e6b6ffea98ad55a3c5c1@git.kernel.org>
Git-Commit-ID: ee1b06ea6aed979da3b4e6b6ffea98ad55a3c5c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Feb 2011 01:25:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee1b06ea6aed979da3b4e6b6ffea98ad55a3c5c1
Gitweb:     http://git.kernel.org/tip/ee1b06ea6aed979da3b4e6b6ffea98ad55a3c5c1
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 18 Feb 2011 15:47:42 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 18 Feb 2011 15:47:42 -0800

x86, reboot: Fix the use of passed arguments in 32-bit BIOS reboot

The initial version of this patch had %eax being a segment and %ecx
being the mode.  I had changed the interfaces, but not the actual
implementation!

Reported-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <AANLkTikxqk=HEw9R-Du=v-1ti1HDGAY9vaNUep2XARaz@mail.gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthieu Castet <castet.matthieu@free.fr>
---
 arch/x86/kernel/reboot_32.S |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/reboot_32.S b/arch/x86/kernel/reboot_32.S
index f242356..29092b3 100644
--- a/arch/x86/kernel/reboot_32.S
+++ b/arch/x86/kernel/reboot_32.S
@@ -23,10 +23,14 @@ r_base = .
 1:	popl	%ebx
 	subl	$1b, %ebx
 
+	/* Compute the equivalent real-mode segment */
+	movl	%ebx, %ecx
+	shrl	$4, %ecx
+	
 	/* Patch post-real-mode segment jump */
-	movw	dispatch_table(%ebx,%ecx,2),%cx
-	movw	%cx, 101f(%ebx)
-	movw	%ax, 102f(%ebx)
+	movw	dispatch_table(%ebx,%eax,2),%ax
+	movw	%ax, 101f(%ebx)
+	movw	%cx, 102f(%ebx)
 
 	/* Set up the IDT for real mode. */
 	lidtl	machine_real_restart_idt(%ebx)
