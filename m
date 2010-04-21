Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab0DUTWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:22:42 -0400
Received: from kelvin.asmallorange.com ([207.210.111.10]:35540 "EHLO
	kelvin.asmallorange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab0DUTWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:22:40 -0400
Date: Thu, 22 Apr 2010 00:53:19 +0530
From: Rabin Vincent <rabin@rab.in>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Abhishek Sagar <sagar.abhishek@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/10] ARM: ftrace: add ENDPROC annotations
Message-ID: <20100421192319.GA16719@debian>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
 <1268462987-8271-6-git-send-email-rabin@rab.in>
 <20100313084546.GA30400@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100313084546.GA30400@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - kelvin.asmallorange.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - rab.in
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 08:45:46AM +0000, Russell King - ARM Linux wrote:
> On Sat, Mar 13, 2010 at 12:19:42PM +0530, Rabin Vincent wrote:
> >  
> >  	.globl ftrace_stub
> > -ftrace_stub:
> > +ENTRY(ftrace_stub)
> 
> ENTRY does the .globl for you, so please kill your own version.

Updated patch below.

>From 87b70ed633da00fe9873a5819c6d24e57368de43 Mon Sep 17 00:00:00 2001
From: Rabin Vincent <rabin@rab.in>
Date: Sun, 14 Feb 2010 01:18:33 +0530
Subject: [PATCH] ARM: ftrace: add ENDPROC annotations

When building as Thumb-2, the ".type foo, %function" annotation in
ENDPROC seems to be required in order for the assembly routines to be
recognized as Thumb-2 code.  If the ENDPROC annotations are not present,
calls to these routines are generated as BLX instead of BL.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/kernel/entry-common.S |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 6805a72..c7a8c20 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -146,6 +146,7 @@ mcount_call:
 	bl	ftrace_stub
 	ldr	lr, [fp, #-4]			@ restore lr
 	ldmia	sp!, {r0-r3, pc}
+ENDPROC(mcount)
 
 ENTRY(ftrace_caller)
 	stmdb	sp!, {r0-r3, lr}
@@ -158,6 +159,7 @@ ftrace_call:
 	bl	ftrace_stub
 	ldr	lr, [fp, #-4]			@ restore lr
 	ldmia	sp!, {r0-r3, pc}
+ENDPROC(ftrace_caller)
 
 #else
 
@@ -179,6 +181,7 @@ gnu_trace:
 	mov	pc, r2
 	ldmia	sp!, {r0-r3, ip, lr}
 	mov	pc, ip
+ENDPROC(__gnu_mcount_nc)
 
 #ifdef CONFIG_OLD_MCOUNT
 /*
@@ -204,13 +207,14 @@ trace:
 	mov	pc, r2
 	ldr	lr, [fp, #-4]			@ restore lr
 	ldmia	sp!, {r0-r3, pc}
+ENDPROC(mcount)
 #endif
 
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
-	.globl ftrace_stub
-ftrace_stub:
+ENTRY(ftrace_stub)
 	mov	pc, lr
+ENDPROC(ftrace_stub)
 
 #endif /* CONFIG_FUNCTION_TRACER */
 
-- 
1.7.0.4

