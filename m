Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2EKCwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 22:52:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55962 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401Ab2EKCwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 22:52:09 -0400
Date: Thu, 10 May 2012 19:51:54 -0700
From: tip-bot for Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Message-ID: <tip-34d0b02e08470c56a411ba6da1f377bc6da02826@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        pbonzini@redhat.com, jarkko.sakkinen@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, jarkko.sakkinen@intel.com,
        hpa@linux.intel.com
In-Reply-To: <1336633898-23743-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1336633898-23743-1-git-send-email-jarkko.sakkinen@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86, realmode:
  Fix no cache bits test in reboot_32.S
Git-Commit-ID: 34d0b02e08470c56a411ba6da1f377bc6da02826
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 19:52:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34d0b02e08470c56a411ba6da1f377bc6da02826
Gitweb:     http://git.kernel.org/tip/34d0b02e08470c56a411ba6da1f377bc6da02826
Author:     Jarkko Sakkinen <jarkko.sakkinen@intel.com>
AuthorDate: Thu, 10 May 2012 10:11:38 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 10 May 2012 19:31:22 -0700

x86, realmode: Fix no cache bits test in reboot_32.S

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

Reported-and-tested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Link: http://lkml.kernel.org/r/1336633898-23743-1-git-send-email-jarkko.sakkinen@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/realmode/rm/reboot_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
