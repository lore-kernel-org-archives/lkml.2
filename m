Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab0CaSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:25:56 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:52350 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab0CaSZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JGndETRWjMhjnnHQascTU/cGxs1GCJ+dqIkr0jNnYq5hvBoFornYcQK63S/18FRsHV
         X1fGRlzBiVhtsC/4DUZvYgevJzcYgCBFaHgvcdRG39LjQYbKKT5XZrxwAnvGH6Mt6pvN
         I8wsuhRIcPruRYnuLYpOjg7bucEOexbk4rluQ=
Date: Wed, 31 Mar 2010 23:55:18 +0530
From: Rabin Vincent <rabin@rab.in>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/10] ARM: ftrace: add Thumb-2 support
Message-ID: <20100331182518.GA30522@debian>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
 <1268462987-8271-7-git-send-email-rabin@rab.in>
 <tnxsk80r2dh.fsf@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tnxsk80r2dh.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 10:23:54AM +0000, Catalin Marinas wrote:
> If the ftrace_stub isn't .globl, the code compiles fine. My approach
> would be something like this:

New patch below:

>From bf828a0c069b1bb3f6bf4e68f1dceecab396c286 Mon Sep 17 00:00:00 2001
From: Rabin Vincent <rabin@rab.in>
Date: Sun, 14 Feb 2010 01:18:34 +0530
Subject: [PATCH 06/10] ARM: ftrace: add Thumb-2 support

Fix the mcount routines to build and run on a kernel built with the
Thumb-2 instruction set by correcting the following errors using the
fixes suggested by Catalin Marinas:

 - Problem: The following assembler errors appear at the "adr r0,
   ftrace_stub" instruction:

   entry-common.S: Assembler messages:
   entry-common.S:179: Error: invalid immediate for address calculation (value = 0x00000004)

   Fix: The errors don't occur with a non-global symbol, so use one.

 - Problem: The "mov lr, pc" does not set the lsb when storing the pc in
   lr.  The called function returns with "bx lr", and the mode changes
   to ARM.

   Fix: Add a label on the return address and use "adr lr, BSYM(label)".

We don't modify the old mcount because it won't be built when using
Thumb-2.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/kernel/entry-common.S |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index c7a8c20..f5e75de 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -167,7 +167,7 @@ ENTRY(__gnu_mcount_nc)
 	stmdb	sp!, {r0-r3, lr}
 	ldr	r0, =ftrace_trace_function
 	ldr	r2, [r0]
-	adr	r0, ftrace_stub
+	adr	r0, .Lftrace_stub
 	cmp	r0, r2
 	bne	gnu_trace
 	ldmia	sp!, {r0-r3, ip, lr}
@@ -177,8 +177,9 @@ gnu_trace:
 	ldr	r1, [sp, #20]			@ lr of instrumented routine
 	mov	r0, lr
 	sub	r0, r0, #MCOUNT_INSN_SIZE
-	mov	lr, pc
+	adr	lr, BSYM(1f)
 	mov	pc, r2
+1:
 	ldmia	sp!, {r0-r3, ip, lr}
 	mov	pc, ip
 ENDPROC(__gnu_mcount_nc)
@@ -213,6 +214,7 @@ ENDPROC(mcount)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 ENTRY(ftrace_stub)
+.Lftrace_stub:
 	mov	pc, lr
 ENDPROC(ftrace_stub)
 
-- 
1.7.0

