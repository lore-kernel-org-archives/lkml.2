Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2EJHLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:11:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:53882 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612Ab2EJHL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:11:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141270092"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, hpa@linux.intel.com,
        paolo.bonzini@lu.unisi.ch, Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] x86, realmode: fix no cache bits test in reboot_32.S
Date: Thu, 10 May 2012 10:11:38 +0300
Message-Id: <1336633898-23743-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the new real-mode code infrastructure %edx was
used for testing CD and NW bits with andl in order to
decide whether to flush the processor caches or not.
The value of cr0 was also stored in %eax, which was
later used to set cr0 after masking out lower byte
(except TS bit) in order to enter real-mode.

In the new real-mode code infrastructure we wanted to
keep input parameter in %eax so we are using %edx for
both cr0 cases. This has caused regression since andl
overwrites the value of %edx.

This patch fixes the issue by replacing andl with testl,
which is essentially andl without writing result to the
register.

Special thanks to Paolo Bonzini for noting this and
proposing a fix.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/realmode/rm/reboot_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/realmode/rm/reboot_32.S b/arch/x86/realmode/rm/reboot_32.S
index 8d9bfd1..1140448 100644
--- a/arch/x86/realmode/rm/reboot_32.S
+++ b/arch/x86/realmode/rm/reboot_32.S
@@ -76,7 +76,7 @@ machine_real_restart_asm16:
 	movl	%edx, %cr0
 	movl	%ecx, %cr3
 	movl	%cr0, %edx
-	andl	$0x60000000, %edx	/* If no cache bits -> no wbinvd */
+	testl	$0x60000000, %edx	/* If no cache bits -> no wbinvd */
 	jz	2f
 	wbinvd
 2:
-- 
1.7.9.5

