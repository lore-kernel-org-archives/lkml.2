Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2I0GLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:11:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54775 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab2I0GLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:11:14 -0400
Date: Wed, 26 Sep 2012 23:11:03 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-5a5a51db78ef24aa61a4cb2ae36f07f6fa37356d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1348529239-17943-1-git-send-email-hpa@linux.intel.com>
References: <1348529239-17943-1-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86-32: Start out eflags and cr4 clean
Git-Commit-ID: 5a5a51db78ef24aa61a4cb2ae36f07f6fa37356d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 23:11:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a5a51db78ef24aa61a4cb2ae36f07f6fa37356d
Gitweb:     http://git.kernel.org/tip/5a5a51db78ef24aa61a4cb2ae36f07f6fa37356d
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 24 Sep 2012 16:05:48 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 26 Sep 2012 15:06:22 -0700

x86-32: Start out eflags and cr4 clean

%cr4 is supposed to reflect a set of features into which the operating
system is opting in.  If the BIOS or bootloader leaks bits here, this
is not desirable.  Consider a bootloader passing in %cr4.pae set to a
legacy paging kernel, for example -- it will not have any immediate
effect, but the kernel would crash when turning paging on.

A similar argument applies to %eflags, and since we have to look for
%eflags.id being settable we can use a sequence which clears %eflags
as a side effect.

Note that we already do this for x86-64.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1348529239-17943-1-git-send-email-hpa@linux.intel.com
---
 arch/x86/kernel/head_32.S |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index d42ab17..957a47a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -287,27 +287,28 @@ ENTRY(startup_32_smp)
 	leal -__PAGE_OFFSET(%ecx),%esp
 
 default_entry:
-
 /*
  *	New page tables may be in 4Mbyte page mode and may
  *	be using the global pages. 
  *
  *	NOTE! If we are on a 486 we may have no cr4 at all!
- *	So we do not try to touch it unless we really have
- *	some bits in it to set.  This won't work if the BSP
- *	implements cr4 but this AP does not -- very unlikely
- *	but be warned!  The same applies to the pse feature
- *	if not equally supported. --macro
- *
- *	NOTE! We have to correct for the fact that we're
- *	not yet offset PAGE_OFFSET..
+ *	Specifically, cr4 exists if and only if CPUID exists,
+ *	which in turn exists if and only if EFLAGS.ID exists.
  */
-#define cr4_bits pa(mmu_cr4_features)
-	movl cr4_bits,%edx
-	andl %edx,%edx
-	jz 6f
-	movl %cr4,%eax		# Turn on paging options (PSE,PAE,..)
-	orl %edx,%eax
+	movl $X86_EFLAGS_ID,%ecx
+	pushl %ecx
+	popfl
+	pushfl
+	popl %eax
+	pushl $0
+	popfl
+	pushfl
+	popl %edx
+	xorl %edx,%eax
+	testl %ecx,%eax
+	jz 6f			# No ID flag = no CPUID = no CR4
+
+	movl pa(mmu_cr4_features),%eax
 	movl %eax,%cr4
 
 	testb $X86_CR4_PAE, %al		# check if PAE is enabled
