Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2IJIkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:40:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56939 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2IJIki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:40:38 -0400
Date: Mon, 10 Sep 2012 09:40:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chanho Min <chanho0207@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Stephen Warren <swarren@nvidia.com>,
        David Howells <dhowells@redhat.com>, Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH] ARM: Fix build warning in do_alignment.
Message-ID: <20120910084025.GP13739@n2100.arm.linux.org.uk>
References: <CAOAMb1CTk1_dQAUiHy5ch=UxN7vSe0of81KcKbjPjCFqR9e9tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAMb1CTk1_dQAUiHy5ch=UxN7vSe0of81KcKbjPjCFqR9e9tw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 12:25:15PM +0900, Chanho Min wrote:
> Fix the following build warning:
> 
> arch/arm/mm/alignment.c: In function 'do_alignment':
> arch/arm/mm/alignment.c:327:15: warning: 'offset.un' may be used
> uninitialized in this function [-Wuninitialized]
> arch/arm/mm/alignment.c:749:21: note: 'offset.un' was declared here
> 
> Signed-off-by: Chanho Min <chanho.min@lge.com>

The compiler is being silly - notice that it is saying "may" not "is".
In this case, it will not be uninitialized prior to use.

What it's caused by is do_alignment_t32_to_handler(), and its assignment
through a pointer of this variable.  You can see that this is the cause
because the patch below fixes the warning.

It's all about whether gcc can prove that the variable is or is not
assigned.  It has one warning for the 'provably not assigned' case, and
another for the 'can't prove that it is always assigned' case.

Anyway, normally we don't fix warnings where the compiler is wrong (but
we encourage the compiler guys to fix the compiler instead.)

 arch/arm/mm/alignment.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 6d6790e..5ce7733 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -699,7 +699,6 @@ do_alignment_t32_to_handler(unsigned long *pinstr, struct pt_regs *regs,
 	unsigned long instr = *pinstr;
 	u16 tinst1 = (instr >> 16) & 0xffff;
 	u16 tinst2 = instr & 0xffff;
-	poffset->un = 0;
 
 	switch (tinst1 & 0xffe0) {
 	/* A6.3.5 Load/Store multiple */
@@ -854,9 +853,10 @@ do_alignment(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 		break;
 
 	case 0x08000000:	/* ldm or stm, or thumb-2 32bit instruction */
-		if (thumb2_32b)
+		if (thumb2_32b) {
+			offset.un = 0;
 			handler = do_alignment_t32_to_handler(&instr, regs, &offset);
-		else
+		} else
 			handler = do_alignment_ldmstm;
 		break;
 

