Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab0LLX5f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:57:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36644 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab0LLXsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:04 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: fweisbec@gmail.com, rjw@sisk.pl, maciej.rutecki@gmail.com,
        julliard@winehq.org, jason.wessel@windriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [177/223] x86: Ignore trap bits on single step exceptions
Message-Id: <20101212234802.2F303B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Frederic Weisbecker <fweisbec@gmail.com>

commit 6c0aca288e726405b01dacb12cac556454d34b2a upstream.

When a single step exception fires, the trap bits, used to
signal hardware breakpoints, are in a random state.

These trap bits might be set if another exception will follow,
like a breakpoint in the next instruction, or a watchpoint in the
previous one. Or there can be any junk there.

So if we handle these trap bits during the single step exception,
we are going to handle an exception twice, or we are going to
handle junk.

Just ignore them in this case.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=21332

Reported-by: Michael Stefaniuc <mstefani@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Alexandre Julliard <julliard@winehq.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/hw_breakpoint.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- linux.orig/arch/x86/kernel/hw_breakpoint.c
+++ linux/arch/x86/kernel/hw_breakpoint.c
@@ -421,6 +421,10 @@ static int __kprobes hw_breakpoint_handl
 	dr6_p = (unsigned long *)ERR_PTR(args->err);
 	dr6 = *dr6_p;
 
+	/* If it's a single step, TRAP bits are random */
+	if (dr6 & DR_STEP)
+		return NOTIFY_DONE;
+
 	/* Do an early return if no trap bits are set in DR6 */
 	if ((dr6 & DR_TRAP_BITS) == 0)
 		return NOTIFY_DONE;
