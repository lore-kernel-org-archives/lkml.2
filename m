Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab0C3Snf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:43:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:41174 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab0C3Snd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:43:33 -0400
Date: Tue, 30 Mar 2010 18:42:49 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       colin.king@canonical.com, shaohua.li@intel.com, tglx@linutronix.de,
       rjw@sisk.pl
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       colin.king@canonical.com, tglx@linutronix.de, shaohua.li@intel.com,
       rjw@sisk.pl
In-Reply-To: <20100305005932.GA22675@sli10-desk.sh.intel.com>
References: <20100305005932.GA22675@sli10-desk.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32, resume: do a global tlb flush in S4 resume
Message-ID: <tip-f1ddc38590a400e19ba67963dac5bc3addc6e14b@git.kernel.org>
Git-Commit-ID: f1ddc38590a400e19ba67963dac5bc3addc6e14b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Mar 2010 18:42:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1ddc38590a400e19ba67963dac5bc3addc6e14b
Gitweb:     http://git.kernel.org/tip/f1ddc38590a400e19ba67963dac5bc3addc6e14b
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Fri, 5 Mar 2010 08:59:32 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 30 Mar 2010 10:50:42 -0700

x86-32, resume: do a global tlb flush in S4 resume

Colin King reported a strange oops in S4 resume code path (see below). The test
system has i5/i7 CPU. The kernel doesn't open PAE, so 4M page table is used.
The oops always happen a virtual address 0xc03ff000, which is mapped to the
last 4k of first 4M memory. Doing a global tlb flush fixes the issue.

EIP: 0060:[<c0493a01>] EFLAGS: 00010086 CPU: 0
EIP is at copy_loop+0xe/0x15
EAX: 36aeb000 EBX: 00000000 ECX: 00000400 EDX: f55ad46c
ESI: 0f800000 EDI: c03ff000 EBP: f67fbec4 ESP: f67fbea8
DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
...
...
CR2: 00000000c03ff000

Tested-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <20100305005932.GA22675@sli10-desk.sh.intel.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/power/hibernate_asm_32.S |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
index b641388..ad47dae 100644
--- a/arch/x86/power/hibernate_asm_32.S
+++ b/arch/x86/power/hibernate_asm_32.S
@@ -27,10 +27,17 @@ ENTRY(swsusp_arch_suspend)
 	ret
 
 ENTRY(restore_image)
+	movl	mmu_cr4_features, %ecx
 	movl	resume_pg_dir, %eax
 	subl	$__PAGE_OFFSET, %eax
 	movl	%eax, %cr3
 
+	jecxz	1f	# cr4 Pentium and higher, skip if zero
+	andl	$~(X86_CR4_PGE), %ecx
+	movl	%ecx, %cr4;  # turn off PGE
+	movl	%cr3, %eax;  # flush TLB
+	movl	%eax, %cr3
+1:
 	movl	restore_pblist, %edx
 	.p2align 4,,7
 
@@ -54,16 +61,8 @@ done:
 	movl	$swapper_pg_dir, %eax
 	subl	$__PAGE_OFFSET, %eax
 	movl	%eax, %cr3
-	/* Flush TLB, including "global" things (vmalloc) */
 	movl	mmu_cr4_features, %ecx
 	jecxz	1f	# cr4 Pentium and higher, skip if zero
-	movl	%ecx, %edx
-	andl	$~(X86_CR4_PGE), %edx
-	movl	%edx, %cr4;  # turn off PGE
-1:
-	movl	%cr3, %eax;  # flush TLB
-	movl	%eax, %cr3
-	jecxz	1f	# cr4 Pentium and higher, skip if zero
 	movl	%ecx, %cr4;  # turn PGE back on
 1:
 
