Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0GASlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:41:00 -0400
Received: from kroah.org ([198.145.64.141]:40517 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902Ab0GASXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:33 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:12 2010
Message-Id: <20100701173212.865339778@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Khem Raj <raj.khem@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 072/149] ARM: 6164/1: Add kto and kfrom to input operands list.
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Khem Raj <raj.khem@gmail.com>

commit 9a40ac86152c9cffd3dca482a15ddf9a8c5716b3 upstream.

When functions incoming parameters are not in input operands list gcc
4.5 does not load the parameters into registers before calling this
function but the inline assembly assumes valid addresses inside this
function. This breaks the code because r0 and r1 are invalid when
execution enters v4wb_copy_user_page ()

Also the constant needs to be used as third input operand so account
for that as well.

Tested on qemu arm.

Signed-off-by: Khem Raj <raj.khem@gmail.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mm/copypage-feroceon.c |    4 ++--
 arch/arm/mm/copypage-v4wb.c     |    4 ++--
 arch/arm/mm/copypage-v4wt.c     |    4 ++--
 arch/arm/mm/copypage-xsc3.c     |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/arm/mm/copypage-feroceon.c
+++ b/arch/arm/mm/copypage-feroceon.c
@@ -18,7 +18,7 @@ feroceon_copy_user_page(void *kto, const
 {
 	asm("\
 	stmfd	sp!, {r4-r9, lr}		\n\
-	mov	ip, %0				\n\
+	mov	ip, %2				\n\
 1:	mov	lr, r1				\n\
 	ldmia	r1!, {r2 - r9}			\n\
 	pld	[lr, #32]			\n\
@@ -64,7 +64,7 @@ feroceon_copy_user_page(void *kto, const
 	mcr	p15, 0, ip, c7, c10, 4		@ drain WB\n\
 	ldmfd	sp!, {r4-r9, pc}"
 	:
-	: "I" (PAGE_SIZE));
+	: "r" (kto), "r" (kfrom), "I" (PAGE_SIZE));
 }
 
 void feroceon_copy_user_highpage(struct page *to, struct page *from,
--- a/arch/arm/mm/copypage-v4wb.c
+++ b/arch/arm/mm/copypage-v4wb.c
@@ -27,7 +27,7 @@ v4wb_copy_user_page(void *kto, const voi
 {
 	asm("\
 	stmfd	sp!, {r4, lr}			@ 2\n\
-	mov	r2, %0				@ 1\n\
+	mov	r2, %2				@ 1\n\
 	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
 1:	mcr	p15, 0, r0, c7, c6, 1		@ 1   invalidate D line\n\
 	stmia	r0!, {r3, r4, ip, lr}		@ 4\n\
@@ -44,7 +44,7 @@ v4wb_copy_user_page(void *kto, const voi
 	mcr	p15, 0, r1, c7, c10, 4		@ 1   drain WB\n\
 	ldmfd	 sp!, {r4, pc}			@ 3"
 	:
-	: "I" (PAGE_SIZE / 64));
+	: "r" (kto), "r" (kfrom), "I" (PAGE_SIZE / 64));
 }
 
 void v4wb_copy_user_highpage(struct page *to, struct page *from,
--- a/arch/arm/mm/copypage-v4wt.c
+++ b/arch/arm/mm/copypage-v4wt.c
@@ -25,7 +25,7 @@ v4wt_copy_user_page(void *kto, const voi
 {
 	asm("\
 	stmfd	sp!, {r4, lr}			@ 2\n\
-	mov	r2, %0				@ 1\n\
+	mov	r2, %2				@ 1\n\
 	ldmia	r1!, {r3, r4, ip, lr}		@ 4\n\
 1:	stmia	r0!, {r3, r4, ip, lr}		@ 4\n\
 	ldmia	r1!, {r3, r4, ip, lr}		@ 4+1\n\
@@ -40,7 +40,7 @@ v4wt_copy_user_page(void *kto, const voi
 	mcr	p15, 0, r2, c7, c7, 0		@ flush ID cache\n\
 	ldmfd	sp!, {r4, pc}			@ 3"
 	:
-	: "I" (PAGE_SIZE / 64));
+	: "r" (kto), "r" (kfrom), "I" (PAGE_SIZE / 64));
 }
 
 void v4wt_copy_user_highpage(struct page *to, struct page *from,
--- a/arch/arm/mm/copypage-xsc3.c
+++ b/arch/arm/mm/copypage-xsc3.c
@@ -34,7 +34,7 @@ xsc3_mc_copy_user_page(void *kto, const
 {
 	asm("\
 	stmfd	sp!, {r4, r5, lr}		\n\
-	mov	lr, %0				\n\
+	mov	lr, %2				\n\
 						\n\
 	pld	[r1, #0]			\n\
 	pld	[r1, #32]			\n\
@@ -67,7 +67,7 @@ xsc3_mc_copy_user_page(void *kto, const
 						\n\
 	ldmfd	sp!, {r4, r5, pc}"
 	:
-	: "I" (PAGE_SIZE / 64 - 1));
+	: "r" (kto), "r" (kfrom), "I" (PAGE_SIZE / 64 - 1));
 }
 
 void xsc3_mc_copy_user_highpage(struct page *to, struct page *from,


