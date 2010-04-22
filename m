Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab0DVT2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:44 -0400
Received: from kroah.org ([198.145.64.141]:40898 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab0DVT2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:40 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:15 2010
Message-Id: <20100422190915.352290938@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shaohua Li <shaohua.li@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [089/197] x86-32, resume: do a global tlb flush in S4 resume
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohua Li <shaohua.li@intel.com>

commit 8ae06d223f8203c72104e5c0c4ee49a000aedb42 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/power/hibernate_asm_32.S |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

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
 


