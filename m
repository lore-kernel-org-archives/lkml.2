Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab0FHUOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:14:17 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53323 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab0FHUOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:14:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=rUzNVgqIXvybhX1q9xYLyumVrOT2A++d0BuXLfRrnJ0Ew0b/LjIHEGsiLhymxUDYOC
         jzsXzFWzahKz26u9Or5O0VSGCC95yDkyDIiBW6WTUMGSJW3+3WyNjiE87SwK+Fv3OslO
         x9pBywsd3SG/rL7WtoWpQ+LF/mAYH9RT4K0XQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] x86: Make save_stack_address() !CONFIG_FRAME_POINTER friendly
Date: Tue,  8 Jun 2010 22:13:42 +0200
Message-Id: <1276028023-23122-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1276028023-23122-1-git-send-regression-fweisbec@gmail.com>
References: <1276028023-23122-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

If CONFIG_FRAME_POINTER=n, print_context_stack() shouldn't neglect the
non-reliable addresses on stack, this is all we have if dump_trace(bp)
is called with the wrong or zero bp.

For example, /proc/pid/stack doesn't work if CONFIG_FRAME_POINTER=n.

This patch obviously has no effect if CONFIG_FRAME_POINTER=y, otherwise
it reverts 1650743c "x86: don't save unreliable stack trace entries".

Also, remove the unnecessary type-cast.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20100603193239.GA31530@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/stacktrace.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index ea54d02..abc321d 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -26,8 +26,10 @@ static int save_stack_stack(void *data, char *name)
 static void save_stack_address(void *data, unsigned long addr, int reliable)
 {
 	struct stack_trace *trace = data;
+#ifdef CONFIG_FRAME_POINTER
 	if (!reliable)
 		return;
+#endif
 	if (trace->skip > 0) {
 		trace->skip--;
 		return;
@@ -39,9 +41,11 @@ static void save_stack_address(void *data, unsigned long addr, int reliable)
 static void
 save_stack_address_nosched(void *data, unsigned long addr, int reliable)
 {
-	struct stack_trace *trace = (struct stack_trace *)data;
+	struct stack_trace *trace = data;
+#ifdef CONFIG_FRAME_POINTER
 	if (!reliable)
 		return;
+#endif
 	if (in_sched_functions(addr))
 		return;
 	if (trace->skip > 0) {
-- 
1.6.2.3

