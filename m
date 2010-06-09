Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab0FISSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:18:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:49120 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605Ab0FISR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:17:57 -0400
Date: Wed, 9 Jun 2010 18:17:00 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, vegard.nossum@gmail.com, fweisbec@gmail.com,
       roland@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
       oleg@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, vegard.nossum@gmail.com, fweisbec@gmail.com,
       roland@redhat.com, akpm@linux-foundation.org, oleg@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100603193239.GA31530@redhat.com>
References: <20100603193239.GA31530@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Make save_stack_address() !CONFIG_FRAME_POINTER friendly
Message-ID: <tip-147ec4d2361e355ab32499f739cc24845ceb89da@git.kernel.org>
Git-Commit-ID: 147ec4d2361e355ab32499f739cc24845ceb89da
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 18:17:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  147ec4d2361e355ab32499f739cc24845ceb89da
Gitweb:     http://git.kernel.org/tip/147ec4d2361e355ab32499f739cc24845ceb89da
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 3 Jun 2010 21:32:39 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 9 Jun 2010 17:32:15 +0200

x86: Make save_stack_address() !CONFIG_FRAME_POINTER friendly

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
