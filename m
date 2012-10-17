Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab2JQOCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:02:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33957 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab2JQOCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:02:36 -0400
MIME-Version: 1.0
In-Reply-To: <20121015013009.GB2616@ZenIV.linux.org.uk>
References: <20121001213809.GA31155@ZenIV.linux.org.uk> <20121015013009.GB2616@ZenIV.linux.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 17 Oct 2012 15:02:15 +0100
X-Google-Sender-Auth: _4scvxeI9q3JPsRCDiVqsNaevGQ
Message-ID: <CAHkRjk7QbybMx1Kc9dP-Mz_ujMmHf5htLViviNok=HKjac0G+A@mail.gmail.com>
Subject: Re: [RFC][CFT][CFReview] execve and kernel_thread unification work
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On 15 October 2012 02:30, Al Viro <viro@zeniv.linux.org.uk> wrote:
> arch-arm64 - patches from maintainer with minor followup folded

Thanks for updating the arm64 branch. I've adapted the changes, tested
and folded them into the branch below (the AArch64 instruction set
does not have conditional instructions):

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git
execve

Top commit: 6a872777ffff6184f4ac10bd71d926d5e6f2491e (arm64: Use
generic sys_execve() implementation)

The diff between your branch and mine (including one cosmetic change
as the ARM64 Kconfig selects are alphabetically sorted):

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 31e3b5e..75b212d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -6,8 +6,8 @@ config ARM64
 	select GENERIC_IOMAP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
-	select GENERIC_KERNEL_THREAD
 	select GENERIC_KERNEL_EXECVE
+	select GENERIC_KERNEL_THREAD
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index c3d650a..6165318 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -611,10 +611,10 @@ ENDPROC(ret_to_user)
  */
 ENTRY(ret_from_fork)
 	bl	schedule_tail
-	cmp	x19, #0
-	movne	x0, x20
-	blne	x19
-	get_thread_info tsk
+	cbz	x19, 1f				// not a kernel thread
+	mov	x0, x20
+	blr	x19
+1:	get_thread_info tsk
 	b	ret_to_user
 ENDPROC(ret_from_fork)


-- 
Catalin
