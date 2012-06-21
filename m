Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab2FUPHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 11:07:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50268 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044Ab2FUPHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 11:07:22 -0400
Date: Thu, 21 Jun 2012 08:07:06 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-3i0pfh44c1e3jv5lab0cf7sc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] x86, reboot: Drop redundant write of reboot_mode
Git-Commit-ID: 2b1b712f050eaf0ac576591281446dc960c0afc5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 21 Jun 2012 08:07:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b1b712f050eaf0ac576591281446dc960c0afc5
Gitweb:     http://git.kernel.org/tip/2b1b712f050eaf0ac576591281446dc960c0afc5
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 20 Jun 2012 21:18:14 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 20 Jun 2012 21:18:14 -0700

x86, reboot: Drop redundant write of reboot_mode

We write reboot_mode to BIOS location 0x472 in
native_machine_emergency_restart() (reboot.c:542) already, there is no
need to then write it again in machine_real_restart().

This means nothing gets written there for MRR_APM, but the APM call is
a poweroff call and doesn't use this memory location.

Link: http://lkml.kernel.org/n/tip-3i0pfh44c1e3jv5lab0cf7sc@git.kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/reboot.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 6ddb9cd..6ef559f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -179,14 +179,6 @@ void __noreturn machine_real_restart(unsigned int type)
 	write_cr3(real_mode_header->trampoline_pgd);
 #endif
 
-	/*
-	 * Write 0x1234 to absolute memory location 0x472.  The BIOS reads
-	 * this on booting to tell it to "Bypass memory test (also warm
-	 * boot)".  This seems like a fairly standard thing that gets set by
-	 * REBOOT.COM programs, and the previous reset routine did this
-	 * too. */
-	*((unsigned short *)0x472) = reboot_mode;
-
 	/* Jump to the identity-mapped low memory code */
 #ifdef CONFIG_X86_32
 	asm volatile("jmpl *%0" : :
