Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab0KMViC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 16:38:02 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37241 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0KMVh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 16:37:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=gLbrhIvtCQxC0xUMnoW+M0MyiuMB0RJUEEYPzylobdJ6N2u7/utEbiD65cHunSud/a
         YwbEGw3zpl5DNEmBuZxkSPO9xDupX7OUooqa8Pf39h1VacjjfXuZQ9b7oNaRXLUzHFDA
         MFHKTvJVoonkUID9TTEmI4nK1lDCC8g0Wz6/c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Stefaniuc <mstefani@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Alexandre Julliard <julliard@winehq.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "All since 2.6.33.x" <stable@kernel.org>
Subject: [PATCH 1/2] x86: Ignore trap bits on single step exceptions
Date: Sat, 13 Nov 2010 22:37:52 +0100
Message-Id: <1289684273-26770-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com>
References: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: All since 2.6.33.x <stable@kernel.org>
---
 arch/x86/kernel/hw_breakpoint.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index ff15c9d..42c5942 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -433,6 +433,10 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
 	dr6_p = (unsigned long *)ERR_PTR(args->err);
 	dr6 = *dr6_p;
 
+	/* If it's a single step, TRAP bits are random */
+	if (dr6 & DR_STEP)
+		return NOTIFY_DONE;
+
 	/* Do an early return if no trap bits are set in DR6 */
 	if ((dr6 & DR_TRAP_BITS) == 0)
 		return NOTIFY_DONE;
-- 
1.6.2.3

