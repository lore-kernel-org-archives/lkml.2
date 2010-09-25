Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab0IYUHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 16:07:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58269 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab0IYUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 16:07:18 -0400
Date: Sat, 25 Sep 2010 21:07:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rth@twiddle.net, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fix hae_cache race in RESTORE_ALL
Message-ID: <20100925200714.GY19804@ZenIV.linux.org.uk>
References: <20100925181304.GV19804@ZenIV.linux.org.uk>
 <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want interrupts disabled on all paths leading to RESTORE_ALL;
otherwise, we are risking an IRQ coming between the updates of
alpha_mv->hae_cache and *alpha_mv->hae_register and set_hae()
within the IRQ getting badly confused.

RESTORE_ALL used to play with disabling IRQ itself, but that got
removed back in 2002, without making sure we had them disabled
on all paths.  It's cheaper to make sure we have them disabled than
to revert to original variant...

Remove the detritus left from that commit back in 2002; we used to
need a reload of $0 and $1 since swpipl would change those, but
doing that had become pointless when we stopped doing swpipl in
there...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/entry.S |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/kernel/entry.S b/arch/alpha/kernel/entry.S
index ab1ee0a..c674b92 100644
--- a/arch/alpha/kernel/entry.S
+++ b/arch/alpha/kernel/entry.S
@@ -73,8 +73,6 @@
 	ldq	$20, HAE_REG($19);	\
 	stq	$21, HAE_CACHE($19);	\
 	stq	$21, 0($20);		\
-	ldq	$0, 0($sp);		\
-	ldq	$1, 8($sp);		\
 99:;					\
 	ldq	$19, 72($sp);		\
 	ldq	$20, 80($sp);		\
@@ -316,7 +314,7 @@ ret_from_sys_call:
 	cmovne	$26, 0, $19		/* $19 = 0 => non-restartable */
 	ldq	$0, SP_OFF($sp)
 	and	$0, 8, $0
-	beq	$0, restore_all
+	beq	$0, ret_to_kernel
 ret_to_user:
 	/* Make sure need_resched and sigpending don't change between
 		sampling and the rti.  */
@@ -328,6 +326,10 @@ ret_to_user:
 restore_all:
 	RESTORE_ALL
 	call_pal PAL_rti
+ret_to_kernel:
+	lda	$16, 7
+	call_pal PAL_swpipl
+	br restore_all
 
 	.align 3
 $syscall_error:
@@ -657,7 +659,7 @@ kernel_thread:
 	/* We don't actually care for a3 success widgetry in the kernel.
 	   Not for positive errno values.  */
 	stq	$0, 0($sp)		/* $0 */
-	br	restore_all
+	br	ret_to_kernel
 .end kernel_thread
 
 /*
-- 
1.5.6.5

