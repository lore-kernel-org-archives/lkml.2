Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051Ab0EACzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 22:55:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41533 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206Ab0EACyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 22:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=l/ZEM0tN8QVM00gAX1qj6CYTYN718RSwsBr87wLDPmN0Tt6hRSA3AWsAlRvf32uh+f
         DkrGESJOANRhp4BXRTSZ0Ujp7ZfCg0JVvm4htxg8vhWkhzgdRzSNhlaSToGYO57KVfw+
         sRKIEFvPXlllYAzUFxjpkukyqZbrGvZSdB2NQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Will Deacon <will.deacon@arm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/8] hw-breakpoints: Check disabled breakpoints again
Date: Sat,  1 May 2010 04:53:51 +0200
Message-Id: <1272682436-10682-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
References: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We stopped checking disabled breakpoints because we weren't
allowing breakpoints on NULL addresses. And gdb tends to set
NULL addresses on inactive breakpoints.

But refusing NULL addresses was actually a regression that has
been fixed now. There is no reason anymore to not validate
inactive breakpoint settings.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: K. Prasad <prasad@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/hw_breakpoint.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 03808ed..9ed9ae3 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -316,17 +316,7 @@ int register_perf_hw_breakpoint(struct perf_event *bp)
 	if (ret)
 		return ret;
 
-	/*
-	 * Ptrace breakpoints can be temporary perf events only
-	 * meant to reserve a slot. In this case, it is created disabled and
-	 * we don't want to check the params right now (as we put a null addr)
-	 * But perf tools create events as disabled and we want to check
-	 * the params for them.
-	 * This is a quick hack that will be removed soon, once we remove
-	 * the tmp breakpoints from ptrace
-	 */
-	if (!bp->attr.disabled || !bp->overflow_handler)
-		ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
+	ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
 
 	/* if arch_validate_hwbkpt_settings() fails then release bp slot */
 	if (ret)
-- 
1.6.2.3

